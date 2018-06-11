`%||%` <- function(a, b) if (is.null(a)) b else a

`%diag*%` <- function(d, X) d * X

`%*diag%` <- function(X, d) t(t(X) * d)

`%nin%` <- function(x, table) !(x %in% table)

`%sub_in%` <- function(x, table) x[x %in% table]

`%sub_nin%` <- function(x, table) x[x %nin% table]

`%notchin%` <- function(lhs, rhs) {
  !{lhs %chin% rhs}
}

`%||%` <- function(x, y) ifelse(is.null(x), y, x)

`%||%` <- function(x, y) if (is.null(x)) y else x

`%||%` <- function(x, y) if (is.null(x)) y else x

`%||%` <- function(x, default_val) {
  if (is.null(x)) return(default_val)
  x
}

`%||%` <- function(l, r) if (is.null(l)) r else l

`%p%` <- function(e1,e2) return(paste0(e1,e2))

`%||%` <- function(x, y) {
  if (!is.null(x)) {
    x
  } else {
    y
  }
}

`%==%` <- function(x, y) identical(x, y)

`%!=%` <- function(x, y) !identical(x, y)

`%:::%` <- function(pkg, fun) {
  getFromNamespace(fun, asNamespace(pkg))
}

`%||%` <- function(left, right){
  if (!is.null(left)){
    return(left)
  }
  right
}

`%pin%` <- function(x, table) pmatch(x, table, nomatch = 0L) > 0L

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) <= 0) {
    y
  } else {
    x
  }
}

`%??%` <- function(lhs, rhs)
  if (is_empty(lhs)) rhs else lhs

`%In%` <- function(x,Intv)
{
    if (is.integer(x)) x <- as.double(x)
    if (is.matrix(Intv))
    {
        Intv <- Intervals(Intv)
    }
    distance_to_nearest(x,Intv) == 0
}

`%<<%` <- function(a, b) bitwShiftL(a, b)

`%>>%` <- function(a, b) bitwShiftR(a, b)

`%&%` <- function(a, b) bitwAnd(a, b)

