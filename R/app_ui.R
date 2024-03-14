#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    fluidPage(
      div(
        style = "display: flex; align-items: center;",
        tags$img(src = "www/CartoSpider.png", width = "50px", height = "50px", style = "margin-right: 10px;"),
        h1("  CartoSpider: Spiders across the world")
      ),
      div(),
      # Panneau latéral avec sélecteurs
      sidebarLayout(
        sidebarPanel(
          div(
            style = "display: flex; align-items: bottom;",
            span("Search for", style = "margin-right: 10px;"),
            radioButtons(
              label = NULL,
              inputId = "what",
              choices = c("species", "country"),
              selected = "species",
              inline = TRUE
            )
          ),
          mod_selector_pane_ui("selectors"),
          width = 3
        ),
        # Division en deux colonnes
        mainPanel(
          # Colonne 1 : Carte Leaflet
          column(width = 6),
          # Colonne 2 : Tableau DT
          column(width = 6),
          width = 9
        )
      )

    )
  )
}
#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "CartoSpider"
    )
  )
}
