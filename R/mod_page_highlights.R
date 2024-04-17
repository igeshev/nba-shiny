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
mod_page_highlights_server <- function(id, data, globalFilters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    # Filters ----
    hlInternalFilters <- internalFilters$new()
    
    # Team Components ----
    mod_comp_team_card_server('team_stats', data, globalFilters = globalFilters)
    mod_comp_last_games_server('last_games', data,globalFilters = globalFilters)
    
    # Player Components ---- 
    mod_comp_players_dt_server('player_dt', data, globalFilters = globalFilters, hlInternalFilters)
    mod_comp_player_card_server('player_card', data, globalFilters = globalFilters, hlInternalFilters)
    
    
  })
}
    
