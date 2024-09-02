## Tip: use Ctrl (or Cmd) + Enter to run the code line by line

## Variable Assignment
a <- 5
a = 5
a
b <- 4
b
c <- a + b
c
test_scores <- c(82, 89, 92, 75, 74, 99)
test_scores

## Functions
mean(x = c(3, 7, 11, 12, 14, 15))
mean(c(3, 7, 11, 12, 14, 15, NA))
mean(c(3, 7, 11, 12, 14, 15, NA), na.rm = TRUE)
mean(na.rm = TRUE)


## Types - numbers
n <- 2.5
class(n)

int <- as.integer(2)
class(int)
class(-1 + 3i)

## Types - characters
greetings <- "hello world"
class(greetings)

my_enthusiasm <- 'I\'m loving R!'
my_enthusiasm

## Types - logical
class(TRUE)
cond <- 1 > 2
cond
class(cond)

## Types - dates
d <- as.Date("2024/09/07")
d
class(d)
as.Date("09/07/2024")
as.Date("09/07/2024", format = "%m/%d/%Y")

# Types - factors
m <- c("Dec", "Apr", "Jan", "Mar")
sort(m)

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

m <- factor(m, levels = month_levels)
sort(m)


# Structures - vectors
temps <- c(94, 83, 79, 55, 65)
temps

groceries <- c("apples", "carrots", "ice cream", "hot sauce")
groceries

conds <- c(TRUE, TRUE, FALSE, FALSE)
conds

c(1, 2, TRUE)
c("A", "B", TRUE)


## Subsetting vectors
groceries <- c("apples", "carrots", "ice cream", "hot sauce")
groceries[2]
groceries[-2]
groceries[c(1, 2, 3)]
groceries[1:3]


## Structures - lists
l1 <- list("A", 1, TRUE)
l1
l2 <- list(c(1, 2, 3, 4, 5), c("a", "b", "c"), c(TRUE, TRUE))
l2

## Structures - matrices
m1 <- matrix(
  c(43, 43, 65, 76, 87, 34),
  nrow = 3,
  ncol = 2
)
m1

m2 <- matrix(
  c(TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE),
  nrow = 2,
  ncol = 4
)
m2

## Structures - data frames
df <- data.frame(
  x = c(1, 2, 3),
  y = c(5, 6, 7),
  z = c("a", "b", "c")
)
df


library(tidyverse)
df <- tibble(
  x = c(1, 2, 3),
  z = c("a", "b", "c"),
  f = c(TRUE, FALSE, TRUE)
)
df


## Subsetting data frames
df$x
sum(df$x)
df$z[1]
df$z[c(1, 3)]
df[1,1]
df[2, 1:3]


## Vectorization
x <- 1:5
x + 1
x < 4
x == 4

x[x < 4]

temps_f <- c(94, 83, 79, 71, 72)
temps_c <- (temps_f - 32)*5/9
temps_c


## Practice Using Functions!
temps <- c(71, 91, 77, 81, 91, 91, 68, 66, 88, 82, 85, 76, 83, 91, 81, 77, 89, 68)
min(temps)
max(temps)
median(temps)
range(temps)
sd(temps)
sum(temps)
length(temps)
sum(temps > 90)
mean(temps > 90)

## Reading Data
library(readr)
penguins <- read_csv("data/penguins.csv")

# library(readxl)
# penguins <- read_xlsx("data/penguins.xlsx")
# penguins <- read_rds("data/penguins.rds")


## Reading from DataSF
library(RSocrata)
crashes <- read.socrata("https://data.sfgov.org/resource/dau3-4s8f.csv")
# crashes <- read_csv("https://data.sfgov.org/resource/dau3-4s8f.csv")
glimpse(crashes)


## select()
library(tidyverse)

select(penguins, species, island, sex, body_mass_g)

select(penguins, 1:4)

select(penguins, bill_length_mm:body_mass_g)

## arrange()
arrange(penguins, bill_length_mm)

