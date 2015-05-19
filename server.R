# Server R code for data analysis and plotting
# This application does anlaysis of mtcars dataset in R (courtesy Motor Trend)
# The application lets you select a car filtered with Weight restrictions and Engine Capacity
# Result shows how the car you selected stands in comparison with other cars with same criteria

# Load required libraries
library(shiny)
library(ggplot2)
library(gridExtra)

data(mtcars)

shinyServer(function(input, output) {
        # ds functions reactively returns subset of data with filtering criteria selected.
        ds <- reactive({
                subset(mtcars, disp>=input$disp[1] & disp<=input$disp[2] & wt>=input$wt[1] & wt<=input$wt[2])
        })
        # car1 function reactively returns values for a car if it is selected  
        car1 <- reactive({
                validate(
                        need(input$car != "", "Please select a car")
                )
                mtcars[input$car,]
        })
        # Dynamically build list of car names based on selection criteria 
        output$carslist <- renderUI({
                cars <- rownames(ds())
                nbrcars <- length(cars)
                label <- paste("Car list filtered - available (", nbrcars, ")")
                selectInput('car', label, cars)
        }) 
        
        output$mtplot <- renderPlot({
                # Plot mtcars data mpg against wt group by cylinders
                image1 <- ggplot(ds(), aes(x=wt, y=mpg)) + 
                        geom_point(stat="identity", aes(color=factor(cyl))) +
                        geom_point(x=car1()$wt,y=car1()$mpg, shape=13,size=5) +
                        # geom_line(stat="identity", size=3, alpha=0.50, aes(colour=factor(cyl))) +
                        ylab("Miles per gallon") +
                        xlab("Weight of car in 1000lbs") +
                        ggtitle("Mileage chart by Weight")
                # Plot mtcars data mpg against disp group by cylinders
                image2 <- ggplot(ds(), aes(x=disp, y=mpg)) + 
                        geom_point(stat="identity", aes(color=factor(cyl))) +
                        geom_point(x=car1()$disp,y=car1()$mpg, shape=13,size=5) +
                        #geom_line(stat="identity", size=3, alpha=0.50, aes(colour=factor(cyl))) +
                        ylab("Miles per gallon") +
                        xlab("Engine size Cu. In.") +
                        ggtitle("Mileage chart by Engine Size")
                # Plot mtcars data qsec against wt group by cylinders
                image3 <- ggplot(ds(), aes(x=wt, y=qsec)) + 
                        geom_point(stat="identity", aes(color=factor(cyl))) +
                        geom_point(x=car1()$wt,y=car1()$qsec, shape=13,size=5) +
                        #geom_line(stat="identity", size=3, alpha=0.50, aes(colour=factor(cyl))) +
                        ylab("1/4 mile in seconds") +
                        xlab("Weight of car in 1000lbs") +
                        ggtitle("Speed of cars by weight")
                # Plot mtcars data qsec against disp group by cylinders
                image4 <- ggplot(ds(), aes(x=disp, y=qsec)) + 
                        geom_point(stat="identity", aes(color=factor(cyl))) +
                        geom_point(x=car1()$disp,y=car1()$qsec, shape=13,size=5) +
                        #geom_line(stat="identity", size=3, alpha=0.50, aes(colour=factor(cyl))) +
                        ylab("1/4 mile in seconds") +
                        xlab("Engine size Cu. In.") +
                        ggtitle("Speed of cars by engine size")
                # arrange all plots in grid
                grid.arrange(image1,image2,image3,image4,ncol=2)
                # grid.arrange(image1,image2,image3,image4,ncol=1, main=textGrob("Motor Trend Car Data Analysis", 
                # gp = gpar(fontsize = 40, face = "bold", col = "blue")))
        },height=460, width=600)
        # Print information explaining data
        output$cartext2 <- renderPrint({
                cat(input$car)
                cat(" weighs ")
                cat(car1()$wt*1000)
                cat(" lbs with engine capacity ")
                cat(car1()$disp)
                cat(" cubic inches and has ")
                cat(car1()$cyl)
                cat(" cylinders.")
        })
        output$cartext3 <- renderPrint({
                cat(input$car)
                cat(" can go 1/4 mile in ")
                cat(car1()$qsec)
                cat(" seconds and has an economy of ")
                cat(car1()$mpg)
                cat(" miles per gallon.")
        })
        output$ex1 <- renderDataTable(cbind(Model.Name = rownames(mtcars), mtcars), options = list(pageLength = 10))
})