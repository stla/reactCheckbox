library(shiny)
library(reactCheckbox)



ui <- fluidPage(
  reactCheckboxInput(
    "xxx",
    list(
      checkbox("A", FALSE, "red"),
      checkbox("B", TRUE)
    ),
    theme = "material",
    styles = list(
      red = checkboxStyle(
        checked = htmltools::css(
          background.color = "rgba(255,82,82,0.87)",
          border.color = "rgba(0,0,0,0)"
        ),
        checked_hover = htmltools::css(
          background.color = "rgb(0,255,0)",
          border.color = "rgb(0,0,255)"
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observe({
    print(input$xxx)
  })
}

shinyApp(ui, server)

