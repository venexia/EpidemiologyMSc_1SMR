*******************************************************************************
* PART 1: PREPARATION FOR ONE-SAMPLE MENDELIAN RANDOMIZATION
*******************************************************************************

* 1. Load the phenotypic data

use "./PhenAndCov.dta", clear

* 2. Perform basic data checks on the phenotypic data

count // count the number of observations
summarize // summary data for all variables
summarize bmi, detail // detailed information about the variable bmi
summarize crp, detail // detailed information about the variable crp

foreach var of varlist fid-sex{
	count if missing(`var') // count missing values for each variable
}

* 3. Check the distributions for the exposure and outcome

histogram(bmi), name(bmi) // generate histogram for BMI
histogram(crp), name(crp) // generate histogram for CRP

* 4. Transform variables if they are non-normal

tabulate iid if crp == 0 // check there are no zero values for CRP
generate lcrp = ln(crp)/ln(2) // log transform CRP
histogram(lcrp), name(lcrp) // generate histogram for log transformed CRP
save "./PhenAndCov_clean.dta", replace // save the cleaned phenotypic data

* 5. Load the genetic data

use "./GeneticData.dta", clear

* 7. Perform basic data checks on the genetic data

count // count the number of observations
summarize // summary data for all variables
rename crp g_crp // rename the variable "crp" as it appears in both datasets 

* 8. Merge the genetic data with the cleaned phenotypic data

merge 1:1 fid iid using "./PhenAndCov_clean.dta" // perform the merge
drop _merge // drop auto-generated merge variable
save "./PhenAndCovAndGenetic.dta", replace // save master file

* 9. Check that the effect allele is the exposure-increasing allele

foreach variant in sec16b faim2 fto mc4r{
	regress bmi `variant' // perform linear regression for each variant on BMI
	}
	
* 10. Reverse the coding if inversely associated with the exposure

replace faim2 = 2-faim2 // reverse FAIM2 so that it is BMI-increasing
replace fto = 2-fto // reverse FTO so that it is BMI-increasing
foreach variant in faim2 fto{
	regress bmi `variant' // perform linear regression for each variant on BMI
}

* 11. Check Hardy-Weinberg equilibrium of variants

foreach variant in sec16b faim2 fto mc4r{
	tab `variant', missing // check for missing variant counts
	generate `variant'hap = "1_1" if `variant' == 0 // code haplotype 1_1
	replace `variant'hap = "1_2" if `variant' == 1 // code haplotype 1_2
	replace `variant'hap = "2_2" if `variant' == 2 // code haplotype 2_2
	split `variant'hap, p(_) // split haplotype variable into two parts
	genhw `variant'hap1 `variant'hap2 // Hardy-Weinberg equilibrium test 
}

*******************************************************************************
* PART 2: OBSERVATIONAL ANALYSES
*******************************************************************************

* 12. Perform an unadjusted observational analysis

regress lcrp bmi

* 13. Examine the associations of the exposure with the available covariables

regress bmi age
regress bmi sex
forvalues pc=1/10{
	regress bmi pc`pc'
	}
	
* 14. Examine the associations of the exposure with the available covariables

regress lcrp age
regress lcrp sex
forvalues pc=1/10{
	regress lcrp pc`pc'
	}

* 15. Examine the age- and sex-adjusted observational associations
* Note: this is the observational comparison we will use to compare with MR

regress lcrp bmi age sex

* 16. Examine the associations between the BMI genetic variants and BMI

regress bmi fto
regress bmi mc4r
regress bmi faim2
regress bmi sec16b

*******************************************************************************
* PART 3: ONE-SAMPLE MENDELIAN RANDOMIZATION USING ONE INSTRUMENT (E.G. MC4R)
*******************************************************************************

* 17. Check the instrument is not associated with the confounders

regress mc4r age
regress mc4r sex
forvalues pc=1/10{
	regress mc4r pc`pc'
}

* 18. Check the instrument-outcome association

regress lcrp mc4r

* 19. Perform the Mendelian randomization analysis

** Option (A) - manual two-stage least squares (TSLS)

regress bmi mc4r // estimate the genetically predicted values of BMI
predict bmi_gen, xb // save genetically predicted values of BMI
regress lcrp bmi_gen // regress CRP on genetically predicted values of BMI

** Option (B) - ivreg2

ivreg2 lcrp (bmi = mc4r), ffirst // Perform instrumental variable analysis
predict iv_b, xb // save fitted values for plotting
ivendog // Durbin-Wu-Hausman test for comparing observational and MR results

* 20. Plot the Mendelian randomization analysis results

graph twoway (scatter lcrp bmi, color(black)) (lfit lcrp bmi, lcolor(red)) (line iv_b bmi, lcolor(blue) legend(off) ytitle("lcrp")), plotregion(color(white)) graphregion(color(white))

* 21. Repeat analysis with adjustment for the first 10 principal components

ivreg2 lcrp pc* (bmi = mc4r), ffirst

*******************************************************************************
* PART 4: ONE-SAMPLE MENDELIAN RANDOMIZATION USING AN ALLELE SCORE
*******************************************************************************

* 22. Check for linkage disequilibrium (LD) between the BMI genetic variants

pwcorr fto sec16b, sig 
pwcorr fto faim2, sig
pwcorr fto mc4r, sig
pwcorr sec16b faim2, sig
pwcorr sec16b mc4r, sig
pwcorr faim2 mc4r, sig

* 23. Calculate weighted allele score using beta-coefficients for BMI from Speliotes et al (2010)

generate weighted = (faim2*0.12 + sec16b*0.22 + fto*0.39 + mc4r*0.23)

* 24. Estimate the associations between the allele scores and BMI

regress bmi weighted

* 25. Estimate the causal effect of BMI on CRP using the allele score as an instrument

ivregress 2sls lcrp (bmi = weighted)
