*Import CSV file 
import delimited "/Users/rithuuppalapati/Desktop/nhanes.csv", encoding(ISO-8859-1)

*Download necessary packages 
net install st0026_2, replace
net install psmatch2, replace
net install st0149, replace 
net install pbalchk, replace 

*Perform logistic regression and t-test on initial data 
logit heart_attack relative_heart_attack gender age race edu annual_income 
weight bmi diabete smoke_life phy_vigorous phy_moderate blood_press 
blood_press2 hyper_med hbq_med high_chol meadial_access cover_hc health_diet
 year_smoke year_hyper
 
ttest diabete, by(heart_attack)

*Calculate pscore 
pscore diabete relative_heart_attack gender age race edu annual_income 
weight bmi smoke_life phy_vigorous phy_moderate blood_press blood_press2 
hyper_med hbq_med high_chol meadial_access cover_hc health_diet year_smoke 
year_hyper, pscore(pc_pscore) blockid(pc_block) detail

psgraph, treated(diabete)pscore(pc_pscore)

* Match pscore
qui psmatch2 diabete, kernel outcome(heart_attack) pscore(pc_pscore)

*inverse-weighting 
 qui dr heart_attack diabete relative_heart_attack gender age race edu 
 annual_income weight bmi smoke_life phy_vigorous phy_moderate blood_press
 blood_press2 hyper_med hbq_med high_chol meadial_access cover_hc health_diet 
 year_smoke year_hyper, genvars
 egen sumofweights = total(iptwt)
 gen norm_weights = iptwt/sumofweights
 
 *balance tests for matched/weighted datasets
 **matched 
 psmatch2 diabete relative_heart_attack gender age race edu annual_income 
 weight bmi smoke_life phy_vigorous phy_moderate blood_press blood_press2 
 hyper_med hbq_med high_chol meadial_access cover_hc health_diet year_smoke 
 year_hyper, out(heart_attack)
 *** regression on matched data 
 reg heart_attack relative_heart_attack gender age race edu 
 annual_income weight bmi smoke_life phy_vigorous phy_moderate 
 blood_press blood_press2 hyper_med hbq_med high_chol meadial_access 
 cover_hc health_diet year_smoke year_hyper diabete [fweight = _weight]
 *** effects 
  teffects ipw (heart_attack) (diabete relative_heart_attack gender age race 
  edu annual_income weight bmi smoke_life phy_vigorous phy_moderate blood_press
  blood_press2 hyper_med hbq_med high_chol meadial_access cover_hc health_diet 
  year_smoke year_hyper)
 
 **inverse-weighting 
 pbalchk diabete heart_attack diabete relative_heart_attack gender age race edu
 annual_income weight bmi smoke_life phy_vigorous phy_moderate blood_press 
 blood_press2 hyper_med hbq_med high_chol meadial_access cover_hc health_diet 
 year_smoke year_hyper, wt(norm_weights)
 *** doubly robust est 
 teffects ipwra (heart_attack relative_heart_attack gender age race edu 
 annual_income weight bmi smoke_life phy_vigorous phy_moderate blood_press 
 blood_press2 hyper_med hbq_med high_chol meadial_access cover_hc health_diet 
 year_smoke year_hyper) (diabete relative_heart_attack gender age race edu 
 annual_income weight bmi smoke_life phy_vigorous phy_moderate blood_press 
 blood_press2 hyper_med hbq_med high_chol meadial_access cover_hc health_diet 
 year_smoke year_hyper)
 
 
