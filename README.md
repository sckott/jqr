jqr
========

A json parser in R inspired by [`jq`]().

### Quick start

Install

```coffee
devtools::install_github("sckott/jqr")
```

Functions

```coffee
# json parser to list
jq <- function(json, ...){
  json %>% fromJSON(simplifyVector = FALSE, ...)
}

# extract named elements from list
`%v%` <- function(input, vars){
  if(length(vars) > 1){
    lapply(input, function(x) x[vars])
  } else {
    sapply(input, function(x) x[[vars]])
  }
}

# Extract single node
`%s%` <- function(input, vars) input[[vars]]

# key-value, rename keys
kv <- function(x, ...){
  args <- list(...)
  toget <- unname(do.call(c, args))
  lapply(x, function(z){
    names(z) <- names(args)
    z
  })
}
```

Load some libraries

```coffee
library("jsonlite")
library("magrittr")
library("httr")
library("data.table")
```

Get some data

```coffee
json <- content(GET('http://api.plos.org/search/?q=*:*&wt=json'), as = "text")
```

Parse

_note how you can index multiple levels down (here, `response.docs`, would normally be object$response$docs) the list with `%s%`_

```coffee
json %>%
  jq %s%
  'response.docs' %v%
  c('id','journal') %>%
  rbindlist
```

```coffee
                                                     id  journal
 1:                  10.1371/journal.pone.0075723/title PLoS ONE
 2:                        10.1371/journal.pone.0087935 PLoS ONE
 3:                  10.1371/journal.pone.0087935/title PLoS ONE
 4:               10.1371/journal.pone.0087935/abstract PLoS ONE
 5:             10.1371/journal.pone.0087935/references PLoS ONE
 6:                   10.1371/journal.pone.0087935/body PLoS ONE
 7:           10.1371/journal.pone.0087935/introduction PLoS ONE
 8: 10.1371/journal.pone.0087935/results_and_discussion PLoS ONE
 9:  10.1371/journal.pone.0087935/materials_and_methods PLoS ONE
10:            10.1371/journal.pone.0087935/conclusions PLoS ONE
```
