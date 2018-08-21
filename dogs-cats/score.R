# Load model, predict on a selected image, show on shiny app

# load library

library(keras)
library(magrittr)
library(dplyr)
library(shiny)
library(shinyjs)
library(V8)

jsToggleFS <- 'shinyjs.toggleFullScreen = function() {
    var element = document.documentElement,
      enterFS = element.requestFullscreen || element.msRequestFullscreen || element.mozRequestFullScreen || element.webkitRequestFullscreen,
      exitFS = document.exitFullscreen || document.msExitFullscreen || document.mozCancelFullScreen || document.webkitExitFullscreen;
    if (!document.fullscreenElement && !document.msFullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement) {
      enterFS.call(element);
    } else {
      exitFS.call(document);
    }
  }'

# define UI

ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(text = jsToggleFS),
  
  titlePanel("Dogs vs Cats Image Classification"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("img", "Choose image file",
                accept=c("image/jpeg", "image/png", "image/bmp"))
    ),
    mainPanel(
      HTML('<output id="list"></output>'),
      tags$hr(),
      h3(textOutput("pred"))
    )
  )
)

# define server function

server <- function(input, output){
  
  model <- 
    load_model_hdf5(filepath = "dogs-cats-vgg16-model.hdf5", 
                    custom_objects = NULL, 
                    compile = TRUE)
  model.weights <-
    load_model_weights_hdf5(model,
                            filepath = "dogs-cats-vgg16-model-weights.hdf5")
  
  model %>% compile(
    loss = "binary_crossentropy",
    optimizer = optimizer_rmsprop(lr = 2e-5),
    metrics = c("accuracy"))
  
  showImgJs <- paste(readLines("showImg.js"), collapse="\n")
  shinyjs::runjs(showImgJs)
  
  output$pred <- renderText({
    if(is.null(input$img))
      return("")
    img_name <- input$img$name
    img_path <- input$img$datapath
    img <- paste0(as.character(readBin(img_path, raw(), file.size(img_path))), collapse="")
    
    img_dir <- dirname(dirname(img_path))
    img_datagen <- image_data_generator(rescale = 1/255)
    
    img_generator <- flow_images_from_directory(
      img_dir,
      img_datagen,
      target_size = c(150, 150),
      batch_size = 20,
      class_mode = "binary"
    )
    
    pred_score <- model %>% 
      predict_generator(img_generator, steps = 1)
    pred_class <- ifelse(pred_score > 0.5, "dogs", "cats")
    
    out <- paste("Predicted Class =", as.character(pred_class))
    out
  })
  
}

# define shiny app

app <- shinyApp(ui = ui, server = server)

# run shiny app

runApp(app, launch.browser = TRUE)