#' page_highlights UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_page_highlights_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
             mod_filters_highlights_ui(ns('filters')),
             mod_comp_team_card_ui(ns('team_stats'))
    )
 )
}
    
#' page_highlights Server Functions
#'
#' @noRd 
mod_page_highlights_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    highlightsPageFilters <- pageFilters$new(
      default_filters = list(
        available_teams = data$nba_teams_lu[['display_name']],
        selected_team  = data$nba_teams_lu[['display_name']][[1]],
        available_seasons = data$get_available_seasons(data$nba_teams_lu[['display_name']][1]),
        selected_seasons = data$get_available_seasons(data$nba_teams_lu[['display_name']][1])
      )
    )
    
    mod_filters_highlights_server('filters', data, highlightsPageFilters)
    
    mod_comp_team_card_server('team_stats', data, highlightsPageFilters)
 
  })
}
    
## To be copied in the UI
# mod_page_highlights_ui("page_highlights_1")
    
## To be copied in the server
# mod_page_highlights_server("page_highlights_1")
