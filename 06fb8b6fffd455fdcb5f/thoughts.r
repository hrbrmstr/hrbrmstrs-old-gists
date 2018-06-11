#' Convert an XML structure to a data.frame (tbl_df)
#' 
#' Given a parsed doc and xpath to parent node of the table structure, 
#' xml_to_data_frame will either automatically convert all 
#' next-level "simple" child nodes (and/or attributes) to a data.frame (tbl_df) 
#' allowing the caller to optionally apply column types (similar to readr 
#' functions since it'll also try to  guess well if not specified) and also
#' supply a vector of possible values that should equate to NA.
#' 
#' If "col_names" is not TRUE it should be a character vector of length 2 or 
#' more that specify the node names to collect and put into a data.frame.
#' 
#' By default this function will "fill" the data.frame.
#' 
#' @param x xml A document, node, or node set.
#' @param xpath duh
#' @param col_names either 
#'         - TRUE to have xml_to_data_frame use the node names for column names
#'         - a character vector of node names to pull for the data frame
#' @param col_types character vector describing column types (simiar to readr functions)
#' @param include_attrs if "col_names" == "nodes" and this is "TRUE", also all node 
#'        attributes to build the data frame
#' @param na character vector of values to treat as NA
#' @param ns duh
xml_to_data_frame <- function(x, xpath, col_names=TRUE, col_types=NULL, include_attrs=FALSE, na="NA", ns=character()) {
}
