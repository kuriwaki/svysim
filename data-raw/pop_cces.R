## code to prepare `pop_cces` dataset goes here
library(ccesMRPprep)
library(tidyverse)

ccc <- get_cces_dv("cumulative")

pop_cces <- ccc %>%
  filter(year >= 2007, newsint <= 4) %>%
  ccc_std_demographics() %>%
  select(year, case_id, weight, weight_cumulative, state, cd, gender, educ, race, age, age_bin, newsint, pid3_leaner) %>%
  na.omit()

usethis::use_data(pop_cces, overwrite = TRUE)
