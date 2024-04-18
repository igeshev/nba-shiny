library(shinytest2)

test_that("{shinytest2} recording: test_empty", {
  app <- AppDriver$new(name = "test_empty")
  app$click("filters-apply_changes")
  app$set_inputs(`filters-last_season_only` = TRUE)
  app$set_inputs(`filters-selected_seasons` = character(0))
  app$expect_values(output = "filters-seasons_empty_warn")
  app$expect_values(input = "filters-highlights_filters")
})
