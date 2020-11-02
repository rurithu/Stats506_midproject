## Stats506 Midterm Porject Proposal

### Topic
Creating propensity score weights and using inverse propensity weights and/or matching for analysis.

### Data
[NHANES](https://www.cdc.gov/nchs/nhanes/index.htm) Data used in class

### Research Question (TBD)
Whether or not adult patients with diabetes have higher risk for heart attack (HA; myocardial infarction) in the United States.  
Confounders and risk factors in the relationship: BMI, diabetes, smoking, physical activity, access to medical services, hypertension/high blood pressure and diet.

#### Concept
1. Add propensity score weights
2. propensity score matching

### Group Member and Software
Hongfan Chen: SAS  
Rithu Uppalapati: Stata  
Zhihao Xu: Python  
Yawen Hu: R  

### Procedure
1. Estimate propensity score weights by fitting a logistic regression model using whether or not an adult patient has diabete as response and the relatively Confounders/risk factors as predictor.
2. Use Nearest-Neighborhood to match the diabete and non-diabete patients on the estimated propensity scores.
3. Estimate the effect of diabete on heart attack using propensity score-matched sample.