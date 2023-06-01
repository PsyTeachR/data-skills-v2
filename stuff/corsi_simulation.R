# Load necessary libraries
library(dplyr)

# Set the seed for reproducibility
set.seed(123)

# Define the number of participants
n_participants <- 600

# Define the variables
Gender <- c(rep('Woman', n_participants * 0.5),
            rep('Man', n_participants * 0.40),
            rep('Non-Binary', n_participants * 0.1))

Age <- sample(18:60, n_participants, replace = TRUE)

# Set conditions and mean Corsi scores
Condition <- c(rep('8 hours sleep', n_participants * 1/3),
               rep('4 hours sleep', n_participants * 1/3),
               rep('Sleep deprived', n_participants * 1/3))

Mean_Corsi_Score <- ifelse(Condition == '8 hours sleep', 6, ifelse(Condition == '4 hours sleep', 5, 4))

# Simulate Corsi scores around mean, considering a small correlation with age
Corsi_Score <- round(rnorm(n_participants, Mean_Corsi_Score + 0.01*(Age - mean(Age)), sd = 1))
Corsi_Score <- ifelse(Corsi_Score > 9, 9, ifelse(Corsi_Score < 0, 0, Corsi_Score))

# Create a data frame
data <- data.frame(Participant = 1:n_participants,
                   Gender = sample(Gender),
                   Age = Age,
                   Condition = Condition,
                   Corsi_Score = Corsi_Score)

# Define Demographic data
participant_data <- data %>% 
  select(Participant, Gender, Age, Condition)

# Define Score data
score_data <- data %>% 
  select(Participant, Corsi_Score)



write.csv(x = participant_data, file = "book/data/corsi/participant_data.csv")
write.csv(x = score_data, file = "book/data/corsi/score_data.csv")
