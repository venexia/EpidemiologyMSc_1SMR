# One-sample Mendelian randomization practical

Studies over the past few years have focused on estimating the causal relationship between inflammation and adiposity-related traits including obesity, type II diabetes and coronary heart disease (CHD). Previous studies have suggested that increased adiposity leads to higher levels of inflammatory biomarkers, including C-reactive protein (CRP). However, other studies have shown the opposite, whereby increased circulatory levels of these inflammatory biomarkers leads to greater adiposity.

Within this practical, you will use Mendelian randomization (MR) to investigate the causal relationship between body mass index (BMI) and CRP. We have provided you with an analysis script and genetic, phenotypic and covariate data. First, you will use a single genetic variant as an instrumental variable (IV) for BMI to investigate its effect on CRP. Second, you will create an allelic score from multiple genetic variants as a single IV and compare results to those obtained with a single genetic variant. Finally, you can test your knowledge by producing results in the other direction when genetic variants for CRP are used to ask if CRP affects BMI. Within the script, there are note that will help you navigate through the practical. Good luck!

## Scripts and datasets

| File | Description |
|------|-------------|
| 1smr.do | Stata script for performing analysis |
| PhenAndCov.dta | Phenotypic and covariate dataset |
| GeneticData.dta | Genetic dataset |

## Variables 

|     Variable    |     Details                                                 | Datasets                        |
|-----------------|-------------------------------------------------------------|---------------------------------|
| fid             | Family identifier                                           | PhenAndCov.dta, GeneticData.dta |
| iid             | Individual   identifier                                     | PhenAndCov.dta, GeneticData.dta |
| bmi             | Body mass index,   kg/m2                                    | PhenAndCov.dta                  |
| dbp             | Diastolic blood   pressure, mm Hg                           | PhenAndCov.dta                  |
| sbp             | Systolic blood   pressure, mm Hg                            | PhenAndCov.dta                  |
| crp             | C-reactive protein,   mg/L                                  | PhenAndCov.dta                  |
| pc1-pc10        | First 10 principal   components of genetic variation        | PhenAndCov.dta                  |
| age             | Age in years                                                | PhenAndCov.dta                  |
| sex             | Female (1) or male (2)                                      | PhenAndCov.dta                  |
| sec16b          | Genotypes (allele counts) for gene associated with BMI      | GeneticData.dta                 |
| faim2           | Genotypes (allele counts) for gene associated with BMI      | GeneticData.dta                 |
| fto             | Genotypes (allele counts) for gene associated with BMI      | GeneticData.dta                 |
| mc4r            | Genotypes (allele counts) for gene associated with BMI      | GeneticData.dta                 |
| crp             | Genotypes (allele counts) for gene associated with CRP      | GeneticData.dta                 |
| hnf1a           | Genotypes (allele counts) for gene associated with CRP      | GeneticData.dta                 |
| apoc1           | Genotypes (allele counts) for gene associated with CRP      | GeneticData.dta                 |

## Support

If you have any questions regarding this practical, please contact Venexia Walker (venexia.walker@bristol.ac.uk), Neil Davies (neil.davies@bristol.ac.uk) or Luisa Zuccolo (l.zuccolo@bristol.ac.uk).
