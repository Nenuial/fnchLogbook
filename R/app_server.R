#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # Setup for SQLite DB
  # credentials <- data.frame(
  #   user = c("burkhardp"), # mandatory
  #   password = c("initialMdp"), # secret initial password
  #   start = c("2022-01-01"), # optinal (all others)
  #   expire = c(NA),
  #   admin = c(TRUE),
  #   notion_uid = c("df3049b1910648ed9c0ed60ea55eaa2d"),
  #   stringsAsFactors = FALSE
  # )

  # keyring::key_set("fnchLogbook", "dbAdmin") # Set password for SQLite DB
  # shinymanager::create_db(
  #   credentials_data = credentials,
  #   sqlite_path = "inst/users.sqlite",
  #   passphrase = keyring::key_get("fnchLogbook", "dbAdmin")
  # )

  session$userData$auth <- shinymanager::secure_server(
    check_credentials = shinymanager::check_credentials(
      fs::path(rappdirs::user_data_dir(appname = "fnchLogbook"), "users.sqlite"),
      passphrase = keyring::key_get("fnchLogbook", "dbAdmin")
    )
  )

  mod_log_event_server("log_event")
}
