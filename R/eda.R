# Load packages
library(RSocrata)
library(lubridate)
library(stringr)
library(tidyverse)

# Import data
incidents_raw <- read.socrata("https://data.sfgov.org/resource/wg3w-h783.csv")
glimpse(incidents_raw)

# Clean data
incidents <- incidents_raw %>%
  mutate(
    # 'True' NAs
    analysis_neighborhood = if_else(
      analysis_neighborhood %in% c("", "null"), NA, analysis_neighborhood
      ),
    # 'True' TRUE/FALSE
    filed_online = filed_online == "true",
    # Empty strings to NA
    incident_category = if_else(incident_category == "", NA, incident_category)
    ) %>%
  select(-c(supervisor_district_2012:point))

# Count stuff!
incidents %>% count(analysis_neighborhood, sort = TRUE)
incidents %>% count(incident_category, sort = TRUE)
incidents %>% count(incident_day_of_week, sort = TRUE)
incidents %>% count(incident_year)

incidents %>%
  summarize(
    earliest_incident = min(incident_date),
    latest_incident = max(incident_date)
  )

# Isolate incidents on Market
incidents_on_market <- incidents %>%
  filter(str_detect(intersection, "MARKET"))

# Look at incidents on Market over time
# Expand the plot in RStudio (Zoom)
incidents_on_market %>%
  count(incident_date) %>%
  ggplot(aes(x = incident_date, y = n)) +
  geom_line(color = "steelblue") +
  scale_x_datetime(date_labels = "%b %Y", date_breaks = "9 months") +
  labs(
    x = NULL,
    y = NULL,
    title = "Police Incidents on Market",
    subtitle = "2018-2024"
  ) +
  theme_minimal()

# When were those spikes?
incidents_on_market %>%
  count(incident_date, sort = TRUE) %>%
  head()

# Looks like most were 'Larceny Theft' during the last weekend in June
# Question: how does incidents of Larceny Theft compare to the weekends before and after?
is_second_to_last_weekend_of_june <- function(x) {
  is_june <- month(x) == 6
  is_weekend <- wday(x) %in% c(7, 1)
  last_day_of_month <- ceiling_date(x, "month") - days(1)
  is_in_last_14_days_of_month <- between(mday(last_day_of_month) - mday(x), 7, 14)
  return(is_june & is_weekend & is_in_last_14_days_of_month)
}

is_last_weekend_of_june <- function(x) {
  is_june <- month(x) == 6
  is_weekend <- wday(x) %in% c(7, 1)
  last_day_of_month <- ceiling_date(x, "month") - days(1)
  is_in_last_7_days_of_month <- mday(last_day_of_month) - mday(x) < 7
  return(is_june & is_weekend & is_in_last_7_days_of_month)
}

is_first_weekend_of_july <- function(x) {
  is_july <- month(x) == 7
  is_weekend <- wday(x) %in% c(7, 1)
  first_day_of_month <- floor_date(x, "month")
  is_in_first_7_days_of_month <- mday(x) < 7
  return(is_july & is_weekend & is_in_first_7_days_of_month)
}

plot_data <- incidents_on_market %>%
  mutate(
    weekend = case_when(
      is_second_to_last_weekend_of_june(incident_date) ~ "Second to last weekend in June",
      is_last_weekend_of_june(incident_date) ~ "Last weekend in June",
      is_first_weekend_of_july(incident_date) ~ "First weekend in July",
      .default = "Outside scope"
      )
    ) %>%
  # Factor weekend variable 'in order'
  mutate(
    weekend = factor(
      weekend,
      levels = c("Second to last weekend in June", "Last weekend in June", "First weekend in July")
    )
  ) %>%
  filter(
    weekend != "Outside scope",
    incident_category == "Larceny Theft"
    )

plot_data %>%
  count(weekend) %>%
  ggplot(aes(x = weekend, y = n)) +
  geom_col(fill = "steelblue", color = "black") +
  geom_label(aes(label = n)) +
  labs(
    x = NULL,
    y = NULL,
    title = "Incidents of Larceny Theft on Market Street",
    subtitle = "2018-2024"
  ) +
  theme_minimal()

# Same plot but 'faceted' by year
# Remove 'COVID' years
# Pattern only starts in 2019 and disappears in 2024?
plot_data %>%
  filter(!incident_year %in% 2020:2021) %>%
  count(incident_year, weekend) %>%
  ggplot(aes(x = weekend, y = n)) +
  geom_col(fill = "steelblue", color = "black") +
  geom_label(aes(label = n)) +
  facet_wrap(~incident_year, ncol = 1) +
  labs(
    x = NULL,
    y = NULL,
    title = "Incidents of Larceny Theft on Market Street",
    subtitle = "2018-2024"
  ) +
  theme_minimal()


# ggsave saves the last plot made
# ggsave("figures/Incidents of Larceny Theft on Market.png", bg = "white")

# Write cleaned, filtered data to rds
write_rds(incidents_on_market, "data/incidents_on_market.rds")
