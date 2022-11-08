##=====================================================================================##
## High-Dimensional Mediation
## Set the options below and run this executable file
## It will run the Rmarkdown file with the options you 
## set and then rename the results file accordingly.
##=====================================================================================##

merge_tissues=FALSE
local_imputation=FALSE
weight_adjusted=FALSE
complete_mediation=TRUE
delete_previous=FALSE

##=====================================================================================##
## run the markdown with these parameters
## Make sure any lines that specify args in the Rmd are commented out.
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', '1.Setup_Data', 'High_Dimensional_Mediation.Rmd'))" --args $merge_tissues $local_imputation $weight_adjusted $complete_mediation $delete_previous

##=====================================================================================##
## translate the parameters to English to rename the final results
##=====================================================================================##

if [ $merge_tissues == 'TRUE' ]; then
	tissue_option=tissues_merged
else
	tissue_option=tissues_sep
fi

if [ $local_imputation == 'TRUE' ]; then
	imputation_option=local_imputation
else
	imputation_option=full_imputation
fi

if [ $weight_adjusted == 'TRUE' ]; then
	weight_option=weight_adjusted
else
	weight_opation=_
fi

if [ $complete_mediation == 'TRUE' ]; then
	mediation_option=complete_mediation
else
	mediation_option=reactive
fi


mv Documents/1.Setup_Data/High_Dimensional_Mediation.html Documents/1.Setup_Data/High_Dimensional_Mediation-$tissue_option-$imputation_option-$weight_option-$mediation_option.html


