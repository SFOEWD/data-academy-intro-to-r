# The absolute minimum amount of things you need to know about ggplot2
# adapted from 'ggplot2: Elegant Graphics for Data Analysis (3e)

library(tidyverse)

# the mpg dataset
glimpse(mpg)
# `cty` and `hwy` record miles per gallon (mpg) for city and highway driving.
# `displ` is the engine displacement in litres.
# `drv` is the drivetrain: front wheel (f), rear wheel (r) or four wheel (4).
# `model` is the model of car.
# `class` is a categorical variable describing the "type" of car: two seater, SUV, compact, etc.

# Every ggplot2 plot has three key components:
# 1. data
# 2. aesthetic mappings between variables in the data and visual properties
# 3. geoms (or 'layers')

# aesthetic mappings to memorize:
# ('which variable in the data is the __'?)
# * x
# * y
# * fill
# * color
# * shape
# * size
# * label
# * alpha

# geoms to memorize:
# * geom_point()
# * geom_histogram()
# * geom_density()
# * geom_smooth()
# * geom_bar()
# * geom_col()
# * geom_boxplot()
# * geom_violin()
# * geom_jitter()
# * geom_text()
# * geom_label()

# A simple scatterplot
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()

# data: mpg
# aesthetic mappings: x = displ, y = hwy
# geom: point

# unnamed arguments
ggplot(mpg, aes(displ, hwy)) +
  geom_point()

# including other aesthetic mappings
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point()

ggplot(mpg, aes(displ, hwy, shape = class)) +
  geom_point()

# If you want to set an aesthetic to a fixed value, without scaling it,
# do it **outside** of aes()
ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = "blue"))
ggplot(mpg, aes(displ, hwy)) + geom_point(color = "blue")

# Faceting
# 'facets' create small multiples of your data based on one or more variables
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~class) # ncol/nrow

ggplot(mpg, aes(cty, hwy)) +
  geom_point() +
  facet_grid(year ~ drv)


# Boxplots and jittered points
ggplot(mpg, aes(drv, hwy)) +
  geom_point()

ggplot(mpg, aes(drv, hwy)) +
  geom_jitter()

ggplot(mpg, aes(drv, hwy)) +
  geom_boxplot()

ggplot(mpg, aes(drv, hwy)) +
  geom_violin()

# Which representation of the data do you prefer? Each has strengths and weaknesses.

# Adding other geoms: order matters!
ggplot(mpg, aes(drv, hwy)) +
  geom_boxplot() +
  geom_jitter() # adjust alpha and width

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth()

# `method`, which allows you to choose which type of model is used to fit the smooth curve:
# -   `"loess"`, the default for small n, uses a smooth local regression
# -   `"lm"` fits a linear model, giving the line of best fit.

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(method = "lm")

# Distributions
ggplot(mpg, aes(hwy)) +
  geom_histogram() # adjust binwidth, color, and fill

ggplot(mpg, aes(hwy)) +
  geom_density()

# Bar charts
ggplot(mpg, aes(manufacturer)) +
  geom_bar()

mpg |>
  count(manufacturer) |>
  ggplot(aes(manufacturer, n)) + # flip x/y?
  geom_col()

# Line plots

# ?economics
glimpse(economics)

ggplot(economics, aes(date, uempmed)) +
  geom_line()

# Titles and labs
ggplot(mpg, aes(cty, hwy)) +
  geom_point() +
  labs(
    title = "Miles per Gallon (MPG)",
    subtitle = "Popular models from 1999-2008",
    x = "city driving (mpg)",
    y = "highway driving (mpg)"
  )

# themes
p <- ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()

p + theme_bw()
p + theme_classic()
p + theme_minimal()

# There are really cool custom themes out in the wild
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(
    title = "Miles per Gallon (MPG)",
    subtitle = "Popular models from 1999-2008",
    x = "city driving (mpg)",
    y = "highway driving (mpg)"
  ) +
  pilot::theme_pilot() # must install the pilot package from GitHub

# Saving plots
?ggsave()

# Let's make some plots!
penguins <- read_csv("data/penguins.csv")
glimpse(penguins)

# 1. Make a scatter plot with flipper length and body mass. Color points by species

# 2. Add the line of best fit to the plot.

# 3. Add a title and custom x and y axis labels to the plot.

# 4. Facet the plot by sex. How might you get rid of the third panel?

# 5. Make a boxplot of body mass for each island. Fill the color of each
# boxplot by island.

# 6. Add the jittered points on top of each box plot. Adjust both the width
# of the points and the opacity (alpha)

# 7. Make a bar chart of the penguins by island. Fill all the bars 'firebrick' and
# use a custom theme.

# 8. *Extreme Challenge:* add the count numbers on top of each bar. Hint:
# You probably want to use count() beforehand and then geom_col() and then
# geom_label or geom_text()

# Extra things
# Alternative syntax and inheritance
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point()

# ==

ggplot(mpg) +
  aes(displ, hwy) +
  geom_point()

# ==

ggplot() +
  geom_point(data = mpg, aes(displ, hwy))

# To understand why these are all the same, read the `mapping` and `data`
# parameters in ?geom_point()

# There are awesome ggplot extension packages in the wild
# Installed either from CRAN or GitHub
library(gghighlight)
set.seed(2)
d <- purrr::map_dfr(
  letters,
  ~ data.frame(
    idx = 1:400,
    value = cumsum(runif(400, -1, 1)),
    type = .,
    flag = sample(c(TRUE, FALSE), size = 400, replace = TRUE),
    stringsAsFactors = FALSE
  )
)

ggplot(d) +
  geom_line(aes(idx, value, colour = type)) +
  gghighlight(max(value) > 20)

library(gganimate)
library(gapminder)

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, color = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

library(ggrepel)
set.seed(42)

dat <- mtcars |> filter(wt > 2.75 & wt < 3.45)
dat$car <- rownames(dat)

p <- ggplot(dat, aes(wt, mpg, label = car)) +
  geom_point(color = "red")
p

p1 <- p + geom_text() + labs(title = "geom_text()")
p1

p2 <- p + geom_text_repel() + labs(title = "geom_text_repel()")
p2

library(ggstatsplot)
set.seed(123)

ggbetweenstats(
  data  = iris,
  x     = Species,
  y     = Sepal.Length,
  title = "Distribution of sepal length across Iris species"
)

library(ggtext)
library(glue)

data <- tibble(
  bactname = c("Staphylococcaceae", "Moraxella", "Streptococcus", "Acinetobacter"),
  OTUname = c("OTU 1", "OTU 2", "OTU 3", "OTU 4"),
  value = c(-0.5, 0.5, 2, 3)
)

data %>% mutate(
  color = c("#009E73", "#D55E00", "#0072B2", "#000000"),
  name = glue("<i style='color:{color}'>{bactname}</i> ({OTUname})"),
  name = fct_reorder(name, value)
)  %>%
  ggplot(aes(value, name, fill = color)) +
  geom_col(alpha = 0.5) +
  scale_fill_identity() +
  labs(caption = "Example posted on **stackoverflow.com**<br>(using made-up data)") +
  theme(
    axis.text.y = element_markdown(),
    plot.caption = element_markdown(lineheight = 1.2)
  )

# What to learn next:
# 1. Scales (e.g. scale_*_continuous(), scale_*_manual(), scale_x_*(), etc.)
# 2. theme(...) arguments
