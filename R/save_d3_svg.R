#' Save a D3 visualization as a SVG file
#' @param d3 D3 visualization to save.
#' @param file File to save SCG into.
#' @param background Text string giving the html background color of
#'   the widget. Defaults to white.
#' @param delay Delay (in seconds) to wait before saving the SVG.
#' @importFrom r2d3 save_d3_html
#' @importFrom chromote ChromoteSession
#' @export
#' @examples
#' library(r2d3)
#'
#' viz <- r2d3(
#'   data = c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
#'   script = system.file("examples/barchart.js", package = "r2d3")
#' )
#'
#' save_d3_svg(viz, file = tempfile(fileext = ".svg"))
save_d3_svg <- function(d3, file, background = "white", delay = 0.5) {
  tmp_html <- tempfile("save_d3_svg", fileext = ".html")

  # use synchronous (for now) since it's easier
  b <- chromote::ChromoteSession$new()
  on.exit(unlink(tmp_html))
  r2d3::save_d3_html(d3, file = tmp_html, background = background)

  b$Page$navigate(file_url(tmp_html))
  # b$Page$loadEventFired()
  Sys.sleep(delay)

  # TODO: allow custom JS to be evaluated prior to saving the SVG
  # (e.g. triggering an interaction with the plot, etc.)

  eval <- paste0(
    "var el = document.getElementById('htmlwidget_container').firstElementChild;\n",
    "el.shadowRoot === null ? el.innerHTML : el.shadowRoot.innerHTML;"
  )
  x <- b$Runtime$evaluate(eval)

  # TODO: look for any external dependencies and base64 encode
  cat(x$result$value, file = file)

  invisible(file)
}

file_url <- function(filename) {
  if (is_windows()) {
    paste0("file://", normalizePath(filename, mustWork = TRUE))
  } else {
    enc2utf8(paste0("file:///", normalizePath(filename, winslash = "/",
      mustWork = TRUE)))
  }
}

is_windows <- function() .Platform$OS.type == "windows"
# is_mac <- function() Sys.info()[['sysname']] == 'Darwin'
# is_linux <- function() Sys.info()[['sysname']] == 'Linux'
