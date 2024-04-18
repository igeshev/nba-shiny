#' vline
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd

vline <- function(x = 0, color = "red") {
  list(
    type = "line",
    y0 = 0,
    y1 = 1,
    yref = "paper",
    x0 = x,
    x1 = x,
    line = list(color = color, dash = "dot")
  )
}
