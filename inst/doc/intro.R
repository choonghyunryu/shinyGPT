## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# devtools::install_github("bit2r/bitGPT")

## ----eval=FALSE---------------------------------------------------------------
# devtools::install_github("choonghyunryu/shinyGPT")

## ----eval=FALSE---------------------------------------------------------------
# library("bitGPT")
# 
# # 실제 사용자가 할당받은 openai API key를 사용합니다.
# regist_openai_key("XXXXXXXXXXX")
# 
# # 실제 사용자가 할당받은 DeepL API key를 사용합니다.
# regist_deepl_key("XXXXXXXXXXX")

## ----eval=FALSE---------------------------------------------------------------
# library(shinyGPT)
# 
# shiny_chatgpt()

## ----app_image, echo=FALSE, out.width='80%', fig.align='center', fig.pos="!h", fig.cap="이미지 생성 예제"----
knitr::include_graphics('img/app_image.png')

## ----app_chat, echo=FALSE, out.width='80%', fig.align='center', fig.pos="!h", fig.cap="채팅 예제"----
knitr::include_graphics('img/app_chat.png')

