#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardPage(
      header =
        bs4DashNavbar(
          title = tags$span(class = "app_title", "NBA Insights"),
          compact = FALSE,
          border = TRUE,
          bs4Dash::navbarMenu(
            navbarTab(
              text = "OVERVIEW",
              tabName = "highlights"
            ),
            navbarTab(
              text = "DEEP DIVE",
              tabName = "deepdive"
            )
          ),
          fixed = TRUE
        ),
      body = dashboardBody(
        fluidRow(mod_filters_global_ui("filters")),
        tabItems(
          tabItem(
            tabName = "highlights",
            mod_page_highlights_ui("highlights")
          ),
          tabItem(
            tabName = "deepdive",
            mod_page_deepdive_ui("deepdive")
          )
        )
      ),
      sidebar = dashboardSidebar(disable = TRUE),
      dark = NULL,
      help = NULL,
      preloader = list(
        html = tagList(waiter::spin_ball()),
        color = "#576270"
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "nba.dashboard"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
