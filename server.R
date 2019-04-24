suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(googleVis))
WrldArea <- read.csv("./WrldArea.csv",sep=";",dec=",")
Wrld <- merge(WrldArea,Population[,2:3],by="Country")
Wrld$Area <- Wrld$Area/10^3
Wrld$Population <- Wrld$Population/10^6

shinyServer(function(input, output) {
    SelCountries <- reactive({
        PopLowLim <- input$SliderPop[1]
        PopHighLim <- input$SliderPop[2]
        if (input$InflateSliderPop) {PopHighLim <- PopHighLim*10}
        AreaLowLim <- input$SliderArea[1]
        AreaHighLim <- input$SliderArea[2]
        if (input$InflateSliderArea) {AreaHighLim <- AreaHighLim*10}
        subset(Wrld,Population>=PopLowLim & Population<=PopHighLim 
               & Area >= AreaLowLim &  Area <= AreaHighLim)
    })

    BrushedCountries <- reactive({
        brushed_data <- brushedPoints(SelCountries(), input$brush1,xvar="Area",yvar="Population")
        if (nrow(brushed_data) < 1) {
            return (SelCountries())
            }
        else {
            PopLowLim <- min(brushed_data$Population)
            PopHighLim <- max(brushed_data$Population)
            AreaLowLim <- min(brushed_data$Area)
            AreaHighLim <- max(brushed_data$Area)
            return(subset(SelCountries(),Population>=PopLowLim & Population<=PopHighLim 
                   & Area >= AreaLowLim &  Area <= AreaHighLim))
        }
    })
    
    AveragePop <- reactive({
        format(mean(BrushedCountries()[,3]),digits=2,nsmall=1)
    })
 
    AverageArea <- reactive({
        format(mean(BrushedCountries()[,2]),digits=2,nsmall=1)
    })
    
    NumberOfCountries <- reactive({
        nrow(BrushedCountries())
    })
    
    output$figures <- renderText({
      paste("The number of selected countries is:",
            strong(NumberOfCountries()),
            ". Average Population is:",
            strong(AveragePop()),
            "Millions, and Average Area is:",
            strong(AverageArea()),
            "Thousand Squared Km"
      )
    })
      
    
    output$plot1 <- renderGvis({
        gvisGeoChart(BrushedCountries(), locationvar = "Country", colorvar = "Population",
                     options = list(width = 600, height=400))
    })
    
    output$plot2 <- renderPlot({
         plot(x=SelCountries()[,2],y=SelCountries()[,3],
             main="Population Density",
             xlab="Area in K-Squared Km",
             ylab="Population in Millions")
    })
    
})
