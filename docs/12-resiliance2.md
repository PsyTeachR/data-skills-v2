
# Resilience 2

## Intended Learning Outcomes {#sec-ilo-resil-2}


```
## Rows: 890 Columns: 4
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (1): gender
## dbl (3): participant_ID, age, treatment
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 890 Columns: 7
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## dbl (7): participant_ID, bounce_back_quickly, hard_time_stressful_events, lo...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
## Rows: 30 Columns: 4
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (2): item, scoring
## dbl (2): response, score
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


By the end of this chapter you should be able to:

* Create new columns with `mutate` and `case_when()`
* Identify and deal with missing data


## Walkthrough video {#sec-walkthrough-resil}

There is a walkthrough video of this chapter available via [Zoom]()(INCOMING). We recommend first trying to work through each section of the book on your own and then watching the video if you get stuck, or if you would like more information. This will feel slower than just starting with the video, but you will learn more in the long-run. Please note that there may have been minor edits to the book since the video was recorded. Where there are differences, the book should always take precedence.

## Activity 1: Set-up {#sec-setup-resil2}

Login to the server and then:

* Open your Resilience project.
* Create a new Markdown document named "Resilience 2". Delete the default text and then create a new code chunk.
* Your environment should be clear but if there are objects in it, remove them by pressing the brush icon. 
* Create a new code chunk and then copy, paste, and run the below code. You don't need to edit anything, this will get you to the point you were at in Activity 7 in Resilience 1. Once you've run the code, click on `dat_wide` to view it and take a minute to familiarise yourself with the variables and structure of the dataset.


```r
library(tidyverse)
demo_data <- read_csv("demographic_data.csv")
q_data <- read_csv("questionnaire_data.csv")
scoring <- read_csv("scoring.csv")

demo_cleaned <- demo_data %>%
  mutate(treatment = factor(treatment, 
                            levels = c(1,2), 
                            labels = c("control", "intervention")),
         gender = as.factor(gender),
         participant_ID = as.character(participant_ID)) # convert to character

q_cleaned <- q_data %>%
  mutate(participant_ID = as.character(participant_ID))

dat_wide <- inner_join(x = demo_cleaned, y = q_cleaned, by = "participant_ID") 
```

* How many rows of data are there in `dat_wide`? <input class='webex-solveme nospaces' size='3' data-answer='["890"]'/>
* How many columns (variables) are there in `dat_wide`? <input class='webex-solveme nospaces' size='2' data-answer='["10"]'/>
* What is the name of the column that stores the participant's ID number? <select class='webex-select'><option value='blank'></option><option value=''>ID</option><option value=''>Participant ID</option><option value='answer'>participant_ID</option><option value=''>Participant_id</option></select>

## Activity 2: Identify missing data

As noted in Resilience 1, there is a little bit of missing data in this dataset. There's a few ways to identify missing data. The first method you have already encountered, you can run `summary()` on the object and any variables with missing data will have a count of `NA's`.


```r
summary(dat_wide)
```

```
##  participant_ID          age               gender           treatment  
##  Length:890         Min.   :18.00   man       :429   control     :426  
##  Class :character   1st Qu.:23.00   non-binary: 28   intervention:464  
##  Mode  :character   Median :29.00   woman     :433                     
##                     Mean   :28.92                                      
##                     3rd Qu.:35.00                                      
##                     Max.   :40.00                                      
##                     NA's   :8                                          
##  bounce_back_quickly hard_time_stressful_events long_to_recover_stress
##  Min.   :1.000       Min.   :1.000              Min.   :1.000         
##  1st Qu.:2.000       1st Qu.:2.000              1st Qu.:2.000         
##  Median :3.000       Median :3.000              Median :3.000         
##  Mean   :3.034       Mean   :3.014              Mean   :2.972         
##  3rd Qu.:4.000       3rd Qu.:4.000              3rd Qu.:4.000         
##  Max.   :5.000       Max.   :5.000              Max.   :5.000         
##  NA's   :44          NA's   :26                 NA's   :35            
##  snap_back_difficulty through_difficult_times long_time_over_setbacks
##  Min.   :1.000        Min.   :1.00            Min.   :1.000          
##  1st Qu.:2.000        1st Qu.:2.00            1st Qu.:2.000          
##  Median :3.000        Median :3.00            Median :3.000          
##  Mean   :3.013        Mean   :3.03            Mean   :3.006          
##  3rd Qu.:4.000        3rd Qu.:4.00            3rd Qu.:4.000          
##  Max.   :5.000        Max.   :5.00            Max.   :5.000          
##  NA's   :53           NA's   :17              NA's   :44
```

