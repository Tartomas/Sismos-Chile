shinyServer(function(input, output) {

    filteredData <- reactive({
      ultimos_sismos<-na.omit(ultimos_sismos)
      ultimos_sismos[ultimos_sismos$Magnitud >= input$range[1] & ultimos_sismos$Magnitud <= input$range[2],]
    })
    
    colorpal <- reactive({
      colorNumeric(input$colors, ultimos_sismos$Magnitud)
    })
    
    output$map <- renderLeaflet({
      ii<-which.max(ultimos_sismos_sp@data$Magnitud)
      leaflet(ultimos_sismos_sp) %>% 
        setView(lng = ultimos_sismos_sp@coords[ii,2], 
                lat = ultimos_sismos_sp@coords[ii,1], zoom = 9) %>%
        addProviderTiles("Esri.NatGeoWorldMap",group="NatGeoWM")%>%
        addProviderTiles("CartoDB.Positron") %>%
        addProviderTiles("Esri.WorldImagery",group="Visible") %>%
        addProviderTiles("OpenTopoMap",group = "Topo") %>%
        # Layers control
        addLayersControl(position="bottomleft",
                         baseGroups = c("Visible","OSM","NatGeoWM","Topo"),
                         options = layersControlOptions(collapsed = TRUE))
    })
    
    observe({
      pal <- colorpal()
      
      Fecha<-filteredData()$'Fecha Local'
      leafletProxy("map", data = filteredData()) %>%
        clearShapes() %>%
        addCircles(radius = ~10^Magnitud/10, weight = 2, color = "#777777",
                   fillColor = ~pal(Magnitud), fillOpacity = 0.7, 
                   popup = ~paste(sep = "<br/>",
                                  paste("<b>Lugar:",Lugar),
                                  paste("<b>Fecha",Fecha),
                                  paste("<b>Magnitud:",Magnitud, "Ml")
                                  )
        )
    })
    
    observe({
      proxy <- leafletProxy("map", data = ultimos_sismos)

      proxy %>% clearControls()
      if (input$legend) {
        pal <- colorpal()
        proxy %>% addLegend(position = "bottomright",
                            pal = pal, values = ~Magnitud
        )
      }
    })
  })