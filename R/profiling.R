#### Profiling ####


#' Return the first part of an asset
#'
#' Queries the first part of an asset using a SODA request
#' Returns 10 rows by default
#'
#' @import jsonlite utils
#' @export
#' @param x a SODA request
#' @param n number of rows to query
#' @param ... dot-dot-dot
head.soda <- function(x, n = 10, ...){
  request <- x
  request <- set_query_limit_offset(request, limit = n)
  res <- as_data_frame.soda(request)
  res
}



#' Return rich metadata about an asset in a list
#'
#' @import jsonlite httr
#' @export
#' @param request a SODA request
#' @param ... dot-dot-dot
about.soda <- function(request,...){
  res <- list()
  # get row count
  nrow_request <- request
  if (has_plain_query(nrow_request)) { # row count unavailable for plain queries
    res$dim$nrow <- NA
  } else {
    nrow_request$query$`$order` <- NULL
    nrow_request$query$`$select` <- "count (*)"
    res$dim$nrow <- as.numeric(gsub("\\D","", response_content.soda(nrow_request)))
  }

  # get col count
  data_head <- head.soda(request)
  res$dim$ncol <- dim(data_head)[[2]]
  res$colnames <- names(data_head)

  if (!is.null(request$query$`$group`)) { # dim unavailable for aggregate queries
    res$dim$nrow <- NA
    res$dim$ncol <- NA
    res$dim$colnames <- NA
  }

  uuid <- gsub("^.*/", "", request$path)
  meta_request <- request
  meta_request$path <- paste0("api/views/metadata/v1/", uuid)
  res$meta <- jsonlite::fromJSON(response_content.soda(meta_request))

  res
}

#' Column names
#'
#' @export
#' @param request a SODA request
#' @param ... dot-dot-dot
#' @seealso base::colnames
colnames.soda <- function(request, ...){
  about(request)$colnames
}



#' The number of rows/columns of a data frame of SODA asset
#'
#' @param request a SODA request
#' @param ... dot-dot-dot
#' @inherit nrow
#' @export
nrow.soda <- function(request, ...){
  about(request)$dim$nrow
}

#' The number of rows/columns of a data frame of SODA asset
#'
#' @param request a SODA request
#' @param ... dot-dot-dot
#' @inherit ncol
#' @export
ncol.soda <- function(request, ...){
  about(request)$dim$ncol
}



#' Take a glimpse of the first of an asset
#'
#' @import dplyr
#' @export
#' @param request a SODA request
#' @param n number of rows to query
glimpse.soda <- function(request, n = 20){
  dplyr::glimpse(head(request, n))
}


#' Print brief information about an asset targeted by a SODA request to the screen
#'
#' @export
#' @param x a SODA request
#' @param ... dot-dot-dot
print.soda <- function(x, ...){
  request <- x
  cat("<Socrata Resource>: ", paste(request$hostname, request$path, sep = "/"), "\n\n")

  about_it <- about(request)

  cat("Name:\t\t", about_it$meta$name, "\n")
  cat("Attribution:\t", about_it$meta$attribution, "\n")
  cat("Created:\t", as.character(strptime(about_it$meta$createdAt, format = "%Y-%m-%dT%H:%M:%S")), "\n")
  cat("Last Update:\t", as.character(strptime(about_it$meta$dataUpdatedAt, format = "%Y-%m-%dT%H:%M:%S")), "\n")
  cat("\nDescription: ", "\n",about_it$meta$description, "\n\n")
  cat("Query: \n")
  print(request$query)
  if (!is.null(request$query$`$group`)) {
    cat("(dimension unavailable for aggregate queries.)")
  } else {
    cat("\tQuery returns ", about_it$dim$nrow, " rows and ", about_it$dim$ncol, " columns. ")
  }
}