But you can also do this using `tidyverse` functions. The reason this is potentially more useful is that it is easier to store it as a table and refer back to it later. It also just contains the information you need about missing data, rather than all the summary stats.

* `summarise_all()` is a function that applies the summary calculation to all variables in an object
* `sum(is.na(.))` adds up (sums) how many values are NAs (`is.na`)
* The . in `is.na()` acts as a placeholder for each column in turn. 


```r
missing_data <- dat_wide %>%
  summarise_all(~sum(is.na(.)))
```

Finally, you could also eyeball the data (literally just look at it). Although with a large number of data points, this isn't particularly accurate. 

## Activity 3: Removing missing values

Now we've identified which columns have missing values, we can deal with it using the function `drop_na()` which drops any NA values from our object.

The first option is to do the nuclear version and drop any line of data if there is a single missing data point so that we only have complete cases. Because our data is in wide-form, this would mean that we drop all the data from an entire participant if they are missing data in any of the variables. 


```r
dat_complete <- dat_wide %>%
  drop_na()
```

* How many data points are left after running `drop_na()`? <input class='webex-solveme nospaces' size='3' data-answer='["685"]'/>


<div class='webex-solution'><button>Hint</button>


You can figure this out by looking in the environment pane and seeing how many observations `dat_complete` has. You could also do it with code:


```r
dat_complete %>%
  count()
```

<div class="kable-table">

|   n|
|---:|
| 685|

</div>


</div>


We lost a lot of data by doing this, it's removed 205 participants (about 23% of the original dataset) for having one or more NA in any row. You'll learn more about statistical power in Level 2 but the tl:dr version is that we generally want our sample sizes to be as large as possible and we don't want to throw away data unnecessarily. 

Our study is going to look at whether resilience scores change depending on the treatment condition participants underwent. Look at the columns that have missing data and think about which ones are absolutely necessary for that analysis.

* Which column might we not mind having missing data for? <select class='webex-select'><option value='blank'></option><option value=''>participant_ID</option><option value='answer'>age</option><option value=''>bounce_back_quickly</option></select>


<div class='webex-solution'><button>Explain this answer</button>


* Generally speaking, you always need the `participant_id` so you know which data comes from which person. Additionally, `participant_id` doesn't actually have any missing data.

* `bounce_back_quickly` is one of the items on the resilience scale, so if we want to accurately measure resilience scores, we don't want any missing data in this variable.

* However, `age` isn't necessary for our analysis. When writing up a research report, you would normally report the age and gender stats of your sample but we can make a note of any missing data rather than having to delete the entire participant. For example:

*There were 890 participants in total (mean age = 28.9217687, SD = 6.6229404, missing = 8)*


</div>


Instead of running `drop_na()` on the entire dataset, we can specify which columns to include or ignore. This code works the same way as `select()` in that you can either say which columns you want it to run the code on, or you say which columns to ignore. In this case, it's easier to say which ones to ignore.


```r
dat_final <- dat_wide %>%
  drop_na(-participant_ID, -gender, -age)
```

This then means only the resilience and treatment columns are included in the call to `drop_na()`, which gives us an extra 8 participants. Which isn't much, but every little counts.

## Activity 4: Reshape and score

Now we've got rid of the missing data, we can transform the object to long-form and score it. Copy and paste the below code (this was explained in the last chapter, we've provided it for you so we can jump ahead to more interesting things).


