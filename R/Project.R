# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the dataset
covid <- read.csv("C:/Users/Espaw/OneDrive/Documents/UNI/CII2201/project/WHO-COVID-19-global-data.csv")

# Filter the dataset for country_code "GB" and drop the specified columns
f_covid <- covid %>%
  filter(Country_code == "GB") %>%
  select(-WHO_region, -Country) %>%
  mutate_all(~replace(., is.na(.), 0))

# Convert Date_reported to Date format
f_covid <- f_covid %>%
  mutate(Date_reported = as.Date(Date_reported))

# Display the first few rows of the filtered dataset
head(f_covid)

# Get a summary of the filtered dataset
summary(f_covid)

# Create a new column for lockdown periods
f_covid <- f_covid %>%
  mutate(Lockdown_Period = case_when(
    Date_reported >= as.Date("2020-03-01") & Date_reported <= as.Date("2020-06-30") ~ "First National Lockdown",
    Date_reported >= as.Date("2020-09-01") & Date_reported <= as.Date("2020-10-31") ~ "Reinstated Restrictions",
    Date_reported >= as.Date("2020-11-01") & Date_reported <= as.Date("2020-12-31") ~ "Second National Lockdown",
    Date_reported >= as.Date("2021-01-01") & Date_reported <= as.Date("2021-03-31") ~ "Third National Lockdown",
    Date_reported >= as.Date("2021-03-01") & Date_reported <= as.Date("2021-07-31") ~ "Leaving Lockdown",
    TRUE ~ "No Lockdown"
  ))

# Visualize the data
ggplot(f_covid, aes(x = Date_reported, y = New_cases, color = Lockdown_Period)) +
  geom_line() +
  labs(title = "COVID-19 Cases in the UK Over Time",
       x = "Date_reported",
       y = "Number of New Cases",
       color = "Lockdown Period") +
  theme_minimal() +
  scale_color_manual(values = c("First National Lockdown" = "red",
                                "Reinstated Restrictions" = "orange",
                                "Second National Lockdown" = "blue",
                                "Third National Lockdown" = "purple",
                                "Leaving Lockdown" = "green",
                                "No Lockdown" = "gray"))

# Save the plot
ggsave("covid_cases_uk.png", width = 10, height = 6)
