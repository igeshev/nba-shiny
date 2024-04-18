# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
golem::document_and_reload()

# run tests
testthat::test_local()


# deploy app
rsconnect::deployApp(appName = 'nba_dashboard',
                     appFiles = c(
                       'R',
                       'renv.lock',
                       'inst',
                       'data',
                       'NAMESPACE',
                       'DESCRIPTION',
                       "app.R"
                       
                     ))
