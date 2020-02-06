
# r2d3svg

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The simple goal of the r2d3svg package is to provide high-quality vector-based file outputs (svg and pdf) for visualizations created with the [r2d3](https://github.com/rstudio/r2d3) package (or technically any htmlwidget that produces a single visualization contained in an `<svg>` tag).

The motivation for this package is the desire for vector-based file outputs of web-based visualizations, potentially for use in publications, etc. The [webshot](https://github.com/wch/webshot) and [webshot2](https://github.com/rstudio/webshot2) packages provide a great way to capture raster images (or, additionally, entire web page pdf printouts in the case of webshot2), but raster is often not enough.

## Installation

You can install r2d3svg with:

``` r
# install.packages("remotes")
remotes::install_github("hafen/r2d3svg")
```

## Example

``` r
library(r2d3)
library(r2d3svg)
d3 <- r2d3(
  data = c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
  script = system.file("examples/barchart.js", package = "r2d3")
)
save_d3_svg(d3, file = tempfile(fileext = ".svg"))
save_d3_pdf(d3, file = tempfile(fileext = ".pdf"))
```

## Notes

This package works by rendering the r2d3 graphic in a headless Chromium-based browser using the [chromote](https://github.com/rstudio/chromote) package. Once rendered, we can simply extract the contents of the `<svg>` tag and save it as an SVG file. To create a PDF, the [rsvg](https://github.com/jeroen/rsvg) package is used to convert the SVG to a PDF. For PDF outputs, this is preferable to using [webshot2](https://github.com/rstudio/webshot2) to create a PDF printout of the entire page.

This package makes use of the [chromote](https://github.com/rstudio/chromote) package, which is experimental and under devlopment. While using something like PhantomJS under the hood would be more stable, it has been discontinued and cannot handle some modern d3 visualizations (that use ES6 for example).

To be ready for more stable use, there are a few things that would be ideal:

- Not depend on the user having a Chromium-based browser installed. Ideally chromote would have an `install_chrome()` function that is called one time and installs an isolated Chrome in a predictable place.
- Be able to cleanly close chromote connections after each call to `save_d3_svg()` (otherwise, examples fail and there seems to be increased CPU cycles in the rest of the R session).
- Perhaps only *suggest* [rsvg](https://github.com/jeroen/rsvg) since it has a system dependency which could make it difficult to install on some systems. If not available, gracefully fail when trying to save to PDF.
- Better error detection and handling.
