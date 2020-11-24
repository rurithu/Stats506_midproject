/* Midterm Group Project 
 * Stats 506, Fall 2020
 * 
 * Topic: Creating propensity score weights and using inverse propensity 
 * weights and/or matching for analysis.
 * 
 * Question: Whether or not adult patients with diabetes have higher risk for
 * heart attack (myocardial infarction) in the United States?
 * 
 * Updated: November 11, 2020
 * Author: Hongfan Chen
 * Group: Group 1
 * 
 */ 

/* 79: --------------------------------------------------------------------- */

/* libnames:---------------------------------------------------------------- */
libname midterm './';
/* macros csvexport: ------------------------------------------------------- */
%macro csvexport(dataset, lib=work);
 proc export
   data = &lib..&dataset
   outfile = "./output/&dataset..csv"
   dbms = dlm
   replace;
  delimiter=",";
 run;
%mend;

/* data import: ------------------------------------------------------------ */
/* nhanes data*/
proc import
 datafile = "./nhanes.csv"
 out = nhanes
 replace;
 delimiter = ',';
 getnames = yes;
run;

/* Descriptive analysis: --------------------------------------------------- */

/* frequency table */
proc freq data=nhanes noprint;
  tables heart_attack*diabetes / out = freq_table;
  weight weight;
run;
/* It seems that those who have diabetes have a higher risk of heart attack. */

/* Logistic regression heart_attack ~ all */
proc logistic data=nhanes noprint;
  model diabetes = relative_heart_attack gender race edu smoke_life
                   phy_vigorous phy_moderate blood_press blood_press2
                   hyper_med hbq_med high_chol meadial_access cover_hc
                   health_diet age annual_income bmi year_smoke year_hyper/
  link=logit rsquare;
  weight weight;
  output out=ps_los pred=ps xbeta=logit_ps;
run;

/* Select the id, diabetes, probability */
data ps_match;
  set ps_los;
  ps = 1 - ps;
  keep id diabetes ps heart_attack weight;
run;

/* ------------------------------------------------------------------------- */
/* ----------------------- Propensity Score Matching ----------------------- */
/* ------------------------------------------------------------------------- */

/* Compute standard deviation of the propensity score */
proc means std data=ps_match noprint;
 var ps;
 output out=stddata (keep = std) std=std;
run;
/* calipers of width 0.2 standard deviations of the logit of PS. */
data stddata;
 set stddata;
 std = 0.2*std;
run;
/* Create macro variable that contains the width of the caliper for matching */
data _null_;
 set stddata;
 call symput('stdcal',std);
run;
/* Match subjects on the logit of the propensity score. */
proc sort data=ps_match; 
  by diabetes;
run;
%include 'gmatch.sas';
/* The macro %gmatch.sas uses the following parameters:
 Data: the name of the SAS data set containing the treated and untreated subjects.
 Group: the variable identifying treated/untreated subjects.
 Id: the variable denoting subjectsEidentification numbers.
 Mvars: the list of variables on which one is matching.
 Wts: the list of non-negative weights corresponding to each matching variable.
 Dist: the type of distance to calculate [1 indicates weighted sum (over matching
 variables) of absolute case-control differences].
 Dmaxk: the maximum allowable difference in the matching difference between matched
 treated and untreated subjects.
 Ncontls: the number of untreated subjects to be matched to each treated subject.
 Seedca: the random number seed for sorting the treated subjects prior to matching.
 Seedco: the random number seed for sorting the untreated subjects prior to
 matching.
 Out: the name of a SAS data set containing the matched sample.
 Print: the flag indicating whether the matched data should be printed. */
%gmatch(
 data = ps_match,
 group = diabetes,
 id = id,
 mvars = ps,
 wts = 1,
 dist = 1,
 dmaxk = &stdcal,
 ncontls = 1,
 seedca = 25102007,
 seedco = 26102007,
 out = matchpairs,
 print = F
);
/* create a new pair ID */
data matchpairs;
 set matchpairs;
 pair_id = _N_;
