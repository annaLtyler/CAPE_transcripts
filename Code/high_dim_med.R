#This function performs high-dimensional mediation
#with either kernelized matrices, or data matrices.
#all matrices must have rownames that can be aligned
#by the function
#min.weight.diff is the 
#kernel.c, kernel.m, and kernel.o indicate whether the causal,
#mediating, and outcome matrices are kernelized
#mediation.type determines whether we are looking for 
#complete mediation: causal -> mediating -> outcome
#or a reactive model: causal -> outcome -> mediating
#The default is complete mediation


high_dim_med <- function(causal.matrix, mediating.matrix, outcome.matrix, 
    min.weight.diff = 1e-3, max.iter = 15, 
    scheme = c("centroid", "horst", "factorial"), verbose = FALSE, 
    kernel.c = TRUE, kernel.m = TRUE, kernel.o = TRUE){

    scheme <- scheme[1]

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

    check_stop <- function(initial_weights, curr_weights, last_diff){
       
        weight.diff <- abs(initial_weights - curr_weights)

        #check to see if we are converging. 
        #The new weight diffs should be 
        #smaller than the last ones.
        converging <- all(weight.diff < last_diff)

        #check to see if we have reached our minimum 
        #change in weight to meet our stopping criterion.
        reached.min <- all(weight.diff <= min.weight.diff)

        result <- list("reached.min" = reached.min, 
                    "converging" = converging,
                    "weight_diff" = weight.diff)
        return(result)
    }

    decide_stop <- function(stopping_criteria, n.iter){
        do.we.stop = FALSE

        #if we have met the minimum weight change criterion, then stop
        if(stopping_criteria[[1]]){
            do.we.stop = TRUE
            if(verbose){cat("Reached minimum weight change.\n")}
        }

        #if we are not converging, then stop
        if(!stopping_criteria[[2]]){
            do.we.stop = TRUE
            if(verbose){cat("Not converging.\n")}
        }

        if(n.iter >= max.iter){
            do.we.stop = TRUE
            if(verbose){cat("Reached maximum number of iterations.\n")}
        }

    return(do.we.stop)
    }

    A = list(g = g, t = t, p = p)

    weight.mat = 0.5 * matrix(c(0,0,0,1,0,0,0,1,0), 3, 3)    
    weight.mat = weight.mat + t(weight.mat)

    
    #set initial conditions for stopping criteria checks
    stop.now <- FALSE
    W1 <- W2 <- 0.5
    last_diff <- c(Inf, Inf)
    iter = 1

    # Loop over "EM" iterations
    while(!stop.now){

        initial_weights <- c(W1, W2)

        curr_model = rgcca(A, weight.mat, tau = "optimal", verbose = FALSE,
            scheme = scheme)
        
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

        curr_weights <- c(W1, W2)
        if(verbose){print(c(W1, W2))}        

        stopping.criteria <- check_stop(initial_weights, curr_weights, last_diff)
        last_diff <- stopping.criteria[[3]]
        stop.now <- decide_stop(stopping.criteria, iter)
        iter = iter + 1
        
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