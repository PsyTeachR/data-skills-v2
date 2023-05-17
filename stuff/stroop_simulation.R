# Load required libraries
library(dplyr)

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
  congruent_time = rnorm(N_PARTICIPANTS, mean = 750, sd = 100),
  incongruent_time = rnorm(N_PARTICIPANTS, mean = 900, sd = 150),
  congruent_accuracy = rbinom(N_PARTICIPANTS, size = 1, prob = 0.8),
  incongruent_accuracy = rbinom(N_PARTICIPANTS, size = 1, prob = 0.6)
)

# write.csv

write.csv(x = ppt_info, file = "book/data/stroop/participant-data.csv")
write.csv(x = dat, file = "experiment_results.csv")
