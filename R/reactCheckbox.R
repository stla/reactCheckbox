isBoolean <- function(x) {
  is.logical(x) && length(x) == 1L && !is.na(x)
}

isString <- function(x) {
  is.character(x) && length(x) == 1L && !is.na(x)
}

#' @title Define a checkbox
#' @description Define a checkbox by its label, its value, and optionally a
#'   CSS class.
#'
#' @param label the label of the checkbox, can be an ordinary character string,
#'   a \code{html} character string made with the \code{\link[htmltools]{HTML}}
#'   function, or a \code{shiny.tag} object
#' @param value the initial value of the checkbox, \code{TRUE} (checked), or
#'   \code{FALSE} (unchecked)
#' @param class the name of a CSS class to attach to the checkbox, that should
#'   be defined with \code{\link{checkboxStyle}}
#'
#' @return A named list, to be used in \code{\link{reactCheckboxesInput}}.
#' @export
checkbox <- function(label, value, class = "") {
  stopifnot(isBoolean(value))
  stopifnot(isString(class))
  if(inherits(label, "html") || inherits(label, "shiny.tag")) {
    label = list("__html" = URLencode(as.character(label)))
  } else {
    stopifnot(isString(label))
  }
  list("label" = label, "value" = value, "class" = class)
}

#' @title Checkbox style.
#' @description Define CSS styles for a checkbox.
#'
#' @param checked styles for the checkbox in checked state
#' @param checked_hover styles for the checkbox in checked state on hover
#' @param unchecked styles for the checkbox in unchecked state
#' @param unchecked_hover styles for the checkbox in unchecked state on hover
#' @param indeterminate styles for the checkbox in indeterminate state (for
#'   the head checkbox)
#' @param indeterminate_hover styles for the checkbox in indeterminate state
#'   on hover
#'
#' @return A named list, to be used in \code{\link{reactCheckboxesInput}}.
#' @export
#' @examples
#' library(htmltools) # provides the convenient function `css`
#' checkboxStyle(
#'   checked = css(
#'     background.color = "rgba(255, 82, 82, 0.87)",
#'     border.color = "black"
#'   ),
#'   checked_hover = css(
#'     background.color = "darkred",
#'     border.color = "darkred"
#'   )
#' )
checkboxStyle <- function(
  checked = NULL, checked_hover = NULL,
  unchecked = NULL, unchecked_hover = NULL,
  indeterminate = NULL, indeterminate_hover = NULL
){
  styles <- list(
    ":checked"             = checked,
    ":checked:hover"       = checked_hover,
    " "                    = unchecked,
    ":hover"               = unchecked_hover,
    "_indeterminate"       = indeterminate,
    "_indeterminate:hover" = indeterminate_hover
  )
  Filter(Negate(is.null), styles)
}

#' @title Checkbox group input
#' @description Create a checkbox group input for usage in Shiny.
#'
#' @param inputId the id that will be used to get the values in Shiny
#' @param checkboxes a list of checkboxes defined with the
#'   \code{\link{checkbox}} function
#' @param headLabel the label for the head checkbox
#' @param headClass a CSS class for the head checkbox
#' @param styles a named list of styles created with the
#'   \code{\link{checkboxStyle}} function; the names denote the CSS classes
#' @param theme the theme, \code{"bootstrap"}, \code{"fancy"}, or
#'   \code{"material"}
#'
#' @returns A \code{shiny.tag.list} object to be included in a Shiny UI.
#'
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#' @importFrom utils URLencode
#'
#' @export
#' @examples
#' library(shiny)
#' library(htmltools)
#' library(reactCheckbox)
#'
#' ui <- fluidPage(
#'   reactCheckboxesInput(
#'     "iris",
#'     list(
#'       checkbox("Sepal length", FALSE),
#'       checkbox("Sepal width", FALSE),
#'       checkbox("Petal length", FALSE),
#'       checkbox("Petal width", FALSE)
#'     ),
#'     headLabel = tags$span(
#'       "Make a choice", style = "font-size: 1.8rem; font-style: italic;"
#'     ),
#'     headClass = "custom",
#'     theme = "material",
#'     styles = list(
#'       "custom" = checkboxStyle(
#'         checked = css(
#'           background.color = "darkred"
#'         ),
#'         checked_hover = css(
#'           background.color = "maroon"
#'         ),
#'         unchecked = css(
#'           background.color = "darkorange"
#'         ),
#'         unchecked_hover = css(
#'           background.color = "orange"
#'         ),
#'         indeterminate = css(
#'           background.color = "gold"
#'         ),
#'         indeterminate_hover = css(
#'           background.color = "yellow"
#'         )
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   observe({
#'     print(input[["iris"]])
#'   })
#' }
#'
#' if(interactive()) {
#'   shinyApp(ui, server)
#' }
reactCheckboxesInput <- function(
    inputId, checkboxes,
    headLabel = "Check all", headClass = "",
    styles = NULL, theme = "material"
) {
  theme <- match.arg(theme, c("bootstrap", "fancy", "material"))
  if(inherits(headLabel, "html") || inherits(headLabel, "shiny.tag")) {
    headLabel = list("__html" = URLencode(as.character(headLabel)))
  } else {
    stopifnot(isString(headLabel))
  }
  createReactShinyInput(
    inputId,
    "reactCheckbox",
    htmlDependency(
      name = "reactCheckbox-input",
      version = "1.0.0",
      src = "www/reactCheckbox/reactCheckbox",
      package = "reactCheckbox",
      script = "reactCheckbox.js"
    ),
    default = lapply(checkboxes, `[[`, "value"),
    configuration = list(
      "theme" = theme,
      "labels" = lapply(checkboxes, `[[`, "label"),
      "classes" = lapply(checkboxes, `[[`, "class"),
      "headLabel" = headLabel,
      "headClass" = headClass,
      "styles" = styles
    ),
    container = tags$div
  )
}

#' @title Update a react checkboxes widget
#' @description Change the values of a react checkboxes input.
#'
#' @param session the Shiny \code{session} object
#' @param inputId the id of the react checkboxes widget to be updated
#' @param values new values (vector of \code{TRUE} or \code{FALSE} values)
#'
#' @return No returned value, called for side effect.
#'
#' @export
updateReactCheckboxInput <- function(session, inputId, values) {
  check <- all(vapply(values, is.logical, logical(1L)))
  if(!check) {
    stop("Invalid `values` argument.")
  }
  message <- list(values = values)
  session$sendInputMessage(inputId, message)
}
