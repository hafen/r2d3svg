#' Save a D3 visualization as a PDF file
#' @param d3 D3 visualization to save.
#' @param file File to save PDF into.
#' @param background Text string giving the html background color of
#' @param delay Delay (in seconds) to wait before saving the SVG.
#'   the widget. Defaults to white.
#' @importFrom rsvg rsvg_pdf
#' @export
#' @examples
#' library(r2d3)
#'
#' viz <- r2d3(
#'   data = c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
#'   script = system.file("examples/barchart.js", package = "r2d3")
#' )
#'
#' save_d3_pdf(viz, file = tempfile(fileext = ".pdf"))
save_d3_pdf <- function(d3, file, background = "white", delay = 0.5) {
  tmp_svg <- tempfile("save_d3_svg", fileext = ".svg")
  save_d3_svg(d3, file = tmp_svg, background = background, delay = delay)
  rsvg::rsvg_pdf(tmp_svg, file = file)
  invisible(file)
}
