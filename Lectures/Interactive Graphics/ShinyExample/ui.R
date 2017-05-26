library(plotly)
library(threejs)
library(dygraphs)

navbarPage(
  title = "Shiny Examples",
  
  ##############################################################################
  ##############################################################################
  ##############################################################################
  #  Traditional Shiny
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  tabPanel("Traditional Shiny",
           selectInput(inputId = "n_breaks",
                       label = "Number of bins in histogram (approximate):",
                       choices = c(10, 20, 35, 50, 100),
                       selected = 35),
           
           selectizeInput(inputId = "ratings", 
                          label = "Choose Your Content Ratings", 
                          choices = unique(imdb$content_rating), 
                          selected = "R", 
                          multiple = TRUE,
                          options = NULL),
           
           checkboxInput(inputId = "individual_obs",
                         label = strong("Show individual observations"),
                         value = FALSE),
           
           checkboxInput(inputId = "density",
                         label = strong("Show density estimate"),
                         value = FALSE),
           
           plotOutput(outputId = "sams_plot", height = "300px"),
           
           # Display this only if the density is shown
           conditionalPanel(condition = "input.density == true",
                            sliderInput(inputId = "bw_adjust",
                                        label = "Bandwidth adjustment:",
                                        min = 0.2, max = 2, value = 1, 
                                        step = 0.2)
           )
  ),
  
  ##############################################################################
  ##############################################################################
  ##############################################################################
  #  Plotly (embedded in Shiny)
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  tabPanel("Plotly",  
           plotlyOutput(outputId = "plotly_plot", height = "450px")
  ),
  
  
  ##############################################################################
  ##############################################################################
  ##############################################################################
  #  HTML Widgets (embedded in Shiny)
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  tabPanel("HTML Widgets -- threejs",  
           scatterplotThreeOutput(outputId = "html_widget1", height = "600px")
  ),
  tabPanel("HTML Widgets -- Dygraphs",  
           dygraphOutput(outputId = "dygraph", height = "400px")
  )
)
