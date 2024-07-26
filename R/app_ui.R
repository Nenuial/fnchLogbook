#' The application theme
#'
#' @export
app_theme <- function() {
  bslib::bs_theme(
    bg = "#2e3440",
    fg = "#eceff4",
    primary = "#00283c",
    secondary = "#ff0000",
    success = "#a3be8c",
    info = "#4f93b8",
    warning = "#d08770",
    danger = "#bf616a",
    base_font = "Gilroy",
    code_font = "Fira Code",
    heading_font = "Gilroy",
    bootswatch = "darkly"
  )
}

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    page_navbar(
      window_title = "LogBook",
      bg = "#00283c",
      fluid = TRUE,
      fillable = FALSE,
      title = img(src = "www/logo.svg", width = "80"),
      theme = app_theme(),
      nav_panel(
        title = "Événements",
        mod_log_event_ui("log_event")
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
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "fnchLogbook"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
