library(tidyverse)
library(plotly)
library(threejs)
library(dygraphs)
library(timeSeries)
library(xts)

imdb <- read_csv("https://raw.githubusercontent.com/sventura/315-code-and-datasets/master/data/imdb_test.csv")


function(input, output) {
  
  #  Reactive Data Input (for subsetting on content_ratings)
  dat <- reactive({
    dplyr::filter(imdb, content_rating %in% input$ratings)
  })
  
  ##############################################################################
  ##############################################################################
  ##############################################################################
  #  Traditional Shiny
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  output$sams_plot <- renderPlot({
    
    my_plot <- ggplot(data = dat(), aes(x = imdb_score)) + 
      geom_histogram(aes(y = ..density..),
                     bins = input$n_breaks, color = "black", fill = "red") + 
      labs(
        title = "Distribution of IMDB Score",
        x = "Average IMDB Score (1-10) of Movie"
      ) + theme_bw()
    
    if (input$individual_obs) {
      my_plot <- my_plot + geom_rug()
    }
    
    if (input$density) {
      my_plot <- my_plot + 
        geom_density(color = "blue", adjust = input$bw_adjust)
    }
    
    my_plot
  })
  
  ##############################################################################
  ##############################################################################
  ##############################################################################
  #  Plotly (embedded in Shiny)
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  output$plotly_plot <- renderPlotly({
    
    my_plot <- ggplot(data = imdb, aes(x = budget, y = gross, 
                                       color = content_rating)) + 
      geom_point() + 
      labs(
        title = "Gross Profit vs. IMDB Budget",
        subtitle = "By Content Rating",
        x = "Movie Budget ($)",
        y = "Movie Gross Profit ($)"
      ) + 
      theme_bw()
    
    ggplotly(my_plot)
  })

  
  ##############################################################################
  ##############################################################################
  ##############################################################################
  #  HTML Widgets (embedded in Shiny)
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  output$html_widget1 <- renderScatterplotThree({
    
    z <- seq(-10, 10, 0.01)
    x <- cos(z)
    y <- sin(z)
    scatterplot3js(x,y,z, color=rainbow(length(z)))
  })  
  
  output$dygraph <- renderDygraph({
    lungDeaths <- cbind(mdeaths, fdeaths)
    dygraph(lungDeaths) %>%
      dySeries("mdeaths", label = "Male") %>%
      dySeries("fdeaths", label = "Female") %>%
      dyOptions(stackedGraph = TRUE) %>%
      dyRangeSelector(height = 20)
  })
}

