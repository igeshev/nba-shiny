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
      width = 12,
      collapsible = TRUE,
      headerBorder = FALSE,
      title = 'Filters',
      fluidRow(
        column(3,
               selectInput(
                 inputId = ns('selected_team'),
                 label = "Select a team",
                 choices = NULL
               ) 
        ),
        column(4,
                selectInput(
                 inputId = ns('selected_seasons'),
                 label = 'Select Season',
                 choices = NULL,
                 multiple = TRUE
               )
        ),

        column(2,
               selectInput(
                 inputId = ns('selected_gametype'),
                 label = 'Select Game Type',
                 choices = c('regular', 'playoffs'),
                 multiple = TRUE,
                 selected = c('regular', 'playoffs')
               )
        ),
        
        column(2,
               fluidRow(
                 style = 'margin-top: 28px;
                 margin-left:10px;',
                 checkboxInput(
                   inputId = ns('last_season_only'),
                   'Last Season Only',
                   value =FALSE
                 )
               )
           )
        ),
      fluidRow(
        column(12,
               
                bs4Dash::actionButton(
                 inputId = ns('apply_changes'),
                 label = 'Apply Filters',
                 status = 'success',
                 width = '10%'
                )
        )
      )
    )
    
  )
}
    
#' filters_highlights Server Functions
#'
#' @noRd 
mod_filters_highlights_server <- function(id, data, globalFilters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    updateSelectInput(
      session = session,
      inputId = 'selected_team',
      choices = globalFilters$default_filters$available_teams,
      selected = globalFilters$default_filters$selected_team
    )
    
  
    observeEvent(c(
      input$last_season_only,
      input$selected_team), ignoreInit = TRUE, {
      
      choices <- data$get_available_seasons(input$selected_team) 
      if(isTruthy(input$last_season_only)){
        selected <- max(choices)
      }else{
        selected <- choices
      }
                      
      updateSelectInput(
        session =session,
        inputId = 'selected_seasons',
        choices = choices,
        selected = selected
      )
      
    })
    
    
    observeEvent(input$apply_changes,{
      # Save selected filters to globally available R6 Class
      globalFilters$filter$selected_team <- input$selected_team
      globalFilters$filter$selected_seasons <- input$selected_seasons
      globalFilters$filter$selected_gametype <- input$selected_gametype
      
      # Trigger Rerender for all objects dependant on this R6 class
      globalFilters$trigger_rerender()
      
    })

  })
}
    
