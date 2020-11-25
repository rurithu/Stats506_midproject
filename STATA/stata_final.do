// import data
import delimited "/Users/rithuuppalapati/Desktop/nhanes.csv", encoding(ISO-8859-1)

// find covariates to use 
// look for covariates that are significantly correlated to 
//both treatment and outcome vars
// can also include covariates that are correlated to treatment var, if they 
// come before 

pwcorr heart_attack diabete relative_heart_attack gender age race edu 
annual_income weight bmi smoke_life phy_vigorous phy_moderate blood_press 
blood_press2 hyper_med hbq_med high_chol meadial_access cover_hc health_diet 
year_smoke year_hyper, sig star(.05)

// include relative heart attack, gender, age, edu, annual income, weight,
//bmi, smoke_life, phy_vigorous, phy_moderate, blood_press, blood_press2, 
//high_chol, meadial_access, cover_hc, health_diet, 
//year_smoke, and year_hyper 

// perform logistic regression to predict assignment condition
// 0 - diabetes & 1 - no diabetes
// perform t-test

logit heart_attack relative_heart_attack gender
 age edu annual_income weight bmi diabete smoke_life phy_vigorous 
 phy_moderate blood_press blood_press2 high_chol 
 meadial_access cover_hc health_diet year_smoke year_hyper
 
 ttest diabete, by(heart_attack)
 
// calculate pscore 
pscore diabete relative_heart_attack gender age edu annual_income 
weight bmi smoke_life phy_vigorous phy_moderate blood_press blood_press2 
high_chol meadial_access cover_hc health_diet year_smoke 
year_hyper, pscore(pc_pscore) blockid(pc_block) detail
 
//graph to see balance 
psgraph, treated(diabete)pscore(pc_pscore)

// matching 
// two types nearest neighbor or kernel
// before matched
twoway (kdensity _pscore if _treated==1) (kdensity _pscore if _treated==0, 
lpattern(dash)), legend( label( 1 "Diabetes") label( 2 "No Diabetes" ) ) 
xtitle("Propensity Score Before Matching") saving(before, replace)
// nearest neighbor
psmatch2 diabete, outcome(heart_attack) pscore(pc_pscore) neighbor(1) 
caliper(.001) common
// create graph for matching
gen match=_n1
replace match=_id if match==.
duplicates tag match, gen(same_match)
twoway (kdensity _pscore if _treated==1) 
(kdensity _pscore if _treated==0 & dup>0, lpattern(dash)), 
legend( label( 1 "Diabetes") label( 2 "No Diabetes" ) ) 
xtitle("Propensity Score After Matching") saving(before, replace)

//kernel matching 
psmatch2 diabete, kernel outcome(heart_attack) pscore(pc_pscore)

// run directly after psmatch2
pstest gender age edu annual_income weight 
bmi smoke_life phy_vigorous phy_moderate blood_press 
blood_press2 high_chol meadial_access cover_hc health_diet 
year_smoke year_hyper, both graph

// inverse weighting 
qui dr heart_attack diabete relative_heart_attack 
gender age edu annual_income weight bmi smoke_life 
phy_vigorous phy_moderate blood_press blood_press2 high_chol 
meadial_access cover_hc health_diet year_smoke year_hyper, genvars
//normalize weights
egen sumofweights = total(iptwt)
gen norm_weights = iptwt/sumofweights
//Balance table to determine bias
pbalchk diabete relative_heart_attack gender age
 edu annual_income weight bmi smoke_life phy_vigorous 
 phy_moderate blood_press blood_press2 high_chol meadial_access 
 cover_hc health_diet year_smoke year_hyper, wt(norm_weights)
 
// graph comparing after weighted 
twoway kdensity heart_attack if diabete [aweight= norm_weights] || kdensity 
heart_attack if !diabete [aweight=norm_weights] 

// treatment effects 
// propensity score matching
teffects psmatch (heart_attack) (diabete smoke_life phy_vigorous 
phy_moderate blood_press blood_press2 high_chol meadial_access 
cover_hc health_diet year_smoke year_hyper relative_heart_attack 
gender age edu annual_income weight bmi), atet
//check covariates using box plot
tebalance box

// inverse weighting 
teffects ipw (heart_attack) (diabete smoke_life phy_vigorous 
phy_moderate blood_press blood_press2 high_chol meadial_access 
cover_hc health_diet year_smoke year_hyper relative_heart_attack 
gender age edu annual_income weight bmi), atet
// check covariates (using age) density plot
tebalance density age 

 
