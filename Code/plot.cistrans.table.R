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
	
	if(is.null(col)){col = rep("black", nrow(transcript.pos.table))}
	if(length(col) == 1){col <- rep(col, nrow(transcript.pos.table))}

	#make relative positions for each SNP by chromosome
	chr.max <- sapply(map, function(x) max(x)) #get the max position for making relative positions of transcripts
	rel.snp <- sapply(map, function(x) x/max(x))
	for(i in 1:length(rel.snp)){
		rel.snp[[i]] <- rel.snp[[i]] + i
	}
	snp.pos.table <- Reduce("c", rel.snp)

	rel.pos <- function(chr, pos){
		chr.locale <- which(names(chr.max) == chr)
		chr.size <- chr.max[chr.locale]
		rel.loc <- (pos/chr.size) + chr.locale
		return(rel.loc[1])
	}

	#convert physical transcript positions, and eQTL positions
	#to relative positions.
	transcript.pos <- apply(transcript.pos.table, 1, function(x) rel.pos(x[2], as.numeric(x[3])))
	eqtl.pos <- apply(eqtl.table, 1, function(x) rel.pos(x[2], as.numeric(x[3])))
	
	#group the eQTL positions by transcript ID
	eqtl.pos.list <- lapply(transcript.pos.table[,1], 
		function(x) eqtl.pos[which(eqtl.table[,1] == x)])
	names(eqtl.pos.list) <- transcript.pos.table[,1]
	
	#now plot each lod score where
	#x values are the position of the eQTL peak (from lod.thresh.idx)
	#y values are the position of the transcript for which the peak was found (from gene.loc)	
	
	#for each transcript, at the y value where it is encoded, plot
	#points at the positions of SNPs with high lod scores for that transcript
	#I'm still confused about x and y. Need to review this carefully

	if(!add){
		plot.new()
		plot.window(xlim = c(0, 20), ylim = c(0, 20))

		#add chromosome boundaries and labels
		par(xpd = TRUE)
		for(i in seq(1,length(map), 2)){
			draw.rectangle(i, i+1, 1, length(map)+1, fill = rgb(189/256 ,189/256 ,189/256, alpha = 0.5),
			border = NA)
			text(x = i+0.5, y = 0.5, labels = i)
			#if(i < length(map)){text(x = i+1.5, y = 0.5, labels = i+1)}
		}
	}

	all.x <- unlist(eqtl.pos.list)
	all.y <- unlist(sapply(1:length(eqtl.pos.list), function(x) if(length(eqtl.pos.list[[x]]) > 0){rep(transcript.pos[x], length(eqtl.pos.list[[x]]))}))
	all.col <- unlist(sapply(1:length(eqtl.pos.list), function(x) if(length(eqtl.pos.list[[x]]) > 0){rep(col[x], length(eqtl.pos.list[[x]]))}))
	points(all.x, all.y, col = all.col, pch = 16, cex = cex)

	coord.table <- cbind(all.x, all.y)
	invisible(coord.table)
}
