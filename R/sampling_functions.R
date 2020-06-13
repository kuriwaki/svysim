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
  urb_int <- (data$cd %in% urban_CDs) + 1 # FALSE = 1, TRUE = 2
  race_int <- zap_labels(data$race)
  educ_int <- zap_labels(data$educ)
  news_int <- zap_labels(data$newsint)

  inv_logit_scaled(-8 +
                     c(2, 0)[urb_int] +
                     c("White" = 1, "Black" = 0.8, "Hispanic" = 0.7, "Asian" = 0.6, "Other" = 0.5)[race_int] +
                     c("No HS" = 0.5, "Some College" = 1.2, "College" = 3.0, "Post-grad" = 4.0)[educ_int] +
                     c("Most" = 4.0, "Often" = 1.0, "Now and Then" = 0.4, "Hardley" = 0.3)[news_int])
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
  urb_int <- (data$cd %in% urban_CDs) + 1 # FALSE = 1, TRUE = 2
  race_int <- zap_labels(data$race)
  educ_int <- zap_labels(data$educ)
  news_int <- zap_labels(data$newsint)
  pid3_int <- zap_labels(data$pid3_leaner)

  inv_logit_scaled(-10 +
                     c(0, 2)[urb_int] +
                     c("White" = 1, "Black" = 0.8, "Hispanic" = 0.7, "Asian" = 0.6, "Other" = 0.5)[race_int] +
                     c("No HS" = 0.5, "Some College" = 1.2, "College" = 3.0, "Post-grad" = 4.0)[educ_int] +
                     c("Most" = 4.0, "Often" = 1.0, "Now and Then" = 0.4, "Hardley" = 0.3)[news_int] +
                     c("D" = 10, "R" = 1, "I" = 0.8, rep(NA, 4), "DK" = 0.8)[pid3_int])
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
