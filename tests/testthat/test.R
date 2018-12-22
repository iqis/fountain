#### Authentication
auth_test <-
  soda("https://soda.demo.socrata.com/resource/a9g2-feh2") %>%
  credential(user = "mark.silverberg+soda.demo@socrata.com",
             password = "7vFDsGFDUG") %>% collect()

test_that("authentication works", {
  expect_equal(dim(auth_test), c(3,2))
})


#### Earthquake Data
earthquake <-
  soda("https://soda.demo.socrata.com/resource/4tka-6guv") %>%
  credential(
    username = "mark.silverberg+soda.demo@socrata.com",
    password = "7vFDsGFDUG",
    app_token = "JnDigAX3zQtqQIgBJvVlMLgm8")

# original
earthquake_data <- earthquake %>% collect()


# SoQL
earthquake_soql <- earthquake %>%
  query("SELECT *
        WHERE depth > 15 AND source = 'US'
        ORDER BY depth")

earthquake_soql_data <- earthquake_soql %>% collect()

# aggregate
earthquake_agg <- earthquake %>%
  group_by(region, source) %>%
  summarize(max_depth = max(depth), avg_mag = avg(magnitude)) %>%
  filter(max_depth > 328, source == "us")

earthquake_agg_data <- earthquake_agg %>% collect()

# mutate
earthquake_mutate <- earthquake %>%
  select(magnitude, region, depth, source) %>%
  filter(depth > 10, magnitude > 3) %>%
  mutate(wow_factor = depth * magnitude)

earthquake_mutate_data <- earthquake_mutate %>% collect()


# Tests
test_that("earthquake datasets has correct dimensions", {
  expect_equal(dim(earthquake_data), c(108209, 10))
  expect_equal(dim(earthquake_soql_data), c(5230, 10))
  expect_equal(dim(earthquake_agg_data), c(31, 4))
  expect_equal(dim(earthquake_mutate_data), c(7930, 5))
})