run; 
/* Create a data set containing the 
   matched normal patients (untreated subjects) */
data control_match;
 set matchpairs;
 id = __IDCO;
 ps = __CO1;
 keep pair_id id ps;
run;
/* Create a data set containing the 
   matched diabete patients (treated subjects) */
data case_match;
 set matchpairs;
 id = __IDCA;
 ps = __CA1;
 keep pair_id id ps;
run; 
/* select the wanted id for merge */
data long_id;
 set control_match case_match;
 keep id;
run; 
/* sort two dataset by id, respectively */
proc sort data=long_id;
  by id;
run; 
proc sort data=ps_match;
  by id;
run;
/* merge two dataset by id */
data ps_merge;
 merge ps_match (in=f1) long_id (in=f2);
 by id;
 if f1 and f2;
run; 
/* sort the data by id and create a frequency table */
proc sort data=ps_merge;
  by diabetes;
run;
proc freq data=ps_merge noprint;
  tables heart_attack*diabetes / out = freq_table_merge;
  weight weight;
run;

/* ------------------------------------------------------------------------- */
/* ------------------- Inverse Propensity Score Weight --------------------- */
/* ------------------------------------------------------------------------- */

/* creating inverse weight */
data ps_match_treatment;
  set ps_match;
  where diabetes = 1;
  total_weight = weight / ps;
run;
data ps_match_control;
  set ps_match;
  where diabetes = 0;
  total_weight = weight / (1 - ps);
run;
data ps_match_inverse;
  set ps_match_treatment ps_match_control;
run;
/* creating inverse weighted frequency table */
proc freq data=ps_match_inverse noprint;
  tables heart_attack*diabetes / out = ps_match_inverse_table;
  weight total_weight;
run;
/* ------------------------------------------------------------------------- */
/* -------------------------- Export Results ------------------------------- */
/* ------------------------------------------------------------------------- */

%csvexport(ps_match_inverse_table, lib=work)
%csvexport(freq_table_merge, lib=work)
%csvexport(freq_table, lib=work)
run;

/* ------------------------------------------------------------------------- */
/* ------------------------ Descriptive Analysis --------------------------- */
/* ------------------------------------------------------------------------- */

/* Decode by Formatting */
proc format library = midterm.nhanes_format;
  value pressone
	0 = "No"
	1 = "Yes";
  value presstwo
	0 = "No"
	1 = "Yes";
  value diabetes
    0 = "No"
	1 = "Yes";
run;

/* Format catalog and search order */
options fmtsearch = (midterm.nhanes_format);

data nhanes;
 set nhanes;
 format blood_press2 presstwo. blood_press pressone. diabetes diabetes.;
run;

data ps_match;
 set ps_match;
 format diabetes diabetes.;
run;

/* -------- Comparison Graph Between Prematch Data And Macthed Data -------- */
/* ------------------------------------------------------------------------- */

/* sort for by steo use */
proc sort data=nhanes; 
  by id;
proc sort data=ps_merge; 
  by id;
/* create matched nhanes data */
data nhanes_match;
 merge nhanes (in=f1) ps_merge (in=f2);
 by id;
 if f1 and f2;
run; 

/* age distribution before match */
goptions reset=all;
proc gchart data=nhanes;
  vbar age/sumvar=weight group=diabetes type=sum discrete;
    title 'Age Distribution Before Match'; 
run;
/* age distribution after match */
proc gchart data=nhanes_match;
  vbar age/sumvar=weight group=diabetes type=sum discrete;
    title 'Age Distribution After Match'; 
run;

/* Year of smoke distribution before match */
proc gchart data=nhanes;
  where year_smoke > 0;
  vbar year_smoke/sumvar=weight group=diabetes type=sum discrete;
    title 'Year of Smoke Distribution Before Match'; 
