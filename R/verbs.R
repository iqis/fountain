#### Tidyish Verbs from dplyr ####

# TODO
# tidyselect functionality: contains, starts_with(), ends_with()
# currently translated to SoQL, has no environment awareness.
# desc()


#' Select variables
#'
#' @import dplyr
#' @param .data a SODA request
#' @param ... dot-dot-dot
#' @export
select.soda <- function(.data, ...){
  dots <- as.character(match.call(expand.dots = FALSE)$...)
  dots <- gsub("\\s*", "", dots)
  clause <- paste(dots, collapse = ", ")
  res <- .data
  res$query$`$select` <- clause
  res
}

# TODO add `OR` and `NOT` capability
#' Return rows with matching conditions
#'
#' @import dplyr
#' @param .data a SODA request
#' @param ... dot-dot-dot
#' @export
filter.soda <- function(.data, ...){
  dots <- as.character(match.call(expand.dots = FALSE)$...)

  dots <- gsub("\\s*", "", dots) # remove blankspace
  dots <- gsub("==", "=", dots)
  dots <- gsub("!", " NOT ", dots)
  dots <- gsub("\\|", " OR ", dots)
  clause <- paste(dots, collapse = " AND ")

  res <- .data

  if (is.null(res$query$`$group`)) {
    if (length(res$query$`$where`) == 0) {
      query_text <- clause
    } else {
      query_text <- paste(res$query$`$where`, clause, sep = " AND ")
    }
    res$query$`$where` <- query_text
  } else {
    if (length(res$query$`$having`) == 0) {
      query_text <- clause
    } else {
      query_text <- paste(res$query$`$having`, clause, sep = " AND ")
    }
    res$query$`$having` <- query_text  }

  res
}

#' Add new variables
#'
#' @import dplyr
#' @param .data a SODA request
#' @param ... dot-dot-dot
#' @export
mutate.soda <- function(.data, ...){
  dots <- match.call(expand.dots = FALSE)$...
  # dots <- gsub("\\s*", "", dots)

  clause <- character()
  for (i in 1:length(dots)) {
    clause[i] <- paste(deparse(dots[[i]]), "AS", names(dots)[i])
  }
  clause <- paste(clause, collapse = ", ")

  res <- .data
  res$query$`$select` <- paste(res$query$`$select`, clause, sep = ', ')
  res
}

#' Group by one or more variables
#'
#' @import dplyr
#' @export
#' @param .data a SODA request
#' @param ... dot-dot-dot
group_by.soda <-  function(.data, ...){
  dots <- as.character(match.call(expand.dots = FALSE)$...)
  dots <- gsub("\\s*", "", dots)

  clause <- paste(dots, collapse = ", ")
  res <- .data
  res$query$`$group` <- clause
  res$query$`$select` <- clause
  res
}

#' Reduce multiple values down to a single value
#'
#' @import dplyr
#' @param .data a SODA request
#' @param ... dot-dot-dot
#' @export
summarise.soda <- function(.data, ...){
  dots <- match.call(expand.dots = FALSE)$...
  dots_names <- names(dots) # get names
  dots <- gsub("\\s*", "", dots) # remove space & coerce into character

  clause <- character()
  for (i in 1:length(dots)) {
    clause[i] <- paste(dots[i], "AS", dots_names[i])
  }
  clause <- paste(clause, collapse = ", ")

  res <- .data
  res$query$`$select` <- paste(res$query$`$select`, clause, sep = ', ')
  res
}



#' Summarize
#'
#' @inherit summarise.soda
#' @import dplyr
#' @export
summarize.soda <- summarise.soda # how to declare this an alias to summarise() ?



#' Arrange
#'
#' @import dplyr
#' @export
#' @param .data a SODA request
#' @param ... dot-dot-dot
arrange.soda <- function(.data, ...){
  dots <- as.character(match.call(expand.dots = FALSE)$...)
  clause <- paste(dots, collapse = " , ")
  res <- .data
  res$query$`$order` <- clause
  res
}
