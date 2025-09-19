# SPOILERS (solutions below)

# 1. Make a scatter plot with flipper length and body mass. Color points by species
ggplot(penguins, aes(flipper_length_mm, body_mass_g, color = species)) +
  geom_point()

# 2. Add the line of best fit to the plot.
ggplot(penguins, aes(flipper_length_mm, body_mass_g, color = species)) +
  geom_point() +
  geom_smooth(method = "lm")

# 3. Add a title and custom x and y axis labels to the plot.
ggplot(penguins, aes(flipper_length_mm, body_mass_g, color = species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(
    title = "Longer Flipper = More Penguin Mass",
    x = "Flipper Length",
    y = "Body Mass (g)"
  )

# 4. Facet the plot by sex. How might you get rid of the third panel?

# 5. Make a boxplot of body mass for each island. Fill the color of each
# boxplot by island.
ggplot(penguins, aes(island, body_mass_g, fill = island)) +
  geom_boxplot()

# 6. Add the jittered points on top of each box plot. Adjust both the width
# of the points and the opacity (alpha).
ggplot(penguins, aes(island, body_mass_g, fill = island)) +
  geom_boxplot() +
  geom_jitter(width = 0.2, alpha = 0.2)

# 7. Make a bar chart of the penguins by island. Fill all the bars 'firebrick' and
# use a custom theme.
ggplot(penguins, aes(island)) +
  geom_bar(fill = "firebrick") +
  theme_minimal()

# 8. *Extreme Challenge:* add the count numbers on top of each bar. Hint:
# You probably want to use count() beforehand and then geom_col() and then
# geom_label or geom_text()
penguins |>
  count(island) |>
  ggplot(aes(island, n)) +
  geom_col(fill = "firebrick") +
  geom_label(aes(label = n)) +
  theme_minimal()


