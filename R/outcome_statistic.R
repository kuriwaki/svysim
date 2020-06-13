
#' Get a sample estimate
#'
#' `stat_dem` computes the mean Democrats, `stat_Z` computes the sample proportion
#' of the simulated oucome `Z`, `stat_Y` the mean of the simulated continuous variable
#' `Y`.
#'
#' @param tbl A dataframe with the variable pid3_leaner
#'
#' @return A scalar, in this case the proportion of Democrats (including leaners)
#' @export
stat_dem <- function(tbl) {
  as.numeric(prop.table(table(tbl$pid3_leaner))[1])
}


#' @rdname stat_dem
#'
stat_Z <- function(tbl) {
  mean(tbl$Z)
}

#' @rdname stat_dem
#'
stat_Y <- function(tbl) {
  mean(tbl$Y)
}