`%notin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

`%or%` <- function(lhs, rhs) if (is.null(lhs)) rhs else lhs

`%||%` <- function (x, y) if (is.null(x)) y else x

`%||%` <- function(x, y) {
    if (is.null(x)) return(y)
    x
}

`%~~%` <- function(x, y) {
    if (length(x) == 0L) return(y)
    x
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

`%||%` <- function(x, y) if(is.null(x)) y else x

`%||%` <- function(x, y) if (is.null(x)) y else x

`%||%` <- function(lhs, rhs) {
  if (is.null(lhs)) {
    rhs
  } else {
    lhs
  }
}

`%R%` <- function(lhs, rhs){
  if(length(lhs)) lhs else rhs
}

`%M%` <- function(lhs, rhs) {
  if (lhs < rhs) {
    old.lhs <- lhs
    lhs <- rhs
    rhs <- old.lhs
  }
  x <- lhs %/% rhs
  y <- lhs %% rhs
  return(c(quotient = x, remainder = y))
}

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

`%notin%` <- function(x, y) {
  !(x %in% y)
}

`%||%` <- function (a, b) {
  if (is.null(a)) b else a
}

`%||%` <- function(a, b) if (!is.null(a)) a else b

`%fin%` <- function(a, tbl) fmatch(a, tbl, 0L, NULL) > 0L

`%||%` <- function(x, y){
  if (is.null(x)) y else x
}

`%||%` <- function (lhs, rhs) {
  lres <- withVisible(eval(lhs, envir = parent.frame()))
  if (is.null(lres$value)) {
    eval(rhs, envir = parent.frame())
  } else {
    if (lres$visible) {
      lres$value
    } else {
      invisible(lres$value)
    }
  }
}

`%&&%` <- function(lhs, rhs) {
  lres <- withVisible(eval(lhs, envir = parent.frame()))
  if (!is.null(lres$value)) {
    eval(rhs, envir = parent.frame())
  } else {
    if (lres$visible) {
      lres$value
    } else {
      invisible(lres$value)
    }
  }
}

`%+%` <- function(x, y) {
  stopifnot(is.character(x), is.character(y))
  paste0(x, y)
}

`%inr%` <- function(x,range)
{
    if (!is.numeric(range) || length(range) != 2)
    {
        stop("Range must be a vector of 2 numeric values")
    }
    if (!is.numeric(x))
    {
        stop("x must be numeric")
    }
    else
    {
        if (diff(range) < 0)
        {
            stop('Range must be increasing')
        }

        x >= range[1] & x <= range[2]
    }
}

`%||%` <- function(l, r) if (is.null(l)) r else l

`%diag*%` <- function(d, X) d * X

`%*diag%` <- function(X, d) t(t(X) * d)

`%||%` <- function(a,b) if(is.null(a)) b else a

`%+%` <- function(a, b) paste0(a, b)

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) <= 0) {
    y
  } else {
    x
  }
}

`%==%` <- function(x, y) {
  identical(x, y)
}

`%!=%` <- function(x, y) {
  !identical(x, y)
}

`%||%` <- function(l, r) if (is.null(l)) r else l

`%contains%` <- function(x,y)contains(y,x)

`%||%` <- function(x, y) if (is.null(x)) y else x

`%din%` <- function(x, y) {
    by <- intersect(names(x), names(y))
    nx <- nrow(x <- as.data.frame(x))
    ny <- nrow(y <- as.data.frame(y))
    bx <- x[,by,drop=FALSE]
    by <- y[,by,drop=FALSE]
    names(bx) = names(by) <- paste("V", seq_len(ncol(bx)), sep="")
    bz <- do.call(paste, c(rbind(bx, by), sep="\r"))
    bx <- bz[seq_len(nx)]
    by <- bz[nx + seq_len(ny)]
    comm <- match(bx, by, 0)
    x[comm > 0,]
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

`%nin%` <- function(x, y) {
  !(x %in% y)
}

`%+%` <- function(lhs, rhs) {
  check_string(lhs)
  check_string(rhs)
  paste0(lhs, rhs)
}

`%||%` <- function(lhs, rhs) {
  if (!is.null(lhs)) { lhs } else { rhs }
}

`%s%` <- function(lhs, rhs) {
  assert_that(is.string(lhs))
  list(lhs) %>%
    c(as.list(rhs)) %>%
    do.call(what = sprintf)
}

`%+%` <- function(lhs, rhs) {
  paste0(lhs, rhs)
}

`%||%` <- function(l, r) if (is.null(l)) r else l

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

`%@%` <- function(x, name) attr(x, name, exact = TRUE)

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

`%notin%` <- function(needle, haystack) {
  ! (needle %in% haystack)
}

`%||%` <- function(l, r) if (is.null(l)) r else l

`%||%` <- function(a, b) if (is.null(a)) b else a

`%||%` <- function (a, b) if (!is.null(a)) a else b

`%:::%` <- function (p, f) get(f, envir = asNamespace(p))

`%::%` <- function (p, f) get(f, envir = asNamespace(p))

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

`%==%` <- function(x, y) {
  identical(x, y)
}

`%||%` <- function(a,b) if(is.null(a)) b else a

`%||%` <- function(l, r) if (is.null(l)) r else l

`%:::%` <- function(p, f) {
  get(f, envir = asNamespace(p))
}

`%||%` <- function(a, b) {
  if (is.null(a)) b else a
}

`%++%` <- function(l, r) { append(l, r) }

`%||%` <- function(a,b) if(is.null(a)) b else a

`%+%` <- function(a,b) paste(a, b, sep = '')

`%+|%` <- function(a,b) paste(a, b, sep = '|')

`%+&%` <- function(a,b) paste(a, b, sep = '&')

`%||%` <- function(l, r) {
  if (is.null(l)) r else l
}

`%notin%` <- function(a, b) !(a %in% b)

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

`%AND%` <- function (x, y)
{
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

`%||%` <- function(x, y) {
  if (!is.null(x)) x else y
}

`%OR%` <- function(x, y) {
  if (is.null(x) || isTRUE(is.na(x)))
    y
  else
    x
}

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

`%.%` <- function(x, y) {
  paste(x, y, sep='')
}

`%OR%` <- function(x, y) {
  if (is.null(x) || isTRUE(is.na(x)))
    y
  else
    x
}

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

`%||%` <- function(l, r) if (is.null(l)) r else l

`%||%` <- function(a, b) {
  if (is.null(a)) b else a
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

`%identical%` <- function(x, y) identical(x, y)

`%assert_class%` <- function(dat, class){
  assert_class(dat = dat, class = class)
}

`%||%` <- function(a, b) if (is.null(a)) b else a

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0L) y else x
}

`%+%` <- function(chr1, chr2){
  paste0(chr1, chr2)
}

`%||%` <- function(l, r) if (is.null(l)) r else l

`%+%` <- function(l, r) {
  assert_string(l)
  assert_string(r)
  paste0(l, r)
}

`%||%` <- function(a, b) if (is.null(a)) b else a

