#' log_event UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_log_event_ui <- function(id){
  ns <- NS(id)  
  p(
    shiny::uiOutput(
      fill = "container",
      inline = TRUE,
      outputId = ns("event_warnings")
    ),
    bslib::card(
      bslib::card_header("Événement"),
      bslib::card_body(
        layout_columns(
          shiny::selectInput(
            inputId = ns("event_id"),
            label = "Concours",
            choices = rsvps::get_fnch_logbook_events() |>
            dplyr::select(ort, id) |>
            tibble::deframe()
          ),
          shiny::uiOutput(
            fill = "container",
            inline = TRUE,
            outputId = ns("event_class_ui")
          )
        ),
        layout_columns(
          shiny::uiOutput(
            fill = "container",
            inline = TRUE,
            outputId = ns("event_couple_id")
          ),
          shiny::selectInput(
            inputId = ns("event_categories"),
            label = "Catégories",
            choices = c(
              "Selectionnez" = "",
              "Avertissement oral",
              "Carton jaune",
              "Exclusion de l'épreuve",
              "Exclusion de la manifestation",
              "Contrôle de la muserolle",
              "Contrôle de médication",
              "Contrôle de passeport",
              "Vaccination incomplète",
              "Déclaration de médication",
              "Harnachement incorrect",
              "Incorrect envers le cheval",
              "Incorrect envers un officiel",
              "Infraction au règlement",
              "Autre"
            ),
            multiple = T
          )
        ),
        layout_columns(
          shiny::textAreaInput(
            inputId = ns("event_comment"),
            label = "Commentaire",
            height = 200
          )
        ),
        layout_columns(
          shiny::actionButton(
            inputId = ns("save"),
            label = "Enregistrer"
          )
        )
      )
    )
  )
}

#' log_event Server Functions
#'
#' @noRd
mod_log_event_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    events <- rsvps::get_fnch_logbook_events()
    startlist <- tibble::tibble()
    warnings <- rsvps::get_fnch_logbook_entries()
    
    # Update the startlist selection
    observe({
      req(input$event_id)
      
      output$event_class_ui <- shiny::renderUI({
        shiny::selectInput(
          inputId = ns("event_class_id"),
          label = "Épreuve",
          choices = rsvps::get_fnch_event_startlists(input$event_id) |>
          dplyr::mutate(name = glue::glue("{nummer} - {name}"), id) |>
          dplyr::select(name, id) |>
          tibble::deframe()
        )
      })
    })
    
    # Update the rider-horse couple selection
    observe({
      req(input$event_id, input$event_class_id)
      
      rsvps::get_fnch_startlist(input$event_id, input$event_class_id) |>
      dplyr::filter(typ == "starter") ->> startlist
      
      output$event_couple_id <- shiny::renderUI({
        shiny::selectInput(
          inputId = ns("event_couple_id"),
          label = "Couple",
          choices = startlist |>
          dplyr::mutate(name = glue::glue("{startnummer} - {reiter_name} {pferd_name}")) |>
          dplyr::select(name, id) |>
          tibble::deframe()
        )
      })
    })
    
    # Check if rider already has warnings
    observe({
      req(input$event_id, input$event_couple_id)

      startlist |>
      dplyr::filter(id == input$event_couple_id) -> starter
      
      warnings |> 
        dplyr::filter(Licence == starter$reiter_id) |> 
        dplyr::mutate(Date = withr::with_locale(new = c("LC_TIME" = "fr_CH"), code = strftime(Timestamp, format = "%d %B %Y"))) |> 
        dplyr::select(Date, Concours, Catégorie, Cheval, Commentaire) -> warning_table
      
      if (nrow(warning_table) < 1) {
        output$event_warnings <- shiny::renderUI(NULL)
      } else {
        output$event_warnings <- shiny::renderUI({
          bslib::card(
            bslib::card_header("Avertissements", class = "bg-danger"),
            bslib::card_body(
              reactable::renderReactable(
                warning_table |> reactable::reactable(pagination = FALSE, class = "warning-table")
              )
            )
          )
        })
      }
      
      
      
    })
    
    # Log event
    observeEvent(input$save,{
      req(input$event_id, input$event_couple_id)
      
      events |>
      dplyr::filter(id == input$event_id) |>
      dplyr::pull(ort) -> event_name
      
      startlist |>
      dplyr::filter(id == input$event_couple_id) -> starter
      
      rsvps::fnch_add_logbook_event(
        event_name = event_name,
        event_judge = session$userData$auth$notion_uid,
        event_horse_id = starter$pferd_id,
        event_horse = starter$pferd_name,
        event_rider_id = starter$reiter_id,
        event_rider = starter$reiter_name,
        event_categories = input$event_categories,
        event_comment = input$event_comment
      )
      
      updateSelectInput(
        session = session,
        inputId = "event_categories",
        selected = ""
      )
      
      updateTextAreaInput(
        session = session,
        inputId = "event_comment",
        value = ""
      )
    })
  })
}

# https://info.fnch.ch/startlisten/53836.json?startliste_id=42689

## To be copied in the UI
# mod_log_event_ui("log_event_1")

## To be copied in the server
# mod_log_event_server("log_event_1")
