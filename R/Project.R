# Install necessary package (if not already installed)
install.packages("lubridate")
# Install plotly if not already installed
install.packages("plotly")

# Load necessary libraries
library(dplyr)
library(ggplot2)
library(lubridate)  # For automatic date parsing
library(scales)      # For formatting y-axis as whole numbers
library(plotly)      # For interactive visualizations

# Read the dataset
# Change file_path to suit you
file_path <- "C:/Users/Espaw/OneDrive/Documents/UNI/CII2201/project/WHO-COVID-19-global-data.csv"
covid <- read.csv(file_path)

# Clean up any leading/trailing whitespace in Date_reported (in case it's stored as character)
covid$Date_reported <- trimws(covid$Date_reported)

# Check the first few rows to inspect Date_reported
head(covid$Date_reported)

# Attempt parsing with multiple formats using parse_date_time
f_covid <- covid %>%
  mutate(Date_reported = parse_date_time(Date_reported, orders = c("dmy", "ymd", "mdy")))

# Check if there are any NA values or problematic dates in Date_reported
summary(f_covid$Date_reported)

# Check for any rows with invalid dates (NA values)
invalid_dates <- f_covid %>% filter(is.na(Date_reported))
if (nrow(invalid_dates) > 0) {
  cat("Found", nrow(invalid_dates), "invalid date(s).\n")
  print(head(invalid_dates))  # Inspect some of the rows with invalid dates
}

# Filter the dataset for country_code "GB" and drop the specified columns
f_covid <- f_covid %>%
  filter(Country_code == "GB") %>%
  select(-WHO_region, -Country)

# Replace NAs with 0 only for numeric columns
f_covid <- f_covid %>%
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0)))

# Check the class of Date_reported
cat("Class of Date_reported before conversion: ", class(f_covid$Date_reported), "\n")

# Force conversion to Date class (if not already done)
f_covid$Date_reported <- as.Date(f_covid$Date_reported)

# Check again to confirm conversion
cat("Class of Date_reported after conversion: ", class(f_covid$Date_reported), "\n")

# Create the Lockdown_Period column for all dates, including those between lockdowns
f_covid <- f_covid %>%
  mutate(Lockdown_Period = factor(
    case_when(
      Date_reported >= as.Date("2020-03-01") & Date_reported <= as.Date("2020-06-28") ~ "First National Lockdown",
      Date_reported >= as.Date("2020-08-30") & Date_reported <= as.Date("2020-11-01") ~ "Reinstated Restrictions",
      Date_reported >= as.Date("2020-11-01") & Date_reported <= as.Date("2020-12-27") ~ "Second National Lockdown",
      Date_reported >= as.Date("2021-01-03") & Date_reported <= as.Date("2021-03-28") ~ "Third National Lockdown",
      Date_reported >= as.Date("2021-02-28") & Date_reported <= as.Date("2021-08-01") ~ "Leaving Lockdown",
      Date_reported >= as.Date("2020-01-05") & Date_reported <= as.Date("2024-10-06") ~ "No Lockdown",
    ),
    levels = c("First National Lockdown", "Reinstated Restrictions", 
               "Second National Lockdown", "Third National Lockdown", 
               "Leaving Lockdown", "No Lockdown")  # Ensure "No Lockdown" is last
  ))

# Split the data into two: One for "No Lockdown" and one for other lockdown periods
f_covid_lockdowns <- f_covid %>% filter(Lockdown_Period != "No Lockdown")
f_covid_no_lockdown <- f_covid %>% filter(Lockdown_Period == "No Lockdown")

# Create the static ggplot object with continuous "No Lockdown" line
static_plot <- ggplot() +
  # Plot the "No Lockdown" period as the background line (this will be continuous)
  geom_line(data = f_covid, aes(x = Date_reported, y = New_cases), color = "gray", group = 1) +
  
  # Overlay the lockdown periods with different colors
  geom_line(data = f_covid_lockdowns, aes(x = Date_reported, y = New_cases, color = Lockdown_Period, group = 1)) +
  
  # Customize the plot labels and title
  labs(title = "COVID-19 Cases in the UK Over Time",
       x = "Date Reported",
       y = "Number of New Cases",
       color = "Lockdown Period") +
  
  # Adjust x-axis to show every 6 months
  scale_x_date(date_labels = "%b %Y", date_breaks = "6 months") + 
  
  # Format y-axis as whole numbers and set the interval to 200,000
  scale_y_continuous(labels = scales::comma, 
                     breaks = seq(0, max(f_covid$New_cases), by = 100000)) +
  
  # Customize the colors for the lockdown periods
  scale_color_manual(values = c("First National Lockdown" = "red",
                                "Reinstated Restrictions" = "orange",
                                "Second National Lockdown" = "blue",
                                "Third National Lockdown" = "purple",
                                "Leaving Lockdown" = "green")) +
  
  # Customize theme for better readability
  theme_minimal() +
  theme(legend.position = "right", 
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 8),
        axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels

# Convert the ggplot to an interactive plotly plot
interactive_plot <- ggplotly(static_plot)

# Display the interactive plot
interactive_plot

# Optionally, save the interactive plot as an HTML file
# Change save location to suit you
htmlwidgets::saveWidget(interactive_plot, "C:/Users/Espaw/OneDrive/Documents/UNI/CII2201/project/covid_cases_uk_interactive.html")
