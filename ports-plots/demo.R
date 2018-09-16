########################################################################
# Introduce the concept of telling the data narative through plots
#
# Copyright 2018 Graham.Williams@togaware.com

#-----------------------------------------------------------------------
# Load required packages from local library into the R session.
#-----------------------------------------------------------------------

suppressMessages(
{
  library(directlabels) # Dodging labels for ggplot2.
  library(dplyr)        # Data wrangling.
  library(ggplot2)      # Visualise data.
  library(grid)         # Layout of plots: viewport().
  library(magrittr)     # Use pipelines for data processing.
  library(rattle)       # normVarNames().
  library(readr)        # Modern data reader.
  library(readxl)       # Read Excel spreadsheets.
  library(scales)       # Include commas in numbers.
  library(stringi)      # The string concat operator %s+%.
  library(stringr)      # String manpiulation.
  library(tidyr)        # Tidy the dataset.
})

cat("\n========================================",
    "\nVisualising the Australian Ports Dataset",
    "\n========================================\n\n")

cat("The Australian Ports dataset (http://essentials.togaware.com/ports.xlsx)\n")
cat("is used to illustrate Data Visualisation.\n\n")

cat("These examples come from the book, Essentials of Data Science, by Graham Williams.\n")
cat("Used with permission. Visit https://essentials.togaware.com\n\n")

cat("Press the <Enter> key after each message to display the referenced plot.\n")
cat("Review the plot and discern the story the data it is telling us.\n")
cat("Close the graphic window (Ctrl-W) to continue on to the next plot.\n")

#-----------------------------------------------------------------------
# Prepare the Ports Dataset.
#-----------------------------------------------------------------------

# Local location of the downloaded file.

dspath <- "ports.xlsx"

# Ingest the dataset.

ports <- read_excel(path=dspath, sheet=1, col_names=FALSE)

# Prepare the dataset for usage with our template.

dsname <- "ports"
ds     <- get(dsname)

# Identify specific colors required for the organisaitonal style.

cols <- c('#F6A01A', # Primary Yellow
          '#0065A4', # Primary Blue
          '#455560', # Primary Accent Grey
          '#B2BB1E', # Secondary Green
          '#7581BF', # Secondary Purple
          '#BBB0A3', # Secondary Light Grey
          '#E31B23', # Secondary Red
          '#C1D2E8') # Variant Grey

# Create a ggplot2 theme using these colours.

theme_bitre <- scale_fill_manual(values=cols)

#-----------------------------------------------------------------------
# Compare import and export by weight.
#-----------------------------------------------------------------------

cat("\nShow a faceted dodged bar plot comparing the import and export total weight",
    "\nacross multiple years aggregated over the largest 17 ports and all Australian",
    "\nports, respectively:")
invisible(readChar("stdin", 1))

fname <- "ports_weight.pdf"
pdf(file=fname, width=12)
ds[96:117, 1:4] %>%
  set_names(c("period", "location", "export", "import")) %>%
  mutate(
    export = as.numeric(export),
    import = as.numeric(import),
    period = period[seq(1, 21, 2) %>% rep(2) %>% sort()]
  ) %>%
  gather(type, value, -c(period, location)) %>%
  ggplot(aes(x=location, y=value/1000, fill=type)) +
  geom_bar(stat="identity",position=position_dodge(width = 1)) +
  facet_grid(~period) +
  labs(y="Million tonnes", x="", fill="") +
  theme(axis.text.x=element_text(angle=45, hjust=1, size=10)) +
  theme_bitre
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Data Preparation.
#-----------------------------------------------------------------------

ds[2:4, 2:18] %>% 
  t() %>% 
  data.frame(row.names=NULL, stringsAsFactors=FALSE) %>%
  tbl_df() %>%
  set_names(c("port", "weight", "rate")) %>%
  mutate(
    weight = as.numeric(weight),
    rate   = as.numeric(rate)
  ) %>%
  left_join(ds[7:17, 1:2] %>%
              set_names(ds[6, 1:2]) %>%
              gather(type, port) %>%
              na.omit(), 
            by="port") %>% 
  mutate(type=factor(type, levels=c("Mixed", "Bulk"))) %>%
  filter(port != "Darwin") ->
