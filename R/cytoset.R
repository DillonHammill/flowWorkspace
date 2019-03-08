#' @include cytoframe.R
NULL

#' @include cytoframe.R
NULL

#' 'cytoset': a reference class for efficiently managing the data representation
#' of a \code{flowSet}
#'
#' This class is a container for a set of \code{cytoframe} objects, analagous to
#' a \code{flowSet}. 
#' 
#' Similar to the distinction between the \code{cytoframe} and
#' \code{flowFrame} classes, the primary difference between the \code{cytoset} 
#' and \code{flowSet} classes is in the underlying representation of the data.
#' Because \code{cytoset} is a reference class, copying or subsetting a \code{cytoset}
#' object will return a \code{cytoset} pointing to the same underlying data. A
#' deep copy of the data can be obtained via the \code{\link{realize_view}} method.
#' 
#' There is one notable exception to the typical behavior of most methods returning a \code{cytoframe}.
#' The standard extraction operator (\code{[[]]}) will by default perform a deep
#' copy of the subset being extracted and return a \code{flowFrame}. This is for the sake of compatibility
#' with existing user scripts.
#' methods.
#' 
#' @name cytoset
#' @docType class
#'
#' @section Creating Objects:
#' 
#' Objects can be created using \code{cytoset()} and then adding samples
#' by providing a cytoframe and sample name to \code{cs_add_sample}:\cr\cr
#' 
#' \code{
#' cs <- cytoset()\cr
#' cs_add_sample(cs, "Sample Name", cytoframe)
#' }
#' 
#' The safest and easiest way to create \code{cytoset}s directly from
#' \acronym{FCS} files is via the \code{\link{load_cytoset_from_fcs}} function, and
#' there are alternative ways to specify the files to read. See the separate
#' documentation for details.
#' 
#' @section Methods:
#'   \describe{
#' 
#' \item{[, [[}{Subsetting. \code{x[i]} where \code{i} is a scalar,
#'   returns a \code{cytoset} object, and \code{x[[i]]} a
#'   \code{\linkS4class{flowFrame}} object. In this respect the
#'   semantics are similar to the behavior of the subsetting operators
#'   for lists. \code{x[i, j]} returns a \code{cytoset} for which the
#'   parameters of each \code{\linkS4class{cytoframe}} have been subset
#'   according to \code{j}, \code{x[[i,j]]} returns the subset of a
#'   single \code{\linkS4class{flowFrame}} for all parameters in
#'   \code{j}. 
#'   
#'   The reason for the default behavior for the extraction operator \code{[[]]}
#'   of returning a \code{flowFrame} rather than \code{cytoframe}
#'   is for backwards compatibility with existing user scripts. This behavior
#'   can be overridden to instead return a \code{cytoframe} with the additional
#'   \code{returnType} argument
#'   
#'   \emph{Usage:}
#'   
#'   \code{   cytoset[i]}
#'   
#'   \code{   cytoset[i,j]}
#'   
#'   \code{   cytoset[[i]]}
#'   
#'   \code{cytoset[[i, returnType = "cytoframe"]]}
#' }
#' 
#' \item{$}{Subsetting by frame name. This will return a single
#'   \code{\linkS4class{cytoframe}} object. Note that names may have to
#'   be quoted if they are no valid R symbols
#'   (e.g. \code{cytoset$"sample 1"})
#' }
#' 
#' \item{colnames, colnames<-}{Extract or replace
#'   the \code{character} object with the (common)
#'   column names of all the data matrices in the
#'   \code{\link{cytoframe}}s.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   colnames(cytoset)}
#'   
#'   \code{   colnames(cytoset) <- value}
#' }
#' 
#' \item{identifier, identifier<-}{Extract or replace the \code{name}
#'   item from the environment.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   identifier(cytoset)}
#'   
#'   \code{   identifier(cytoset) <- value}
#'   
#' }
#' 
#' 
#' \item{phenoData, phenoData<-}{Extract or replace the
#'   \code{\link[Biobase:class.AnnotatedDataFrame]{AnnotatedDataFrame}}
#'   containing the phenotypic data for the whole data set. Each row
#'   corresponds to one of the \code{\linkS4class{cytoframe}}s.  
#'   The \code{sampleNames} of \code{phenoData}
#'   (see below) must match the names of the
#'   \code{\linkS4class{cytoframes}} in the \code{frames} environment.
#'   
#'   
#'   \emph{Usage:}
#'   
#'   \code{   phenoData(cytoset)}
#'   
#'   \code{   phenoData(cytoset) <- value}
#'   
#' }
#' 
#' \item{pData, pData<-}{Extract or replace the data frame (or columns
#'   thereof) containing actual phenotypic information from the
#'   \code{phenoData} of the underlying data.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   pData(cytoset)}
#'   
#'   \code{   pData(cytoset)$someColumn <- value}
#'   
#' }
#' 
#' \item{varLabels, varLabels<-}{ \strong{Not yet implemented.}\cr
#'   Extract and set varLabels in the \code{\link[Biobase:class.AnnotatedDataFrame]{AnnotatedDataFrame}}
#'   of the \code{phenoData} of the underyling data.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   varLabels(cytoset)}
#'   
#'   \code{   varLabels(cytoset) <- value}
#'   
#' }
#' 
#' \item{sampleNames}{Extract and replace sample names from the
#'   \code{phenoData}. Sample names correspond to frame
#'   identifiers, and replacing them will also replace the \code{GUID}
#'   for each cytoframe. Note that \code{sampleName} needs to be
#'   unique.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   sampleNames(cytoset)}
#'   
#'   \code{   sampleNames(cytoset) <- value}
#'   
#' }
#' 
#' \item{keyword}{Extract or replace keywords specified in a character
#'   vector or a list from the \code{description} slot of each
#'   frame. See \code{\link{keyword}} for details.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   keyword(cytoset, list(keywords))}
#'   
#'   \code{   keyword(cytoset, keywords)}
#'   
#'   \code{   keyword(cytoset) <- list(foo="bar") }
#'   
#' }
#' 
#' \item{length}{number of \code{\link{cytoframe}} objects in
#'   the set.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   length(cytoset)}
#'   
#' }
#' 
#' \item{show}{display object summary.}
#' 
#' \item{summary}{Return descriptive statistical summary (min, max,
#'   mean and quantile) for each channel of each \code{\link{cytoframe}}
#'   
#'   \emph{Usage:}
#'   
#'   \code{   summary(cytoset)}
#'   
#' }
#' 
#' 
#' \item{fsApply}{Apply a function on all frames in a \code{cytoset}
#'   object. Similar to \code{\link{sapply}}, but with additional
#'   parameters. See separate documentation for details.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   fsApply(cytoset, function, ...)}
#'   
#'   \code{   fsApply(cytoset, function, use.exprs=TRUE, ...)}
#'   
#' }
#' 
#' \item{compensate}{Apply a compensation matrix on all frames in a
#'   \code{cytoset} object. See separate documentation for details.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   compensate(cytoset, matrix)}
#'   
#' }
#' 
#' \item{transform}{Apply a transformation function on all frames of a
#'   \code{cytoset} object. See separate documentation for details.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   transform(cytoset, ...)}
#'   
#' }
#' 
#' \item{filter}{Apply a filter object on a \code{cytoset}
#'   object. There are methods for \code{\linkS4class{filter}}s,
#'   \code{\link{filterSet}}s and lists of filters. The latter has to
#'   be a named list, where names of the list items are matching
#'   sampleNames of the \code{cytoset}. See \code{\linkS4class{filter}}
#'   for details.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   filter(cytoset, filter)}
#'   
#'   \code{   filter(cytoset, list(filters))}
#'   
#' }
#' 
#' \item{split}{Split all \code{cytoset} objects according to a
#'   \code{\link{filter}}, \code{\link{filterResult}} or a list of such
#'   objects, where the length of the list has to be the same as the
#'   length of the \code{cytoset}. This returns a list of
#'   \code{\linkS4class{cytoframe}}s or an object of class
#'   \code{cytoset} if the \code{flowSet} argument is set to
#'   \code{TRUE}. Alternatively, a \code{cytoset} can be split into
#'   separate subsets according to a factor (or any vector that can be
#'   coerced into factors), similar to the behaviour of
#'   \code{\link[base]{split}} for lists. This will return a list of
#'   \code{cytoset}s. See \code{\link{split}} for details.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   split(cytoset, filter)}
#'   
#'   \code{   split(cytoset, filterResult)}
#'   
#'   \code{   split(cytoset, list(filters))}
#'   
#'   \code{   split(cytoset, factor)}
#'   
#' }
#' 
#' \item{Subset}{Returns a \code{cytoset} of
#'   \code{\linkS4class{cytoframe}}s that have been subset according
#'   to a \code{\linkS4class{filter}} or
#'   \code{\linkS4class{filterResult}}, or according to a list of such
#'   items of equal length as the \code{cytoset}.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   Subset(cytoset, filter)}
#'   
#'   \code{   Subset(cytoset, filterResult)}
#'   
#'   \code{   Subset(cytoset, list(filters))}
#'   
#' }
#' 
#' 
#' \item{rbind2}{\strong{Not yet implemented.}\cr Combine two \code{cytoset} objects, or one
#'   \code{cytoset} and one \code{\linkS4class{cytoframe}} object.
#'   
#'   \emph{Usage:}
#'   
#'   \code{   rbind2(cytoset, cytoset)}
#'   
#'   \code{   rbind2(cytoset, cytoframe)}
#'   
#' }
#' 
#' \item{spillover}{Compute spillover matrix from a compensation
#'   set. See separate documentation for details.
#' }
#' 
#' \item{shallow_copy}{Returns a new \code{cytoset} that points to the same
#' underlying data as the original
#'   
#' \emph{Usage:}
#'     
#' \code{shallow_copy(cytoset)}
#'   
#' }
#' \item{realize_view}{Returns a new \code{cytoset} with its own copy of the
#' underlying data (a deep copy). The optional \code{filepath} argument accepts
#' a string to specify a full directory name for storing the new copies of the data 
#' from the FCS files in h5 format.
#'   
#'   \emph{Usage:}
#'     
#'   \code{realize_view(cytoset, filepath)}
#' }
#' \item{cs_add_sample}{Adds a \code{cytoframe} to the \code{cytoset} with sample name given
#' by a string.
#' 
#'   \emph{Usage:}
#'   
#'   \code{cs_add_sample(cytoset, "SampleName", cytoframe)}
#' }
#' }
#'   
#' @importClassesFrom flowCore flowSet
#' @export 
setClass("cytoset", contains = "flowSet"
          ,representation=representation(pointer = "externalptr"))

