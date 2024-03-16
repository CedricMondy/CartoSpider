#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_map_ui <- function(id){
  ns <- NS(id)
  tagList(
    leaflet::leafletOutput(ns("map"), height = '800px')
  )
}

#' map Server Functions
#'
#' @noRd
mod_map_server <- function(id, what, selection){
  moduleServer( id, function(input, output, session){
    library(sf)

    ns <- session$ns

    output$map <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(leaflet::providers$Esri.WorldStreetMap) |>
        leaflet::setView(
          lng = 50,
          lat = 6,
          zoom = 1
        )
    })

    observeEvent(what(),{
      leaflet::leafletProxy(mapId = "map") |>
        leaflet::clearShapes()
    })

    observe({
      req(what(), selection())

      if (what() == "country") {
        MapData <- loc_geoms |>
          dplyr::filter(location == selection())
      }

      if (what() == "species") {
        MapData <- loc_geoms |>
          dplyr::inner_join(
            countries |>
              dplyr::filter(species == selection()),
            by = c("location" = "country")
          ) |>
          dplyr::group_by(family, species, location.y) |>
          dplyr::summarise(.groups = "drop")
      }

      MapDataBox <- sf::st_bbox(MapData)

      leaflet::leafletProxy(mapId = "map") |>
        leaflet::clearShapes() |>
        leaflet::addPolygons(
          data = MapData,
          fillOpacity = 0
          ) |>
        leaflet::flyToBounds(
          lng1 = MapDataBox[["xmin"]],
          lat1 = MapDataBox[["ymin"]],
          lng2 = MapDataBox[["xmax"]],
          lat2 = MapDataBox[["ymax"]]
        )

    })


  })
}

## To be copied in the UI
# mod_map_ui("map_1")

## To be copied in the server
# mod_map_server("map_1")
