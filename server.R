source('https://raw.githubusercontent.com/sudhir-voleti/PCA-App/main/dependencies.R')
#---------Staring Server code--------#

server <- function(input, output,session) {
  #-----Data upload----#
  df_data <- reactive({
    req(input$file)
    df = read.csv(input$file$datapath)
    
  })
  
  #--1.Main Panel O/P
  # 1. dimension
  output$dim <- renderPrint({
    cat("Uploaded dataset has ",dim(df_data())[1],"rows and ",dim(df_data())[2]," columns")
  })
  
  # 2. sample data
  output$samp_data <- DT::renderDataTable({
    head(df_data(),5)
  })
  
  # 3. missing plot
  output$miss_plot <- renderPlot({
    req(input$file)
    Amelia::missmap(df_data())
  })
  
  
  #----build rmse mat -----#
  
  list0 <- reactive({
    suppressWarnings({ 
      df_data <- df_data()%>%tidyr::drop_na()
      list0 = build_rmse_mat(df_data()) 
      return(list0)
    })
  })
  

  
  #---PCA Loadings Tab---#
  output$loadings_dt <- DT::renderDataTable({
    df1 = list0()[[2]]
    loadings <- pca_outputs(df1)[[1]]
    loadings[, 1:input$k]
  })
  
  output$loading_hm <- plotly::renderPlotly({
    df1 = list0()[[2]]
    build_pca_loadings_heatmap(df1, k=input$k)
  })
  #----PCA Scores Tab--#
  output$scores_dt <- DT::renderDataTable({
    df1 = list0()[[2]]
    scores <- pca_outputs(df1)[[2]]
    scores[, 1:input$k]
  })
  
  output$bi_plot <- plotly::renderPlotly({
    X = list0()[[2]]
    build_display_biplot(X)
  })
  #--- Variance exp Tab---#
  output$var_exp <- plotly::renderPlotly({
    X = list0()[[2]]
    varExpl = var_expl(X); # dim(varExpl)
    # now plot-ly the var explained %s
    plot01 = ggplot(data = varExpl, aes(component, compt.var)) + geom_col() + ggtitle("% variance explained by PCA compts")
    fig01 = ggplotly(plot01)
    fig01  # show in Var Explained tab
  })
  
  output$cum_var_exp <- plotly::renderPlotly({
    X = list0()[[2]]
    varExpl = var_expl(X); # dim(varExpl)
    plot02 = ggplot(data = varExpl, aes(component, cumul.var)) + 
      geom_col() + 
      ggtitle("% Cumul variance explained by PCA compts")
    fig02 = ggplotly(plot02)
    fig02  # show in Var Explained Tab
  })
  
  
}
