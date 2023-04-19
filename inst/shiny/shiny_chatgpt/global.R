################################################################################
## 01. Prepare Resources
################################################################################

##==============================================================================
## 01.01. Load Packages
##==============================================================================
##------------------------------------------------------------------------------
## 01.01.01. Load packages that are related shiny & html
##------------------------------------------------------------------------------
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(shinybusy)
library(htmltools)

##------------------------------------------------------------------------------
## 01.01.02. Load packages that are tidyverse families and bitGPT
##------------------------------------------------------------------------------
library(dplyr)
library(bitGPT)


################################################################################
## 02. Prepare environments
################################################################################
##==============================================================================
## 02.01. Global Options
##==============================================================================
## for trace, if want.
options(shiny.trace = FALSE)

## for progress
options(spinner.color = "#0275D8", spinner.color.background = "#ffffff",
        spinner.size = 2)


##==============================================================================
## 02.02. Initialize Chat
##==============================================================================
bitGPT:::unset_gptenv("chat_messages")



##==============================================================================
## 02.03. Define javascript
##==============================================================================
## 프롬프트에 엔터를 입력할 때, 수행하기 위한 JavaScript -----------------------
## https://stackoverflow.com/questions/55731607/trigger-actionbutton-with-keyboard-in-shiny-using-uioutput
js_enter <- '$(document).keyup(function(e) {
    if (e.key == "Enter") {
    $("#chat_message").click();
}});'


# Reference https://stackoverflow.com/questions/57592774/how-to-select-shinydashboard-skin-dynamically
js_change_skin <- "Shiny.addCustomMessageHandler('change_skin', function(skin) {
        document.body.className = skin;
       });"

