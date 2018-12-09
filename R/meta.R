#### Meta####


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
    res <- dplyr::select("res", "title", "description", "issued", "modified", "theme", "identifier")
  }

  res$domain <- domain
  # substr_uuid <- function(x) substr(x, (nchar(x) - 8), nchar(x))
  # res$uuid <- substr_uuid(res$identifier)
  res$uuid <- gsub("^.*/", "", res$identifier)

  res$theme <- as.character(res$theme)

  res
}
