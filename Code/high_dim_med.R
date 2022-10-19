#This function performs high-dimensional mediation
#with either kernelized matrices, or data matrices.
#all matrices must have rownames that can be aligned
#by the function
#kernel.c, kernel.m, and kernel.o indicate whether the causal,
#mediating, and outcome matrices are kernelized
#mediation.type determines whether we are looking for 
#complete mediation: causal -> mediating -> outcome
#or a reactive model: causal -> outcome -> mediating
#The default is complete mediation


high_dim_med <- function(causal.matrix, mediating.matrix, outcome.matrix, 
    num.iterations = 5, verbose = FALSE, kernel.c = TRUE, kernel.m = TRUE, 
    kernel.o = TRUE){

    common.ind <- Reduce("intersect", list(rownames(causal.matrix), 
        rownames(mediating.matrix), rownames(outcome.matrix)))

    if(kernel.c){
        g <- causal.matrix[common.ind, common.ind]
    }else{
        g <- causal.matrix[common.ind,,drop=FALSE]
    }

    if(kernel.m){
        t <- mediating.matrix[common.ind, common.ind]
    }else{
        t <- mediating.matrix[common.ind,,drop=FALSE]
    }

    if(kernel.o){
        p <- outcome.matrix[common.ind, common.ind]
    }else{
        p <- outcome.matrix[common.ind,,drop=FALSE]
    }

    A = list(g = g, t = t, p = p)

    weight.mat = 0.5 * matrix(c(0,0,0,1,0,0,0,1,0), 3, 3)    
    weight.mat = weight.mat + t(weight.mat)

    # Loop over "EM" iterations
    #five iteractions seem to be sufficient to converge in all cases
    #might want to make a more sophisticated check later.
    for(i in 1:num.iterations){
        curr_model = rgcca(A, weight.mat, tau = "optimal", verbose = FALSE)
        
        curr_g_score = as.matrix(A[[1]] %*% curr_model$a[[1]])
        curr_t_score = as.matrix(A[[2]] %*% curr_model$a[[2]])
        curr_p_score = as.matrix(A[[3]] %*% curr_model$a[[3]])
        
        curr_scores = cbind(curr_g_score, cbind(curr_t_score, curr_p_score))
        model_scores[[tx]] <- curr_scores        

        curr_cor = cor(curr_scores)
        
        w1 = curr_cor[1, 2] / (1 - curr_cor[1, 2]^2)
        w2 = curr_cor[2, 3] / (1 - curr_cor[2, 3]^2)
        
        W1 = w1 / (w1 + w2)
        W2 = w2 / (w1 + w2)
        
        if(verbose){print(c(W1, W2))}
        
        weight.mat = 0.5 * matrix(c(0,0,0,W1,0,0,0,W2,0), 3, 3)
        weight.mat = weight.mat + t(weight.mat)
    }

    # Parse final model
    curr_g_score = as.matrix(A[[1]] %*% curr_model$a[[1]])
    curr_t_score = -as.matrix(A[[2]] %*% curr_model$a[[2]])
    curr_p_score = as.matrix(A[[3]] %*% curr_model$a[[3]])

    curr_scores = cbind(curr_g_score, cbind(curr_t_score, curr_p_score))
    colnames(curr_scores) <- c("Causal", "Mediator", "Outcome")
    return(curr_scores)
}