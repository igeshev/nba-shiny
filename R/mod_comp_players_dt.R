#' comp_players_dt UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_comp_players_dt_ui <- function(id){
  ns <- NS(id)
  tagList(
    column(6,
           box(
             width = 12,
             collapsible = FALSE,
             title = strong('Free Throw Shots Statistics By Player'),
             headerBorder = FALSE,
             DT::dataTableOutput(ns('player_dt'))
           )
    )
 
  )
}
    
#' comp_players_dt Server Functions
#'
#' @noRd 
mod_comp_players_dt_server <- function(id, data, pageFilters, internalFilters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    output$player_dt <- DT::renderDataTable({
      pageFilters$trigger$render
      
      data$get_players_stats_table(pageFilters$filter$selected_team,
                                   pageFilters$filter$selected_seasons) |> 
        
        DT::datatable( 
          extensions = c('Scroller','Responsive'),
          selection = list(mode = 'single', selected = 1),
          rownames =FALSE,
          filter = 'top',
          class = list(stripe= FALSE),
          options = list(
            dom = 'toS',
            deferRender = TRUE,
            scrollY = 300,
            scroller = TRUE,
            columnDefs = list(
                    list(
                      targets = c(1,2,3),
                      className = 'dt-center'
                    )
                  )
            )
        
        ) |> 
        DT::formatPercentage(columns = 3)
      
    })
    
    
    
    observeEvent(input$player_dt_rows_selected,ignoreNULL = TRUE,{
      
      selected_row <- data$get_players_stats_table(pageFilters$filter$selected_team,
                                                                     pageFilters$filter$selected_seasons) |> 
        dplyr::slice(as.integer(input$player_dt_rows_selected)) 
      
      
      internalFilters$set_filter('player_dt_name', selected_row$Player)
      
      
 
      
    })
 
  })
}
    
## To be copied in the UI
# mod_comp_players_dt_ui("comp_players_dt_1")
    
## To be copied in the server
# mod_comp_players_dt_server("comp_players_dt_1")
