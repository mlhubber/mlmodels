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
library(rattle.data)  # Until rattle is updated on DSVM.
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

cat("The Australian weather dataset from the Rattle package (from R)\n")
cat("is used to illustrate bar charts.\n\n")

cat("These examples come from the book, Essentials of Data Science,\n")
cat("by Graham Williams. Used with permission.\n")
cat("Visit https://essentials.togaware.com for more details.\n\n")

cat("Press the <Enter> key after each message to display the referenced plot.\n")
cat("Close the graphic window (Ctrl-W) to continue on to the next plot.\n\n")

#-----------------------------------------------------------------------
# Prepare the Weather dataset.
#-----------------------------------------------------------------------

cat("Plot a bar chart to show the frequency of wind direction in the dataset: ")
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
  scale_y_continuous(labels=comma) +
  geom_bar()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Incorporate stacked bars.
#-----------------------------------------------------------------------

cat("\nPlot a stacked bar chart to include an extra dimension (variable): ")
invisible(readChar("stdin", 1))

fname <- "weather_bar_stacked.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=wind_dir_3pm, fill=rain_tomorrow)) +
  scale_y_continuous(labels=comma) +
  geom_bar()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Replace stacked bars with dodged bars.
#-----------------------------------------------------------------------

cat("\nPlotting dodged bars in the chart may be more informative: ")
invisible(readChar("stdin", 1))

fname <- "weather_bar_dodged.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=wind_dir_3pm, fill=rain_tomorrow)) +
  scale_y_continuous(labels=comma) +
  geom_bar(position="dodge")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# A carefully crafted bar chart.
#-----------------------------------------------------------------------

cat("\nPlot a more carefully crafted bar chart: ")
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
