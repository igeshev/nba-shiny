dataManager <- R6::R6Class(
  classname = 'dataManager',
  public = list(
    free_throws = NULL,
    nba_teams_lu = NULL,
    players_lu = NULL,
    
    initialize = function(free_throws, nba_teams_lu, players_lu){
      self$free_throws <- free_throws
      self$nba_teams_lu <- nba_teams_lu
      self$players_lu <- players_lu
    }
  ,
  get_available_teams = function(){
    self$nba_teams_lu |> dplyr::pull(display_name)
  },
  get_team_abbreviation = function(team){
    self$nba_teams_lu |> 
      dplyr::filter(display_name == !!team ) |> 
      dplyr::pull(abbreviation)
  },
  get_available_seasons = function(team){
    
    team_abb <- self$get_team_abbreviation(team)
    
    available_seasons <- self$free_throws |> 
      dplyr::filter(home_team == team_abb |
                    away_team == team_abb) |> 
      dplyr::distinct(season) |> 
      dplyr::pull()
  },
  get_team_logo = function(team){
    self$nba_teams_lu |> 
      dplyr::filter(display_name == team |
                    abbreviation == team) |> 
      dplyr::pull(logo)
  },
  get_last_5_games = function(team, selected_seasons,selected_gametype){
    
    team_abb <- self$get_team_abbreviation(team) 
    
    logo_dims <- '35px'
    self$free_throws |> 
      dplyr::filter(home_team == team_abb |
                      away_team == team_abb,
                    season %in% selected_seasons,
                    playoffs %in% selected_gametype) |> 
      dplyr::distinct(end_result,game_id, .keep_all = TRUE) |>
      
      dplyr::slice_max(order_by = game_id, n = 5) |>  
      dplyr::select(
        home_team,
        home_end_score,
        away_team,
        away_end_score,
        winner
      ) |> 
      dplyr::rowwise() |> 
      dplyr::transmute(
        home_team = 
          paste0('<img width =', logo_dims, 'height =', logo_dims ,' src = ',
                 self$get_team_logo(home_team), '> ', 
                 strong(home_team), ': ', home_end_score),
        away_team =
          paste0('<img width =', logo_dims, 'height =', logo_dims ,' src = ',
                 self$get_team_logo(away_team), '> ', 
                 strong(away_team), ': ', away_end_score),
        won = winner == team_abb
      ) |> 
      dplyr::ungroup()
    
  },
  get_team_stats_wr = function(team, selected_seasons,selected_gametype, type = 'all_time'){
    team_abb <- self$get_team_abbreviation(team) 
    
    assertthat::assert_that(
      type %in% c('all_time', 'last_selected_season'),
      msg = 'type is not one of \'all_time\', \'last_selected_season\''
    )
    
    if(type == 'last_selected_season'){
      seasons_filter <- max(selected_seasons)
    }
    
    
    self$free_throws |> 
      dplyr::filter(home_team == team_abb |
                      away_team == team_abb,
                    playoffs %in% selected_gametype,
                    {if(type!='all_time')season %in% seasons_filter else TRUE}
                    ) |> 
      dplyr::distinct(game_id,winner) |>
      dplyr::ungroup() |> 
      dplyr::summarise(wr = paste0(round(sum(winner==team_abb)/sum(!is.na(winner))*100, digits =0), '%')) |> 
      dplyr::pull(wr)
  },
  get_home_vs_away_winrate = function(team, selected_seasons, selected_gametype){
    team_abb <- self$get_team_abbreviation(team) 
    
    self$free_throws |> 
      dplyr::filter(home_team == team_abb |
                      away_team == team_abb,
                    season %in% selected_seasons,
                    playoffs %in% selected_gametype) |> 
      dplyr::distinct(home_team, away_team, end_result,game_id, .keep_all = TRUE) |> 
      dplyr::ungroup() |> 
      dplyr::summarise(
        home_wr = paste0(round(
          (sum(home_team == team_abb & home_team == winner)/
            sum(home_team == team_abb))*100, digits = 0),'%'),
        away_wr = paste0(round(
          (sum(away_team == team_abb & away_team == winner)/
            sum(home_team == team_abb) )*100, digits = 0),'%')
      )
  },
  get_winrate_over_time = function(team, selected_seasons,selected_gametype){
    
    team_abb <- self$get_team_abbreviation(team) 
    
    self$free_throws |> 
      dplyr::filter((home_team == team_abb |
                      away_team == team_abb),
                    season %in% selected_seasons ,
                    playoffs %in% selected_gametype) |> 
      dplyr::group_by(season) |> 
      dplyr::distinct(home_team, away_team, end_result, game_id, winner, season) |> 
      dplyr::ungroup() |> 
      dplyr::group_by(season) |> 
      dplyr::summarise(
        home = round(
          (sum(home_team == team_abb & home_team == winner)/
             sum(home_team == team_abb))*100, digits = 0),
        away = round(
          (sum(away_team == team_abb & away_team == winner)/
             sum(home_team == team_abb) )*100, digits = 0)
      ) |> 
      tidyr::pivot_longer(
        cols = c(home, away),
        values_to = 'winrate_over_time',
        names_to = 'type'
      ) |> 
      dplyr::mutate(team = team_abb)
    
  },
  get_players_stats_table = function(team, selected_seasons,selected_gametype){
    
    team_abb <- self$get_team_abbreviation(team) 
    
    self$free_throws |> 
      
      dplyr::filter(home_team == team_abb |
                      away_team == team_abb,
                    season %in% selected_seasons,
                    playoffs %in% selected_gametype) |> 
      dplyr::group_by( player ) |> 
      dplyr::summarise(
        total_shots = sum(!is.na(shot_made)),
        shot_conversion_perc = sum(shot_made)/total_shots,
        game_winning_shots = sum(shooting_team == winner &
                                 period == 4 &
                                 (home_end_score == home_score |
                                 away_end_score == away_score)
                                 
                                 )
      ) |> 
      dplyr::arrange(desc(total_shots)) |> 
      dplyr::rename_with(.fn = \(x){
        stringr::str_replace_all(
          stringr::str_to_title(x),
          c('_' = ' ',
            'perc' = '%'
          )
          )
        })
  
    
      
      
    
  },
  get_player_id_from_name = function(name){
    
    self$players_lu |> 
      dplyr::filter(player_name == name) |> 
      dplyr::distinct() |> 
      dplyr::pull(player_id)
  },
  get_ft_accuracy_by_time = function(team, selected_seasons,selected_gametype){
    
    team_abb <- self$get_team_abbreviation(team) 
    
    
    self$free_throws |> 
       dplyr::filter(shooting_team == team_abb,
                    season %in% selected_seasons,
                    playoffs %in% selected_gametype) |> 
      dplyr::mutate(time = lubridate::ms(time) + ((period-1) * lubridate::ms('12:00'))) |> 
      dplyr::mutate(rounded_time = lubridate::minute(time) + (lubridate::second(time)>=30)*1) |> 
      dplyr::group_by(
        season,
        rounded_time,
        shooting_team
      ) |> 
      dplyr::summarise(
        shots_accuracy = (sum(shot_made) / sum(!is.na(shot_made))*100),
        .groups = 'drop'
      ) 
      
  }
  )
  
  
)


globalFilters <- R6::R6Class(
  classname = 'globalFilters',
  public = list(
    # Track & trigger shiny event
    trigger = shiny::reactiveValues(render = 0),
    trigger_rerender = function(){
      self$trigger$render <- self$trigger$render + 1
    },
    filter = list(),
    default_filters = list(),
  initialize = function(default_filters){
    self$default_filters <- default_filters
    self$filter <- default_filters
    
  }
  )
)

internalFilters <- R6::R6Class(
  classname = 'internalFilters',
  public = list(
    filter = reactiveValues(),
    initialize = function(){},
    set_filter = function(filter_name, filter_value){
      
    self$filter[[filter_name]] <- filter_value
  },
  get_filter = function(filter_name){
    # if(is.null(filter_name)) return(NULL)
    self$filter[[filter_name]]
  }
  )
)
