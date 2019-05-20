library(shiny)
library(ggplot2)
library(dplyr)
library(tools)
tidy_anime <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-04-23/tidy_anime.csv")

ui <- fluidPage(

    # Application title
    titlePanel("Animes"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("y",
                        "Y-axis",
                        choices = c("Score" = "score",
                                    "Rank"="rank", 
                                    "Popularity" = "popularity"),
                        selected = "score"),
            selectInput("x",
                        "x-axis",
                        choices = c("Score" = "score", 
                                    "Rank"="rank", 
                                    "Popularity" = "popularity"),
                        selected = "popularity"),
            checkboxGroupInput(inputId = "selected_type",
                               label = "Select genres:",
                               choices = c("Action", "Adventure", "comedy", "Drama"),
                               selected = "Action"),
            
            textInput(inputId = "plot_title", 
                      label = "Plot title", 
                      placeholder = "Enter text for plot title")
            
        ),
        
        
        
        # Show a plot of the generated distribution
        mainPanel(
           plotOutput(outputId = "scatterplot")
        )
        
     
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    animes_subset <- reactive({
      req(input$selected_type)  
        filter(tidy_anime, genre %in% input$selected_type)
    })
    
    pretty_plot_title <- reactive({ toTitleCase(input$plot_title) })
    
# Scatterplot erstellen
    output$scatterplot <- renderPlot({
        ggplot(data = animes_subset(), 
               aes_string(x = input$x, y = input$y)) +
            geom_point() +
            labs(title = pretty_plot_title())
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
