# Set the seed for reproducibility
set.seed(123)

# Define the number of participants
num_participants <- 890

# Generate questionnaire responses with a small proportion of missing data
generate_responses <- function(n, prob_missing = 0.05) {
  responses <- sample(1:5, size = n, replace = TRUE, prob = c(0.1, 0.2, 0.4, 0.2, 0.1))
  missing_indices <- sample(1:n, size = floor(prob_missing * n))
  responses[missing_indices] <- NA
  return(responses)
}

# Generate the dataset
data <- data.frame(
  participant_ID = 1:num_participants,
  bounce_back_quickly = generate_responses(num_participants, 0.05),
  hard_time_stressful_events = generate_responses(num_participants, 0.03),
  long_to_recover_stress = generate_responses(num_participants, 0.04),
  snap_back_difficulty = generate_responses(num_participants, 0.06),
  through_difficult_times = generate_responses(num_participants, 0.02),
  long_time_over_setbacks = generate_responses(num_participants, 0.05),
  age = sample(18:40, num_participants, replace = TRUE),
  gender = sample(c("man", "woman", "non-binary"), num_participants, replace = TRUE, prob = c(0.48, 0.48, 0.04))
)

# Introduce missing data to age
age_missing_indices <- sample(1:num_participants, size = floor(0.01 * num_participants))
data$age[age_missing_indices] <- NA


# Create a data frame to serve as a codebook
codebook <- data.frame(
  item = c("bounce_back_quickly", "hard_time_stressful_events", "long_to_recover_stress", 
           "snap_back_difficulty", "through_difficult_times", "long_time_over_setbacks"),
  scoring = c("forward", "reverse", "reverse", "forward", "forward", "reverse"),
  score_1 = c(1, 5, 5, 1, 1, 5),
  score_2 = c(2, 4, 4, 2, 2, 4),
  score_3 = c(3, 3, 3, 3, 3, 3),
  score_4 = c(4, 2, 2, 4, 4, 2),
  score_5 = c(5, 1, 1, 5, 5, 1)
) %>%
  pivot_longer(cols = score_1:score_5, names_to = "response", values_to = "score") %>%
  mutate(response = case_when(response == "score_1" ~ 1,
                              response == "score_2" ~ 2,
                              response == "score_3" ~ 3,
                              response == "score_4" ~ 4,
                              response == "score_5" ~ 5),
         response = as.numeric(response))


# long-form for calculating treatment scores

dat <- data %>%
  pivot_longer(cols = 2:7, names_to = "item", values_to = "response") %>%
  inner_join(codebook) %>%
  group_by(participant_ID) %>%
  summarise(mean_score = mean(score, na.rm = TRUE))


# Assuming dat is your data frame and mean_score is a column in dat
# Use a logistic function to determine the probability of being in the intervention group

# Define the max score for scaling (this should be set according to your data)
max_score <- max(dat$mean_score, na.rm = TRUE)

# Calculate probabilities of being in the intervention group
# The logistic function here can be adjusted based on how steeply you want the probability to increase
dat$intervention_prob <- 1 / (1 + exp(- (dat$mean_score - mean(dat$mean_score, na.rm = TRUE)) / sd(dat$mean_score, na.rm = TRUE)))

# Assign to groups based on the calculated probability
set.seed(123) # For reproducibility
dat$treatment <- ifelse(runif(nrow(dat)) < dat$intervention_prob, "2", "1")

# add treatment groups to original data set

data <- dat %>%
  select(participant_ID, treatment) %>%
  right_join(data)


# Split the dataset into two separate datasets
# Dataset 1: Participant ID and questionnaire data
questionnaire_data <- data[c("participant_ID", "bounce_back_quickly", "hard_time_stressful_events", 
                             "long_to_recover_stress", "snap_back_difficulty", 
                             "through_difficult_times", "long_time_over_setbacks")]

# Dataset 2: Participant ID, age, gender, and treatment
demographic_data <- data[c("participant_ID", "age", "gender", "treatment")]

readr::write_csv(x = demographic_data, file = "book/data/resilience/demographic_data.csv")
readr::write_csv(x = questionnaire_data, file = "book/data/resilience/questionnaire_data.csv")
readr::write_csv(x = codebook, file = "book/data/resilience/scoring.csv")


