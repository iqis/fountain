auth_test <-
  soda("https://soda.demo.socrata.com/resource/a9g2-feh2") %>%
  credential(user = "mark.silverberg+soda.demo@socrata.com",
             password = "7vFDsGFDUG") %>% collect()

test_that("authentication works", {
  expect_equal(dim(auth_test), c(3,2))
})


