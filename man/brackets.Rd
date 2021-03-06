% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GatingSet_Methods.R
\name{[,GatingSet,ANY-method}
\alias{[,GatingSet,ANY-method}
\alias{[}
\alias{[,GatingSetList,ANY-method}
\alias{brackets}
\alias{[[}
\alias{[[,GatingSet,numeric-method}
\alias{[[,GatingSet,logical-method}
\alias{[[,GatingSet,character-method}
\alias{[[<-,GatingSet,ANY,ANY,GatingHierarchy-method}
\title{Bracket operators on \code{GatingSet} and \code{GatingSetList} objects}
\usage{
x[i]

x[[i]]
}
\arguments{
\item{x}{a \code{GatingSet} or \code{GatingSetList}}

\item{i}{\code{numeric} or \code{logical} or \code{character} used as sample indices}
}
\value{
The \code{[} operator returns an object of the same type as \code{x} corresponding to the subset of indices
in i, while the \code{[[} operator returns a single \code{GatingHierarchy}
}
\description{
\code{[} subsets a \code{GatingSet} or \code{GatingSetList} using the familiar bracket notation

\code{[[} extracts a \code{GatingHierarchy} object from a \code{GatingSet}.
}
