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
    ),
    fluidRow(
      hr(style = 'display:inline-block; width: 40%; height: 2rem;'),
      span('TEAM', class = 'section_title'),
      hr(style = 'display:inline-block;  width: 40%; height: 2rem;'),
    ),
    fluidRow(
       mod_comp_team_card_ui(ns('team_stats')),
    ),
    fluidRow( mod_comp_last_games_ui(ns('last_games')) ),
    fluidRow(
      style = 'margin-top: 15px;',
      hr(style = 'display:inline-block; width: 40%; height: 2rem;'),
      span('PLAYERS', class = 'section_title'),
      hr(style = 'display:inline-block;  width: 40%; height: 2rem;')
    ),
    fluidRow(
      mod_comp_players_dt_ui(ns('player_dt')),
      mod_comp_player_card_ui(ns('player_card'))
    )
 )
}
    
#' page_highlights Server Functions
#'
#' @noRd 
mod_page_highlights_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    # Filters ----
    highlightsPageFilters <- pageFilters$new(
      default_filters = list(
        available_teams = data$nba_teams_lu[['display_name']],
        selected_team  = data$nba_teams_lu[['display_name']][[1]],
        available_seasons = data$get_available_seasons(data$nba_teams_lu[['display_name']][1]),
        selected_seasons = data$get_available_seasons(data$nba_teams_lu[['display_name']][1])
      )
    )
    
    hlInternalFilters <- internalFilters$new()
    
    mod_filters_highlights_server('filters', data, highlightsPageFilters)
    
    # Team Components ----
    mod_comp_team_card_server('team_stats', data, highlightsPageFilters)
    mod_comp_last_games_server('last_games', data, highlightsPageFilters)
    
    # Player Components ---- 
    mod_comp_players_dt_server('player_dt', data, highlightsPageFilters, hlInternalFilters)
    mod_comp_player_card_server('player_card', data, highlightsPageFilters, hlInternalFilters)
    
    
  })
}
    
