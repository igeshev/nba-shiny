#' page_deepdive UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_page_deepdive_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' page_deepdive Server Functions
#'
#' @noRd 
mod_page_deepdive_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_page_deepdive_ui("page_deepdive_1")
    
## To be copied in the server
# mod_page_deepdive_server("page_deepdive_1")
