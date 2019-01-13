#### Generics ####


#' Add query to a request
#'
#' This is a generic function
#'
#' @param ... dot-dot-dot
#' @export
query <- function(...) UseMethod("query")

#' Get Information about an object
#'
#' This is a generic function
#'
#' @param ... dot-dot-dot
#' @export
about <- function(...) UseMethod("about")


#' Get an httr response to request
#'
#' This is a generic function
#'
#' @param ... dot-dot-dot
#' @export
response <- function(...) UseMethod("response")

#' Get content from the response to a request
#'
#' This is a generic function
#'
#' @param ... dot-dot-dot
#' @export
response_content <- function(...) UseMethod("response_content")

#' Colnames
#'
#' @inherit base::colnames
#' @param ... dot-dot-dot
#' @export
colnames <- function(...){UseMethod("colnames")}

#' @inherit base::colnames
#' @param ... dot-dot-dot
#' @export
colnames.default <- function(...) base::colnames(...)


#' @inherit base::nrow
#' @param ... dot-dot-dot
#' @export
nrow <- function(...) UseMethod("nrow")

#' @inherit base::nrow
#' @param ... dot-dot-dot
#' @export
nrow.default <- function(...) base::nrow(...)

#' @inherit base::ncol
#' @param ... dot-dot-dot
#' @export
ncol <- function(...) UseMethod("ncol")

#' @inherit base::ncol
#' @param ... dot-dot-dot
#' @export
ncol.default <- function(...) base::ncol(...)

#' @inherit readr::write_csv
#' @import readr
#' @param ... dot-dot-dot
#' @export
write_csv <- function(...) UseMethod("write_csv")

#' @inherit readr::write_csv
#' @import readr
#' @param ... dot-dot-dot
#' @export
write_csv.default <- function(...) readr::write_csv(...)
