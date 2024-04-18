#' filters_deepdive UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filters_deepdive_ui <- function(id) {
  ns <- NS(id)
  tagList()
}

#' filters_deepdive Server Functions
#'
#' @noRd
mod_filters_deepdive_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}

## To be copied in the UI
# mod_filters_deepdive_ui("filters_deepdive_1")

## To be copied in the server
# mod_filters_deepdive_server("filters_deepdive_1")
