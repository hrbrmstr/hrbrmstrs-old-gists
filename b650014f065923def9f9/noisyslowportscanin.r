#' Test to see if a TCP port is open
#' 
#' @param host IP address or host name to TCP connect to
#' @param port port to connect to 1:65535
#' @param timeout how many secs to let it try (can be < 1 but shld be > 0)
#' @examples
#' is_port_open("dds.ec", 7070)
is_port_open <- function(host, port=22, timeout=1) {

  require(purrr)
  
  WARN <- getOption("warn")
  options(warn=-1)
  
  SOCK <- purrr::safely(socketConnection)
  
  con <- SOCK(host, port, blocking=TRUE, timeout=timeout)

  if (!is.null(con$result)) {
    close(con$result)
    options(warn=WARN)
    TRUE
  } else {
    options(warn=WARN)
    FALSE
  }

}

is_port_open("dds.ec", 7070)
is_port_open("dds.ec", 22)
is_port_open("rud.is", 22)

