#' comp_ft_accuracy_by_time UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_comp_ft_accuracy_by_time_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      width = 12,
      title = "Team Free Throw Accuracy by Time (4 Quarters)",
      plotly::plotlyOutput(ns("ft_by_time_plot"))
    )
  )
}

#' comp_ft_accuracy_by_time Server Functions
#'
#' @noRd
mod_comp_ft_accuracy_by_time_server <- function(id, data, globalFilters) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$ft_by_time_plot <- plotly::renderPlotly({
      globalFilters$trigger$render

      fig_data <- data$get_ft_accuracy_by_time(
        globalFilters$filter$selected_team,
        globalFilters$filter$selected_seasons,
        globalFilters$filter$selected_gametype
      ) |>
        dplyr::filter(rounded_time <= 48)

      plotly::plot_ly(
        data = fig_data,
        x = ~rounded_time,
        y = ~shots_accuracy,
        color = ~season,
        type = "scatter",
        mode = "lines",
        line = list(shape = "spline", smoothing = 1.3)
      ) |>
        plotly::layout(
          shapes = list(
            vline(12),
            vline(24),
            vline(36),
            vline(48)
          ),
          xaxis = list(
            title = "Time (minutes)",
            dtick = 1
          ),
          yaxis = list(
            title = "Shots Accuracy (%)",
            range = c(0, 100)
          )
        )
      # color palette warning : open issue (https://github.com/plotly/plotly.R/issues/2289)
    })
  })
}
