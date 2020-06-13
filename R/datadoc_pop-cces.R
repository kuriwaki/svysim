#' CCES Sample that can be used as a quasi-sample
#'
#' The cumulative CCES stacks CCES common content for all years and harmonizes
#' the variables, which makes it ideal for using it for MRP.  This is a sample for
#' illustration; see \link{ccesMRPprep::get_cces_dv} to get the full data.
#'
#' @details This is encoded as a RDS file with some variables stored in the Stata-based
#' integer + labelled class instead of as factors. See the CCES cumulative guide
#' for the difference between the two and how to go from one to another.
#'
#' @format A dataset of `r nrow(pop_cces)` observations and `r ncol(pop_cces)` columns.
#' See the CCES cumulative codebook for more explanation of the variables.
#'
#' \describe{
#'   \item{year}{Year of the common content}
#'   \item{case_id}{Respondent identifier (unique within each year)}
#'   \item{state}{State (in the form of \code{state.name})}
#'   \item{cd}{Congressional district at the time of the survey.}
#'   \item{gender}{Gender (equivalent to sex in ACS for the purposes of this package)}
#'   \item{age}{Age, in integers}
#'   \item{race}{Race and ethnicity}
#'   \item{educ}{Education level}
#'   \item{newsint}{Frequency of following the news}
#'   \item{pid3_leaner}{Partisan Identification}
#'   \item{Y}{A simulated continuous outcome. See the source file `data-raw` for exact
#'   simulation}
#'   \item{Z}{A simulated binary outcome, sampled from passing `Y` with a inverse logit
#'    link and using its probailities.}
#' }
#' @source Kuriwaki, Shiro, 2018, "Cumulative CCES Common Content (2006-2018)",
#' <https://doi.org/10.7910/DVN/II2DB6>, Harvard Dataverse
#'
#'
"pop_cces"
