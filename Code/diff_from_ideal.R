#In a high-dimensional mediation, you want the 
#correlation between the causal factor and the outcome
#to be equal to the product of the causal-mediator
#and mediator-outcome correlations.
#This function take in a correlation matrix in which
#the columns are ordered as causal, mediator, outcome
#and calculates the difference between the realized
#correlations and the ideal correlations.

diff_from_ideal <- function(cor_mat){
    diff_cor <- cor_mat[1, 3] - cor_mat[1,2] * cor_mat[2,3]
    return(diff_cor)
}
