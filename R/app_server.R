#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  shinyjs::runjs("$('nav').removeClass('navbar-expand').addClass('navbar-expand-lg')")
  
 # Initialize R6 objects ---- 
  nba_data <- dataManager$new(
    free_throws,
    nba_teams_lu,
    players_lu
  )
  
  # Global Filters ----
   globalFilters <- globalFilters$new(
    default_filters = list(
      available_teams = nba_data$nba_teams_lu[['display_name']],
      selected_team  = nba_data$nba_teams_lu[['display_name']][[1]],
      available_seasons = nba_data$get_available_seasons(nba_data$nba_teams_lu[['display_name']][1]),
      selected_seasons = nba_data$get_available_seasons(nba_data$nba_teams_lu[['display_name']][1]),
      selected_gametype = c('regular','playoffs')
    )
  )
  mod_filters_highlights_server('filters', nba_data, globalFilters)
  
  # Page ----
  mod_page_highlights_server('highlights', nba_data, globalFilters)
  mod_page_deepdive_server('deepdive')
  
}
