# fountain: R Client to Socrata Open Data API

[![TravisCI](https://travis-ci.org/iqis/fountain.svg?branch=master)](https://travis-ci.org/iqis/fountain)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/iqis/fountain?branch=master&svg=true)](https://ci.appveyor.com/project/iqis/fountain)

This package provides R connectivity to Socrata resources. 

## Installation

To install fountain from github (requires `devtools` package):

```R
devtools:install_github("iqis/fountain")
```
## Quick Start

Baltimore City's open data platform, [Open Baltimore](https://data.baltimorecity.gov/) uses Socrata. Let's use it as an example.

Locate a dataset of interest.

In this case, we choose the [BPD Arrests](https://data.baltimorecity.gov/Public-Safety/BPD-Arrests/3i3v-ibrt) data set. Locate the endpoint in the "API" tab, exclude the ".json" or ".csv" at the end.

Initiate a request object from asset URL using `soda()`.

If necessary, add credential with optional `credential()`, this is dataset is open to the public: 

```R
# use the endpoint
bpd_arrests <- soda("https://data.baltimorecity.gov/resource/icjs-e3jg")
# or use domain and uuid separately
bpd_arrests <- soda(domain = "data.baltimorecity.gov", uuid = "icjs-e3jg")
```
Now we have a request.
Take a glimps of what would be the query return, using some familiar functions:

```R
ncol(bpd_arrests)
colnames(bpd_arrests)
nrow(bpd_arrests)
head(bpd_arrests)
```

Build request with `dplyr` verbs, let's say we only want the arrest date and time of white female detainees, under 35 years of age:

```R
bpd_arrests_query <- bpd_arrests
    filter(race == "W", sex == "F", age < 35) %>% 
    select(arrestdate, arresttime)
```

let see the profile of the query again:

```R
bpd_arrests_query %>% nrow()
bpd_arrests_query %>% head()
```

We are happy about the result, `collect()` the request to receive a data frame and start to work locally:

```R
bpd_arrest_data <- bpd_arrest_query %>% collect()
```

Also, check out other assets from the same domain:

```R
baltimore_catalog <- cagalog("https://data.baltimorecity.gov/")

```
### TODO's

* Error handling faculty
* Accept human-readable URLs directly copied from the browser address bar
* Upload (write) faculty
