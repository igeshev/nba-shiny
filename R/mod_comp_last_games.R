#' comp_last_games UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_comp_last_games_ui <- function(id){
  ns <- NS(id)
  tagList(
 
        column(12,
               uiOutput(ns('last_6_games'))
        )
  )
}
    
#' comp_last_games Server Functions
#'
#' @noRd 
mod_comp_last_games_server <- function(id, data, pageFilters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 

    
    output$last_6_games <- renderUI({
      
      pageFilters$trigger$render
      
      data <- data$get_last_6_games(pageFilters$filter$selected_team,
                            pageFilters$filter$selected_season) 
      
      
      
      last_games <- purrr::map(
        .x = 1:nrow(data),
        .f = \(x){
          row <- data[x,]
          title <- if(x==1)'Most Recent Game' else paste0('Last 6 Games - #',x)
          box(
            title = title, 
            width = 2,
            closable = FALSE,
            collapsible = FALSE,
            HTML(
              paste0(
                row$home_team,
                '<br>',
                row$away_team
              )
            )
      
          )
           }
      )

          tagList(fluidRow(last_games))
      
    })
  })
}
    
## To be copied in the UI
# mod_comp_last_games_ui("comp_last_games_1")
    
## To be copied in the server
# mod_comp_last_games_server("comp_last_games_1")
