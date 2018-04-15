library(rattle)
library(rattle.data)
library(magrittr)
library(dplyr)
library(rpart)

data(weatherAUS)

dsname <- "weatherAUS"
ds     <- get(dsname)

names(ds) %<>% normVarNames()

ds %<>% select(-date, -location, -risk_mm)

names(ds)[which(names(ds) == "rain_tomorrow")] <- "target"

model <- rpart(target ~ ., data=ds)

save(model, file="rain-tomorrow.RData")
