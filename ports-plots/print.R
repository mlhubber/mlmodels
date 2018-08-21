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
txt <- txt[!str_detect(txt, '^ +"\\\\n')]       # Remove trace statements.
txt <- txt[!str_detect(txt, '^# Suggest next step.')]

model <- basename(getwd())
msg <- sprintf("#\n# This script generated from mlhub.ai:/pool/main/%s/%s/",
               str_sub(model, 1, 1), model)

ins <- str_detect(txt, '# Copyright') %>% which()
if (length(ins) == 1) txt %<>% append(msg, after=ins)

# Remove duplicate empty lines.

dup <- c()
for (l in 2:length(txt))
{
  if (txt[l] == "" && txt[l-1] == "") dup <- c(dup, l)
}
txt <- txt[-dup]

# Remove duplicate comment separators as is usual at end of file with
# the Next Action comment that gets removed.

dup <- c()
for (l in 2:length(txt))
{
  if (str_detect(txt[l], "^#----") && str_detect(txt[l-1], "^#----")) dup <- c(dup, l)
}
txt <- txt[-dup]

paste(txt, collapse="\n") %>% cat()

