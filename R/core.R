#' fountain: R Client to Socrata Open Data API
#'

#'
#' @docType package
#' @name fountain
NULL


#### Core ####


#' Create a SODA request
#'
#' Create a SODA request to an asset either using a url,
#' or using together the domain name and the identifier.
#'
#' @param endpoint a url pointing to a SODA endpoint.
#' @param domain a Socratas domain
#' @param uuid the "four-by-four" identifier of an asset on the domain
#' @param ... dot-dot-dot
#' @return a list containing the RESTful API request. See httr::parse_url.
#' @export
soda <- function(endpoint, domain, uuid, ...){
  if (missing(endpoint)) endpoint <- paste("http:/", domain, "resource", uuid, sep = "/" )
  endpoint <- add_protocol(endpoint)
  request <-  httr::parse_url(endpoint)
  class(request) <- c("soda", "fountain", class(request))
  request
}


#' Add credentials to a SODA request
#'
#' Add credentials to a SODA request
#'
#' @param request a SODA request
#' @param app_token an application token issued by Socrata
#' @param user use name issued by the Socrata domain
#' @param password password useed by the Socrata domain
#' @param ... dot-dot-dot, ignored
#' @return a SODA request
#' @export
credential <- function(request, app_token = NULL, user = NULL, password = NULL, ...) {
  attributes(request)$app_token <- app_token
  attributes(request)$user <- user
  attributes(request)$password <- password
  request
}


#' Use a plain SoQL query string in a SODA request
#'
#' Forgiving parameterized queries built by tidyish verbs
#'
#' @param request a SODA request
#' @param query_string a SoQL query string
#' @param ... dot-dot-dot, ignored
#' @return a SODA request with query
#' @export
query.soda <- function(request, query_string, ...){
  res <- request
  res$query <- NULL
  res$query$`$query` <- query_string
  res
}


#' Returns the query of a SODA request
#'
#' @param x a SODA request
#' @param ... dot-dot-dot, ignored
#' @export
show_query.soda <- function(x, ...){
  x$query
}


# TODO
# = add data type parsing when collecting:
# prepare parsing functions to each data type, mind: date/time, GeoJSON, etc
# get data type on fields from response header
# map appropriate parsing function to each field


#' Submit a SODA query and retrieve result
#' @import dplyr
#' @export
#' @param x a SODA request
#' @param ... dot-dot-dot, ignored
collect.soda <- function(x, ...){
  request <- x

  if (has_plain_query(request)) { # set single frame limit & offset
    request$query$`$query` <- paste(request$query$`$query`, "LIMIT 50000")
    request$query$`$query` <- paste(request$query$`$query`, "OFFSET 0")
  } else {
    request$query$`$limit` <- 50000
    request$query$`$offset` <- 0
  }

  res <- data.frame()
  single_frame <- as_data_frame.soda(request)

  suppressWarnings({
    while (nrow(single_frame) > 0) { # paginate through frames
      if (has_plain_query(request)) {
        request$query$`$query` <- gsub("OFFSET .*$", paste("OFFSET", nrow(res)), request$query$`$query`)
      } else {
        request$query$`$offset` <- nrow(res)
      }
      single_frame <- as_data_frame.soda(request)
      res <- dplyr::bind_rows(res, single_frame)
    }
  })

  res
}


# TODO add `very_rich` option, through which queries metadata on assets through "identifier" field
# and merge with original data.

#' Metadata on datasets on a Socrata domain
#'
#' @import httr jsonlite
#' @export
#' @param domain a Socrata domain
#' @param rich get rich metadata
#' @return  a data frame
catalog <- function(domain, rich = FALSE){
  # if (very_rich == TRUE) rich <- TRUE
  request <- httr::parse_url(add_protocol(domain))
  request$path <- "data.json"

  res <- jsonlite::fromJSON(response_content.soda(request))$dataset

  if (!rich) {
    res <- dplyr::select(res, "title", "description", "issued", "modified", "theme", "identifier")
  }

  res$domain <- domain
  # substr_uuid <- function(x) substr(x, (nchar(x) - 8), nchar(x))
  # res$uuid <- substr_uuid(res$identifier)
  res$uuid <- gsub("^.*/", "", res$identifier)

  res$theme <- as.character(res$theme)

  res
}
