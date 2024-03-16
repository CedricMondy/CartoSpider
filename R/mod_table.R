#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::DTOutput(
      ns("table"),
      height = '800px', fill = TRUE
    )
  )
}

#' table Server Functions
#'
#' @noRd
mod_table_server <- function(id, what, selection){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(what(),{
      output$table <- DT::renderDT(NULL)
    })

    observe({
      req(what(), selection())

      if (what() == "country") {
        TableData <- loc_geoms |>
          sf::st_intersection(
            loc_geoms |>
              dplyr::filter(location == selection())
          ) |>
          sf::st_drop_geometry() |>
          dplyr::select(location) |>
          dplyr::left_join(countries, by = c("location" = "country")) |>
          dplyr::distinct(family, species, location.y) |>
          dplyr::rename_with(
            .cols = c("family", "species", "location.y"),
            .fn = function(x) {c("Family", "Species", paste0("Location (WSC, ", lubridate::year(wsc_date), ")"))}
          ) |>
          dplyr::arrange(Family, Species) |>
          DT::datatable(
            rownames = FALSE,
            options = list(
              scrollY = '750px',
              paging = FALSE,
              search.regex = TRUE
            )
          )
      }

      if (what() == "species") {
        TableData <- countries |>
          dplyr::filter(species == selection()) |>
          dplyr::mutate(
            on_map = country %in% loc_geoms$location
          ) |>
          dplyr::distinct(country, on_map) |>
          dplyr::rename_with(
            .cols = country,
            .fn = function(x) {paste0("Location (WSC, ", lubridate::year(wsc_date), ")")}
          ) |>
          DT::datatable(
            rownames = FALSE,
            options = list(
              scrollY = '750px',
              paging = FALSE,
              search.regex = TRUE
            )
          )
      }

      output$table <- DT::renderDT(
        TableData
      )

    })

  })
}

## To be copied in the UI
# mod_table_ui("table_1")

## To be copied in the server
# mod_table_server("table_1")
