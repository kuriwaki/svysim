#' Sample with custom function
#'
#'
#' @param population A dataframe, which will be wrapped internally around \link{DeclareDesign::declare_design}.
#' See help page here.
#' @param sampling_f A sampling function that can be passed as a handler to
#' `declare_sampling`.
#' @param n the sample size to draw
#'
#' @importFrom DeclareDesign declare_sampling draw_data declare_population
#'
#'
#' @examples
#'
#' # Population Value
#' stat_dem(pop_cces)
#'
#' # SRS
#' samp0  <- samp_with(pop_cces, samp_srs, n = 1000)
#' stat_dem(samp0)
#'
#' # Oversample Higher-ed
#' samp1  <- samp_with(pop_cces, samp_highed, n = 1000)
#' stat_dem(samp1)
#'
#' @export
samp_with <- function(population, sampling_f, n, ...) {
  population <- declare_population(population)
  draw_data(population + declare_sampling(handler = sampling_f, n = n, ...))
}

