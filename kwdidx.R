library(magrittr)
library(stringr)

"Packages.yaml" %>%
  readLines() %>%
  str_subset('^ *(name|keywords) *:') %>%
  str_replace('^ *name *: *(.*)', '|\\1&') %>%
  str_replace('^ *url *: *(.*)', ' & \\1') %>%
  str_replace('^ *keywords *: *', ' ') %>%
  str_c(collapse="") %>%
  tolower() %>%
  str_replace('^\\|', '') %>%
  str_split('\\|') %>%
  extract2(1) %>%
  str_split('&') %>%
  sapply(function(x)
    if (str_length(x[2] > 0)) sapply(str_split(x[2], ','),
                                     function (y) paste(y, ':', x[1]))) %>%
  unlist() %>%
  str_replace('^ ', '') %>%
  str_subset(' : ') %>%
  str_sort() %>%
  str_split(' : ') ->
kwd
      
"Packages.yaml" %>%
  readLines() %>%
  str_subset('^ *(name|url) *:') %>%
  str_replace('^ *name *: *(.*)', '|\\1&') %>%
  str_replace('^ *url *: *(.*)', ' \\1') %>%
  str_c(collapse="") %>%
  str_replace('^\\|', '') %>%
  str_split('\\|') %>%
  extract2(1) %>%
  str_split('&') %>%
  sapply(function(x)
    if (str_length(x[2] > 0)) sapply(str_split(x[2], ','),
                                     function (y) paste(y, ':', x[1]))) %>%
  unlist() %>%
  str_replace('^ ', '') %>%
  str_subset(' : ') %>%
  str_sort() %>%
  str_split(' : ') %>%
  sapply(function(x) c(x[2], x[1])) ->
tmp

urls <- tmp[2,]
names(urls) <- tmp[1,]

"Packages.yaml" %>%
  readLines() %>%
  str_subset('^ *(name|title) *:') %>%
  str_replace('^ *name *: *(.*)', '|\\1&') %>%
  str_replace('^ *title *: *(.*)', ' \\1') %>%
  str_c(collapse="") %>%
  str_replace('^\\|', '') %>%
  str_split('\\|') %>%
  extract2(1) %>%
  str_split('&') %>%
  sapply(function(x)
    if (str_length(x[2] > 0)) sapply(str_split(x[2], ','),
                                     function (y) paste(y, ':', x[1]))) %>%
  unlist() %>%
  str_replace('^ ', '') %>%
  str_subset(' : ') %>%
  str_sort() %>%
  str_split(' : ') %>%
  sapply(function(x) c(x[2], x[1])) ->
tmp

titles <- tmp[2,]
names(titles) <- tmp[1,]

current <- ""
sep <- ""
pend <- ""

for (k in kwd)
{
  if (k[1] != current)
  {
    current <- k[1]
    cat(sprintf('%s\n<h4 class="shade">%s</h4>\n\n<ul>\n', pend, k[1]))
    sep <- ""
    pend <- "</ul>\n"
  }
  else
  {
    sep <- "\n "
  }
  l1 <- str_sub(k[2], 1, 1)
  cat(sprintf('%s<li><a href="%s">%s</a> %s\n', sep, urls[k[2]], k[2], titles[k[2]]))
}

cat(pend)
