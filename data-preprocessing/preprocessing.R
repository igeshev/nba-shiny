free_throws <- read.csv("data/free_throws.csv") |>
  tidyr::separate_wider_delim(
    cols = game,
    delim = " - ",
    names = c("away_team", "home_team")
  ) |>
  tidyr::separate_wider_delim(
    cols = end_result,
    delim = " - ",
    names = c("away_end_score", "home_end_score"),
    cols_remove = FALSE
  ) |>
  dplyr::mutate(
    winner = ifelse(away_end_score > home_end_score, away_team, home_team)
  ) |>
  tidyr::separate_wider_delim(
    cols = score,
    delim = " - ",
    names = c("away_score", "home_score"),
    cols_remove = FALSE
  )



# we need all team players to understand which team the shooting player was a part of

seasons_in_data <- stringr::str_replace(
  unique(free_throws$season),
  " - 20", "-"
)

players_lu <- purrr::map(
  .x = seasons_in_data,
  .f = \(season){
    message("Extracting Player Data For Season: ", season)
    tmp <- hoopR::nba_playerindex(season = season)$PlayerIndex |>
      dplyr::mutate(season = stringr::str_replace(season, "-", " - 20"))

    assertthat::assert_that(
      nrow(tmp) > 0,
      msg = "No Data Extracted, Please check your statement"
    )

    tmp
  }
) |>
  dplyr::bind_rows() |>
  dplyr::mutate(player_name = paste0(PLAYER_FIRST_NAME, " ", PLAYER_LAST_NAME))


players_ids_lu <- players_lu |>
  dplyr::select(
    "player_id" = PERSON_ID,
    player_name
  )

write.csv(players_ids_lu, "data/players_lu.csv", row.names = FALSE)


players_lu_new <- players_lu |>
  dplyr::select(player_name,
    "lu_team" = TEAM_ABBREVIATION,
    season
  ) |>
  dplyr::mutate(
    lu_team = stringr::str_replace_all(
      lu_team,
      c(
        "WAS" = "WSH",
        "NJN" = "NJ",
        "NOK" = "NO",
        "GSW" = "GS",
        "SAS" = "SA",
        "NYK" = "NY",
        "UTA" = "UTAH"
      )
    )
  ) |>
  dplyr::distinct(season, player_name, .keep_all = TRUE)

free_throws <- free_throws |>
  dplyr::left_join(players_lu_new, by = c("player" = "player_name", "season" = "season")) |>
  dplyr::mutate(
    check = home_team == lu_team | away_team == lu_team
  ) |>
  dplyr::mutate(
    # if we couldn't match the team we select the away team (not the best but no time)
    shooting_team = ifelse(is.na(lu_team) | !check, away_team, lu_team)
  )



write.csv(free_throws, "data/free_throws.csv", row.names = FALSE)



# TESTING derived field -----
# dplyr::left_join(
#   players_lu |>
#     dplyr::mutate(player = paste0(PLAYER_FIRST_NAME, ' ', PLAYER_LAST_NAME)) |> janitor::clean_names() |>
#     dplyr::select(player, team_abbreviation),
#   by = c('player' = 'player' ),
#   multiple = 'any',
# ) |>
# dplyr::mutate(
#   shot_from_team = dplyr::case_when(
#     home_team == team_abbreviation ~ home_team,
#     away_team == team_abbreviation ~ away_team,
#     .default = NA
#   )
# ) |>
# dplyr::group_by(game_id, time) |>
# dplyr::mutate(
#   shot_from_team = dplyr::case_when(
#     shot_made & away_score > dplyr::lag(away_score) ~ away_team,
#     shot_made & home_score > dplyr::lag(home_score) ~ home_team,
#     .default = NA
#   )
# ) |>
# dplyr::ungroup()
