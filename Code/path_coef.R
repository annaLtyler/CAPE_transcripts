#In a high-dimensional mediation, you want the 
#correlation between the causal factor and the outcome
#to be equal to the product of the causal-mediator
#and mediator-outcome correlations.
#This function take in a correlation matrix in which
#the columns are ordered as causal, mediator, outcome
#and calculates the difference between the realized
#correlations and the ideal correlations.

path_coef <- function(cor_mat){
    obs.cor <- cor_mat[1, 3]
    path.coef <- cor_mat[1,2] * cor_mat[2,3]
    diff_cor <- obs.cor - path.coef
    result <- c("path_coef" = path.coef, "obs_cor" = obs.cor, "diff" = diff_cor)
    return(result)
}
