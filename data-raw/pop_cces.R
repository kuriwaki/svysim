## code to prepare `pop_cces` dataset goes here
library(ccesMRPprep)
library(tidyverse)
library(haven)
library(fabricatr)

ccc <- get_cces_dv("cumulative")

pop_cces_lbl <- ccc %>%
  filter(year >= 2007, newsint <= 4) %>%
  ccc_std_demographics() %>%
  select(year, case_id, weight, weight_cumulative, state, cd, gender, educ, race, age, age_bin, newsint, pid3_leaner) %>%
  na.omit()

pop_y <- fabricate(data = mutate_if(pop_cces_lbl, is.labelled, as_factor),
          XB = (-3 + 0.5*log(age) +
                  -2*(race == "White" & gender == "Male" & educ != "Post-Grad") +
                  2*(newsint == "Most Of The Time") +
                  1.5*(pid3_leaner == "Independent (Excluding Leaners)") +
                  -0.5*(pid3_leaner == "Republican (Including Leaners)")) %>%
            as.numeric() %>%
            replace_na(1),
          prob_indiv = inv_logit_scaled(XB),
          prob_stavg = ave(prob_indiv, state),
          prob_cdavg = ave(prob_indiv, cd),
          bin_st = draw_binary_icc(prob_stavg, clusters = state, ICC = 0.1),
          bin_cd = draw_binary_icc(prob_cdavg, clusters = cd, ICC = 0.3),
          Y = (XB - 0.2*bin_st + 0.8*bin_cd + 2*rnorm(N, sd = 5))/10,
          Z = draw_binomial(link = "logit", latent = Y)) %>%
  as_tibble() %>%
  select(Y, Z)

stopifnot(nrow(pop_y) == nrow(pop_cces_lbl))
pop_cces <- bind_cols(pop_cces_lbl, pop_y)

samp <- samp_with(declare_population(pop_cces), sampling_f = sample_highed, n = 10000)
glm(Z ~ gender + educ + race + pid3_leaner, binomial, mutate_if(samp, is.labelled, as_factor)) %>%
  summary()

usethis::use_data(pop_cces, overwrite = TRUE)
