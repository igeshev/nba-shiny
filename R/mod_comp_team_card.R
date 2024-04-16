#' comp_team_card UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_comp_team_card_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::box(
      title = textOutput(ns('team_stats_title')),
      width = 10,
      collapsible = FALSE,
      collapsed = FALSE,
      headerBorder = FALSE,
      fluidRow(
        style = '
              display:flex;
              align-items:top
              ',
        column(2,
               htmlOutput(ns('team_logo'))
        ),
        column(8,
       

                 uiOutput(ns('team_stats')),
                 plotOutput(ns('freethrow_performance_over_time'), height = '250px')
            

            
                 
        ),
        column(2,align = 'right',
               DT::DTOutput(ns('last_5_games'))
        )
        
      )
      
    )
  )
}

#' comp_team_card Server Functions
#'
#' @noRd 
mod_comp_team_card_server <- function(id, data, pageFilters){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$team_stats_title <- renderText({
      paste0('Team Stats for: ', pageFilters$filter$selected_team)
    })
    
    
    output$team_stats <- renderUI({

      pageFilters$trigger$render
      all_time_wr <- data$get_team_stats_wr(pageFilters$filter$selected_team, 
                             pageFilters$filter$selected_seasons,
                             type = 'all_time')
      last_selected_season <- data$get_team_stats_wr(pageFilters$filter$selected_team, 
                                               pageFilters$filter$selected_seasons,
                                               type = 'last_selected_season')
      
      home_and_away_wr <- data$get_home_vs_away_winrate(
        pageFilters$filter$selected_team, 
        pageFilters$filter$selected_seasons
      )


      tagList(
        fluidRow(
          column(3,
                 descriptionBlock(
                   number = all_time_wr,
                   numberIcon = icon('basketball'),
                   header = 'All Time WR'
                 ),
          ),
          column(3,
                 descriptionBlock(
                   number = last_selected_season,
                   numberIcon = icon('basketball'),
                   header = 'Last Selected Season WR'
                 )
          ),
          
          column(3,
                 descriptionBlock(
                   number = home_and_away_wr[['home_wr']],
                   numberIcon = icon('basketball'),
                   header = 'Home WR'
                 )
          ),
          
          column(3,
                 descriptionBlock(
                   number = home_and_away_wr[['away_wr']],
                   numberIcon = icon('basketball'),
                   header = 'Away WR',
                   rightBorder = FALSE,
                 )
          )
        )
      )
    
    })
    
    output$freethrow_performance_over_time <- renderPlot({

       pageFilters$trigger$render
      
      
      data <- data$get_winrate_over_time(pageFilters$filter$selected_team,
                                    pageFilters$filter$selected_season)
      
      ggplot(data,
             mapping = aes(x = season, y = winrate_over_time, group = type, color = type)) + 
        geom_line() +
        geom_point() +
        theme_linedraw() + 
        xlab('Season') + 
        ylab('Win Rate (%)') +
        theme(legend.position="bottom") +
        theme(legend.title=element_blank()) + 
        scale_color_manual(values=c("#CC6666", "#9999CC"))
        
    

    })
    
    
    output$last_5_games <- DT::renderDataTable({
      
      pageFilters$trigger$render
      
      data$get_last_5_games(pageFilters$filter$selected_team,
                            pageFilters$filter$selected_season) |> 
        DT::datatable(
          escape = FALSE,
          rownames = FALSE,
          extensions = 'Responsive',
          callback = htmlwidgets::JS(
            "$('table.dataTable.no-footer').css('border-bottom','none');
            $('table.dataTable th').css('border-bottom','none');
            
            "
          ),
          options(list( 
            dom = 't' ,
            ordering = FALSE)),
          class = list(stripe= FALSE)
        )
      
      
    })
    
    output$team_logo <- renderText({
      pageFilters$trigger$render
      
      HTML(
        paste0('<img style = "margin-top:50px;" src = ',
               data$get_team_logo(pageFilters$filter$selected_team),
               '  width = 200px height = 200px>' ))
    })
  })
}
    