```r
dat_long <- dat_final %>%
  pivot_longer(cols = bounce_back_quickly:long_time_over_setbacks, 
               names_to = "item", 
               values_to = "response")

dat <- inner_join(x = dat_long, y = scoring, by = c("item", "response"))

dat_scores <- dat %>%
  group_by(participant_ID, age, gender, treatment) %>%
  summarise(resilience_score = mean(score, na.rm = TRUE)) %>%
  ungroup()
```

```
## `summarise()` has grouped output by 'participant_ID', 'age', 'gender'. You can
## override using the `.groups` argument.
```

## Activity 5: Creating new variables

In addition to using the data that is contained in our original datasets, we can also create new variables using `mutate()` combined with other functions.

Let's imagine that for some reason, there is an error in the software used to record the data and age has been recorded incorrectly and each participant is actually 1 year older than the values we have.

We can create a new column using `mutate()`. 

* The bit on the left of the equals sign is the name of the new variable we will create, in this case, it will be a column named `age_corrected`. 
* The bit on the right of the equals sign determines the values that column will have. In this case, it will add 1 to the values that are currently stored in the column `age`
* We just want to add columns to the existing object which is why we are still using `dat_scores` rather than creating a new object.


```r
dat_scores <- dat_scores %>%
  mutate(age_corrected = age + 1)
```

We can also create new variables using a combination of `mutate()` and `case_when()`. `case_when()` is a very useful and powerful function that allows you to create new variables based on multiple conditions and values.

For example, we can create a new categorical variable assigns participants to the "Younger" category if their `age_corrected` is less than or equal (`<=`) to 30, and "Older" if `age_corrected` is more than (`>`) 30. This categorisation is not based on any scientifically motivated split, it's just around  the age I stopped being able to go out more than once a week.

