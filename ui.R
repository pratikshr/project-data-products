# User interface for Shiny application Car Analysis
# This application does anlaysis of mtcars dataset in R (courtesy Motor Trend)
# The application lets you select a car filtered with Weight restrictions and Engine Capacity
# Result shows how the car you selected stands in comparison with other cars with same criteria

# Load shiny library and data - mtcars

library(shiny)
data(mtcars)

# A simple shiny template for UI with pagewithSidebar, a sidebarPanel with 3 inputs
# Input 1: Slide to restrict the maximum weight in units of 1000lbs
# Input 2: Slide to restrict the maximum engine capacity in cubic inches
# Input 3: List of cars that satisfy the filtering criteria from Input 1 & 2
# Output produces a grid of plots which compares data with text at bottom with explanation

shinyUI(
        pageWithSidebar(
                headerPanel(""),
                sidebarPanel(
                        h2('select your car'),
                        p('---------------------------------------------'),
                        p('slide to select weight of cars'),
                        sliderInput('wt', 'Car Weight in 1000 lbs', min(mtcars$wt), max(mtcars$wt), c(min(mtcars$wt),max(mtcars$wt))),
                        p('---------------------------------------------'),
                        p('slide to select engine size of cars'),
                        sliderInput('disp', 'Car Engine size in Cu.In.', min(mtcars$disp), max(mtcars$disp), c(min(mtcars$disp),max(mtcars$disp))),
                        p('---------------------------------------------'),
                        p('select your car from dropdown list'),
                        uiOutput("carslist"),
                        p('---------------------------------------------'),
                        strong('Notes'),
                        p('User interface above will help you select
               the car based on filtering selection for weight
               and engine size.'),
                        p('Filtering weight and engine size also eliminates
               data in plot that do not fit your criteria.'),
                        p('Selected car is shown to compare against others')
                ),
                mainPanel(
                        h1('MotorTrend Car Data Analysis'),
                        p('This data product analyzes mtcars dataset in R comparing miles per gallon and speed of selected car.'),
                        p('The graphs below show where selected car stands in comparison of other cars.'), 
                        plotOutput("mtplot",height="100%"),
                        h2('Conclusion'),
                        textOutput("cartext2"),
                        textOutput("cartext3")
                )
        )
)