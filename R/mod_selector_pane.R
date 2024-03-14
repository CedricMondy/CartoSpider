#' selector_pane UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_selector_pane_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("select_what"))
}

#' selector_pane Server Functions
#'
#' @noRd
mod_selector_pane_server <- function(id, what){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      req(what)

      if (what() == "species") {
        output$select_what <- renderUI({
          selectizeInput(
            inputId = ns("species"),
            label = NULL,
            choices = c("Select a species" = ""),
            multiple = FALSE
          )
        })

        updateSelectizeInput(session, 'species',
                             choices = c("Select a species" = "",
                                         wsc_locations |>
                                           dplyr::group_by(family) |>
                                           dplyr::group_split() |>
                                           purrr::map(dplyr::pull, species) |>
                                           purrr::set_names(sort(unique(wsc_locations$family)))
                             ),
                             server = TRUE)

      }

      if (what() == "country") {
        output$select_what <- renderUI({
          selectizeInput(
            inputId = ns("country"),
            label = NULL,
            choices = c("Choose a country" = "",
                        loc_geoms |>
                          sf::st_drop_geometry() |>
                          dplyr::filter(is_country) |>
                          dplyr::arrange(continent, location) |>
                          dplyr::group_by(continent) |>
                          dplyr::group_split() |>
                          purrr::map(dplyr::pull, location) |>
                          purrr::set_names(sort(unique(loc_geoms$continent)))
                        )
          )
        })
      }
    })

    reactive({
      if (what() == "species") {
        input$species
      } else {
        input$country
      }
    })

  })
}

## To be copied in the UI
# mod_selector_pane_ui("selector_pane_1")

## To be copied in the server
# mod_selector_pane_server("selector_pane_1")
