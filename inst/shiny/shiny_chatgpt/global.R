## 사용하는 패키지 -------------------------------------------------------------
library("bitGPT")
library("shiny")
library("dplyr")
library("htmltools")
library("shinybusy")
library("shinyjs")

## 채팅 메시지 초기화 ----------------------------------------------------------
bitGPT:::unset_gptenv("chat_messages")

