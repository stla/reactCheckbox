library(shiny)
library(htmltools)
library(reactCheckbox)

ui <- fluidPage(
  br(),
  reactCheckboxesInput(
    "iris",
    list(
      checkbox("Sepal length", FALSE),
      checkbox("Sepal width", FALSE),
      checkbox("Petal length", FALSE),
      checkbox("Petal width", FALSE)
    ),
    headLabel = tags$span(
      "Make a choice", style = "font-size: 1.8rem; font-style: italic;"
    ),
    headClass = "custom",
    theme = "material",
    styles = list(
      "custom" = checkboxStyle(
        checked = css(
          background.color = "darkred"
        ),
        checked_hover = css(
          background.color = "maroon"
        ),
        unchecked = css(
          background.color = "darkorange"
        ),
        unchecked_hover = css(
          background.color = "orange"
        ),
        indeterminate = css(
          background.color = "gold"
        ),
        indeterminate_hover = css(
          background.color = "yellow"
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observe({
    print(input[["iris"]])
  })
}

shinyApp(ui, server)

