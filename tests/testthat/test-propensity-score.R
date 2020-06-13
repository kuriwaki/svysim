

test_that("Propensity Score gives numbers from 0 to 1", {
  expect_true(all(between(p_highed(pop_cces), 0, 1)))
  expect_true(all(between(p_eddem(pop_cces), 0, 1)))
})
