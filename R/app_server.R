#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  shinyjs::runjs("$('nav').removeClass('navbar-expand').addClass('navbar-expand-lg')")
  
  
  nba_data <- dataManager$new(
    free_throws,
    nba_teams_lu,
    players_lu
  )
  
  mod_page_highlights_server('highlights', data = nba_data)
  
  mod_page_deepdive_server('deepdive')
  
}