* You can read `~` as `then`, i.e., if age is less than or equal to 30, then write "Younger".
* You can have as many conditions as you like, just separate them with commas.
* `.default` isn't always necessary but it controls what value is entered if a value doesn't meet any of the conditions. In this case, it would just return an NA. You could also set it to return "MISSING" or you could set it to return whatever value is in the original column (for example if you didn't need to recode all the values, just some of them).


```r
dat_scores <- dat_scores %>%
  mutate(age_category = case_when(age_corrected <= 30 ~ "Younger",
                                  age_corrected > 30 ~ "Older", 
                                  .default = NA, ))
```

The new variable `age_category` will be created as a `character` variable but we want it to be stored as a factor. 

* Add on a line of code to the above to overwrite the new variable as a factor.


<div class='webex-solution'><button>Hint</button>


```r
dat_scores <- dat_scores %>%
  mutate(age_category = case_when(age_corrected <= 30 ~ "Younger",
                                  age_corrected > 30 ~ "Older", 
                                  .default = NA, ),
         variable_name = function_to_create_factors(variable_to_factorise))
```

</div>



<div class='webex-solution'><button>Solution</button>


```r
dat_scores <- dat_scores %>%
  mutate(age_category = case_when(age_corrected <= 30 ~ "Younger",
                                  age_corrected > 30 ~ "Older", 
                                  .default = NA, ),
         age_category = as.factor(age_category))
```

</div>



Now it's a factor, using your method of choice, count how many participants are in each group.

* There are <input class='webex-solveme nospaces' size='3' data-answer='["351"]'/> participants in the younger group
* There are <input class='webex-solveme nospaces' size='3' data-answer='["334"]'/> participants in the older group


<div class='webex-solution'><button>Hint</button>



```r
summary() 

# or

count()
```


</div>



<div class='webex-solution'><button>Solution</button>



```r
summary(dat_scores)

dat_scores %>%
  count(age_category)
```

```
##  participant_ID          age              gender           treatment  
##  Length:692         Min.   :18.0   man       :322   control     :324  
##  Class :character   1st Qu.:23.0   non-binary: 22   intervention:368  
##  Mode  :character   Median :29.0   woman     :348                     
##                     Mean   :28.9                                      
##                     3rd Qu.:35.0                                      
##                     Max.   :40.0                                      
##                     NA's   :7                                         
##  resilience_score age_corrected   age_category
##  Min.   :1.833    Min.   :19.0   Older  :334  
##  1st Qu.:2.667    1st Qu.:24.0   Younger:351  
##  Median :3.000    Median :30.0   NA's   :  7  
##  Mean   :3.026    Mean   :29.9                
##  3rd Qu.:3.333    3rd Qu.:36.0                
##  Max.   :4.333    Max.   :41.0                
##                   NA's   :7
```

<div class="kable-table">

|age_category |   n|
|:------------|---:|
|Older        | 334|
|Younger      | 351|
|NA           |   7|

</div>


</div>


## Activity 6: More variable creation

Let's try some other examples to give you a sense of the flexibility this affords (this will help you with the group project analysis).

The software we used to store the data really has gone wrong and we've also discovered that `gender` has been coded incorrectly - `man` and `woman` have been switched, although `non-binary` is correct.

* Create a new variable named `gender_corrected` using `mutate()` and `case_when()`
* If `gender` equals `man`, `gender_corrected` should say `woman`
* Everything else can stay the same
* You have to use both the single and double equal signs to get this to work.
* Remember to make it a factor once you're done


<div class='webex-solution'><button>Hint</button>



```r
dat_scores <- dat_scores %>%
  mutate(new_variable = case_when(old_variable == "old_value" ~ "new_value",
                                  old_variable == "old_value" ~ "new_value",
                                  .default = the_rest),
         new_variable = as.factor(new_variable))
```

</div>



<div class='webex-solution'><button>Solution</button>



```r
dat_scores <- dat_scores %>%
  mutate(gender_corrected = case_when(gender == "man" ~ "woman",
                                      gender == "woman" ~ "man",
                                      .default = gender),
         gender_corrected = as.factor(gender_corrected))
```


</div>


* How many men are there in the corrected gender variable? <input class='webex-solveme nospaces' size='3' data-answer='["348"]'/>
* How many women are there in the corrected gender variable? <input class='webex-solveme nospaces' size='3' data-answer='["322"]'/>
* How many non-binary people are there in the corrected gender variable? <input class='webex-solveme nospaces' size='2' data-answer='["22"]'/>

## Activity 7: Analysis and visualisation

For the final step, let's calculate all the numbers you would need if you were writing up this study for an analysis. You've done all of this before multiple times throughout Psych 1A and Psych 1B - try and do as much of it as you can from memory and trial-and-error before you look at the hints or solutions.

### Demographic stats

Write code to calculate the following (remember to use the corrected variables):

* Total number of participants
* Number of each gender
* Mean age and standard deviation
* Number of participants in each treatment condition


<div class='webex-solution'><button>Hint</button>


These are all the functions you need to achieve the above


```r
count()
summarise()
mean
sd
na.rm
sum
is.na
```


</div>



<div class='webex-solution'><button>Solution</button>


If you have looked at the solutions without trying it for yourself, just remember that it's your own learning that will suffer and Level 2 is going to be an unpleasant shock to the system if you've been taking shortcuts throughout Level 1....


```r
# total ppts
dat_scores %>%
  count()

# gender split
dat_scores %>%
  count(gender)

# mean age, sd and missing
dat_scores %>%
  summarise(mean_age = mean(age, na.rm = TRUE),
    sd_age = sd(age, na.rm = TRUE),
    missing = sum(is.na(age)))

# number in each condition
dat_scores %>%
  count(treatment)
```


</div>


### Analysis stats

* Mean, standard deviation, min and max resilience score across all participants
* Mean, standard deviation, min and max resilience score for each treatment condition
* A visualisation of the difference between the two groups


<div class='webex-solution'><button>Hint</button>


These are all the functions you need to achieve the above


```r
summarise()
group_by()
mean
sd
min
max
ggplot()
aes()
# which plot you choose is up to you, it might involve the following
geom_histogram()
geom_boxplot()
geom_violin()
facet_wrap()
```


</div>



<div class='webex-solution'><button>Solution</button>


If you have looked at the solutions without trying it for yourself, just remember that it's your own learning that will suffer and Level 2 is going to be an unpleasant shock to the system if you've been taking shortcuts throughout Level 1....


```r
# overall resilience score
dat_scores %>%
  summarise(mean_score = mean(resilience_score),
            sd_score = sd(resilience_score),
            min_score = min(resilience_score),
            max = max(resilience_score))

# resilience scores by group

dat_scores %>%
  group_by(treatment) %>%
  summarise(mean_score = mean(resilience_score),
            sd_score = sd(resilience_score),
            min_score = min(resilience_score),
            max = max(resilience_score))

# visualisation

## histogram by group

ggplot(dat_scores, aes(x = resilience_score, fill = treatment)) +
  geom_histogram(colour = "black") +
  facet_wrap(~ treatment, nrow = 2) +
  guides(fill = "none") +
  scale_fill_viridis_d(option = "E")

# violin-boxplot

ggplot(dat_scores, aes(x = treatment, y = resilience_score, fill = treatment)) +
  geom_violin(alpha = .3) +
  geom_boxplot(width = .2, alpha = .6)+
  guides(fill = "none") +
  scale_fill_viridis_d(option = "E")
```


</div>


### Write-up

After participants were excluded for having missing data in the resilience scores, in total there were <input class='webex-solveme nospaces' size='3' data-answer='["692"]'/> participants (<input class='webex-solveme nospaces' size='3' data-answer='["322"]'/> men, <input class='webex-solveme nospaces' size='3' data-answer='["348"]'/> women, <input class='webex-solveme nospaces' size='2' data-answer='["22"]'/> non-binary, mean age = <input class='webex-solveme nospaces' size='4' data-answer='["28.9"]'/>, SD = <input class='webex-solveme nospaces' size='3' data-answer='["6.6"]'/>, missing = <input class='webex-solveme nospaces' size='1' data-answer='["7"]'/>). <input class='webex-solveme nospaces' size='3' data-answer='["324"]'/> participants were randomly assigned to the control condition and <input class='webex-solveme nospaces' size='3' data-answer='["368"]'/> were randomly assigned to the treatment condition.

Collapsing across both treatment conditions, the overall mean resilience score was <input class='webex-solveme nospaces' size='4' data-answer='["3.03"]'/> (SD = <input class='webex-solveme nospaces' size='5' data-answer='["0.438",".438"]'/>, min = <input class='webex-solveme nospaces' size='4' data-answer='["1.83"]'/>, max = <input class='webex-solveme nospaces' size='4' data-answer='["4.33"]'/>). When analysed by treatment group, participants in the control condition  (mean = <input class='webex-solveme nospaces' size='4' data-answer='["2.84"]'/>, SD = <input class='webex-solveme nospaces' size='5' data-answer='["0.391",".391"]'/>, min = <input class='webex-solveme nospaces' size='4' data-answer='["1.83"]'/>, max = <input class='webex-solveme nospaces' size='4' data-answer='["3.83"]'/>) self-reported <select class='webex-select'><option value='blank'></option><option value='answer'>lower</option><option value=''>higher</option></select> resilience scores than participants in the treatment condition (mean = <input class='webex-solveme nospaces' size='4' data-answer='["3.19"]'/>, SD = <input class='webex-solveme nospaces' size='5' data-answer='["0.411",".411"]'/>, min = <input class='webex-solveme nospaces' size='1' data-answer='["2"]'/>, max = <input class='webex-solveme nospaces' size='4' data-answer='["4.33"]'/>).

The hypothesis that the treatment would improve resilience scores was therefore <select class='webex-select'><option value='blank'></option><option value='answer'>supported</option><option value=''>rejected</option></select>.

## Finished

Finally, try knitting the file to HTML and remember to  make a note of any mistakes you made and how you fixed them or any other useful information you learned. Then save your Markdown, and quit your session on the server if applicable. 
