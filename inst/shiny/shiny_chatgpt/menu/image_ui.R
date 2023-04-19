output$ui_image <- renderUI({
  tagList(
    fluidRow(
      column(
        width = 1,
        actionButton("image_initial", label = "삭제",
                     icon = icon("eraser"),
                     class = "btn-primary",
                     style = "background-color: #90CAF9; border: none")
      ),
      column(
        width = 7,
        textInput("img_prompt",
                  label = NULL,
                  value = "",
                  width = "100%",
                  placeholder = "그림 그릴 프롬프트를 입력하세요.")
      ),

      column(
        width = 4,
        actionButton("draw_image", label = "생성",
                     icon = icon("paintbrush"),
                     class = "btn-primary",
                     style = "background-color: #90CAF9; border: none"),

        actionButton("variation_image", label = "변형",
                     icon = icon("gears"),
                     class = "btn-primary",
                     style = "background-color: #90CAF9; border: none"),

        downloadButton("downImage", label = "파일", class = "butt"),
        tags$head(tags$style(".butt{background:#90CAF9;} .butt{border: none;}"))
      ),

      column(
        width = 11,
        wellPanel(
          style = "padding-top:10px; padding-left:10px; padding-right:10px; padding-bottom:10px",
          imageOutput("img_created",
                      height = "620px")
        )
      )
    )
  )
})


## 이미지 프롬프트 초기화 -------------------------------------------------------------
observeEvent(input$image_initial, {
  ## 프롬프트 초기화
  updateTextInput(session, "img_prompt", value = "")
})


## 이미지 그리기 -------------------------------------------------------------
observeEvent(input$draw_image, {
  req(input$img_prompt)

  fname <- glue::glue("image_{round(runif(1) * 10^10)}") %>%
    as.character()

  prompt <- input$img_prompt

  bitGPT::draw_img(prompt = prompt,
                   size = input$img_size,
                   type = "file",
                   path = tempdir(),
                   fname = fname)

  output$img_created <- renderImage({
    list(src = paste(paste(tempdir(), paste(fname, "png", sep = "."), sep = "/")),
         alt = "This is chatGPT image",
         width = "100%", height = "700x")
  }, deleteFile = FALSE)

  Sys.setenv(IMG_NAME = paste(fname, "png", sep = "."))
})


## 이미지 변형하기 -----------------------------------------------------------
observeEvent(input$variation_image, {
  req(input$img_prompt)

  fname <- glue::glue("image_{round(runif(1) * 10^10)}") %>%
    as.character()

  image <- paste(tempdir(), Sys.getenv("IMG_NAME"), sep = "/")

  bitGPT::draw_img_variation(image = image,
                             type = "file",
                             path = tempdir(),
                             fname = fname)

  output$img_created <- renderImage({
    list(src = paste(paste(tempdir(), paste(fname, "png", sep = "."), sep = "/")),
         alt = "This is chatGPT image",
         width = "100%", height = "700x")
  }, deleteFile = FALSE)

  Sys.setenv(IMG_NAME = paste(fname, "png", sep = "."))
})


## 이미지 받기 핸들러 --------------------------------------------------------
output$downImage <- downloadHandler(
  filename = function() {
    id <- sprintf("%07d", round(runif(1) * 10 ^ 7))
    paste("image-", id, ".png", sep = "")
  },
  content = function(file) {
    file.copy(paste(tempdir(), Sys.getenv("IMG_NAME"), sep = "/"), file)
  },
  contentType = "image/png"
)

