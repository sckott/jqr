# iris[,as_quoted(.(Species))]
# iris[,plyr:::eval_quoted(as_quoted(.(Species)))]
# plyr:::splitter_d(iris, as_quoted(.(Species)))
# eval_quoted(as_quoted(.(Species)))


choose_vars <- function(json, vars){ 
  eval_quoted(as_quoted(vars), json)
}

`%v%` <- pipe_with(choose_vars)

eval_quoted <- function (exprs, envir = NULL, enclos = NULL, try = FALSE) 
{
  if (is.numeric(exprs)) 
    return(envir[exprs])
  if (!is.null(envir) && !is.list(envir) && !is.environment(envir)) {
    stop("envir must be either NULL, a list, or an environment.")
  }
  qenv <- if (is.quoted(exprs)) 
    attr(exprs, "env")
  else parent.frame()
  if (is.null(envir)) 
    envir <- qenv
  if (is.data.frame(envir) && is.null(enclos)) 
    enclos <- qenv
  if (try) {
    results <- lapply(exprs, failwith(NULL, eval, quiet = TRUE), 
                      envir = envir, enclos = enclos)
  }
  else {
    results <- lapply(exprs, eval, envir = envir, enclos = enclos)
  }
  names(results) <- names(exprs)
  results
}

as_quoted <- function (x, env = parent.frame()) 
{
  structure(lapply(x, function(x) parse(text = x)[[1]]), env = env, 
            class = "quoted")
}