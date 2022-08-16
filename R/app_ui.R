#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bs4Dash
#' @noRd
app_ui <- function(request) {
  theme <- fresh::create_theme(
    fresh::bs4dash_status(primary = "#5E81AC", danger = "#BF616A")
  )

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bs4DashPage(
      header = bs4DashNavbar(
        status = "white",
        border = TRUE,
        skin = "light",
        "LogEvent"
      ),

      title = "LogEvent",

      sidebar = bs4DashSidebar(disable = TRUE),

      body = bs4DashBody(
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
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "fnchLogbook"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
