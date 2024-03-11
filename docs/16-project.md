# Project analysis

We've spent the last 6 months giving you the skills you need to be able to deal with your own data. Now's the time to show us what you've learned. In this chapter we're going to describe the steps you will need to go through when analysing your data but, aside from a few lines that will help you deal with the initial questionnaire data and a couple of hints, we're not going to give you any code solutions. 

For everything else, you have done it before, so use this book to help you. Remember, you don't need to write the code from memory, you just need to find the relevant examples and then copy and paste and change what needs changing to make it work for you. Additionally, data skills homework 3 is a version of this analysis, so if you can do that, you can do this, and vice versa.

We suggest that you problem-solve the code as a group, however, make sure that you all have a separate copy of the final working code. You can attend into GTA sessions in week 9 and 10 to help you as well.

## Step 1: Import and initial data wrangling

To help get you on your way, we've done a bit of the initial wrangling for you. Download the data files into your working directory, create a new Markdown, then run all the below code without changing anything. I would also encourage you to open up the Excel files to see what's in them as it will help your understanding of the analysis.


```r
library(tidyverse)

# list columns to keep text values from

text_cols_to_keep <- c("ResponseId","DistributionChannel","Progress", "Finished", "Consent", "Gender", "Sexual orientation", "Living situation", "Belief in a God")

# list columns to keep numeric values from

numeric_cols_to_keep <- c("ResponseId", "Q11", "DASS 21_1",	"DASS 21_2",	"DASS 21_3",	"DASS 21_4",	"DASS 21_5",	"DASS 21_6",	"DASS 21_7",	"DASS 21_8",	"DASS 21_9",	"DASS 21_10",	"DASS 21_11",	"DASS 21_12",	"DASS 21_13", "DASS 21_14",	"DASS 21_15",	"DASS 21_16",	"DASS 21_17",	"DASS 21_18",	"DASS 21_19",	"DASS 21_20",	"DASS 21_21") 

# read in data but skip rows 2 and 3
col_names <- names(read_csv("dat_numeric.csv", n_max = 0))

dat_text <- read_csv("dat_text.csv", col_names = col_names, skip = 3) %>%
  select(all_of(text_cols_to_keep))

dat_numeric <- read_csv("dat_numeric.csv", col_names = col_names, skip = 3) %>%
  select(all_of(numeric_cols_to_keep)) %>%
  rename("Age" = "Q11")%>%
  rename_with(~ gsub(" ", "_", .), starts_with("DASS"))

dat <- full_join(x = dat_text, dat_numeric, by = "ResponseId") %>%
  filter(Consent == "Yes", # only keep those who gave consent
         DistributionChannel == "anonymous", # get rid of Emily & Jude preview data
         `Belief in a God` != "6", # updated questionnaire at start caused bug in response
         ResponseId != "R_6lxLImSzA629eY0") %>% # problematic response pattern
  select(1, Gender, Age, "Sexual_orientation" = 7, "Living_situation" = 8, "Belief_god" = 9, 11:31)

dass_scoring <- read_csv("dass_scoring.csv")

rm(dat_numeric)
rm(dat_text)
rm(numeric_cols_to_keep)
rm(col_names)
rm(text_cols_to_keep)
```

## Initial sample size

The first thing you want to do is to `count()` the number of participants in `dat`, before you make any exclusions, so that you are aware what the impact of your exclusion/inclusion criteria is.

## Separate the data

It's easier and generally safer to separate the demographic and DASS data until we're done cleaning it all. At the end, we'll join it back up but for now, create two new objects, one named `demo_dat` and one named `dass_dat`. 

`demo_dat` should contain all the demographic variables including `ResponseId`. 

`dass_dat` should contain all the DASS variables as well as `ResponseId`.

## Create new demographic categories

You may need to create new categories depending on how you decided to group your IV, for example, you might have decided to group religious belief into certain/uncertain, or sexual orientation into queer/heterosexual. If so, add any necessary new categories you need using `mutate()` and `case_when()` to `demo_dat`. Always check what you have created is right by a) looking at the object and b) using `summary()` and/or `count()`.

You may also not need to create any new categories in which case skip this step.

## Demographic exclusion criteria

Now implement any exclusion criteria you specified, for example, if you decided to set an age range or exclude particular groups. You also want to think about if you want to keep people who said "Prefer not to say" or "Other" or who didn't answer any of the demographic variables. I suggest saving this as a new object `demo_cleaned` rather than over-writing `demo_dat` it as it will make it easier to check and make any changes.

## Transform and score the DASS data

We can now move to the DASS data. You need to do the following, in this order:

* Transform `dass_dat` to long-form
* Join this long-form DASS data with `dass_scoring`
* Filter the dataset to only keep the scores from the scale you are using as your DV, e.g., anxiety.
* Group and summarise the data to produce an overall score for each participant. You only want it to calculate a score if there is no missing data, so *don't* use `na.rm = TRUE`. Also remember that the DASS score should be a `sum` score, not a mean. There should be one row of data for each participant and there should be two columns, `ResponseId` and then a column for the score. 
* Finally, create a new column using `mutate()` named `final_score` that multiples their score by 2 (which is how the DASS is scored).

You can create intermediate objects or you can do all of these steps in one big pipeline. Whatever you do, the final object should have three columns, `ResponseId`, the raw score, and the multiplied score, with one row for each participant. I would probably call this object `dass_final` but feel free to go rogue as long as you remember what you named it.
 
## Join it together

Next join together `dass_final` and `demo_cleaned` by their common column. I would probably call this `demo_dass`.

## Missing data

Now that everything is joined back up, it's time to decide what to do with any missing data. You definitely want to get rid of any participant who doesn't have a DASS scale score but you'll also need to remove anyone with missing data in your grouping variable (e.g., if gender is missing and your IV is gender, you can't use them in your analysis).

Name this final object `final_dat` and count the number of participants. The difference between this number and the number in the full sample in `dat` is the number of participants you excluded for various reasons.

## Analysis and visualisation

Aren't we having fun?

You're now ready to analyse your data. You need the following:

* The mean scale score and SD for the sample overall
* Number of participants in your final sample, their mean age, SD, gender split, and number of missing data points.
* The number of participants in each group. It is also useful to calculate this as a percent. We haven't shown you this explicitly but your hint is `count()` - `mutate()` - `n / sum(n)`.
* The mean scale score and SD for each of the groups of your IV.
* Two different visualisations. Your choice, but make them look nice and ensure all the labels are corrected and they're colour-blind friendly.

## Finished

And you're done! I wish that I could adequately convey how impressive what you've just done is. I wish that I could show you how amazing your skills are compared to most other psychology undergraduates in the UK and across the world. But no-one ever believes me so I'll just [leave you with this](https://www.tiktok.com/@chelseaparlettpelleriti/video/7016838746108710149?_r=1&_t=8ZtxKOe3sHe)



