isBoolean <- function(x) {
  is.logical(x) && length(x) == 1L && !is.na(x)
}

isString <- function(x) {
  is.character(x) && length(x) == 1L && !is.na(x)
}

#' Title
#'
#' @param label label
#' @param value value
#' @param class class
#'
#' @return x
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

#' Title
#'
#' @param checked x
#' @param checked_hover x
#' @param unchecked x
#' @param unchecked_hover x
#' @param indeterminate x
#' @param indeterminate_hover x
#'
#' @return x
#' @export
checkboxStyle <- function(
  checked = NULL, checked_hover = NULL,
  unchecked = NULL, unchecked_hover = NULL,
  indeterminate = NULL, indeterminate_hover = NULL
){
  styles <- list(
    ":checked" = checked,
    ":checked:hover" = checked_hover,
    " " = unchecked,
    ":hover" = unchecked_hover,
    "_indeterminate" = indeterminate,
    "_indeterminate:hover" = indeterminate_hover
  )
  Filter(Negate(is.null), styles)
}

#' Add Title
#'
#' <Add Description>
#'
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#'
#' @export
reactCheckboxInput <- function(
    inputId, checkboxes,
    headLabel = "Check all", headClass = "",
    styles = NULL, theme = "bootstrap"
) {
  reactR::createReactShinyInput(
    inputId,
    "reactCheckbox",
    htmltools::htmlDependency(
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
    container = htmltools::tags$div
  )
}

#' Add Title
#'
#' <Add Description>
#'
#' @export
updateReactCheckboxInput <- function(session, inputId, value, configuration = NULL) {
  message <- list(value = value)
  if (!is.null(configuration)) message$configuration <- configuration
  session$sendInputMessage(inputId, message);
}
