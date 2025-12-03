# install.packages() is the default function for installing packages
install.packages("pak")
# pak is a package that makes installing packages much faster, safer, and convenient
pak::pkg_install(
  c(
    "tidyverse",
    "gt",
    "writexl",
    "gghighlight",
    "ggtext",
    "ggstatsplot",
    "ggrepel",
    "gapminder",
    "gganimate"
    )
  )
