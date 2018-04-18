# These support functions come from the rattle package. Include them
# locally to avoid having to install RGtk2.

errorMatrix <- function (actual, predicted, percentage = TRUE, digits = ifelse(percentage, 
    1, 3), count = FALSE) 
{
    if (!missing(percentage) & percentage & count) 
        stop("percentages not possible as counts were specified")
    if (is.factor(actual) & is.factor(predicted)) {
        if (!all(levels(actual) == levels(predicted))) 
            stop("The supplied actual and predicted must have the same levels.")
    }
    else if (is.factor(actual)) {
        predicted <- factor(predicted, levels = levels(actual))
    }
    else if (is.factor(predicted)) {
        actual <- factor(actual, levels = levels(predicted))
    }
    x <- table(actual, predicted)
    nc <- nrow(x)
    nv <- length(actual) - sum(is.na(actual) | is.na(predicted))
    if (!count) 
        x <- x/nv
    tbl <- cbind(x, Error = sapply(1:nc, function(r) {
        y <- sum(x[r, -r])/sum(x[r, ])
        if (count) 
            y <- round(100 * y, digits)
        return(y)
    }))
    names(attr(tbl, "dimnames")) <- c("Actual", "Predicted")
    if (!count) 
        tbl <- if (percentage) 
            round(100 * tbl, digits)
        else round(tbl, digits)
    return(tbl)
}

fancyRpartPlot <- function (model, main = "", sub, caption, palettes, type = 2, 
    ...) 
{
    if (!inherits(model, "rpart")) 
        stop("The model object must be an rpart object. ", "Instead we found: ", 
            paste(class(model), collapse = ", "), ".")
    if (missing(sub) & missing(caption)) {
        sub <- paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), 
            Sys.info()["user"])
    }
    else {
        if (missing(sub)) 
            sub <- caption
    }
    num.classes <- length(attr(model, "ylevels"))
    default.palettes <- c("Greens", "Blues", "Oranges", "Purples", 
        "Reds", "Greys")
    if (missing(palettes)) 
        palettes <- default.palettes
    missed <- setdiff(1:6, seq(length(palettes)))
    palettes <- c(palettes, default.palettes[missed])
    numpals <- 6
    palsize <- 5
    pals <- c(RColorBrewer::brewer.pal(9, palettes[1])[1:5], 
        RColorBrewer::brewer.pal(9, palettes[2])[1:5], RColorBrewer::brewer.pal(9, 
            palettes[3])[1:5], RColorBrewer::brewer.pal(9, palettes[4])[1:5], 
        RColorBrewer::brewer.pal(9, palettes[5])[1:5], RColorBrewer::brewer.pal(9, 
            palettes[6])[1:5])
    if (model$method == "class") {
        yval2per <- -(1:num.classes) - 1
        per <- apply(model$frame$yval2[, yval2per], 1, function(x) x[1 + 
            x[1]])
    }
    else {
        per <- model$frame$yval/max(model$frame$yval)
    }
    per <- as.numeric(per)
    if (model$method == "class") 
        col.index <- ((palsize * (model$frame$yval - 1) + trunc(pmin(1 + 
            (per * palsize), palsize)))%%(numpals * palsize))
    else col.index <- round(per * (palsize - 1)) + 1
    col.index <- abs(col.index)
    if (model$method == "class") 
        extra <- 104
    else extra <- 101
    rpart.plot::prp(model, type = type, extra = extra, box.col = pals[col.index], 
        nn = TRUE, varlen = 0, faclen = 0, shadow.col = "grey", 
        fallen.leaves = TRUE, branch.lty = 3, ...)
    title(main = main, sub = sub)
}

normVarNames <- function (vars, sep = "_") 
{
    if (sep == ".") 
        sep <- "\\."
    pat <- "_| |•| |,|-|:|/|&|\\.|\\?|\\[|\\]|\\{|\\}|\\(|\\)"
    rep <- sep
    vars <- gsub(pat, rep, vars)
    vars <- gsub("’", "", vars)
    vars <- gsub("'", "", vars)
    pat <- "(?<!\\p{Lu})(\\p{Lu})(\\p{Lu}*)"
    rep <- "\\1\\L\\2"
    vars <- gsub(pat, rep, vars, perl = TRUE)
    pat <- "(?<!^)(\\p{Lu})"
    rep <- paste0(sep, "\\L\\1")
    vars <- gsub(pat, rep, vars, perl = TRUE)
    pat <- paste0("(?<![", sep, "\\p{N}])(\\p{N}+)")
    rep <- paste0(sep, "\\1")
    vars <- gsub(pat, rep, vars, perl = TRUE)
    vars <- gsub("\\t", "", vars)
    vars <- gsub("^_+", "", vars)
    vars <- gsub("_+$", "", vars)
    vars <- gsub("__+", "_", vars)
    vars <- tolower(vars)
    pat <- paste0(sep, "+")
    rep <- sep
    vars <- gsub(pat, rep, vars)
    vars <- gsub("^([0-9])", "n_\\1", vars)
    return(vars)
}
