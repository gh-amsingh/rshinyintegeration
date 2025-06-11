library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)

# Sample data
daily_users <- data.frame(
  day = 1:10,
  users = sample(100:500, 10)
)

region_revenue <- data.frame(
  region = c("North", "South", "East", "West"),
  revenue = c(30000, 20000, 25000, 15000)
)

sales_data <- data.frame(
  month = factor(month.abb, levels = month.abb),
  sales = c(100, 120, 150, 130, 180, 200, 220, 210, 190, 230, 250, 270)
)

products_data <- data.frame(
  product = c("Product A", "Product B", "Product C", "Product D", "Product E"),
  sales = c(1500, 1200, 1000, 800, 600)
)

ui <- fluidPage(
  div(
  h1("📊 Shiny Dashboard Demo", style = "text-align: center;"),
  style = "margin-bottom: 30px;"
),
fluidRow(
  column(12,
         h4("Brain Viewer (3D Scatter Chart)", align = "center"),
         plotlyOutput("brain_viewer_chart")
  )
),
  fluidRow(
    column(6,
           h4("Daily Active Users (Area Chart)"),
           plotlyOutput("daily_users_chart")
    ),
    column(6,
           h4("Revenue by Region (Pie Chart)"),
           plotlyOutput("region_revenue_chart")
    )
  ),

  fluidRow(
    column(6,
           h4("Monthly Sales Trend"),
           plotlyOutput("line_chart")
    ),
    column(6,
           h4("Top 5 Products"),
           plotlyOutput("bar_chart")
    )
  )
)

server <- function(input, output) {

    output$brain_viewer_chart <- renderPlotly({
  set.seed(123)
  brain_data <- data.frame(
    x = rnorm(200, sd = 10),
    y = rnorm(200, sd = 10),
    z = rnorm(200, sd = 10),
    activity = runif(200, 0, 1)
  )

  plot_ly(
    data = brain_data,
    x = ~x, y = ~y, z = ~z,
    type = 'scatter3d',
    mode = 'markers',
    marker = list(
      size = 5,
      color = ~activity,
      colorscale = 'Viridis',
      opacity = 0.8
    )
  ) %>%
    layout(title = "3D Brain Viewer")
})

  
  output$daily_users_chart <- renderPlotly({
    p <- ggplot(daily_users, aes(x = day, y = users)) +
      geom_area(fill = "steelblue", alpha = 0.7) +
      geom_line(color = "steelblue") +
      labs(title = "Daily Active Users", x = "Day", y = "Users") +
      theme_minimal()
    ggplotly(p)
  })

  output$region_revenue_chart <- renderPlotly({
    p <- plot_ly(region_revenue, labels = ~region, values = ~revenue, type = 'pie',
                 textinfo = 'label+percent', insidetextorientation = 'radial') %>%
      layout(title = "Revenue Distribution by Region")
    p
  })
  
  output$line_chart <- renderPlotly({
    p <- ggplot(sales_data, aes(x = month, y = sales)) +
      geom_line(group = 1, color = "steelblue", size = 1.2) +
      geom_point(size = 3) +
      labs(title = "Monthly Sales", x = "Month", y = "Sales") +
      theme_minimal()
    ggplotly(p)
  })
  
  output$bar_chart <- renderPlotly({
    p <- ggplot(products_data, aes(x = reorder(product, sales), y = sales)) +
      geom_bar(stat = "identity", fill = "coral") +
      coord_flip() +
      labs(title = "Top 5 Products", x = "Product", y = "Sales") +
      theme_minimal()
    ggplotly(p)
  })
}

shinyApp(ui = ui, server = server)
