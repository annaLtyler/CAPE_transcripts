#This function takes in an eqtl.table with positions
# of eQTLs for each transcript with columns
#transcript.id, chromosome, position, LOD score

#and a transcript.pos.table, for the physical position
#of each transcript with columns
#transcript.id, chromosome, and position
	#positions should be in Mb

#col can be a vector of the same length as the
#number of rows in transcript.pos.table.
#if add is FALSE a new plot will be generated.
#if add is TRUE, the points will be plotted on 
#an existing plot.

plot.cistrans.table <- function(eqtl.table, transcript.pos.table, map, col = NULL, 
	add = FALSE, cex = 0.3){
	
    #we will plot one point per eQTL. Make a color vector
    #based on the entries in the eQTL table
	if(is.null(col)){col = rep("black", nrow(eqtl.table))}
	if(length(col) == 1){col <- rep(col, nrow(eqtl.table))}

	#make relative positions for each SNP by chromosome
	 #get the max position for making relative positions of transcripts
	chr.max <- sapply(map, function(x) max(x))
	chr.sum <- sum(chr.max)
	
	if(!add){
		plot.max <- sum(chr.max)

		plot.new()
		plot.window(xlim = c(0, plot.max), ylim = c(0, plot.max))

        chr.max.coord <- cumsum(chr.max)
        chr.min.coord <- chr.max.coord - chr.max

		#add chromosome boundaries and labels
		par(xpd = TRUE)
		for(i in 1:length(map)){
			if(i %% 2 == 1){
                chr.mean.x <- mean(c(chr.max.coord[i], chr.min.coord[i]))
				draw.rectangle(chr.min.coord[i], chr.max.coord[i], 0, plot.max, 
				fill = rgb(189/256 ,189/256 ,189/256, 
				alpha = 0.5), border = NA)
				text(x = chr.mean.x, y = 0, labels = i)
				#if(i < length(map)){text(x = i+1.5, y = 0.5, labels = i+1)}
			}
		}
    }
    
	#for each eQTL, figure out its relative position on the x axis
    rel.pos <- function(chr, pos){
        chr.locale <- which(names(map) == chr)
        rel.loc <- pos/chr.max[chr.locale]
        chr.len <- (chr.max.coord[chr.locale] - chr.min.coord[chr.locale])
        adjust.pos <- chr.len * rel.loc
        rel.x <-  chr.min.coord[chr.locale] + adjust.pos
        return(rel.x)
    }

    eqtl.x <- apply(eqtl.table, 1, function(x) rel.pos(x[2], as.numeric(x[3])))
    
    #build a transcript position table for the eQTL
    eqtl.transcripts <- t(apply(eqtl.table, 1, function(x) transcript.pos.table[which(transcript.pos.table[,1] == x[1]),]))
    
	transcript.y <- apply(eqtl.transcripts, 1, function(x) rel.pos(x[2], as.numeric(x[3])))
    
    #we won't get positions for anything on chromosomes Y or MT
	has.position <- which(sapply(transcript.y, length) > 0)
    eqtl.x <- eqtl.x[has.position]
    transcript.y <- unlist(transcript.y[has.position])
    all.col <- col[has.position]

    points(eqtl.x, transcript.y, col = all.col, pch = 16, cex = cex)

	coord.table <- cbind(eqtl.x, transcript.y, all.col)
    colnames(coord.table) <- c("x", "y", "col")
	invisible(coord.table)
}
