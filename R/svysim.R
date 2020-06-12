#' Sample with custom function
#'
#'
#' @param population An object defined by \link{DeclareDesign::declare_design}. See
#' help page here.
#' @param sampling_f A sampling function that can be passed as a handler to
#' `declare_sampling`.
#' @param n the sample size to draw
#'
#' @importFrom DeclareDesign declare_sampling draw_data
#'
#'
#' @examples
#'
#' # Population Value
#' popn <- declare_population(pop_cces)
#' stat_dem(pop_cces)
#'
#' # SRS
#' samp0  <- samp_with(popn, sample_srs, n = 1000))
#' stat_dem(samp0)
#'
#' # Oversample Higher-ed
#' samp1  <- samp_with(popn, sample_highed, n = 1000)
#' stat_dem(samp1)
#'
#' @export
samp_with <- function(population, sampling_f, n) {
  draw_data(population + declare_sampling(handler = sampling_f, n = n))
}

#' Propensity Score Simulation
#'
#'
#' Propensity Score that oversamples high education and high-news interest people
#'
#'
#' @param data A tibble with the columns race, educ, newsint, as coded by the CCES
#' @param n Sample size to sample
#'
#' @return A vector of propensity scores ranging from 0 to 1
#'
#' @importFrom haven zap_labels
#' @importFrom brms inv_logit_scaled
#'
#' @export
p_highed <- function(data) {
  race_int <- zap_labels(data$race)
  educ_int <- zap_labels(data$educ)
  news_int <- zap_labels(data$newsint)

  inv_logit_scaled(-4 + c(1/(1:5)*c(1, 0.8, 0.7, 0.6, 0.5))[race_int] +
                     (1/(1:4)*c(0.5, 1.2, 4, 5))[educ_int] +
                     (1/(1:4)*c(6, 1, 0.4, 0.3))[news_int])
}

#' @rdname p_highed
#'
#' @export
sample_highed <- function(data, n) {
  pscore <- p_highed(data)
  sampled_ind <- sample.int(n = nrow(data), size = n, replace = FALSE, prob = pscore)
  data[sampled_ind, ]
}


#' Simple Random Sample
#'
#' @inheritParams p_highed
#'
#' @importFrom dplyr sample_n
#'
#' @export
sample_srs <- function(data, n) {
  sample_n(data, n)
}

#' Get a sample estimate
#'
#' @param tbl A dataframe with the variable pid3_leaner
#'
#' @return A scalar, in this case the proportion of Democrats (including leaners)
#' @export
stat_dem <- function(tbl) {
  as.numeric(prop.table(table(tbl$pid3_leaner))[1])
}
