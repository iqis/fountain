# fountain: R Client to Socrata Open Data API

[![TravisCI](https://travis-ci.org/iqis/fountain.svg?branch=master)](https://travis-ci.org/iqis/fountain)

This package provides R connectivity to Socrata resources. 

## Installation

To install `fountain` from github (requires `devtools` package):

```R
devtools::install_github("iqis/fountain")
```

## Quick Start

Don't forget to load and attach the package before you start:

```R
require(fountain)
```

Baltimore City's open data platform, [Open Baltimore](https://data.baltimorecity.gov/) uses Socrata.

We choose the [BPD Arrests](https://data.baltimorecity.gov/Public-Safety/BPD-Arrests/3i3v-ibrt) data set. Locate the asset endpoint in the "API" tab, exclude the ".json" or ".csv" at the end: "https://data.baltimorecity.gov/resource/icjs-e3jg".

Initiate a request object from asset URL using `soda()`:

```R
# use the endpoint
bpd_arrests <- soda("https://data.baltimorecity.gov/resource/icjs-e3jg")
# or use domain and uuid separately
bpd_arrests <- soda(domain = "data.baltimorecity.gov", uuid = "icjs-e3jg")
```
Now we have a request.
Take a glimps of what would be the query return, using some familiar functions, data as of Dec 8, 2018:

```R
print(bpd_arrests)
# <Socrata Resource>:  data.baltimorecity.gov/resource/icjs-e3jg 
# 
# Name:		 BPD Arrests 
# Attribution:	 Baltimore Police Department 
# Created:	 2015-05-05 04:37:12 
# Last Update:	 2018-12-05 16:50:52 
# 
# Description:  
#   This data represents the top arrest charge of those processed at Baltimore's Central Booking & Intake Facility. This data does not contain those who have been processed through Juvenile Booking. 
# 
# Query: 
# NULL
# Query returns  46065  rows and  9  columns. 

ncol(bpd_arrests)
# [1] 9
colnames(bpd_arrests)
# [1] "age"   "arrest"   "arrestdate" "arresttime"  "charge"  "chargedescription"
# [7] "incidento"  "race"  "sex"    
nrow(bpd_arrests)
# [1] 46065
head(bpd_arrests)
#    age   arrest              arrestdate arresttime charge              chargedescription               incidento race sex
# 1   49 18083957 2018-05-25T00:00:00.000      09:15 2 0258       FAIL TO PERFORM CONTRACT         Unknown Offense    B   M
# 2   61 18160660 2018-10-23T00:00:00.000      17:00 1 0077              FAILURE TO APPEAR         Unknown Offense    W   F
# 3   28 18024129 2018-02-09T00:00:00.000      17:38 1 1136 THEFT: $1,500 TO UNDER $25,000         Unknown Offense    B   M
# 4   26 17194802 2017-12-12T00:00:00.000      13:50 1 1415             ASSAULT-SEC DEGREE         Unknown Offense    B   M
# 5   29 18118720 2018-08-01T00:00:00.000      17:00 1 0088         VIOLATION OF PROBATION         Unknown Offense    B   M
# 6   37 17196388 2017-12-14T00:00:00.000      15:00 1 0088         VIOLATION OF PROBATION         Unknown Offense    W   F
# 7   20 18085544 2018-05-30T00:00:00.000      11:20 1 0077              FAILURE TO APPEAR         Unknown Offense    U   M
# 8   40 18020788 2018-02-05T00:00:00.000      13:10 1 0088         VIOLATION OF PROBATION 3JKROBB RESIDENCE-KNIFE    B   M
# 9   26 17198172 2017-12-19T00:00:00.000      06:28 1 0077              FAILURE TO APPEAR         Unknown Offense    B   M
# 10  31 17190883 2017-12-05T00:00:00.000      23:30 1 0077              FAILURE TO APPEAR         Unknown Offense    W   M
```

Build request with `dplyr` verbs, let's say we only want the arrest date and time of white female detainees, under 35 years of age:

```R
bpd_arrests <- bpd_arrests %>%
    filter(race == "W", sex == "F", age < 35) %>% 
    select(arrestdate, arresttime)
```

let see the profile of the query again:
```R
bpd_arrests %>% nrow()
# [1] 1499
bpd_arrests%>% head()
#                 arrestdate arresttime
# 1  2017-12-28T00:00:00.000      01:00
# 2  2017-12-28T00:00:00.000      01:00
# 3  2017-12-27T00:00:00.000      09:04
# 4  2017-12-26T00:00:00.000      21:00
# 5  2017-12-26T00:00:00.000      21:00
# 6  2017-12-09T00:00:00.000      07:30
# 7  2017-12-07T00:00:00.000      22:00
# 8  2017-12-08T00:00:00.000      18:40
# 9  2017-12-05T00:00:00.000      00:15
# 10 2017-12-08T00:00:00.000      18:40
```

Looks fine, `collect()` the request to receive a data frame and start working locally:

```R
bpd_arrest_data <- bpd_arrest %>% collect()

head(bpd_arrests_data)
#                 arrestdate arresttime
# 1 2017-12-28T00:00:00.000      01:00
# 2 2017-12-28T00:00:00.000      01:00
# 3 2017-12-27T00:00:00.000      09:04
# 4 2017-12-26T00:00:00.000      21:00
# 5 2017-12-26T00:00:00.000      21:00
# 6 2017-12-09T00:00:00.000      07:30

```

Now if we desire to explore other assets from the same domain, use `catalog()`:

```R
baltimore_catalog <- cagalog("https://data.baltimorecity.gov/")

```
## TODO's

* Error handling faculty
* Accept human-readable URLs directly copied from the browser address bar
* Upload (write) faculty
* Data type parsing from asset metadata
* Integrate CKAN, BKAN, etc along with Socrata?
