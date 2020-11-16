## Stats506 Midterm Porject Group 1

### Report
Click [here](http://htmlpreview.github.io/?https://github.com/ZhihaoXu/Stats506_midproject/blob/main/writeup.html) to see our latest version of write-up

### Topic
Creating propensity score weights and using inverse propensity weights and/or matching for analysis.

#### Concept
1. Propensity score estimation
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
  - The codes in this folder are mainly done by Zhihao Xu
- `R/`:  
  - `midterm_project.R`: the main R code for tutorial
  - `writeup_R.Rmd` / `writeup_R.html`: the write-up for the R tutorial
  - The codes in this folder are mainly done by Yawen Hu
- `SAS/`:  
  - `GroupProject_SAS_Hongfan.sas`: the main SAS code for tutorial
  - `GroupProject_SAS_Hongfan.Rmd` / `GroupProject_SAS_Hongfan.html`: the write-up for SAS tutorial
  - The codes in this folder are mainly done by Hongfan Chen
- `STATA/`:  
  - `Group_proj_Rithu.do`: the main Stata code for tutorial
  - `rithu_stata.Rmd` / `rithu_stata.html`: the write-up for STATA tutorial
  - The codes in this folder are mainly done by Rithu Uppalapati


### TODO LIST
- Python
  + Write detail instruction about the core package used
  + Add balance checking before and after matching
- R
  + Detailed tutorial on core packages 
  + T-test
- SAS
  + Create Graphs to compare data 
  + Add balance check
- STATA
  + Create Confidence Intervals for all of the variables in order to know which to choose in our final model
  + Create a standardized balance table and compare the means 
  + Create graphics 
  + For matching, I will create a line graph and juxtapose the untreated vs. treated 
  + For weighting, I will create two density graphs to compare 
  + I will also a linear regression estimation using the teffects ra function
  + Create Graphs comparing pre-match data and match data 
  + Create graphs comparing pre-weighted data to weighted data 
  + standardized tables for both matched and weighted data to compare to initial data set




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



