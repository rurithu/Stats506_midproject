## Stats506 Midterm Porject Proposal

### Topic
Creating propensity score weights and using inverse propensity weights and/or matching for analysis.

#### Concept
1. Propensity score weights
2. Propensity score matching
   
#### Data
[NHANES](https://www.cdc.gov/nchs/nhanes/index.htm) Data used in class

#### Research Question
Whether or not adult patients with diabetes have higher risk for heart attack (HA; myocardial infarction) in the United States.  
The predictor used for estimating propensity score: whether relative has heart attack, gender, age, race, education level, annual income, BMI, whether smoke, year of smoke, whethe do vigorous work activity, whethe do moderate work activity, whether being told high blood pressure, whether being told high blood pressure 2+ more times, year of hypertension, whether take hypertension/HBP medicine, whether has high cholesterol level


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