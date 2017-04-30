
pks<-c("sp","rvest","shiny","leaflet","RColorBrewer")

suppressMessages({
   lapply(pks, FUN = function(X) {
     do.call("require", list(X))
   })
})

# install.packages(sp,dependencies = TRUE)
# install.packages(rvest,dependencies = TRUE)
# install.packages(shiny,dependencies = TRUE)
# install.packages(leaflet,dependencies = TRUE)
# install.packages(RColorBrewer,dependencies = TRUE)

# library(sp)
# library(rvest)
# library(shiny)
# library(leaflet)
# library(RColorBrewer)

theurl_basic <- "http://www.sismologia.cl"
theurl <- "http://www.sismologia.cl/links/tabla.html"

# Ultimos sismos
main.page <- read_html(x = theurl)
urls <- main.page %>% # feed `main.page` to the next step
  html_nodes("td") %>%
  html_text() 
ultimos_sismos<-data.frame(matrix(urls,ncol=3,byrow=TRUE))
colnames(ultimos_sismos)<-c("Fecha Local","Lugar","Magnitud")
ultimos_sismos$Magnitud<-as.numeric(substr(ultimos_sismos$Magnitud,1,3))

urls <- main.page %>% # feed `main.page` to the next step
  html_nodes("td") %>%
  html_children()  %>%
  html_attrs()
urls<-lapply(1:length(urls),function(e){
  as.character(data.frame(urls[[e]])[1,])
})

urls<-data.frame(url=do.call('rbind',urls))

urls_sismo<-lapply(1:15,function(e){
  url_sismo<-paste0(theurl_basic,urls[e,])
  
  prueba<-try(sismo <- read_html(x = url_sismo))
  if(substr(prueba[1],1,5)=="Error"){
    urls_sismo<-data.frame(Variable=NA,Value=NA)
    data.frame(lat=NA,lng=NA)
  }else{
    urls_sismo <- sismo %>% 
      html_nodes("td") %>%
      html_text()
    
    urls_sismo<-data.frame(matrix(urls_sismo,ncol=2,byrow=TRUE))
    colnames(urls_sismo)<-c("Variable","Value")
    #lat y lng
    data.frame(lat=urls_sismo[3,2],lng=urls_sismo[4,2])
  }
  
})

urls_sismo<-do.call("rbind",urls_sismo)

as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}

ultimos_sismos$lat<-as.numeric.factor(urls_sismo$lat)
ultimos_sismos$long<-as.numeric.factor(urls_sismo$lng)

ultimos_sismos_sp<-na.omit(ultimos_sismos)
coordinates(ultimos_sismos_sp)<-c("lat","lng")


