## Stats506 Midterm Porject Proposal

### Topic
Creating propensity score weights and using inverse propensity weights and/or matching for analysis.

#### Concept
1. Propensity score matching analysis
   
#### Data
[NHANES](https://www.cdc.gov/nchs/nhanes/index.htm) Data used in class

#### Research Question
Whether or not adult patients with diabetes have higher risk for heart attack (myocardial infarction) in the United States?  
The predictor used for estimating propensity score:  
`heart_attack`(relatives have heart attack or not), `gender`, `age`, `race`, `edu`, `annual_income`, `bmi`, `smoke_life`, `year_smoke`(year of smoke), `phy_vigorous`(doing vigorous work activity or not), `phy_moderate`(doing moderate work activity or not), `blood_press`(being told high blood pressure), `blood_press2`(being told high blood pressure 2+ more times or not), `year_hyper`(year of hypertension), `hyper_med`, `hbp_med`(taking hypertension/HBP medicine or not), `high_chol`(being told high cholesterol level or not)


### Group Member and Software
Hongfan Chen: SAS  
- Key command: `proc psmatch` and `proc logistic`
  
Rithu Uppalapati: Stata  
Zhihao Xu: Python
- Core packages: 
    - `numpy` / `pandas`: data I/O and manipulation  
    - `sklearn.linear_model` and `sklearn.neighbors`: propensity score weight and match  

Yawen Hu: R
- Core packages: 
    - `tidyverse`: data I/O and manipulation  
    - `GLM` and `MatchIt`: propensity score weight and match 

### Tutorial
1. Estimate propensity score by fitting a logistic regression model.
2. Use Nearest-Neighborhood to match the diabete and non-diabete patients on the estimated propensity scores.
3. Use T-test to figure out the effect of diabete on heart attack using propensity score-matched sample.