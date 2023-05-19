# Load required libraries
library(tidyverse)

# Define constants
N_PARTICIPANTS <- 270
N_MEN <- 100
N_WOMEN <- 120
N_NONBINARY <- 50
AGE_MIN <- 18
AGE_MAX <- 30

# Create dataframe for participants
set.seed(123)
ppt_info <- data.frame(
  participant_id = 1:N_PARTICIPANTS,
  gender = c(rep("Man", N_MEN), rep("Woman", N_WOMEN), rep("Non-Binary", N_NONBINARY)),
  age = sample(AGE_MIN:AGE_MAX, N_PARTICIPANTS, replace = TRUE)
)

# Create dataframe for experiment results
dat <- data.frame(
  participant_id = 1:N_PARTICIPANTS,
  congruent = rnorm(N_PARTICIPANTS, mean = 750, sd = 100),
  incongruent = rnorm(N_PARTICIPANTS, mean = 900, sd = 150)
) %>%
  pivot_longer(cols = congruent:incongruent, 
               names_to = "condition", 
               values_to = "reaction_time")
# write.csv

#write.csv(x = ppt_info, file = "book/data/stroop/participant-data.csv")
#write.csv(x = dat, file = "book/data/stroop/experiment_results.csv")