#' @export 
cytoset <- function(){
	new("cytoset", pointer = new_cytoset())
	
}

#' @rdname cyto_flow_coerce_methods
#' @export 
cytoset_to_flowSet <- function(cs){
  fs <- as(fsApply(cs, function(fr)fr), "flowSet")
  pData(fs) <- pData(cs)
  fs
}

#' @rdname cyto_flow_coerce_methods
#' @export 
flowSet_to_cytoset <- function(fs, path = tempfile()){
  tmp <- tempfile()
  write.flowSet(fs, tmp, filename = sampleNames(fs))
  cs <- load_cytoset_from_fcs(phenoData = list.files(tmp, pattern = ".txt")
                              , path = tmp
                              , is_h5 = TRUE
                              , h5_dir = path)
  cs
}
#' @export
setMethod("phenoData",
		signature=signature(object="cytoset"),
		definition=function(object){
			df <- pData(object)
			new("AnnotatedDataFrame",
					data=df,
					varMetadata=data.frame(labelDescription="Name",
							row.names="name"))
		})

#' @export
setMethod("phenoData<-",
		signature=signature(object="cytoset",
				value="ANY"),
		definition=function(object, value)
		{
			current <- phenoData(object)
			## Sanity checking
			if(nrow(current) != nrow(value))
				stop("phenoData must have the same number of rows as ",
						"flow files")
			## Make sure all of the original frames appear in the new one.
			if(!all(sampleNames(current)%in%sampleNames(value)))
				stop("The sample names no longer match.")
			#validity check for 'name' column
			df <- pData(value)
			if(!"name" %in% colnames(df))
				pData(value)[["name"]] = rownames(df)
			
			
			pData(object) <- df
			object
		})
