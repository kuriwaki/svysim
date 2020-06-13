urban_CDs <- read_rds("~/Dropbox/swing-split/data/input/by-cd/rural-urban.rds") %>% filter(cluster == "Pure urban") %>% pull(cd) %>% dput()

usethis::use_data(urban_CDs, overwrite = TRUE)
