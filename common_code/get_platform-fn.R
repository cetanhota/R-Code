get_platform <- function() {
  platform <- .Platform$OS.type
  return(platform)
}