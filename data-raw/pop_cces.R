## code to prepare `pop_cces` dataset goes here
library(ccesMRPprep)
library(tidyverse)
library(haven)
library(fabricatr)

ccc <- get_cces_dv("cumulative")

pop_cces_lbl <- ccc %>%
  filter(year >= 2007, newsint <= 4) %>%
  ccc_std_demographics() %>%
  select(year, case_id, weight, weight_cumulative, state, cd, gender,
         educ, race, age, age_orig,  newsint, pid3_leaner, ideo5) %>%
  na.omit()

pop_y <- fabricate(data = mutate_if(pop_cces_lbl, is.labelled, as_factor),
          XB = (-3 + 0.5*log(age_orig) +
                  -2*(race == "White" & gender == "Male" & educ != "Post-Grad") +
                  2*(newsint == "Most Of The Time") +
                  -5*(ideo5 == "Very Conservative") +
                  -4*(ideo5 == "Conservative") +
                  -3*(ideo5 == "Moderate") +
                  -3*(ideo5 == "Not Sure") +
                  -1*(ideo5 == "Liberal") +
                  -0.5*(pid3_leaner == "Independent (Excluding Leaners)") +
                  -1.5*(pid3_leaner == "Republican (Including Leaners)")) %>%
            as.numeric() %>%
            replace_na(1),
          prob_indiv = inv_logit_scaled(XB),
          prob_stavg = ave(prob_indiv, state),
          prob_cdavg = ave(prob_indiv, cd),
          bin_st = draw_binary_icc(prob_stavg, clusters = state, ICC = 0.15),
          bin_cd = draw_binary_icc(prob_cdavg, clusters = cd, ICC = 0.30),
          Y = (XB + 0.2*bin_st + 0.8*bin_cd + rt(N, df = 5))/10,
          Z = draw_binomial(link = "logit", latent = Y)) %>%
  as_tibble() %>%
  select(ID, Y, Z)

stopifnot(nrow(pop_y) == nrow(pop_cces_lbl))
pop_cces <- bind_cols(pop_cces_lbl, pop_y) %>%
  relocate(ID)

usethis::use_data(pop_cces, overwrite = TRUE)


#
# pop_cces %>% group_by(state) %>% summarize(mean = mean(Y)) %>% ggplot(aes(mean, fct_reorder(state, mean))) + geom_point()
