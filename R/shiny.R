#' Simple chatGPT app
#'
#' @description chatGPT를 이용한 채팅 및 이미지 생성을 위한 Shiny 앱 호출
#' @return 없음
#' @author 유충현
#' @seealso \code{\link{chat_completion}}, \code{\link{draw_img}}, \code{\link{draw_img_variation}}
#' @examples
#' \dontrun{
#'  library(shinyGPT)
#'
#'  ## chatGPT를 이용한 채팅 및 이미지 생성기(Shiny Web Application) 호출
#'  shiny_chatgpt()
#' }
#' @export
#' @import shiny bitGPT 
#' @import bitGPT 
#' @import dplyr 
#' @import htmltools 
#' @import shinybusy 
#' @import shinyjs 
#'
shiny_chatgpt <- function() {
  library(shiny)
  
  runApp(system.file("shiny/shiny_chatgpt", package="shinyGPT"))
}
