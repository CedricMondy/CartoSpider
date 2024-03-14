#' Download species distribution information from WSC
#'
#' This function get information from known distribution of spider species from
#' the World Spider Catalog.
#'
#' The function scrape the web page listing all spider families
#' (https://wsc.nmbe.ch/families) to get the family-specific web page adresses
#' and then scrape each one of them to get information about species names and
#' known location.
#'
#' @return a data frame with worldwide known information about location for each
#'   species from each family
#' @export
#'
#' @importFrom dplyr arrange select mutate
#' @importFrom httr GET
#' @importFrom purrr list_rbind map
#' @importFrom rvest html_attrs html_elements read_html html_text html_nodes
#' @importFrom stringr str_split str_remove fixed
#' @importFrom tibble tibble
get_wsc_species_loc <- function() {
  get_tail <- function(x) {
    tail(x[[1]], n = 1)
  }

  "https://wsc.nmbe.ch/families" |>
    httr::GET() |>
    rvest::read_html() |>
    rvest::html_elements(xpath = '//a[@title="Classic view"]') |>
    rvest::html_attrs() |>
    sapply(function(x) {
      paste0("https://wsc.nmbe.ch", x[["href"]])
    })|>
    purrr::map(
      function(url_family) {
        page_content <- url_family |>
          httr::GET() |>
          rvest::read_html()

        tibble::tibble(
          species = page_content |>
            rvest::html_nodes(xpath = '//div[@class="speciesTitle"]') |>
            rvest::html_text() |>
            stringr::str_split(pattern = "\n") |>
            sapply(FUN = function(x) x[1]),
          location =  page_content |>
            rvest::html_nodes(xpath = '//div[@class="speciesTitle"]//span[@class="specInfo"]') |>
            rvest::html_text() |>
            stringr::str_split(pattern = stringr::fixed("|")) |>
            sapply(function(x) {x[3]}) |>
            stringr::str_remove(pattern = "\n.*]$")
        ) |>
          dplyr::mutate(
            family = url_family |>
              stringr::str_split(pattern = "/") |>
              get_tail()
          )
      },
      .progress = TRUE
    ) |>
    purrr::list_rbind() |>
    dplyr::select(family, species, location) |>
    dplyr::arrange(family, species, location)
}
