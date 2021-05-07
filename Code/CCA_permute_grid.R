#This function performs CCA.permute over a grid of penalties

CCA_permute_grid <- function(X, Z, penalty_min = 0, penalty_max = 1, n.penalty = 10, 
nperms = 100, search_grid = TRUE, filename){
    if(!file.exists(filename)){
        penalty_seq <- segment_region(penalty_min, penalty_max, n.penalty, "ends")
        if(search_grid){
            penalty_pairs <- pair.matrix(penalty_seq, ordered = TRUE, self.pairs = TRUE)
        }else{
            penalty_pairs <- cbind(penalty_seq, penalty_seq)
        }
        perm.results <- CCA.permute(x = X, Z, typex = "standard", typez = "standard", 
        penaltyxs = penalty_pairs[,1], penaltyzs = penalty_pairs[,2], nperms = nperms)
        saveRDS(perm.results, filename)
    }else{
        perm.results <- readRDS(filename)
    }
    return(perm.results)
}