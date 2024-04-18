#' comp_last_games UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_comp_last_games_ui <- function(id) {
  ns <- NS(id)
  tagList(
    column(
      12,
      uiOutput(ns("last_6_games"))
    )
  )
}

#' comp_last_games Server Functions
#'
#' @noRd
mod_comp_last_games_server <- function(id, data, globalFilters) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns



    output$last_6_games <- renderUI({
      globalFilters$trigger$render

      data <- data$get_last_5_games(
        globalFilters$filter$selected_team,
        globalFilters$filter$selected_season,
        globalFilters$filter$selected_gametype
      )



      last_games <- purrr::map(
        .x = 1:nrow(data),
        .f = \(x){
          row <- data[x, ]
          title <- paste0("Last 5 Games - #", x)
          box(
            title = title,
            width = 2,
            closable = FALSE,
            collapsible = FALSE,
            height = 130,
            fluidRow(
              column(6, HTML(paste0(row$home_team, "<br>", row$away_team))),
              column(6, div(
                style = "font-family: 'NBA';
                            display:flex; justify-content:center; align-items:center;
                            font-size:42px; font-weight: 400;
                            ",
                if (row$won) {
                  span(style = "color: var(--nba_blue);opacity: 0.8;", "Win")
                } else {
                  span(style = "color: var(--nba_red);opacity: 0.6;", "Loss")
                }
              ))
            )
          )
        }
      )

      tagList(fluidRow(
        box(
          title = "Last 5 games WR",
          width = 2,
          closable = FALSE,
          collapsible = FALSE,
          height = 130,
          div(
            style = "font-family: 'NBA';
                            display:flex; justify-content:space-between; align-items:center;
                            font-size:32px; font-weight: 400;",
            "WINS:", as.integer(sum(data$won)), br(),
            "LOSSES:", 5 - as.integer(sum(data$won))
          )
        ),
        last_games
      ))
    })
  })
}
