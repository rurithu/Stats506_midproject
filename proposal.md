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
| Predictor      | Description                                         |
| -------------- | ----------------------------------------------------|
| `heart_attack` | Relatives have heart attack or not                  |
| `gender`       | Gender of the participant                           |
| `age`          | Age of the participant                              |
| `race`         | Race of the participant                             |
| `edu`          | Education Level                                     | 
| `annual_income`| Annual Income                                       | 
| `bmi`          | Body Mass Index                                     |
| `smoke_life`   | Smoked at least 100 cigarettes in life or not       |
| `year_smoke`   | Year of smoke                                       |
| `phy_vigorous` | Doing vigorous work activity or not                 | 
| `phy_moderate` | Doing moderate work activity or not                 |
| `blood_press`  | Being told high blood pressure                      | 
| `blood_press2` | Being told high blood pressure 2+ more times or not |
| `year_hyper`   | Year of hypertension                                | 
| `hyper_med`    | Taking hypertension medicine or not                 |
| `hbp_med`      | Taking HBP medicine or not                          | 
| `high_chol`    | Being told high cholesterol level or not            |

**Note:** For all the binary variable here with value 1 and 0, 1 = Yes and 0 = No


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
3. Inverse weighting by propensity score and use inverse propensity weights to analyse data.
4. Use T-test to figure out the effect of diabete on heart attack using propensity score-matched sample.