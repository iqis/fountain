auth_test <-
  soda("https://soda.demo.socrata.com/resource/a9g2-feh2") %>%
  credential(user = "mark.silverberg+soda.demo@socrata.com",
             password = "7vFDsGFDUG") %>% collect()

test_that("authentication works", {
  expect_equal(dim(auth_test), c(3,2))
})



# earthquake <-
#   soda("https://soda.demo.socrata.com/resource/4tka-6guv") %>%
#   credential(
#     username = "mark.silverberg+soda.demo@socrata.com",
#     password = "7vFDsGFDUG",
#     app_token = "JnDigAX3zQtqQIgBJvVlMLgm8")
#
# earthquake_query1 <- earthquake %>%
#   query("SELECT *
#              WHERE depth > 15 AND source = 'US'
#              ORDER BY depth") %>%
#   collect()
#
#
# earthquake_query2 <- earthquake %>%
#   filter(depth > 20, source == 'US') %>%
#   collect()
#
#
# earthquake_query3 <- earthquake %>%
#   group_by(source) %>%
#   summarize(max_depth = max(depth)) %>%
#   filter(depth > 20) %>%
#   collect()
