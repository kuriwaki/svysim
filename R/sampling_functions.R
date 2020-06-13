#' High News Interest Oversample
#'
#'
#' Propensity Score that oversamples high education and high-news interest people
#'
#'
#' @details We model the true propensity score as being a separable function of
#'  race, education, and news interest. There is no explicit correlation between
#'  selection and the outcome (say, partisanship), so Meng's rho would be non-zero
#'  only so far as the covariates correlates with race, education, and news interest.
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
#' @source Inspired by Lauren Kennedy's code in [rstanarm](https://mc-stan.org/rstanarm/articles/mrp.html)
#'
#' @examples
#' p_highed(sample_n(pop_cces, 100))
#'
#' @export
#'
p_highed <- function(data) {
  race_int <- zap_labels(data$race)
  educ_int <- zap_labels(data$educ)
  news_int <- zap_labels(data$newsint)

  inv_logit_scaled(-4 + c(1/(1:5)*c("White" = 1, "Black" = 0.8, "Hispanic" = 0.7, "Asian" = 0.6, "Other" = 0.5))[race_int] +
                     (1/(1:4)*c("No HS" = 0.5, "Some College" = 1.2, "College" = 3.0, "Post-grad" = 4.0))[educ_int] +
                     (1/(1:4)*c("Most" = 4.0, "Often" = 1.0, "Now and Then" = 0.4, "Hardley" = 0.3))[news_int])
}

#' @rdname p_eddem
#'
#' @export
sample_highed <- function(data, n) {
  pscore <- p_highed(data)
  sampled_ind <- sample.int(n = nrow(data), size = n, replace = FALSE, prob = pscore)
  data[sampled_ind, ]
}

#' High News Interest + Democrat Oversample
#'
#'
#' Propensity Score that oversamples high education, high-news
#' interest, and Democratic people
#'
#'
#' @details We model the true propensity score as being a separable function of
#'  race, education, news interest, and party.
#'
#' @inherit p_highed
#'
#' @examples
#' p_eddem(sample_n(pop_cces, 100))
#'
#' @export
p_eddem <- function(data) {
  race_int <- zap_labels(data$race)
  educ_int <- zap_labels(data$educ)
  news_int <- zap_labels(data$newsint)
  pid3_int <- zap_labels(data$pid3_leaner)

  inv_logit_scaled(-4 + c(1/(1:5)*c(1, 0.8, 0.7, 0.6, 0.5))[race_int] +
                     (1/(1:4)*c(0.5, 1.2, 4, 5))[educ_int] +
                     (1/(1:4)*c(4.0, 1, 0.4, 0.3))[news_int] +
                     (1/(1:8)*c(3.0, 1, 1, rep(NA, 4), 1))[pid3_int])
}

#' @rdname p_eddem
#'
#' @export
sample_eddem <- function(data, n) {
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
