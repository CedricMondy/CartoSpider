#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  what <- reactive(input$what)

  selection <- mod_selector_pane_server("selectors", what)

  observe(print(selection()))

}