arrange(penguins, species)

arrange(penguins, desc(bill_length_mm))

## rename()
rename(penguins, Sex = sex)

rename(penguins, genus = species, isle = island)

## distinct()
distinct(penguins, sex)

distinct(penguins, island)

distinct(penguins, island, species)

## filter()
filter(penguins, sex == "female")

filter(penguins, body_mass_g > 4800)

filter(penguins, sex == "female", body_mass_g >= 4800)


## filter()
filter(penguins, is.na(bill_length_mm))
filter(penguins, !is.na(bill_length_mm))


filter(penguins, island == "Biscoe" | island == "Dream")
filter(penguins, island %in% c("Biscoe", "Dream"))
filter(penguins, !island %in% c("Biscoe", "Dream"))

## filter() with string helpers
library(stringr)

filter(penguins, str_detect(island, "ger"))

filter(penguins, str_length(species) == 6)


## mutate()
mutate(penguins, body_mass_lb = body_mass_g/453.6)

usa_penguins <- mutate(
  penguins,
  body_mass_lb = body_mass_g/453.6,
  flipper_length_in = flipper_length_mm/25.4
)

select(usa_penguins, species, body_mass_lb, flipper_length_in)


## mutate() with helpers
mutate(penguins, body_mass_g = if_else(island == "Biscoe", body_mass_g - 50, body_mass_g))

new_measurements <- mutate(penguins, new_body_mass_g = case_when(
  island == "Biscoe" ~ body_mass_g - 50,
  island == "Dream" ~ body_mass_g - 75,
  island == "Torgersen" ~ body_mass_g - 100
)
)
select(new_measurements, island, body_mass_g, new_body_mass_g)


## mutate() with string helpers
penguins_with_ids <- mutate(penguins, id = paste(island, species, sex, year, sep = "-"))
select(penguins_with_ids, island, species, sex, year, id)

mutate(penguins, sex = str_sub(sex, start = 1, end = 1))

mutate(penguins, sex = str_to_title(sex))

## count()
count(penguins, sex)

count(penguins, species)

count(penguins, sex, species, sort = TRUE)

## count()
count(penguins, island, name = "n_island_dwellers")

count(penguins, island == "Biscoe")

count(penguins, body_mass_g < 3000)


## summarize()
summarize(penguins, mean_flipper_length = mean(flipper_length_mm))

summarize(
  penguins,
  mean_flipper_length = mean(flipper_length_mm, na.rm = TRUE),
  mean_body_mass = mean(body_mass_g, na.rm = TRUE),
  mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
)

## group_by()
penguins_grouped_by_sex <- group_by(penguins, sex)
penguins_grouped_by_sex
summarize(penguins_grouped_by_sex, mean_body_mass = mean(body_mass_g, na.rm = TRUE))

penguins_grouped_by_sex_and_species <- group_by(penguins, sex, species)
penguins_grouped_by_sex_and_species
summarize(penguins_grouped_by_sex_and_species, mean_body_mass = mean(body_mass_g, na.rm = TRUE))

summarize(penguins, mean_body_mass = mean(body_mass_g, na.rm = TRUE), .by = sex)


## The Pipe
penguins %>%
  filter(body_mass_g > 4000) %>%
  group_by(sex) %>%
  summarize(mean_body_mass = mean(body_mass_g, na.rm = TRUE)) %>%
  arrange(desc(mean_body_mass))

penguins %>% count(species)

## Practice using tidyverse functions!
air_traffic <- read.socrata("https://data.sfgov.org/resource/rkru-6vcg.csv")

# How many passengers deplaned from airlines with 'China' in their name?
air_traffic %>%
  filter(
    str_detect(operating_airline, "China"),
    activity_type_code == "Deplaned"
    ) %>%
  group_by(operating_airline) %>%
  summarize(passengers = sum(passenger_count)) %>%
  arrange(desc(passengers))

