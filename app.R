library(shiny)
library(ifm)
library(igraph)
library(XLConnect)

# tryCatch(
#     {
#         df <<- excel.xls.to.list('www/spreadsheet.xls')
#     },
#     error = function(e) {
#         stop(safeError(e))
#     }
# )

df <- excel.xls.to.list('www/spreadsheet.xls')


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
              a(href="spreadsheet.xls", "download a CSV sample file, "),
              'implement your case and upload here again.'),

            fileInput("file1", "Upload XLS or CSV File",
                      multiple = FALSE,
                      accept = c(".xls", ".csv"),
                      placeholder = 'Upload your Data File here'),
            
            tags$hr(),
            
            h3('Settings'),
            
            p(numericInput("taxRate", "Define % of Tax Rate:", 2, step = 0.1, width = 80)),
            
            p(actionButton("executeIfm", "Execute IFM"), align='right'),

        ),

        mainPanel(
            textOutput("contents"),
            plotOutput("plotGraph"),
        )
    ),
    
    
    tags$hr(),
    
    fluidRow(
        column(1,
               a(href='http://ufrj.br', p(img(src = "minerva.png", width = 60)),align='right')
        ),
        column(5,
                h6('More datails in https://github.com/antoanne/ifmWebApp.'), align='left' ),
        column(6,
               h6('Author: Antoanne Christopher Pontes Wanderley'),
               h6('Advisor: Prof. Eber Assis Schmitz, Ph.D.'),
               h6('Co-advisor: Prof. Sérgio Manuel Serra da Cruz, D.Sc.'), align='right'),
    ),
    
    
)

# Define server logic
server <- function(input, output, session) {

    observeEvent(input$file1, {
        output$contents <- renderTable({
            req(input$file1)
            tryCatch(
                {
                    df <<- excel.xls.to.list(input$file1$datapath)
                },
                error = function(e) {
                    stop(safeError(e))
                }
            )
            return(df)
        })
    })

    observeEvent(input$loadSampleData, {
        output$contents <- renderText({
            tryCatch(
                {
                    df <<- excel.xls.to.list('www/spreadsheet.xls')
                },
                error = function(e) {
                    stop(safeError(e))
                }
            )
            return(df$activities)
        })
    })

    
    observeEvent(input$executeIfm, {
        output$plotGraph <- renderPlot({
            tryCatch(
                {
                    df <<- excel.xls.to.list('www/spreadsheet.xls')
                    edges <- utils.pred2graph(df$predecessors)
                    g <- make_graph(edges, directed = TRUE )
                    plot(g)
                    updateNumericInput(session, "taxRate", value = df$interest.rate*100)
                    return(df)
                },
                error = function(e) {
                    stop(safeError(e))
                }
            )
        })
    })
    
    
}

shinyApp(ui, server)