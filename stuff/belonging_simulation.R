# Load necessary libraries
library(MASS)
library(tidyverse)

# Set seed for reproducibility
set.seed(123)

# Define number of participants
n_participants <- 1000

# Define genders and age
gender <- c(rep('1', n_participants * 0.4), 
            rep('2', n_participants * 0.5),
            rep('3', n_participants * 0.1))
age <- sample(17:25, n_participants, replace = TRUE)

# Define mean and standard deviation for each scale
mean_belongingness <- 4.06
sd_belongingness <- 0.5
mean_engagement <- 3.82
sd_engagement <- 0.5
mean_self_confidence <- 3.48
sd_self_confidence <- 0.5

# Correlate the scales
sigma <- matrix(c(1, 0.5, 0.6,
                  0.5, 1, 0.7,
                  0.6, 0.7, 1), 
                nrow=3, ncol=3)  # Correlation matrix
mu <- c(mean_belongingness, mean_engagement, mean_self_confidence)  # Means

# Simulate the correlated data
set.seed(123)
simulated_scores <- mvrnorm(n_participants, mu, sigma)
colnames(simulated_scores) <- c("belongingness", "engagement", "self_confidence")

# Adjust for gender effect on self-confidence and engagement
simulated_scores[gender == '2', "self_confidence"] <- simulated_scores[gender == '2', "self_confidence"] + 0.1
simulated_scores[gender == '2', "engagement"] <- simulated_scores[gender == '2', "engagement"] - 0.1
simulated_scores[gender == '3', "self_confidence"] <- simulated_scores[gender == '3', "self_confidence"] - 0.1

# Adjust for age effect on engagement and self-confidence
simulated_scores[, "engagement"] <- simulated_scores[, "engagement"] + 0.01 * (age - mean(age))
simulated_scores[, "self_confidence"] <- simulated_scores[, "self_confidence"] + 0.01 * (age - mean(age))

# Create a new dataframe
data <- data.frame(participant = 1:n_participants,
                   gender = sample(gender),
                   age = age,
                   belongingness = simulated_scores[, "belongingness"],
                   engagement = simulated_scores[, "engagement"],
                   self_confidence = simulated_scores[, "self_confidence"]) %>%
  mutate(gender = as.numeric(gender))

# Round questionnaire data to 2 decimal places
data <- data %>% mutate_at(vars(belongingness:self_confidence), round, 2)

# Split into demographic and questionnaire data
demographic_data <- data %>% select(participant, gender, age)
questionnaire_data <- data %>% select(participant, belongingness, engagement, self_confidence)
