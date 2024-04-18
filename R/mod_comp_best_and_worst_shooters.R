#' comp_best_and_worst_shooters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_comp_best_and_worst_shooters_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      width = 12,
      collapsible = FALSE,
      title = "Top5 Best & Worst Shooters",
      uiOutput(ns("best_worst_shooters"))
    )
  )
}

#' comp_best_and_worst_shooters Server Functions
#'
#' @noRd
mod_comp_best_and_worst_shooters_server <- function(id, data, globalFilters) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    output$best_worst_shooters <- renderUI({
      globalFilters$trigger$render

      shooters <-
        data$get_players_stats_table(
          globalFilters$filter$selected_team,
          globalFilters$filter$selected_seasons,
          globalFilters$filter$selected_gametype
        ) |>
        dplyr::filter(`Total shots` > 20) |>
        dplyr::arrange(desc(`Shot conversion %`)) |>
        dplyr::select(1:3)


      best_shooters <- shooters |>
        head(5)

      worst_shooters <- shooters |>
        tail(5)

      output$best_shooters_dt <- DT::renderDataTable({
        best_shooters |>
          DT::datatable(
            selection = "none",
            rownames = FALSE,
            class = list(stripe = FALSE),
            options = list(
              dom = "t",
              columnDefs = list(
                list(
                  targets = c(1, 2),
                  className = "dt-center"
                )
              )
            )
          ) |>
          DT::formatPercentage(columns = 3)
      })

      output$worst_shooters_dt <- DT::renderDataTable({
        globalFilters$trigger$render

        worst_shooters |>
          DT::datatable(
            selection = "none",
            rownames = FALSE,
            class = list(stripe = FALSE),
            options = list(
              dom = "t",
              columnDefs = list(
                list(
                  targets = c(1, 2),
                  className = "dt-center"
                )
              )
            )
          ) |>
          DT::formatPercentage(columns = 3)
      })

      output$ft_players_best_worst <- plotly::renderPlotly({
        globalFilters$trigger$render


        print(globalFilters$filter$selected_gametype)
        fig_data <- data$get_ft_accuracy_by_time(
          globalFilters$filter$selected_team,
          globalFilters$filter$selected_seasons,
          globalFilters$filter$selected_gametype,
          player_names = c(
            best_shooters$Player,
            worst_shooters$Player
          )
        ) |>
          dplyr::filter(period %in% 1:4)

        plotly::plot_ly(
          data = fig_data,
          x = ~period,
          y = ~shots_accuracy,
          color = ~player,
          type = "scatter",
          mode = "lines"
        ) |>
          plotly::add_trace(
            x = ~period,
            y = ~shots_accuracy,
            color = ~player,
            type = "scatter",
            mode = "markers",
            showlegend = F,
            marker = list(size = 12)
          ) |>
          plotly::layout(
            xaxis = list(
              title = "Quarter",
              dtick = 1,
              range = c(.5, 4.5)
            ),
            yaxis = list(
              title = "Shots Accuracy (%)",
              dtick = 10,
              range = c(-9, 109),
              zeroline = FALSE
            )
          )
        # color palette warning : open issue (https://github.com/plotly/plotly.R/issues/2289)
      })


      tagList(
        fluidRow(
          column(
            2,
            strong("Best Shooters"),
            DT::DTOutput(ns("best_shooters_dt"))
          ),
          column(
            2,
            strong("Worst Shooters"),
            DT::DTOutput(ns("worst_shooters_dt"))
          ),
          column(
            8,
            plotly::plotlyOutput(ns("ft_players_best_worst"))
          )
        )
      )
    })
  })
}
