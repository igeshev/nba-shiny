#' comp_team_card UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_comp_team_card_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bs4Dash::box(
      title = textOutput(ns("team_stats_title")),
      width = 12,
      collapsible = FALSE,
      collapsed = FALSE,
      headerBorder = FALSE,
      fluidRow(
        style = "
              display:flex;
              align-items:top
              ",
        column(
          2,
          htmlOutput(ns("team_logo"))
        ),
        column(
          10,
          uiOutput(ns("team_stats")),
          plotOutput(ns("freethrow_performance_over_time"), height = "300px")
        )
      )
    )
  )
}

#' comp_team_card Server Functions
#'
#' @noRd
mod_comp_team_card_server <- function(id, data, globalFilters) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$team_stats_title <- renderText({
      paste0("Team Stats for: ", globalFilters$filter$selected_team)
    })


    output$team_stats <- renderUI({
      globalFilters$trigger$render
      all_time_wr <- data$get_team_stats_wr(globalFilters$filter$selected_team,
        globalFilters$filter$selected_seasons,
        globalFilters$filter$selected_gametype,
        type = "all_time"
      )
      last_selected_season <- data$get_team_stats_wr(globalFilters$filter$selected_team,
        globalFilters$filter$selected_seasons,
        globalFilters$filter$selected_gametype,
        type = "last_selected_season"
      )

      home_and_away_wr <- data$get_home_vs_away_winrate(
        globalFilters$filter$selected_team,
        globalFilters$filter$selected_seasons,
        globalFilters$filter$selected_gametype
      )


      tagList(
        fluidRow(
          column(
            3,
            descriptionBlock(
              number = all_time_wr,
              numberIcon = icon("basketball"),
              header = "All Time WR"
            ),
          ),
          column(
            3,
            descriptionBlock(
              number = last_selected_season,
              numberIcon = icon("basketball"),
              header = "Last Selected Season WR"
            )
          ),
          column(
            3,
            descriptionBlock(
              number = home_and_away_wr[["home_wr"]],
              numberIcon = icon("basketball"),
              header = "Home WR"
            )
          ),
          column(
            3,
            descriptionBlock(
              number = home_and_away_wr[["away_wr"]],
              numberIcon = icon("basketball"),
              header = "Away WR",
              rightBorder = FALSE,
            )
          )
        )
      )
    })

    output$freethrow_performance_over_time <- renderPlot({
      globalFilters$trigger$render


      data <- data$get_winrate_over_time(
        globalFilters$filter$selected_team,
        globalFilters$filter$selected_season,
        globalFilters$filter$selected_gametype
      )

      ggplot(data,
        mapping = aes(x = season, y = winrate_over_time, group = type, color = type)
      ) +
        geom_line() +
        geom_point() +
        theme_linedraw() +
        xlab("Season") +
        ylab("Win Rate (%)") +
        theme(
          legend.position = "bottom",
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 14, face = "bold"),
          legend.title = element_blank(),
          legend.text = element_text(size = 14)
        ) +
        scale_color_manual(values = c("#CC6666", "#9999CC"))
    })


    output$team_logo <- renderText({
      globalFilters$trigger$render

      HTML(
        paste0(
          '<img style = "margin-top:60px;" src = ',
          data$get_team_logo(globalFilters$filter$selected_team),
          "  width = 200px height = 200px>"
        )
      )
    })
  })
}
