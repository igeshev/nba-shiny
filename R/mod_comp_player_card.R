#' comp_player_card UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_comp_player_card_ui <- function(id){
  ns <- NS(id)
  tagList(
    column(6,
           uiOutput(ns('user_box'))
           )

  )
}
    
#' comp_player_card Server Functions
#'
#' @noRd 
mod_comp_player_card_server <- function(id, data , pageFilters, internalFilters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    
    output$user_box <- renderUI({
      req(internalFilters$get_filter('player_dt_name'))
      
      player_image <- hoopR::nba_playerheadshot(data$get_player_id_from_name(internalFilters$get_filter('player_dt_name')))
      player_name <- internalFilters$get_filter('player_dt_name')
      
      userBox(
        width =12,
        title = userDescription(
          title = player_name,
          subtitle = "Player Stats",
          type = 1,
          image = player_image,
        ),
        status = "gray-dark",
        boxToolSize = "xl",
        collapsible = FALSE,
        "Some text here!",
        footer = "The footer here!"
      )
    })
      

    
 

 
  })
}
    
## To be copied in the UI
# mod_comp_player_card_ui("comp_player_card_1")
    
## To be copied in the server
# mod_comp_player_card_server("comp_player_card_1")
