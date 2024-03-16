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

    output$select_what <- renderUI({
      selectizeInput(
        inputId = ns("selection"),
        label = NULL,
        choices = c("") |>
          purrr::set_names(paste0("Choose a ", what())),
        multiple = FALSE
      )
    })

    observeEvent(what(), {
      if(what() == "species") {
        updateSelectizeInput(session, 'selection',
                           choices = c("Choose a species" = "",
                                       species_list |>
                                         dplyr::arrange(family, species) |>
                                         dplyr::group_by(family) |>
                                         dplyr::group_split() |>
                                         purrr::map(dplyr::pull, species) |>
                                         purrr::set_names(sort(unique(wsc_locations$family)))
                           ),
                           server = TRUE)
      } else {
        updateSelectizeInput(
        session, "selection",
        choices = c("Choose a country" = "",
                        country_list |>
                          dplyr::arrange(continent, country) |>
                          dplyr::group_by(continent) |>
                          dplyr::group_split() |>
                          purrr::map(dplyr::pull, country) |>
                          purrr::set_names(sort(unique(country_list$continent))))
      )
      }

    })

    reactive(input$selection)

  })
}

## To be copied in the UI
# mod_selector_pane_ui("selector_pane_1")

## To be copied in the server
# mod_selector_pane_server("selector_pane_1")
