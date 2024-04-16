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
 
  )
}
    
#' comp_player_card Server Functions
#'
#' @noRd 
mod_comp_player_card_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_comp_player_card_ui("comp_player_card_1")
    
## To be copied in the server
# mod_comp_player_card_server("comp_player_card_1")
