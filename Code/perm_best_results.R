perm_best_results <- function(perm_grid, pval.thresh = 0.05, 
    cor.diff.thresh = 0, plot.results = TRUE){

    pass.p <- which(perm_grid$p <= pval.thresh)
    cor.diff <- perm_grid$Cor - perm_grid$Perm.Cor
    pass.cor <- which(cor.diff > cor.diff.thresh)
    best.penalty <- intersect(pass.p, pass.cor)
    nx <- ncol(cor.diff)
    nz <- nrow(cor.diff)
    best.penalty.z <- best.penalty %% nz
    best.penalty.x <- ceiling(best.penalty/nx)
    best.penalty <- list("x" = as.numeric(colnames(cor.diff)[best.penalty.x]),
        "z" = as.numeric(rownames(cor.diff)[best.penalty.z]))

    star.nudge = 0.3

    if(plot.results){
        par(mfrow = c(2,2), mar = c(1,2,2,1))
        imageWithText(round(perm_grid$Cor, 2), col.scale = "blue", 
        main = "Correlations of Identified Components", 
        col.text.rotation = 0, row.text.shift = -0.25)
        points(x = best.penalty.x+star.nudge, 
        y = nz - best.penalty.z + 1 + star.nudge, 
        pch = "*", col = "red", cex = 1)
        
        imageWithText(round(perm_grid$Perm.Cor, 2), col.scale = "red", 
        main = "Correlations of Permuted Components", 
        col.text.rotation = 0, row.text.shift = -0.25)
        points(x = best.penalty.x + star.nudge, 
        y = nz - best.penalty.z + 1 + star.nudge, 
        pch = "*", col = "blue", cex = 1)
        
        imageWithText(round(cor.diff, 2), col.scale = "purple", 
        main = "Difference in Correlations", 
        col.text.rotation = 0, row.text.shift = -0.25)
        points(x = best.penalty.x + star.nudge, 
        y = nz - best.penalty.z + 1 + star.nudge, 
        pch = "*", col = "red", cex = 1)
        
        imageWithText(perm_grid$p, col.scale = "green", 
        main = "P values", col.text.rotation = 0, row.text.shift = -0.25)
        points(x = best.penalty.x + star.nudge, 
        y = nz - best.penalty.z + 1 + star.nudge, 
        pch = "*", col = "red", cex = 1)
    }

   return(best.penalty)

}