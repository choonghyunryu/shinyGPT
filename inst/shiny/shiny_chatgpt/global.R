## 사용하는 패키지 -------------------------------------------------------------
library("bitGPT")
library("shiny")
library("dplyr")
library("htmltools")
library("shinybusy")
library("shinyjs")

## 채팅 메시지 초기화 ----------------------------------------------------------
bitGPT:::unset_gptenv("chat_messages")


## 프롬프트에 엔터를 입력할 때, 수행하기 위한 JavaScript -----------------------
## https://stackoverflow.com/questions/55731607/trigger-actionbutton-with-keyboard-in-shiny-using-uioutput
jscode <- '$(document).keyup(function(e) {
    if (e.key == "Enter") {
    $("#chat_message").click();
}});'