tds

#-----------------------------------------------------------------------
# Scatter Plot with Insert.
#-----------------------------------------------------------------------

cat("\nShow a labelled scatter plot with an insert: ")
invisible(readChar("stdin", 1))

fname <- "ports_scatter.pdf"
pdf(file=fname, width=8)
tds %>%
  ggplot(aes(x=weight, y=rate)) +
  geom_point(aes(colour=type, shape=type), size=4) +
  xlim(0, 300) + ylim(0, 13) +
  labs(shape="Port Type", 
       colour="Port Type",
       x="Throughput 2011-12 (million tonnes)",
       y="Throughput average annual growth rate") +
  geom_text(data=filter(tds, type=="Bulk"), 
            aes(label=port), vjust=2) +
  annotate("rect", xmin=0, xmax=45, ymin=3, ymax=6.5, 
           alpha = .1) +
  annotate("text", label="See inset", x=28, y=3.3, size=4) +
  theme(legend.position="bottom")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Insert.
#-----------------------------------------------------------------------

above <- c("Townsville", "Fremantle")
tds %<>% filter(port != "Darwin" & type == "Mixed")

cat("\nThe insert - a labelled scatter plot: ")
invisible(readChar("stdin", 1))

fname <- "ports_scatter_insert.pdf"
pdf(file=fname, width=8)
tds %>%
  ggplot(aes(x=weight, y=rate, label=port)) +
  geom_point(aes(colour=type, shape=type), size=4) +
  labs(shape="Port Type", colour="Port Type") +
  xlim(0, 40) + ylim(3, 6) +
  labs(x="Throughput 2011-12 (million tonnes)",
       y="Throughput average annual growth rate") +
  geom_text(data=filter(tds, !port%in%above), vjust= 2.0) +
  geom_text(data=filter(tds,  port%in%above), vjust=-1.0) +
  theme(legend.position="bottom")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Faceted Plot.
#-----------------------------------------------------------------------

cat("\nShow a faceted bar plot with an embedded second bar plot: ")
invisible(readChar("stdin", 1))

# Build the main faceted plot.

ds[20:36, 1:13] %>%
  set_names(c("port", ds[19, 2:13])) %>% 
  gather(period, calls, -port) %>%
  mutate(calls=as.integer(calls)) %>%
  ggplot(aes(x=period, y=calls)) +
  geom_bar(stat="identity", position="dodge", fill="#6AADD6") +
  facet_wrap(~port) +
  labs(x="", y="Number of Calls") +
  theme(axis.text.x=element_text(angle=90, hjust=1, size=8)) +
  scale_y_continuous(labels=comma) ->
p1

# Generate the second plot.

ds[20:36, 1:13] %>%
  set_names(c("port", ds[19, 2:13])) %>%
  select(port, 2, 13) %>%
  set_names(c('port', 'start', 'end')) %>%
  mutate(
    start = as.integer(start),
    end   = as.integer(end),
    avg   = 100*(exp(log(end/start)/11)-1)
  ) %>%
  ggplot(aes(x=port, y=avg)) +
  geom_bar(stat="identity", 
           position="identity", 
           fill="#6AADD6") +
  theme(axis.text.x=element_text(angle=45, hjust=1, size=6), 
        axis.text.y=element_text(size=8), 
        axis.title=element_text(size=10),
        plot.title=element_text(size=8),
        plot.background = element_blank()) +
  labs(x="", 
       y="Per cent",
       title="Average Annual Growth, 2001-02 to 2012-13") ->
p2

fname <- "ports_faceted.pdf"
pdf(file=fname, height=6, width=8)
print(p1)
print(p2, vp=viewport(x=0.72, y=0.11, height=0.28, width=0.54))
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Horizontal Bar Chart
#-----------------------------------------------------------------------

