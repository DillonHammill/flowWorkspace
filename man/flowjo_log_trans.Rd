% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flow_trans.R
\name{flowjo_log_trans}
\alias{flowjo_log_trans}
\alias{flowJo.flog}
\alias{flowjo_flog}
\title{flog transform function}
\usage{
flowjo_log_trans(
  decade = 4.5,
  offset = 1,
  scale = 1,
  n = 6,
  equal.space = FALSE
)
}
\arguments{
\item{decade}{total number of decades (i.e. log(max)-log(min)}

\item{offset}{offset to the orignal input(i.e. min value)}

\item{scale}{the linear scale factor}

\item{inverse}{whether return the inverse function}
}
\value{
flog(or its inverse) transform function
}
\description{
flog transform function constructor. It is different from flowCore version of \link{logtGml2}
in the way that it reset negative input so that no NAN will be returned.
}
\examples{
trans <- flowjo_log_trans()
data.raw <- c(1,1e2,1e3)
data.trans <- trans[["transform"]](data.raw)
data.trans

inverse.trans <- trans[["inverse"]]
inverse.trans(data.trans)

#negative input
data.raw <- c(-10,1e2,1e3)
data.trans <- trans[["transform"]](data.raw)
data.trans
inverse.trans(data.trans)#we lose the original value at lower end since flog can't restore negative value

#different
trans <- flowjo_log_trans(decade = 3, offset = 30)
data.trans <- trans[["transform"]](data.raw)
data.trans
inverse.trans <- trans[["inverse"]]
inverse.trans(data.trans)

}
