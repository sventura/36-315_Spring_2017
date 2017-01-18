library("shinydashboard")

shinyUI(bootstrapPage(
  
  dashboardPage(
    
    dashboardHeader(title = "Example Solutions"),
    
    dashboardSidebar( 
      sidebarMenu(
          menuItem("Part (a)", tabName = "parta", icon = icon("cog")), 
          menuItem("Part (b)", tabName = "partb1", icon = icon("cog")))),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "parta",
            selectInput(inputId = "n_breaks",
                        label = "Number of bins in histogram (approximate):",
                        choices = c(10, 20, 35, 50),
                        selected = 20),
            
            checkboxInput(inputId = "individual_obs",
                          label = strong("Show individual observations"),
                          value = FALSE),
            
            checkboxInput(inputId = "density",
                          label = strong("Show density estimate"),
                          value = FALSE),
            
            plotOutput(outputId = "main_plot", height = "500px"),
            
            # Display this only if the density is shown
            conditionalPanel(condition = "input.density == true",
                             sliderInput(inputId = "bw_adjust",
                                         label = "Bandwidth adjustment:",
                                         min = 0.2, max = 2, value = 1, step = 0.2))
        ), 

        
        tabItem(tabName = "partb1", 
                tabsetPanel(tabPanel("Scatterplot", 
                                     checkboxInput(inputId = "show_trend", 
                                         label = "Show Trendline", 
                                         value = FALSE), 
                                     plotOutput(outputId = "plotb1", height = "500px")),
                            
                            tabPanel("Heatmap", 
                                     checkboxInput(inputId = "show_points",
                                                   label = "Show Points",
                                                   value = FALSE), 
                                     plotOutput(outputId = "plotb2", height = "500px"))))
        
        
        
)
        
      
      
      
    )
  )
  
  

  
))

