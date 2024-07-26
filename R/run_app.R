#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  css <- "@font-face {
  font-family: 'Gilroy';
  src: url('https://cdn.jsdelivr.net/gh/repalash/gilroy-free-webfont@fonts/Gilroy-Light.eot');
  src: local('Gilroy Light'), local('Gilroy-Light'),
    url('https://cdn.jsdelivr.net/gh/repalash/gilroy-free-webfont@fonts/Gilroy-Light.eot?#iefix') format('embedded-opentype'),
    url('https://cdn.jsdelivr.net/gh/repalash/gilroy-free-webfont@fonts/Gilroy-Light.woff') format('woff'),
    url('https://cdn.jsdelivr.net/gh/repalash/gilroy-free-webfont@fonts/Gilroy-Light.ttf') format('truetype');
  font-weight: 300;
  font-style: normal;
}
  
* {
  font-family: 'Gilroy'
}
.panel-auth {background-color: #00283c;}"
  
  with_golem_options(
    app = shinyApp(
      ui = shinymanager::secure_app(
        app_ui, 
        enable_admin = T, 
        language = "fr",
        tags_top = tags$div(tags$head(tags$style(css)))
      ),
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