#' @export 
setMethod("pData",
          signature=signature(object="cytoset"),
          definition=function(object) get_pheno_data(object@pointer))

#' @export 
setReplaceMethod("pData",
                 signature=signature(object="cytoset",
                                     value="data.frame"),
                 definition=function(object,value)
                 {
                   for(i in seq_along(value))
                     value[[i]] <- as.character(value[[i]])
                   set_pheno_data(object@pointer, value)
                   object
                 })

setMethod("colnames",
          signature=signature(x="cytoset"),
          definition=function(x, do.NULL="missing", prefix="missing")
            get_colnames(x@pointer))
  
setReplaceMethod("colnames",
	signature=signature(x="cytoset",
			value="ANY"),
	definition=function(x, value)
	{
       for(i in sampleNames(x))
	   {
         fr <- x[[i, returnType = "cytoframe"]]
		     colnames(fr) <- value
	   }
         
				
	   x
	})

#' @export 
cs_swap_colnames <- function(x, col1, col2){
	invisible(lapply(x, cf_swap_colnames, col1, col2))
	
}
setMethod("markernames",
    signature=signature(object = "cytoset"),
    definition=function(object){
      res <- lapply(sampleNames(object), function(sn){
        markernames(object[[sn, returnType = "cytoframe", use.exprs = FALSE]])
      })
      
      res <- unique(res)
      if(length(res) > 1)
        warning("marker names are not consistent across samples within flowSet")
      else
        res <- res[[1]]
      res
    })
      

