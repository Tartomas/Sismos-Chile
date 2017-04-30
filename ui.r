shinyUI(bootstrapPage(
  div(class="outer",
      tags$head(includeCSS("www/styles.css")),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top=20, right=-10, height=200, width=300,draggable = TRUE,
                wellPanel(
                  HTML('
                  <font size="3"> <strong> &Uacute;ltimos Sismos en Chile </strong> </font>
                  <p>
                  <font size="1"> Mantente al tanto de los &uacute;ltimos acontecimientos:</font>
                  </p>
                  '),
                hr(),
                sliderInput("range", paste("Filtrar Magnitud Ml"), min(ultimos_sismos$Magnitud), 
                            max(ultimos_sismos$Magnitud),
                            value = range(ultimos_sismos$Magnitud), step = 0.2
                ),
                selectInput("colors", "Gama de Colores",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                checkboxInput("legend", "Mostrar Leyenda", TRUE),
                hr(),
           HTML('
           
           <font size="2"> <strong> Data:</strong> </font>
           <font size="2"> <a href="http://www.sismologia.cl", target="_blank">Centro Sismol&oacute;gico Nacional UdeChile</a> <br/> </font>
           <font size="2"> <strong> Creado por:</strong> </font>
           <font size="2"> Tom&aacute;s Acu&ntilde;a Ruz | <a href="https://github.com/Tartomas" target="_blank"> R useR! </a> </font>
           ')
  )))
))