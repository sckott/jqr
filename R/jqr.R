# library("jsonlite")
# library("magrittr")
# library("httr")
# library("dplyr")
# library("data.table")

# json <- content(GET('http://api.plos.org/search/?q=*:*&wt=json'), as = "text")
# fromJSON(json, FALSE)

# jq <- function(json, ...){ 
#   res <- json %>% fromJSON(FALSE)
#   res[[...]]
# }
# 
# json %>% jq('docs')

##################

#' parse json
#' 
#' @import magrittr jsonlite
#' @param json (character) Input json string
#' @param ... Addtn inputs to fromJSON
#' @export
#' @examples
#' library("httr")
#' library("magrittr")
#' library("data.table")
#' 
#' # GBIF example
#' json <- content(GET('http://api.gbif.org/v0.9/occurrence/search?taxonKey=3119195'), as = "text")
#' json %>% 
#'    jq %s% 
#'    'results' %v% 
#'    c('scientificName','country') %>%
#'    rbindlist
#'    
#' # PLOS example
#' json <- content(GET('http://api.plos.org/search/?q=*:*&wt=json'), as = "text")
#' json %>% 
#'    jq %s% 
#'    'response.docs' %v% 
#'    c('id','journal') %>% 
#'    rbindlist

jq <- function(json, ...){ 
  json %>% fromJSON(FALSE, ...)
}

#' Parse one or more named values from a list
#' @param input Input list
#' @param vars Named values to get
#' @export
`%v%` <- function(input, vars){
  #   eval_quoted(as_quoted(vars), json)
  if(length(vars) > 1){
    lapply(input, function(x) x[vars])
  } else {
    sapply(input, function(x) x[[vars]])
  }
}

#' Parse one or more named values from a list
#' @param input Input list
#' @param var Named value to get
#' @export
`%s%` <- function(input, var){
  var <- strsplit(var, "\\.")[[1]]
  input[[var]]
}

#' Parse one or more named values from a list
#' @param x Input list
#' @param ... Addtn inputs
#' @export
kv <- function(x, ...){
  args <- list(...)
  toget <- unname(do.call(c, args))
  lapply(x, function(z){
    names(z) <- names(args)
    z
  })
}