#' @export
setReplaceMethod("markernames",
                 signature=signature(object="cytoset", value="ANY"), function(object, value){
                   for(i in sampleNames(object))
                   {
                     fr <- object[[i, returnType = "cytoframe", use.exprs = FALSE]]
                     markernames(fr) <- value
                   }
                   object
                 })

setMethod("show",
          signature=signature(object="cytoset"),
          definition=function(object)
          { 
            cat("A cytoset with", length(object),"samples.\n")
            
            cat("\n")
            #			}
            cat("  column names:\n  ")
            cat(" ", paste(colnames(object), collapse = ", "))
             cat("\n")
            cat("\n")
            
          })
setMethod("sampleNames",
          signature=signature(object="cytoset"),
          definition=function(object) 
            rownames(pData(object)))

setMethod("[[",
          signature=signature(x="cytoset"),
          definition=function(x, i, j,  use.exprs = TRUE, returnType = c("flowFrame", "cytoframe"))
          {
            returnType <- match.arg(returnType)
            if(missing(j))
              j <- NULL
            
            fr <- get_cytoframe_from_cs(x, i, j, use.exprs)
            if(returnType == "flowFrame")
              fr <- cytoframe_to_flowFrame(fr)
            fr
            
          })
#TODO: how to clean up on-disk h5 after replacement with new cf
setReplaceMethod("[[",
	  signature=signature(x="cytoset",
			  value="flowFrame"),
	  definition=function(x, i, j, ..., value)
	  {
	    
		  if(length(i) != 1)
			  stop("subscript out of bounds (index must have ",
					  "length 1)")
		  cnx <- colnames(x)
		  cnv <- colnames(value)
		  if(length(cnx) != length(cnv) || !all(sort(cnv) == sort(cnx)))
			  stop("The colnames of this cytoframe don't match ",
					  "the colnames of the cytoset.")
			  
			  sel <- if(is.numeric(i)) sampleNames(x)[[i]] else i
			  cf <- get_cytoframe_from_cs(x, sel)
			  parameters(cf) <- parameters(value)
			  keyword(cf) <- keyword(value)
			  exprs(cf) <- exprs(value)
			  return(x)
		  })
  

  
  
#' @export
#' @rdname compensate
setMethod("compensate", signature=signature(x="cytoset", spillover="ANY"),
  definition=function(x, spillover){
	  samples <- sampleNames(x)
	  
	  if(!is.list(spillover)||is.data.frame(spillover)){
		  spillover <- sapply(samples, function(guid)spillover, simplify = FALSE)
	  }
	  #can't use NextMethod() for x could be gs due to manual dispatching S4 from compensate method
	  selectMethod("compensate", signature=c(x="cytoset", spillover="list"))(x, spillover)
	  
  })

