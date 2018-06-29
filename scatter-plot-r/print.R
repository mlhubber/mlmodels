library(magrittr)
library(stringr)

txt <- readLines("demo.R")

txt <- txt[!str_detect(txt, '^cat')]
txt <- txt[!str_detect(txt, '^invisible')]
txt <- txt[!str_detect(txt, '^fname')]
txt <- txt[!str_detect(txt, '^pdf')]
txt <- txt[!str_detect(txt, '^system')]
txt <- txt[!str_detect(txt, '^suppress')]
txt <- txt[!str_detect(txt, '^\\{')]
txt <- txt[!str_detect(txt, '^\\}\\)')]
txt <- txt[!str_detect(txt, '^ +"')]
txt <- txt[!str_detect(txt, '^# Suggest next step.')]

msg <- "# This script generated from mlhub.ai:/pool/main/s/scatter-plot-r/\n\n"
paste(txt, collapse="\n") %>% cat(msg, ., "\n")
