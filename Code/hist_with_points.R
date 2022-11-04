#This function creates a histogram, but in the form 
#of a stacked stripchart. This gives you the option
#of coloring the points by a particular feature, like
#sex, diet, or another covariate.
#V is your vector of numbers that you want to draw a histogram of
#breaks is the number of bins you want to break your distribution
#into. Akin to breaks in a histogram.


hist_with_points <- function(V, breaks = 100, col = "black",
 main, xlab, ylab, add = FALSE){
    
	if(missing(main)){main = deparse(substitute(V))}
	if(missing(xlab)){xlab = deparse(substitute(V))}
	if(missing(ylab)){ylab = "Density"}


    if(length(col) == 1){
        cols <- rep(col, length(V))
    }else{
        cols = col
    }

    min.val <- min(V, na.rm = TRUE)
    max.val <- max(V, na.rm = TRUE)
    vals <- segment.region(min.val, max.val, breaks, "ends")
    binned.vals <- bin.vector(V, vals)
    u_vals <- unique(binned.vals)
    u_vals <- u_vals[which(!is.na(u_vals))]
    val.idx <- lapply(u_vals, function(x) which(binned.vals == x))
    val.list <- lapply(val.idx, function(x) binned.vals[x])
    val.col <- lapply(val.idx, function(x) cols[x])
    max.len <- max(sapply(val.list, length))
    yvals <- segment.region(0, 1, max.len, "ends")
    
    if(!add){
        plot.new()
        plot.window(xlim = c(min.val, max.val), ylim = c(0,1))
        axis(1);axis(2)
        mtext(xlab, side = 1, line = 2.5)
        mtext(ylab, side = 2, line = 2.5)
        mtext(main, side = 3, line = 1)
    }
    for(i in 1:length(u_vals)){
        points(val.list[[i]], yvals[1:length(val.list[[i]])], 
            col = val.col[[i]], pch = 16)
    }

}
