#' filters_highlights UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_filters_highlights_ui <- function(id){
  ns <- NS(id)
  tagList(
 
    bs4Dash::box(
      id = ns('highlights_filters'),
      width = 2,
      collapsible = TRUE,
      headerBorder = FALSE,
      title = 'Filters',
      fluidRow(
        column(12,
               selectInput(
                 inputId = ns('selected_team'),
                 label = "Select a team",
                 choices = NULL
               ),
               selectInput(
                 inputId = ns('selected_seasons'),
                 label = 'Select Season',
                 choices = NULL,
                 multiple = TRUE
               ),
               bs4Dash::actionButton(
                 inputId = ns('apply_changes'),
                 label = 'Apply Filters',
                 status = 'success',
                 width = '50%'
               )
               ),

      )
    )
  
  )
}
    
#' filters_highlights Server Functions
#'
#' @noRd 
mod_filters_highlights_server <- function(id, data, pageFilters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    updateSelectInput(
      session = session,
      inputId = 'selected_team',
      choices = pageFilters$default_filters$available_teams,
      selected = pageFilters$default_filters$selected_team
    )
    
    observeEvent(input$selected_team, ignoreInit = TRUE, {
      
      updateSelectInput(
        session =session,
        inputId = 'selected_seasons',
        choices = data$get_available_seasons(input$selected_team),
        selected = data$get_available_seasons(input$selected_team)
      )
      
    })
    
    
    observeEvent(input$apply_changes,{
      # Save selected filters to globally available R6 Class
      pageFilters$filter$selected_team <- input$selected_team
      pageFilters$filter$selected_seasons <- input$selected_seasons
      
      # Trigger Rerender for all objects dependant on this R6 class
      pageFilters$trigger_rerender()
      
    })

  })
}
    
