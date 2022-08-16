.onLoad <- function(libname, pkgname) {
  user_db_path <- fs::path(rappdirs::user_data_dir(appname = "fnchLogbook"), "users.sqlite")

  if (!fs::file_exists(user_db_path)) {
    fs::dir_create(fs::path_dir(user_db_path), recurse = T)

    fs::file_copy(
      path = system.file("users.sqlite", package = 'fnchLogbook', mustWork = TRUE),
      new_path = user_db_path
    )
  }
}