#' @export
#' @rdname compensate
setMethod("compensate", signature=signature(x="cytoset", spillover="list"),#explicitly define this to avoid dispatching (cs, list) to (flowSet,list)
          definition=function(x, spillover){
            spillover <- sapply(spillover, check_comp, simplify = FALSE)
            
            suppressMessages(cs_set_compensation(x@pointer, spillover, TRUE))
            x
          })

#' @export
setMethod("transform",
	  signature=signature(`_data`="cytoset"),
	  definition=function(`_data`, translist,...)
	  {
		  if(missing(translist))
			  stop("Missing the second argument 'translist'!")
		  else if(is(translist, "transformList"))
		  {
			  translist <- sapply(sampleNames(gs), function(obj)translist, simplify = FALSE)
		  }
	    if(is(translist, "list"))
	    {
	      tList <- lapply(translist, function(trans){
	        if(!is(trans, "transformList"))
	          stop("All the elements of 'translist' must be 'transformList' objects!")
	        })
	      sns <- sampleNames(`_data`)
	      if(!setequal(sns, names(translist)))
	        stop("names of 'translist' must be consistent with flow data!")
	      for(sn in sampleNames(`_data`))
	      {
	        cf <- get_cytoframe_from_cs(`_data`, sn)
	        transform(cf, translist[[sn]], ...)
	      }
      }else
			  stop("expect the second argument as a 'transformList' object or a list of 'transformList' objects!")
		  

		  
		  `_data`
	  })
setMethod("identifier",
		signature=signature(object="cytoset"),
		definition=function (object)
		{
			get_gatingset_id(object@pointer)
		})

# TODO: define its behavior and handle the h5 issue of "unable to truncate a file which is already open"
# csApply <- function(x,FUN,..., new = FALSE)
# 		{
# 			
# 			if(missing(FUN))
# 				stop("csApply function missing")
# 			FUN <- match.fun(FUN)
# 			if(!is.function(FUN))
# 				stop("This is not a function!")
# 			cs.new <- cytoset()
# 			if(new)
# 			{
# 				h5_dir <- identifier(x)
# 				dir.create(h5_dir)
# 			}else
# 			{
# 				h5_dir <- cs_get_h5_file_path(x)
# 				if(h5_dir=="")
# 					stop("in-memory version of cytoset is not supported!")
# 				
# 			}
# 				
# 			for(n in sampleNames(x))
# 			{
# 				fr <- x[[n]]
# 				fr <- try(
# 						FUN(fr,...)
# 				)
# 				if(is(fr, "try-error"))
# 					stop("failed on sample: ", n)
# 				else if(!is(fr, "cytoframe"))
# 				{
# 					
# 					fr <- flowFrame_to_cytoframe(fr, is_h5 = TRUE, h5_filename = file.path(h5_dir, n))
# 				}
# 					
# 				
# 				if(new)
# 					cs_add_sample(cs.new, n, fr)
# 				else
# 					x[[n]]<- fr
# 			}           
# 			if(new)
# 				cs.new
# 			else
# 				x
# 		}

#' Add a cytoframe to a cytoset
#' 
#' @export
cs_add_sample <- function(cs, sn, fr){
	cs_add_cytoframe(cs@pointer, sn, fr@pointer)
}

#' Return the file path of the underlying h5 files
#' 
#' @family cytoframe/cytoset IO functions
#' @export  
cs_get_h5_file_path <- function(x){
	cf <- get_cytoframe_from_cs(x, 1)
	h5file <- cf_get_h5_file_path(cf)
	dirname(h5file)
	
}
#' @export
get_cytoframe_from_cs <- function(x, i, j = NULL, use.exprs = TRUE){
  
  new("cytoframe", pointer = get_cytoframe(x@pointer, i, j), use.exprs = use.exprs)
}
setMethod("[",
	signature=signature(x="cytoset"),
	definition=function(x, i, j, ..., drop=FALSE)
	{
  
		if(missing(i))
		  i <- NULL
    if(missing(j))
      j <- NULL
    x <- shallow_copy(x)
    subset_cytoset(x@pointer, i, j)
    x
	})

# Dispatching to the flowSet-version of fsApply by changing simplify default value from TRUE from FALSE
setMethod("fsApply",
    signature=signature(x="cytoset",
        FUN="ANY"),
    definition=function(x,FUN,...,simplify=FALSE, use.exprs=FALSE)
    {
      callNextMethod()
    })
