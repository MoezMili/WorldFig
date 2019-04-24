library(shiny)
suppressPackageStartupMessages(library(googleVis))

shinyUI(fluidPage(
  
  # Application title
  titlePanel("World Population"),
  helpText("Spot a set of countries depending on Population size and Area. Use the sliders to define your subset limits. Population slider higher limit is restricted to 150 Millions. Area slider higher limit is restricted to 2000 Sq Km. To catch higher values, check the Inflate boxes. You can also brush the countries on the graph. Once you're done, Hit the Submit Botton ! The subset of countries will be spotted on the world map !"),
  
  # Sidebar with a slider input for the params 
  sidebarLayout(
    sidebarPanel(
        sliderInput("SliderPop",
                   "Population Range in Millions:",
                   min = 0,
                   max = 150,
                   value = c(0,150)),
        checkboxInput("InflateSliderPop","Inflate Population Slider Higher Limit by 10: ",value=FALSE),
        sliderInput("SliderArea",
                    "Area in K Squared Km:",
                    min = 0,
                    max = 2000,
                    value = c(0,2000)),
        checkboxInput("InflateSliderArea","Inflate Area Slider Higher Limit by 10: ",value=FALSE),
        plotOutput("plot2", brush = brushOpts(id = "brush1")),
        submitButton("submit")
    ),
    
    # Show World Map Highlighting Countries within selected range
    mainPanel(
        htmlOutput("plot1"),
        htmlOutput("figures")
    )
  )
))