run;
/* Year of smoke distribution after match */
proc gchart data=nhanes_match;
  where year_smoke > 0;
  vbar year_smoke/sumvar=weight group=diabetes type=sum discrete;
    title 'Year of Smoke Distribution After Match'; 
run;

/* Year of hypertension distribution before match */
goptions reset=all;
proc gchart data=nhanes;
  where year_hyper > 0;
  vbar year_hyper/sumvar=weight group=diabetes type=sum discrete;
    title 'Year of Hypertension Distribution Before Match'; 
run;
/* Year of hypertension distribution after match */
proc gchart data=nhanes_match;
  where year_hyper > 0;
  vbar year_hyper/sumvar=weight group=diabetes type=sum discrete;
    title 'Year of Hypertension Distribution After Match'; 
run;

/* Being told high blood pressure 2+ more times or not before match */
goptions reset=all;
proc gchart data=nhanes;
  vbar blood_press2/sumvar=weight group=diabetes type=sum discrete;
    title 'Being Told High Blood Pressure 2+ More Times or Not Before Match';
run;
/* Being told high blood pressure 2+ more times or not after match */
proc gchart data=nhanes_match;
  vbar blood_press2/sumvar=weight group=diabetes type=sum discrete;
    title 'Being Told High Blood Pressure 2+ More Times or Not After Match';
run;

/* Being told high blood pressure before match */
goptions reset=all;
proc gchart data=nhanes;
  vbar blood_press/sumvar=weight group=diabetes type=sum discrete;
    title 'Being Told High Blood Pressure Before Match';
run;
/* Being told high blood pressure after match */
proc gchart data=nhanes_match;
  vbar blood_press/sumvar=weight group=diabetes type=sum discrete;
    title 'Being Told High Blood Pressure After Match';
run;

/* -------------------- Distribution of Propensity Score ------------------- */
/* ------------------------------------------------------------------------- */

/* sort data for group step */
proc sort data=ps_match; 
  by diabetes;
run;

/* set color for bar chart */
pattern1 v=solid color=CREAM;
pattern2 v=solid color=VLIGB;

/* plot distribution of propensity score, combined*/
proc gchart data=ps_match;
  vbar ps/subgroup=diabetes;
    title 'Distribution of Propensity Score';
run;

/* ------------------------------------------------------------------------- */
/* ---------------------------- Balance Check  ----------------------------- */
/* ------------------------------------------------------------------------- */

/* Compute mean and standard deviation for matched data -------------------- */

/* sort data for by step */

proc sort data=nhanes_match;
  by diabetes;
run;

proc means data=nhanes_match mean std;
  var relative_heart_attack gender race edu smoke_life
      phy_vigorous phy_moderate blood_press blood_press2
      hyper_med hbq_med high_chol meadial_access cover_hc
      health_diet age annual_income bmi year_smoke year_hyper;
  by diabetes;
  freq weight;
  ods output summary = matched_summary;
run;

ods output close;

/* Compute mean and standard deviation for prematch data ------------------- */
/* sort data for by step */

proc sort data=nhanes;
  by diabetes;
run;

proc means data=nhanes mean std;
  var relative_heart_attack gender race edu smoke_life
      phy_vigorous phy_moderate blood_press blood_press2
      hyper_med hbq_med high_chol meadial_access cover_hc
      health_diet age annual_income bmi year_smoke year_hyper;
  by diabetes;
  freq weight;
  ods output summary = pre_summary;
run;

ods output close;

/* Performing t-test for matched data -------------------------------------- */
proc ttest data=nhanes_match;
  where diabetes in (0, 1);
  var heart_attack;
  class diabetes;
  weight weight;
  ods output ttests = ttest conflimits = conflimits;
run;

/* ------------------------------------------------------------------------- */
/* -------------------------- Export Results ------------------------------- */
/* ------------------------------------------------------------------------- */

%csvexport(pre_summary, lib=work)
%csvexport(matched_summary, lib=work)
%csvexport(conflimits, lib=work)
%csvexport(ttest, lib=work)
run;
