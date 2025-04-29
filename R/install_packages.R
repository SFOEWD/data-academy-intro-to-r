install.packages(
  c(
    "tidyverse",
    "gt",
    "RSocrata",
    "clipr",
    "writexl"
  )
)

# UPDATE 2025/04/29 - RSocrata was removed from CRAN. It should reappear shortly, but in the meantime, you can install the package via:
install.packages("RSocrata", repos = c("https://chicago.r-universe.dev", "https://cloud.r-project.org"))
