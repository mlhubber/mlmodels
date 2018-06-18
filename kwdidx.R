library(magrittr)
library(stringr)

"Packages.yaml" %>%
  readLines() %>%
  str_subset('^ *(name|keywords) *:') %>%
  str_replace('^ *name *: *(.*)', '|\\1:') %>%
  str_replace('^ *keywords *: *', ' ') %>%
  str_c(collapse="") %>%
  str_replace('^\\|', '') %>%
  str_split('\\|') %>%
  extract2(1) %>%
  str_split(':') %>%
  sapply(function(x)
    if (str_length(x[2] > 0)) sapply(str_split(x[2], ','),
                                     function (y) paste(y, ':', x[1]))) %>%
  unlist() %>%
  str_replace('^ ', '') %>%
  str_subset(' : ') %>%
  str_sort() %>%
  str_split(' : ') ->
kwd
      
current <- ""
sep <- ""
pend <- ""

for (k in kwd)
{
  if (k[1] != current)
  {
    current <- k[1]
    cat(sprintf('%s\n<h2>%s</h2>\n\n<p class="shade">\n', pend, k[1]))
    sep <- ""
    pend <- "</p>\n"
  }
  else
  {
    sep <- ": "
  }
  l1 <- str_sub(k[2], 1, 1)
  cat(sprintf('%s<a href="https://mlhub.ai/pool/main/%s/%s/">%s</a>\n', sep, l1, k[2], k[2]))
}

cat(pend)