cat("\nShow a horizontal bar chart: ")
invisible(readChar("stdin", 1))

fname <- "ports_horiz_bar_chart.pdf"
pdf(file=fname, height=3, width=8)
ds[48:56, 1:2] %>%
  set_names(c("occupation", "percent")) %>%
  mutate(
    percent    = as.numeric(percent),
    occupation = factor(occupation, 
                        levels=occupation[order(percent)])
  ) %>%
  ggplot(aes(x=occupation, y=percent)) + 
  geom_bar(stat="identity", fill="#6AADD6", width=0.8) + 
  theme(axis.title.x=element_text(size=10)) + 
  labs(x="", y="Per cent") + 
  coord_flip()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Data Preparation.
#-----------------------------------------------------------------------

tds <- 
  ds[39:40, 2:9] %>%
  set_names(ds[38, 2:9]) %>%
  mutate(type=c("Mixed Ports", "Bulk Ports")) %>%
  gather(occupation, percent, -type) %>%
  mutate(
    percent    = as.numeric(percent),
    occupation = factor(occupation,
           levels=c("Managers", 
                    "Professionals", 
                    "Technicians and Trades Workers", 
                    "Community and Personal Service Workers", 
                    "Clerical and Administrative Workers", 
                    "Sales Workers", 
                    "Machinery Operators and Drivers", 
                    "Labourers"))
  )

mv <- 
  tds %>% 
  filter(type=="Mixed Ports") %>% 
  extract2("percent") %>%
  rev()

my <- (mv/2) + c(0, head(cumsum(mv), -1))

bv <- 
  tds %>% 
  filter(type=="Bulk Ports") %>% 
  extract2("percent") %>%
  rev()

by <- (bv/2) + c(0, head(cumsum(bv), -1))

lbls <- 
  data.frame(x=c(rep(1, length(mv)), rep(2, length(bv))),
             y=c(by, my),
             v=round(c(bv, mv)))

#-----------------------------------------------------------------------
# Horizontal Bar Chart with Multiple Stacks.
#-----------------------------------------------------------------------

cat("\nShow a horizontal bar chart with multiple stacks: ")
invisible(readChar("stdin", 1))

fname <- "ports_occ_bar.pdf"
pdf(file=fname, width=8, height=3)
tds %>%
  ggplot(aes(x=type, y=percent, fill=occupation)) +
  geom_bar(stat="identity", width=0.3) +
  labs(x="", y="Per cent", fill="") +
  annotate("text", 
           x=lbls$x, 
           y=lbls$y, 
           label=lbls$v, 
           colour="white") +
  coord_flip() +
  scale_y_reverse() +
  theme_bitre
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Data Preparation.
#-----------------------------------------------------------------------

ds[43:45, 1:3] %>%
  set_names(c("type", ds[42, 2:3])) %>%
  gather(var, count, -type) %>% 
  mutate(
    count = as.integer(count),
    type  = factor(type, 
                   levels=c("Bulk", "Mixed", "Australia"))
  ) ->
tds

lbls <- data.frame(x=c(.7, 1, 1.3, 1.7, 2, 2.3),
                   y=tds$count-3,
                   lbl=round(tds$count))

#-----------------------------------------------------------------------
# Simple Bar Chart
#-----------------------------------------------------------------------

cat("\nShow a simple bar chart with dodged and labelled bars: ")
invisible(readChar("stdin", 1))

fname <- "ports_simple_bar.pdf"
pdf(file=fname, width=7, height=5)
tds %>%
  ggplot(aes(x=var, y=count)) +
  geom_bar(stat="identity", position="dodge", aes(fill=type)) +
  labs(x="", y="Per cent", fill="") + ylim(0, 100) +
  geom_text(data=lbls, 
            aes(x=x, y=y, label=lbl), 
            colour="white") +
  theme_bitre
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Suggest next step.
#-----------------------------------------------------------------------

cat("\nYou may like to view the code for this demo with:\n",
    "\n  $ ml print ports-plots\n\n")
