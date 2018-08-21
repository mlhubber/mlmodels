########################################################################
# Introduce the concept of bar charts through MLHub
#
# Copyright 2018 Graham.Williams@togaware.com

#-----------------------------------------------------------------------
# Load required packages from local library into the R session.
#-----------------------------------------------------------------------

suppressMessages(
{
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
library(rattle)       # Support: normVarNames(), weatherAUS. 
library(ggplot2)      # Visualise data.
library(dplyr)        # Wrangling: tbl_df(), group_by(), print().
library(randomForest) # Model: randomForest() na.roughfix() for missing data.
library(RColorBrewer) # Choose different colors.
library(scales)       # Include commas in numbers.
library(stringi)      # String concat operator %s+%.
})

cat("\n=====================================",
    "\nIntroducing Bar Charts with R ggplot2",
    "\n=====================================\n\n")

cat("The Australian weather dataset from the Rattle package is used",
    "to illustrate bar charts.\n\n")

cat("These examples come from the book, Essentials of Data Science, by Graham Williams.\n")
cat("Used with permission. Visit https://essentials.togaware.com\n\n")

cat("Press the <Enter> key after each message to display the referenced plot.\n")
cat("Close the graphic window (Ctrl-W) to continue on to the next plot.\n\n")

#-----------------------------------------------------------------------
# Prepare the Weather dataset.
#-----------------------------------------------------------------------

cat("A bar chart showing frequency of wind direction in the dataset: ")
invisible(readChar("stdin", 1))

dsname <- "weatherAUS"
ds     <- get(dsname)

# Cleanup the dataset.

names(ds) %<>% normVarNames()

vars   <- names(ds)
target <- "rain_tomorrow"
vars   <- c(target, vars) %>% unique()
risk   <- "risk_mm"
id     <- c("date", "location")
ignore <- c(risk, id)
vars   <- setdiff(vars, ignore)

ds[vars] %<>% na.roughfix()

#-----------------------------------------------------------------------
# A simple bar chart.
#-----------------------------------------------------------------------

fname <- "weather_bar_basic.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=wind_dir_3pm)) +
  geom_bar()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Incorporate stacked bars.
#-----------------------------------------------------------------------

cat("\nA stacked bar chart can show an extra dimension (variable): ")
invisible(readChar("stdin", 1))

fname <- "weather_bar_stacked.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=wind_dir_3pm, fill=rain_tomorrow)) +
  geom_bar()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Replace stacked bars with dodged bars.
#-----------------------------------------------------------------------

cat("\nDodged bars in the chart may be more informative: ")
invisible(readChar("stdin", 1))

fname <- "weather_bar_dodged.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=wind_dir_3pm, fill=rain_tomorrow)) +
  geom_bar(position="dodge")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# A carefully crafted bar chart.
#-----------------------------------------------------------------------

cat("\nA more carefully crafted bar chart: ")
invisible(readChar("stdin", 1))

blues2 <- brewer.pal(4, "Paired")[1:2]

ds$location %>%
  unique() %>%
  length() ->
num_locations

fname <- "weather_bar_informative.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=wind_dir_3pm, fill=rain_tomorrow)) +
  geom_bar(position="dodge") +
  scale_fill_manual(values = blues2,
                    labels = c("No Rain", "Rain")) +
  scale_y_continuous(labels=comma) +
  theme(legend.position   = c(.85, .95),
        legend.direction  = "horizontal",
        legend.title      = element_text(colour="grey40"),
        legend.text       = element_text(colour="grey40"),
        legend.background = element_rect(fill="transparent")) +
  labs(title    = "Rain Expected by Wind Direction at 3pm",
       subtitle = "Observations from " %s+% num_locations %s+% " weather stations",
       caption  = "Source: Australian Bureau of Meteorology", 
       x        = "Wind Direction 3pm",
       y        = "Number of Days",
       fill     = "Tomorrow")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Suggest next step.
#-----------------------------------------------------------------------

cat("\nYou may like to view the code for this demo with:\n",
    "\n  $ ml print barchart\n\n")
