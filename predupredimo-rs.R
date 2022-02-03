


require(rgdal)
require(leaflet)
require(htmltools)
require(dplyr)
load("predupredimo-serbia-map")
opstine <- read.csv("opstine.csv")

Serbia_leaflet@data$Opstina <- left_join(Serbia_leaflet@data, opstine, by=c("code"="Code"))$Opstina

Serbia_leaflet@data[ is.na(Serbia_leaflet@data$Opstina),"Opstina"] <- c("Sevojno", "Niš-grad", "Novi Sad-grad")

bins <- c(4000,5000, 6000,7000,8000, 9000,10000, 12000)
pal <- colorBin("YlOrRd", domain = Serbia_leaflet@data$YPLLi17_19, bins = bins)

labels <- sprintf(
  "<div> <span style='font-size: 15px'><strong>%s</strong></span></div>
  <div>
  <p>Godišnji gubitak: <strong>%g</strong> života
  <p>Što je <strong>%g</strong> godina potencijalnog života</p>
  <p>PM2.5 aerozagađenje izazove: <strong>%g</strong> prevremenih smrti </p>
  <p>Što je <strong>%g</strong> izgubljenih godina potencijalnog života. </p>
  <p><strong>%g</strong> prevremenih smrti se moglo izbeći, i spasiti <strong> %g</strong> godina</p>
  <p>U 2020. god. SARS-CoV-2 je ondeo : <strong>%g</strong> života</p> i rezultirao gubitkom od <strong>%g</strong> potencijalnih godina života ",
  
  Serbia_leaflet@data$Opstina,
  round(Serbia_leaflet@data$Broj20172019TotalBroj/3,0),
  round(Serbia_leaflet@data$YPLL17_19,0),
  round(Serbia_leaflet@data$BrojPM25,0),
  round(Serbia_leaflet@data$YPLLpm2.5,0),
  round(Serbia_leaflet@data$Broj20172019avoidableBroj,0),
  round(Serbia_leaflet@data$YPLL20172019avoidable,0),
  round(Serbia_leaflet@data$BrojSARS,0),
  round(Serbia_leaflet@data$YPLLSARS,0),
  round(Serbia_leaflet@data$YPLLSARS,0)
  
) %>% lapply(htmltools::HTML)


rr <- tags$div(
  HTML('<h2>Prevremeni mortalitet u Srbiji</h2>')
)  

leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
  addProviderTiles(providers$CartoDB.DarkMatter,
                   options= providerTileOptions(opacity = 0.99)) %>%
  addPolygons(data=Serbia_leaflet,
              fillColor = ~pal(YPLLi17_19),
              weight = 1,
              opacity = 1,
              color = "#000",
              dashArray = "1",
              fillOpacity = 0.8,
              highlightOptions = highlightOptions(
                weight = 2,
                color = "#0C0C0C",
                dashArray = "",
                fillOpacity = 1,
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal","background-color"="#0C0C0C", color="#f0f0f0", "line-height"="10px", padding = "5px 5px"),
                textsize = "11px",
                direction = "auto")) %>% addLegend(pal = pal, values = Serbia_leaflet@data$YPLLi17_19, opacity = 0.7,title = "Br. godina na 100000 st. <75",
                                                     position = "topright") %>%  addControl(rr, "topleft")












