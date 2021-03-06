% Generated by roxygen2 (4.0.1): do not edit by hand
\name{jq}
\alias{jq}
\title{parse json}
\usage{
jq(json, ...)
}
\arguments{
\item{json}{(character) Input json string}

\item{...}{Addtn inputs to fromJSON}
}
\description{
parse json
}
\examples{
library("httr")
library("data.table")

# GBIF example
json <- content(GET('http://api.gbif.org/v0.9/occurrence/search?taxonKey=3119195'), as = "text")
json \%>\%
   jq \%s\%
   'results' \%v\%
   c('scientificName','country') \%>\%
   rbindlist

# PLOS example
## The jqr way
json <- content(GET('http://api.plos.org/search/?q=*:*&wt=json'), as = "text")
json \%>\%
   jq \%s\%
   'response.docs' \%v\%
   c('id','journal') \%>\%
   rbindlist
## How it would be otherwise
library("jsonlite")
res <- fromJSON(json, FALSE)
out <- res$response$docs
out2 <- lapply(out, function(x) x[c('id','journal')])
rbindlist(out2)
## Thought the jqr way is a tiny bit longer, it's much more intuitive
}

