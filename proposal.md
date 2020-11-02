## Stats506 Midterm Porject Proposal

### Topic
Creating propensity score weights and using inverse propensity weights and/or matching for analysis.

#### Concept
1. Propensity score weights
2. Propensity score matching
   
#### Data
[NHANES](https://www.cdc.gov/nchs/nhanes/index.htm) Data used in class

#### Research Question
Whether or not adult patients with diabetes have higher risk for heart attack (myocardial infarction) in the United States.  
The predictor used for estimating propensity score:  
`heart_attack`(relatives have heart attack or not), `gender`, `age`, `race`, `edu`, `annual_income`, `bmi`, `smoke_life`, `year_smoke`(year of smoke), `phy_vigorous`(doing vigorous work activity or not), `phy_moderate`(doing moderate work activity or not), `blood_press`(being told high blood pressure), `blood_press2`(being told high blood pressure 2+ more times or not), `year_hyper`(year of hypertension), `hyper_med`, `hbp_med`(taking hypertension/HBP medicine or not), `high_chol`(being told high cholesterol level or not)


### Group Member and Software
Hongfan Chen: SAS  
Rithu Uppalapati: Stata  
Zhihao Xu: Python
- Core packages: 
    - `numpy` / `pandas`: data I/O and manipulation  
    - `sklearn.linear_model` and `sklearn.neighbors`: propensity score weight and match  

Yawen Hu: R
- Core packages: 
    - `tidyverse`: data I/O and manipulation  
    - `GLM` and `MatchIt`: propensity score weight and match 

### Procedure
1. Estimate propensity score weights by fitting a logistic regression model using whether or not an adult patient has diabete as response and the relatively Confounders factors and demographic variable as predictor.
2. Use Nearest-Neighborhood to match the diabete and non-diabete patients on the estimated propensity scores.
3. Estimate the effect of diabete on heart attack using propensity score-matched sample.