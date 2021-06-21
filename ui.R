library(dplyr)
shinyUI(fluidPage(
    
    title = "PCA App",
    titlePanel(title=div(img(src="logo.png",align='right'),"PCA App")),
    sidebarPanel(
        
        conditionalPanel(condition = "input.tabselected==1",
                         fileInput("file", "Upload Input file"),
                         numericInput("k","Select K",min = 2,max=50,value=2)
        ),
        conditionalPanel(condition="input.tabselected==3",
                         
        ),
        
        
    ),
    mainPanel(

        tabsetPanel(
            tabPanel("Overview & Example Dataset", value=1, 
                     includeMarkdown("overview.md")
            ),
            tabPanel("Data Summary", value=1,
                     h4("Data Dimensions"),
                     verbatimTextOutput("dim"),
                     hr(),
                     h4("Sample Dataset"),
                     DT::dataTableOutput("samp_data"),
                     hr(),
                     h4("Missingness Map"),
                     plotOutput("miss_plot")
                     
            ),
            tabPanel("Variance Explained", value=1,
                     plotly::plotlyOutput("var_exp"),
                     plotly::plotlyOutput("cum_var_exp") 
                     
            ),
            tabPanel("PCA Scores",value=1,
                     DT::dataTableOutput("scores_dt"),
                     plotly::plotlyOutput("bi_plot")
            ),
            
            tabPanel("PCA Loadings",value=1,
                    DT::dataTableOutput("loadings_dt"),
                    plotly::plotlyOutput("loading_hm")
            ),
            id = "tabselected"
        )
    )
))

