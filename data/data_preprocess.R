## Data Preprocessing
## Author: Zhihao Xu, xuzhihao@umich.edu
## Updated: November 2, 2020
# 79: -------------------------------------------------------------------------

#! Load libraries at the top of your script.
# libraries: ------------------------------------------------------------------
library('foreign') 
library('tidyverse') 

# main:------------------------------------------------------------------------
# All the binary factor below after preprocessing: 1 = Yes, 0 = No
# Demographics Variable
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/DEMO_J.htm
demo = read.xport("DEMO_J.XPT") %>%
  select(id = SEQN, gender = RIAGENDR, age = RIDAGEYR, race = RIDRETH1, 
         edu = DMDEDUC2, annual_income = INDHHIN2, weight = WTINT2YR)%>%
  mutate(annual_income = 
           ifelse((annual_income==77)|(annual_income==99), NA, annual_income ),
         annual_income = replace_na(annual_income, 
                                    round(mean(annual_income, na.rm=T),0)))

# Medical Condition
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/MCQ_J.htm
mcq = read.xport("MCQ_J.XPT") %>%
  select(id = SEQN, heart_attack = MCQ160E, relative_heart_attack = MCQ300A) %>%
  drop_na() %>%
  mutate(
    heart_attack = ifelse(heart_attack==1, 1, 0),
    relative_heart_attack = ifelse(relative_heart_attack==1, 1, 0)
  )

# Body Measure
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/BMX_J.htm
bmx = read.xport("BMX_J.XPT") %>%
  select(id = SEQN, bmi = BMXBMI) %>%
  mutate(
    bmi = replace_na(bmi, mean(bmi, na.rm=T))
  )


# Diabete
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/DIQ_J.htm
diq = read.xport("DIQ_J.XPT") %>%
  select(id = SEQN, diabete = DIQ010) %>%
  mutate(
    diabete = ifelse(diabete==1, 1, 0)
  )

# Smoke
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/SMQ_J.htm
smq = read.xport("SMQ_J.XPT") %>%
  select(id = SEQN, smoke_life = SMQ020, age_smoke = SMD030) %>%
  mutate(
    smoke_life = replace_na(smoke_life, 2),
    smoke_life = ifelse(smoke_life==1, 1, 0),
    age_smoke = replace_na(age_smoke, 999)
    )

# Physical Activity
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/PAQ_J.htm
paq = read.xport("PAQ_J.XPT") %>%
  select(id = SEQN, phy_vigorous = PAQ605, phy_moderate = PAQ620) %>%
  mutate(
    phy_vigorous = ifelse(phy_vigorous==1, 1, 0),
    phy_moderate = ifelse(phy_moderate==1, 1, 0)
  )


# Blood Pressure and Cholesterol
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/BPQ_J.htm
## All factor here 1==Yes, 0==No
bpq = read.xport("BPQ_J.XPT") %>%
  select(id = SEQN, blood_press = BPQ020, blood_press2 = BPQ030,
         age_hyper = BPD035, hyper_med = BPQ040A, hbq_med = BPQ050A,
         high_chol = BPQ080) %>%
  mutate(
    blood_press = ifelse(blood_press==1, 1, 0),
    blood_press2 = replace_na(blood_press2, 2),
    blood_press2 = ifelse(blood_press2==1, 1, 0),
    age_hyper = replace_na(age_hyper, 999),
    hyper_med = replace_na(hyper_med, 2),
    hyper_med = ifelse(hyper_med==1, 1, 0),
    hbq_med = replace_na(hbq_med, 2),
    hbq_med = ifelse(hbq_med==1, 1, 0),
    high_chol = ifelse(high_chol==1, 1, 0)
    )

# Access to care
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/HUQ_J.htm
huq = read.xport("HUQ_J.XPT") %>%
  select(id = SEQN, meadial_access = HUQ030) %>%
  mutate(
    meadial_access = ifelse(meadial_access==1, 1, 0)
  )

# Health Insurance
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/HIQ_J.htm
hiq = read.xport("HIQ_J.XPT") %>%
  select(id = SEQN, cover_hc = HIQ011) %>%
  mutate(
    cover_hc = ifelse(cover_hc==1, 1, 0)
  )

# Diet
# https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/DBQ_J.htm
# 0: Poor, 1: Fair, 2: Good, 3: Very Good, 4: Excellent
dbq = read.xport("DBQ_J.XPT") %>%
  select(id = SEQN, health_diet = DBQ700) %>%
  mutate(
    health_diet = ifelse(health_diet==9, NA, health_diet),
    health_diet = replace_na(health_diet, 3),
    health_diet = 5 - health_diet
  )



full_data = mcq %>%
  left_join(demo, by = "id") %>%
  left_join(bmx, by = "id") %>%
  left_join(diq, by = "id") %>%
  left_join(smq, by = "id") %>%
  left_join(paq, by = "id") %>%
  left_join(bpq, by = "id") %>%
  left_join(huq, by = "id") %>%
  left_join(hiq, by = "id") %>%
  left_join(dbq, by = "id") %>%
  filter( age >= 20) %>%
  drop_na() %>%
  mutate(
    year_smoke = pmax(age - age_smoke, 0),
    year_hyper = pmax(age - age_hyper, 0)
  ) %>%
  select(- age_smoke, - age_hyper)

full_data %>%
  write_delim("nhanes.csv", delim=",")

