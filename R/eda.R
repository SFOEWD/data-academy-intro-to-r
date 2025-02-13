# Load packages
library(RSocrata)
library(lubridate)
library(stringr)
library(tidyverse)

# Import data
# incidents_raw <- read.socrata("https://data.sfgov.org/resource/wg3w-h783.csv")
incidents_raw <- read_rds("data/incidents_raw.rds")
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
    incident_category = if_else(incident_category == "", NA, incident_category),
    # Harmonize labels
    incident_category = case_match(
      incident_category,
      "Weapons Offence" ~ "Weapons Offense",
      "Motor Vehicle Theft?" ~ "Motor Vehicle Theft",
      .default = incident_category
      )
    ) %>%
  select(-c(supervisor_district_2012:point))

# The utility of true logicals
incidents %>% filter(filed_online)

incidents %>%
  group_by(incident_year) %>%
  summarize(perc_filed_online = mean(filed_online))

incidents %>%
  mutate(is_weekend = wday(incident_date) %in% 6:7) %>%
  summarize(perc_weekend = mean(is_weekend))

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
bin_weekends <- function(x) {
  month <- month(x)
  mday <- mday(x)
  is_weekend <- wday(x) %in% c(7, 1)
  last_day_of_month <- ceiling_date(x, "month") - days(1)
  days_from_last_mday <- mday(last_day_of_month) - mday
  out <- case_when(
    month == 6 & is_weekend & between(days_from_last_mday, 7, 14) ~ "Second to last weekend in June",
    month == 6 & is_weekend & between(days_from_last_mday, 0, 6) ~ "Last weekend in June",
    month == 7 & is_weekend & mday < 7 ~ "First weekend in July",
    .default = "Outside scope"
  )
  return(out)
}

plot_data <- incidents_on_market %>%
  mutate(weekend = bin_weekends(incident_date)) %>%
  filter(
    weekend != "Outside scope",
    incident_category == "Larceny Theft"
  ) %>%
  # Factor weekend variable 'in order'
  mutate(
    weekend = factor(
      weekend,
      levels = c("Second to last weekend in June", "Last weekend in June", "First weekend in July")
    )
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
