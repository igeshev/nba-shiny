free_throws <- read.csv('data/free_throws.csv') |> 
  tidyr::separate_wider_delim(
    cols = game,
    delim = ' - ',
    names = c('away_team', 'home_team')
  ) |> 
  tidyr::separate_wider_delim(
    cols = end_result,
    delim = ' - ',
    names = c('away_end_score', 'home_end_score'),
    cols_remove = FALSE
  ) |> 
  dplyr::mutate(
    winner  = ifelse(away_end_score> home_end_score, away_team, home_team)
  ) |> 
  tidyr::separate_wider_delim(
    cols = score,
    delim = ' - ',
    names = c('away_score', 'home_score'),
    cols_remove = FALSE
  ) 


write.csv(free_throws , 'data/free_throws.csv', row.names = FALSE)


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



