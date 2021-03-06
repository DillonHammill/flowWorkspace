% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GatingHierarchy_Methods.R
\name{gh_get_compensations}
\alias{gh_get_compensations}
\alias{getCompensationMatrices}
\alias{getCompensationMatrices,GatinHierachy-method}
\title{Retrieve the compensation matrices from a GatingHierarchy}
\usage{
gh_get_compensations(x)
}
\arguments{
\item{x}{A \code{GatingHierarchy} object.}
}
\value{
A list of \code{matrix} representing the spillover matrix in \code{GatingHierarchy}
}
\description{
Retrieve the compensation matrices from a GatingHierarchy.
}
\details{
Return all the compensation matrices in a GatingHierarchy.
}
\examples{
  \dontrun{
	#Assume gh is a GatingHierarchy
  gh_get_compensations(gh);
}
}
