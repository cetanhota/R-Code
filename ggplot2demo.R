data <- structure(list(time = structure(c(1338361200, 1338390000, 1338445800, 
                                          1338476400, 1338532200, 1338562800, 
                                          1338618600, 1338647400, 1338791400, 
                                          1338822000), 
                                        class = c("POSIXct", "POSIXt"), 
                                        tzone = ""), 
                       variable = c(168L, 193L, 193L, 201L, 206L, 200L, 218L, 
                                    205L, 211L, 230L)), 
                  .Names = c("time", "variable"), 
                  row.names = c(NA, -10L), class = "data.frame")

theme_set(theme_bw()) 
ggplot(aes(x = time, y = variable), data = data) + geom_line()
