library("ggplot2")

shinyServer(function(input, output) {
  
  
  output$main_plot <- renderPlot({
    
  h <- ggplot(data = faithful) + 
          geom_histogram(aes(x = eruptions, y = ..density..), bins = as.numeric(input$n_breaks)) + 
          labs(x = "Duration (minutes)") + 
          ggtitle("Geyser eruption duration") 
    print(h)
    
    if (input$individual_obs) {
      r <- geom_rug(aes(x = eruptions))
      h <- h + r
      print (h)
    }
    
    if (input$density) {
      d <- geom_density(aes(x = eruptions), col = "blue", adjust = input$bw_adjust)
      h <- h + d
      print (h)
    }

  })
  
  
  output$plotb1 <- renderPlot({
    scat <- ggplot(data = faithful) + 
                geom_point(aes(x = eruptions, y = waiting)) + 
                labs(x = "Eruption Time (minutes)", 
                     y = "Time to Next Eruption (minutes)") + 
                ggtitle("Time to Next Eruption vs. Time of Eruption 
                        for Old Faithful Geyser")
    print(scat)
    
    if (input$show_trend) {
      smooth <- geom_smooth(aes(x = eruptions, y = waiting), se = FALSE)
      scat <- scat + smooth
      print(scat)
    }
  })
  
  
  output$plotb2 <- renderPlot({
    de <- ggplot(data = faithful) + 
      stat_density2d(aes(x = eruptions, y = waiting,
                         fill = ..density..), geom = "tile", contour = F) +
      scale_fill_gradient(low = "white", high = "blue") + 
      ggtitle("Heat Map of Eruption Time and Time Between Eruptions") + 
      labs(x = "Eruption Time (minutes)", y = "Time to Next Eruption (minutes)", 
           fill = "Density")
    
    print(de)
    
    
    if (input$show_points){
      points <-  geom_point(aes(x = eruptions, y = waiting))
      de <- de + points
      print(de)
    }
    
  })
  
})