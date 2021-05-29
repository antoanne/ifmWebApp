library(shiny)

# Define UI for application
ui <- fluidPage(
    tags$body(style='color: #333; background-color: #f5'),
    titlePanel("ifmFramework"),
    fluidRow(
        column(8,
               p('This WebApp uses ifmFramework, a R library with a set of 
               functions for financial evaluation of projects based on 
               Incremental Funding Method (IFM).'),
               p('IFM is a financially informed approach
                to software development, designed to maximize
                returns through delivering functionality in ‘chunks’
                of customer valued features, carefully sequenced so
                as to optimize Net Present Value (NPV).'),
        ),
        column(4,
               a(href='http://www.ppgi.ufrj.br', p(img(src = "ppgi.png", width = 300)),align='right'),
        ),
    ),
    
    tags$hr(),
    
    sidebarLayout(
        sidebarPanel(
            h3('Load Data'),
            p('Click ', actionLink("loadSampleData", "here"), 'to load example data.'),
            
            p('If you need an template data file,',
              a(href="sample.csv", "download a CSV sample file, "),
              'implement your case and upload here again.'),

            fileInput("file1", "Upload CSV File",
                      multiple = FALSE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv"),
                      placeholder = 'Upload your CSV Data File here'),
            
            tags$hr(),
            
            h3('Settings'),
            
            numericInput("taxRate", "Define % of Tax Rate:", 2.4, step = 0.1, width = 80),
            
            p(actionButton("executeIfm", "Execute IFM"), align='right'),

        ),

        mainPanel(
            tableOutput("contents"),
            
        )
    ),
    
    
    tags$hr(),
    
    fluidRow(
        column(2,
               a(href='http://ufrj.br', p(img(src = "minerva.png", width = 60)),align='left')
        ),
        p(column(10,
               
               h6('Author: Antoanne Christopher Pontes Wanderley'),
               h6('Advisor: Prof. Eber Assis Schmitz, Ph.D.'),
               h6('Co-advisor: Prof. Sérgio Manuel Serra da Cruz, D.Sc.'), align='right'),
        ),
        
    ),
    
    
)

# Define server logic
server <- function(input, output) {

    observeEvent(input$file1, {
        output$contents <- renderTable({
            req(input$file1)
            tryCatch(
                {
                    df <- read.csv(input$file1$datapath,
                                   header = TRUE,
                                   sep = ";",
                                   quote = "")
                },
                error = function(e) {
                    stop(safeError(e))
                }
            )
            return(df)
        })
    })
    
    observeEvent(input$loadSampleData, {
        output$contents <- renderTable({
            tryCatch(
                {
                    df <- read.csv('www/sample.csv',
                                   header = TRUE,
                                   sep = ";",
                                   quote = "")
                },
                error = function(e) {
                    stop(safeError(e))
                }
            )
            return(df)
        })
    })
    
    observeEvent(input$executeIfm, {
        
        print({input$taxRate})
    })
    
    
}

shinyApp(ui, server)