function(input, output, session) {
  ## 채팅 완성하기 -------------------------------------------------------------
  observeEvent(input$chat_message, {
    req(input$chat_prompt)

    prompt <- input$chat_prompt

    # messages 생성 또는 추가하여 패키지 environment에 추가
    if (is.null(bitGPT:::get_gptenv("chat_messages"))) {
      # messages가 없으면 prompt로 새 messages 생성
      bitGPT:::set_gptenv("chat_messages", create_messages(user = prompt))
    } else {
      # messages가 있으면 user prompt 추가
      bitGPT:::get_gptenv("chat_messages") %>%
        add(user = prompt) %>%
        bitGPT:::set_gptenv("chat_messages", .)
    }

    # 채팅 형태로 질문에 답변(answer) 생성
    answer <- chat_completion(messages = bitGPT:::get_gptenv("chat_messages"),
                              type = 'messages')
    bitGPT:::set_gptenv("chat_messages", answer)

    output$chat_created <- renderUI({
      bitGPT:::show.messages(answer, type = "viewer", is_browse = FALSE)
      includeHTML("answer.html")
    })

    ## 프롬프트 초기화
    updateTextInput(session, "chat_prompt", value = "")
  })

  output$ui_prompt <- renderUI({
    tagList(
      column(
        width = 9,
        tagAppendAttributes(textInput("chat_prompt",
                  label = NULL,
                  value = "",
                  width = "100%",
                  placeholder = "프롬프트를 입력하세요."),
                  `data-proxy-click` = "chat_message")
      ),
      column(
        width = 3,
        actionButton("chat_message", label = "채팅",
                     icon = icon("comment"),
                     class = "btn-primary",
                     style = "background-color: #90CAF9; border: none"),

        actionButton("chat_initial", label = "초기화",
                     icon = icon("trash"),
                     class = "btn-primary",
                     style = "background-color: #90CAF9; border: none")
      )
    )
  })

  # 출력된 HTML 코드가 업데이트 될 때마다 맨 아래로 스크롤 이동
  observeEvent(input$chat_created, {
    shinyjs::runjs("$('.shiny-html-chat_created').scrollTop($('.shiny-html-chat_created')[0].scrollHeight)")
  })


  ## 메시지 초기화 -------------------------------------------------------------
  observeEvent(input$chat_initial, {
    bitGPT:::unset_gptenv("chat_messages")
  })


  ## 이미지 그리기 -------------------------------------------------------------
  observeEvent(input$draw_image, {
    req(input$img_prompt)

    fname <- glue::glue("image_{round(runif(1) * 10^10)}") %>%
      as.character()

    prompt <- input$img_prompt

    bitGPT::draw_img(prompt = prompt,
                     size = "1024x1024",
                     type = "file",
                     path = tempdir(),
                     fname = fname)

    output$img_created <- renderImage({
      list(src = paste(paste(tempdir(), paste(fname, "png", sep = "."), sep = "/")),
           alt = "This is chatGPT image",
           width = "100%", height = "512x")
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
           width = "100%", height = "512x")
    }, deleteFile = FALSE)

    Sys.setenv(IMG_NAME = paste(fname, "png", sep = "."))
  })


  ## 이미지 받기 핸들러 --------------------------------------------------------
  output$downImage <- downloadHandler(
    filename = function() {
      input$fname_image
    },
    content = function(file) {
      file.copy(paste(tempdir(), Sys.getenv("IMG_NAME"), sep = "/"), file)
    }
  )
}
