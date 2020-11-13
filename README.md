## Stats506 Midterm Porject Group 1

### Topic
Creating propensity score weights and using inverse propensity weights and/or matching for analysis.

#### Concept
1. Propensity score weight estimate
2. Propensity score matching
3. Inverse propensity weights

#### Research Question
Whether or not adult patients with diabetes have higher risk for heart attack (myocardial infarction) in the United States?  

### Code Organization
- `writeup.Rmd` / `writeup.html`: the write-up for this project
- `data/`: 
  - `*.XPT`: the sub-dataset we used in [NHANES](https://www.cdc.gov/nchs/nhanes/index.htm) 
  - `data_preprocess.R`: the code for data preparation and the result is stored in `nhanes.csv`
  - `nhanes.csv`: the dataset we used in the later tutorial 
- `py/`:
  - `prop_py.ipynb`: the main python code for tutorial
  - `writeup_py.Rmd` / `writeup_py.html`: the write-up for the python tutorial
- `SAS/`:
  - `GroupProject_SAS_Hongfan.sas`: the main SAS code for tutorial
  - `GroupProject_SAS_Hongfan.Rmd` / `GroupProject_SAS_Hongfan.html`: the write-up for SAS tutorial


Hongfan Chen: SAS  
Rithu Uppalapati: Stata  
Zhihao Xu: Python  
Yawen Hu: R




### Data Description
[NHANES](https://www.cdc.gov/nchs/nhanes/index.htm) Data used in class

Outcome: `heart_attack`  
Treatment: `diabetes`
Predictors: 
|  Variable               | Description                                         |
| ----------------------- | ----------------------------------------------------|
| `relative_heart_attack` | Relatives have heart attack or not                  |
| `gender`                | Gender of the participant                           |
| `age`                   | Age of the participant                              |
| `race`                  | Race of the participant                             |
| `edu`                   | Education Level                                     | 
| `annual_income`         | Annual Income                                       | 
| `bmi`                   | Body Mass Index                                     |
| `smoke_life`            | Smoked at least 100 cigarettes in life or not       |
| `year_smoke`            | Year of smoke                                       |
| `phy_vigorous`          | Doing vigorous work activity or not                 | 
| `phy_moderate`          | Doing moderate work activity or not                 |
| `blood_press`           | Being told high blood pressure                      | 
| `blood_press2`          | Being told high blood pressure 2+ more times or not |
| `year_hyper`            | Year of hypertension                                | 
| `hyper_med`             | Taking hypertension medicine or not                 |
| `hbp_med`               | Taking HBP medicine or not                          | 
| `high_chol`             | Being told high cholesterol level or not            |
| `meadial_access`        | Being able to have medical access or nor            |
| `cover_hc`              | Covered by health care or not                       |
| `health_diet`           | Having a health diet or not                         |
**Note:** For all the binary variable here with value 1 and 0, 1 = Yes and 0 = No