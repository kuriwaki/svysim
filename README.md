
<!-- README.md is generated from README.Rmd. Please edit that file -->

The goal of `svysim` is to facilitate creating realistic simulations of
(biased) survey sampling.

*Abstract*: Surveys are used to teach sampling distributions and
selection biases all the time, but illustrating a sampling distribution
is difficult (because often we only have one survey) and most
simulations are unrealistic (because they draw from a population with
uncorrelated random variables, or because they assume a simple random
sample from that population. This package provides some ready-made
datasets from the CCES and Census-related datasets along with some
customizable sampling schemes, using DeclareDesign.

## Installation

``` r
remotes::install_github("kuriwaki/svysim")
```

## Usage Example

Make a population dataset that expands the common sample via weights.
Though the weights are not frequency weights, we treat it as such for
simplicity.

``` r
pop_wtd <- pop_cces %>% 
  mutate(weight_rounded = ceiling(weight_cumulative)) %>% 
  tidyr::uncount(weights = weight_rounded)

pop_wtd
#> # A tibble: 611,027 x 17
#>    ID     year case_id weight weight_cumulati… state cd     gender    educ
#>    <chr> <dbl> <chr>    <dbl>            <dbl> <chr> <chr> <dbl+l> <dbl+l>
#>  1 0000…  2007 605      0.379             1.24 New … NY-15 1 [Mal… 4 [Pos…
#>  2 0000…  2007 605      0.379             1.24 New … NY-15 1 [Mal… 4 [Pos…
#>  3 0000…  2007 612      0.995             3.26 Kans… KS-01 2 [Fem… 2 [Som…
#>  4 0000…  2007 612      0.995             3.26 Kans… KS-01 2 [Fem… 2 [Som…
#>  5 0000…  2007 612      0.995             3.26 Kans… KS-01 2 [Fem… 2 [Som…
#>  6 0000…  2007 612      0.995             3.26 Kans… KS-01 2 [Fem… 2 [Som…
#>  7 0000…  2007 627      0.379             1.24 Cali… CA-52 2 [Fem… 4 [Pos…
#>  8 0000…  2007 627      0.379             1.24 Cali… CA-52 2 [Fem… 4 [Pos…
#>  9 0000…  2007 674      0.379             1.24 Texas TX-14 2 [Fem… 2 [Som…
#> 10 0000…  2007 674      0.379             1.24 Texas TX-14 2 [Fem… 2 [Som…
#> # … with 611,017 more rows, and 8 more variables: race <int+lbl>,
#> #   age <int+lbl>, age_orig <dbl>, newsint <dbl+lbl>, pid3_leaner <dbl+lbl>,
#> #   ideo5 <dbl+lbl>, Y <dbl>, Z <int>
```

Declare it formally as a population using the `DeclareDesign` package.

``` r
popn <- DeclareDesign::declare_population(pop_cces)
```

Pick a propensity score. For example to oversample highly educated, the
true propensity score we chose is:

``` r
pop_psc <- pop_wtd %>% 
  mutate(
    psc_highed = p_highed(.data),
    psc_eddem  = p_eddem(.data),
  )
```

<img src="man/figures/README-pscore-histogram-1.png" width="90%" />

Take samples, e.g. a 0.1 percent sample with no replacement

``` r
stat_dem(pop_wtd) # true value
#> [1] 0.4624918

samp0  <- samp_with(pop_psc, samp_srs, n = 600)
stat_dem(samp0)
#> [1] 0.43

samp1  <- samp_with(pop_psc, samp_pscore, varname = psc_highed, n = 600)
stat_dem(samp1)
#> [1] 0.4433333

samp2  <- samp_with(pop_psc, samp_pscore, varname = psc_eddem, n = 600)
stat_dem(samp2)
#> [1] 0.5283333
```

Take Multiple Samples. This will take several minutes depending on how
many independent samples we draw.

``` r
pop_mu <- stat_dem(pop_wtd)
n_surveys <- 1000
n_samp <- 600
samps0 <- map_dbl(1:n_surveys, function(x) stat_dem(samp_with(pop_psc, samp_srs, n_samp)))
samps1 <- map_dbl(1:n_surveys, 
                  function(x) stat_dem(samp_with(pop_psc, samp_pscore, varname = psc_highed, n = n_samp)))
samps2 <- map_dbl(1:n_surveys, 
                  function(x) stat_dem(samp_with(pop_psc, samp_pscore, varname = psc_eddem, n = n_samp)))
```

Plot the Sampling Distributions

<img src="man/figures/README-sampling-dist-1.png" width="90%" />

# Related Packages

  - `kuriwaki/ccesMRPprep`
  - `kuriwaki/ddi`
  - `kuriwaki/sparseregMRP`
  - `kuriwaki/synthArea`
