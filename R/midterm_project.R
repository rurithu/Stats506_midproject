## Midterm Project - R 
##
## Question: Whether or not adult patients with diabetes have higher risk for 
##           heart attack (myocardial infarction) in the United States?
## Data: 
## Author(s): Yawen Hu, yawenhu@umich.edu
## Updated: November 13, 2020 

# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(MatchIt)
library(survey)
library(tidyverse)
library(ggplot2)
library(tableone)
#library(ipw) # get inverse propensity weight


# directories: ----------------------------------------------------------------
setwd("~/Desktop/stats506/midterm_project")

# data: -----------------------------------------------------------------------
nhanes = read_delim("nhanes.csv", delim = ",")
nhanes = nhanes %>%
  mutate(
    diabete = as.factor(diabete),
    heart_attack = as.factor(heart_attack),
    gender = ifelse(gender == 2, 1, 0),
  )
dim(nhanes)

# I. Propensity score estimation
## Logistic regression for treatment ~ pretreatment:
design_ps = svydesign( ids = ~1, weights = ~weight, data = nhanes )
ps_mod = svyglm(diabete ~ relative_heart_attack + gender + age + race + edu 
                + annual_income + bmi + smoke_life + phy_vigorous + phy_moderate 
                + blood_press + blood_press2 + hyper_med + hbq_med + high_chol 
                + meadial_access + cover_hc + health_diet + year_smoke + year_hyper,
                family = binomial(),
                design = design_ps)
summary(ps_mod)


## Get the propensity score:
p_score = predict(ps_mod, type = "response")

# Check the distribution by plotting:
ps = data.frame(
  p_score = ps_mod$fitted.values,
  treatment = ps_mod$model$diabete
)

ps %>%
  ggplot( aes(x = p_score) ) + 
  geom_histogram( aes(color = treatment, fill = treatment),
                      position = "identity", bins = 30, alpha = 0.4) +
  scale_color_manual(values = c("#00AFBB", "#E7B800")) +
  scale_fill_manual(values = c("#00AFBB", "#E7B800"))

# II. Propensity score match:
nhanes_ps = nhanes %>%
  mutate(
    p_score = p_score
  )

match_mod = matchit(ps_mod,
                    distance = 'logit',
                    method = "nearest", 
                    caliper = .2,
                    ratio = 1,
                    data = nhanes_ps,
                    replace = FALSE
)
ps_match = match.data(match_mod)

dim(ps_match)

# III. Balance Checking:
var = c("relative_heart_attack", "gender", "age", "race", "edu", "annual_income",
        "bmi", "smoke_life", "phy_vigorous", "phy_moderate", "blood_press",
        "blood_press2", "hyper_med", "high_chol", "meadial_access", "cover_hc",
        "health_diet", "year_smoke", "year_hyper")
match_tab = CreateTableOne(vars=var, strata="diabete", data=ps_match, test=FALSE)
print(match_tab, smd = TRUE)  

# IV. Compare between pre_match data and matched data.

pre_mt = nhanes %>%
  group_by(diabete, heart_attack) %>%
  summarize(n = sum(weight), .groups = "drop_last") %>%
  mutate(
    prop = 100*(n / sum(n))
  )

mt = ps_match %>%
  group_by(diabete, heart_attack) %>%
  summarize(n = sum(weight), .groups = "drop_last") %>%
  mutate(
    prop = 100*(n / sum(n))
  )

# V. Inverse propensity score:
invert = nhanes_ps %>%
  select(diabete, heart_attack, weight, p_score) %>%
  mutate(
    inverse_wt = ifelse(diabete == 1, 1/p_score, 1/(1-p_score)),
    new_wt = weight * inverse_wt
  ) %>% 
  group_by(diabete, heart_attack) %>%
  summarize(n = sum(new_wt), .groups = "drop_last") %>%
  mutate(
    prop = 100*(n / sum(n))
  )

# 79: -------------------------------------------------------------------------