setMethod("Subset",
          signature=signature(x="cytoset",
                              subset="filterResultList"),
          definition=function(x, subset, ...)
          {
            flowCore:::validFilterResultList(subset, x, strict=FALSE)
            Subset(x, sapply(subset, function(i)as(i, "logical"), simplify = FALSE))
          })
setMethod("Subset",
          signature=signature(x="cytoset",
                              subset="filter"),
          definition=function(x, subset, ...)
          {
            fres <- filter(x, subset, ...)
            Subset(x,fres)
          })

setMethod("Subset",
          signature=signature(x="cytoset",
                              subset="list"),
          definition=function(x, subset, select, validityCheck = TRUE, ...)
          {
            if(is.null(names(subset)))
              stop("Filter list must have names to do something reasonable")
            nn <- names(subset)
            if(validityCheck)
            {
              
              sn <- sampleNames(x)
              unused <- nn[!(nn %in% sn)]
              notfilter <- sn[!(sn %in% nn)]
              ##Do some sanity checks
              if(length(unused) > 0)
                warning(paste("Some filters were not used:\n",
                              paste(unused,sep="",collapse=", ")), call.=FALSE)
              if(length(notfilter) > 0)
                warning(paste("Some frames were not filtered:\n",
                              paste(notfilter,sep="",collapse=", ")),
                        .call=FALSE)	
              if(length(x) != length(subset))
                stop("You must supply a list of the same length as the ncdfFlowSet.")
              used <- nn[nn %in% sn]
            }else
              used <- nn
            
            
            cs = shallow_copy(x)
            for(sn in used)
            {
              
              ind <- subset[[sn]]
              if(is(ind, "logical"))
                ind <- which(ind)
              
              if(!is(ind, "integer"))
                stop("Invalid row indices for: ", sn)
              
              subset_cytoset_by_rows(cs@pointer, sn, ind - 1)
            }
              
            cs         
        })
# copied from subset.gatingSet        
#' @export 
subset.cytoset <- function (x, subset, ...) 
{
	pd <- pData(x)
	r <- if (missing(subset))
				rep_len(TRUE, nrow(x))
			else {
				e <- substitute(subset)
				r <- eval(e, pd, parent.frame())
				if (!is.logical(r))
					stop("'subset' must be logical")
				r & !is.na(r)
			}
	
	x[as.character(rownames(pd[r, ]))]
}
#' @export 
shallow_copy.cytoset <- function(x){
  new("cytoset", pointer = shallow_copy_cytoset(x@pointer))
}
#' @export 
realize_view.cytoset <- function(x, filepath = tempdir()){
  if(!dir.exists(filepath))
    dir.create(filepath)
  new("cytoset", pointer = realize_view_cytoset(x@pointer, filepath))
}




## Note that the replacement method also replaces the GUID for each flowFrame
setReplaceMethod("sampleNames",
	signature=signature(object="cytoset"),
	definition=function(object, value)
	{
		selectMethod("sampleNames<-", signature = "GatingSet")(object, value)
		return(object)
	})

#' apply \code{FUN} to each sample (i.e. \code{cytoframe})
#'
#' sample names are used for names of the returned list
#'
#' @param X \code{cytoset}
#' @param FUN \code{function} to be applied to each sample in 'cytoset'
#' @param ... other arguments to be passed to 'FUN'
#'
#' @rdname lapply-methods
#' @export
setMethod("lapply","cytoset",function(X,FUN,...){
  sapply(sampleNames(X),function(sn,...){
    cf <- get_cytoframe_from_cs(X, sn)
    FUN(cf, ...)
  }, simplify = FALSE, ...)
  
  
})

#' @param cs cytoset object
#' @export 
#' @rdname lock
cs_lock <- function(cs){
	invisible(lapply(cs, cf_lock))
  }
#' @export 
#' @rdname lock
cs_unlock <- function(cs){
	invisible(lapply(cs, cf_unlock))
}

#' @param cs cytoset object
#' @export 
#' @rdname load_meta
cs_flush_meta <- function(cs){
	invisible(lapply(cs, cf_flush_meta))
}
#' @export 
#' @rdname load_meta
cs_load_meta <- function(cs){
	invisible(lapply(cs, cf_load_meta))
}