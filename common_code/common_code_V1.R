#library(DBI)
#library(RMySQL)
#library(jsonlite)

get__platform <- function() {
  platform <- .Platform$OS.type
  return(platform)
}

getfilepath           <- function( env_var ) {
  pl        <- get__platform()
  if ( pl == "windows" ) {
    fpath     <- "'C:/Users/wleutwy/My Documents/R`"
  } else if (is.element(pl, c("unix", "linux" ))) {
    #fpath     <- Sys.getenv(env_var)
    fpath <- "/Users/wayne/R"
  } else {
    ermsg     <- paste0("[send__email] Unsupported platform - [", pl, "]")
    stop( ermsg )
  }
  return ( fpath )
}

bp_db_connect <- function(){
  filepath <- getfilepath()
  id = fromJSON(paste0(filepath, "/common_code/keys.json"))$id
  pw = fromJSON(paste0(filepath, "/common_code/keys.json"))$pw
  
  con <- dbConnect(MySQL(), user=(id), password=(pw), 
                   dbname="bloodpressure", host="192.168.1.21")
}
