#
#
#
golem::fill_desc(
  pkg_name = "CartoSpider",
  pkg_title = "CartoSpider: Spiders across the world",
  pkg_description = "This package uses information from the world spider catalog and observation records to visualize known spider species distribution",
  author_first_name = "Cédric",
  author_last_name = "Mondy",
  author_email = "cedric.mondy@gmail.com",
  repo_url = "https://github.com/CedricMondy/CartoSpider",
  pkg_version = "0.0.0.9000"
)
golem::set_golem_options()
golem::install_dev_deps()
usethis::use_mit_license("Cédric Mondy")
usethis::use_readme_rmd(open = FALSE)
devtools::build_readme()
usethis::use_code_of_conduct(contact = "Cédric Mondy")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)
usethis::use_git()
golem::use_recommended_tests()
golem::use_favicon()
golem::use_utils_ui(with_test = TRUE)
golem::use_utils_server(with_test = TRUE)
rstudioapi::navigateToFile("dev/02_dev.R")