# How many flights for each operating airline in 2020?
air_traffic %>%
  filter(
    activity_period_start_date >= as.Date("2020-01-01") &
      activity_period_start_date <= as.Date("2020-12-31")
    ) %>%
  count(operating_airline, sort = TRUE, name = "flights") %>%
  head()


## left_join()
df1 <- tibble(x = 1:3)
df2 <- tibble(x = c(1, 2), y = c("first", "second"))
df1
df2
left_join(df1, df2, by = "x") # or df1 %>% left_join(df2, join_by(x))

## left_join() (multiple matches)
df1 <- tibble(id = 1:3)
df2 <- tibble(code = c(1, 1, 2), y = c("first", "second", "third"))
df1
df2
df1 %>% left_join(df2, join_by(id == code))

## inner_join()
x <- tibble(c1 = 1:3, c2 = c("x1", "x2", "x3"))
y <- tibble(c1 = c(1, 2, 4), c3 = c("y1", "y2", "y4"))
inner_join(x, y, by = join_by(c1))

## bind_rows()
penguins_2007 <- penguins %>% filter(year == 2007)
penguins_2008 <- penguins %>% filter(year == 2008)
nrow(penguins_2007)
nrow(penguins_2008)

all_penguins <- bind_rows(penguins_2007, penguins_2008)
all_penguins


## Practice joining data!
flights <- read_rds("data/flights.rds")
airlines <- read_rds("data/airlines.rds")
planes <- read_rds("data/planes.rds")
airports <- read_rds("data/airports.rds")

left_join(flights, airlines, by = join_by(carrier))

flights %>%
  left_join(airports, join_by(dest == faa)) %>%
  select(year, month, day, origin, dest, tzone)

flights %>%
  inner_join(planes, join_by(tailnum)) %>%
  select(flight, month, day, type, engine)

## pivot_longer()
relig_income <- read_rds("data/relig_income.rds")
glimpse(relig_income)
relig_income %>%
  pivot_longer(
    cols = 2:11,
    names_to = "income",
    values_to = "count"
  )

## pivot_wider()
penguins %>%
  count(island, species) %>%
  pivot_wider(
    names_from = species,
    values_from = n
  )

## Writing Data
adelie_males_on_torgersen_in_2007 <- penguins %>%
  filter(
    species == "Adelie",
    sex == "male",
    island == "Torgersen",
    year == "2007"
  ) %>%
  select(bill_length_mm:body_mass_g)

write_csv(adelie_males_on_torgersen_in_2007, "data/adelie_males_on_torgersen_in_2007.csv")
write_rds(adelie_males_on_torgersen_in_2007, "data/adelie_males_on_torgersen_in_2007.rds")

library(writexl)
write_xlsx(adelie_males_on_torgersen_in_2007, "data/adelie_males_on_torgersen_in_2007.xlsx")

## ggplot2
ggplot(data = penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(outliers = FALSE) +
  geom_jitter(width = 0.1, alpha = 0.3) +
  labs(x = "Species", y = "Body Mass (grams)", title = "Penguin Body Mass by Species") +
  theme_classic() +
  theme(legend.position = "none")


## gt
library(gt)

penguins %>%
  group_by(island, species, sex) %>%
  summarize(mean_body_mass = mean(body_mass_g, na.rm = TRUE)) %>%
  ungroup() %>%
  drop_na(sex) %>%
  pivot_wider(
    names_from = sex,
    values_from = mean_body_mass
  ) %>%
  mutate(island = paste("On", island, "island")) %>%
  rename(
    Island = island,
    Species = species,
    Female = female,
    Male = male
  ) %>%
  gt(groupname_col = "Island", rowname_col = "Species") %>%
  tab_style(
    style = list(
      cell_text(align = "right")
    ),
    locations = cells_stub(rows = TRUE)
  ) %>%
  tab_header(
    title = "Penguin Body Mass (grams)",
    subtitle = "Adult foraging penguins near Palmer Station"
  )

