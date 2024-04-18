#' comp_player_card UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_comp_player_card_ui <- function(id) {
  ns <- NS(id)
  tagList(
    column(
      6,
      uiOutput(ns("user_box"))
    )
  )
}

#' comp_player_card Server Functions
#'
#' @noRd
mod_comp_player_card_server <- function(id, data, globalFilters, internalFilters) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns





    output$user_box <- renderUI({
      req(internalFilters$get_filter("player_dt_name"))
      globalFilters$trigger$render


      player_name <- internalFilters$get_filter("player_dt_name")
      player_id <- data$get_player_id_from_name(player_name)
      player_image <- hoopR::nba_playerheadshot(player_id)

      # player_stats <- hoopR::nba_playercareerstats(player_id)[['SeasonTotalsPostSeason']]
      
      # player_stats <-player_stats |>
        # janitor::clean_names() |>
        # dplyr::mutate(season = stringr::str_replace(season_id, "-", " - 20")) |>
        # dplyr::select(season, fga, fgm, fg_pct, fg3a, fg3m, fg3_pct)


      # Rendering this inside to avoid multiple API calls for each season
      # output$player_stats_by_season <- DT::renderDataTable({
      #   req(input$player_season)
      # 
      #   player_stats |>
      #     dplyr::filter(season == input$player_season) |>
      #     dplyr::select(-season) |>
      #     dplyr::mutate(dplyr::across(
      #       .cols = tidyr::ends_with("pct"),
      #       \(x){
      #         paste0(round(as.double(x) * 100, 1), "%")
      #       }
      #     )) |>
      #     tidyr::pivot_longer(cols = tidyr::everything()) |>
      #     dplyr::mutate(name = stringr::str_replace_all(
      #       name, c(
      #         "fgm" = "Field Goal Made",
      #         "fga" = "Field Goal Attempted",
      #         "fg_pct" = "Field Goal %",
      #         "fg3a" = "Field Goal Attempted (3pts)",
      #         "fg3m" = "Field Goal Made (3pts)",
      #         "fg3_pct" = "Field Goal % (3pts)"
      #       )
      #     )) |>
      #     DT::datatable(
      #       rownames = FALSE,
      #       selection = "none",
      #       class = list(stripe = FALSE),
      #       colnames = NULL,
      #       options = list(
      #         dom = "t",
      #         ordering = FALSE
      #       )
      #     )
      # })


      userBox(
        width = 12,
        height = 400,
        title = userDescription(
          title = player_name,
          subtitle = "Player Stats",
          type = 1,
          image = player_image,
        ),
        status = "gray-dark",
        boxToolSize = "xl",
        collapsible = FALSE,
        selectInput(
          inputId = ns("player_season"),
          label = "Season",
          choices = globalFilters$filter$selected_seasons,
          selected = max(globalFilters$filter$selected_seasons)
        ),
        '<PLACEHOLDER>',
        # DT::DTOutput(ns("player_stats_by_season")),
        footer = NULL
      )
    })
  })
}
