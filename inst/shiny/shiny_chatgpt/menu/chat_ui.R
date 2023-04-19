output$ui_chat <- renderUI({
  tagList(
    fluidRow(
      column(
        width = 12,
        wellPanel(
          style = "padding-top:10px; padding-left:10px; padding-right:10px; min-height: 620px; max-height: 620px; overflow:auto;",
          htmlOutput("chat_created")
        )
      ),

      column(
        width = 12,
        tags$head(tags$script(HTML(js_enter))),
        uiOutput("ui_prompt")
      )
    )
  )
})

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
    xml2::write_html(
      rvest::html_node(
        xml2::read_html(paste(tempdir(), "answer.html", sep = "/")), "body"),
                     file = paste(tempdir(), "answer2.html", sep = "/"))
    includeHTML(paste(tempdir(), "answer2.html", sep = "/"))
  })

  ## 프롬프트 초기화
  updateTextInput(session, "chat_prompt", value = "")
})


## 채팅 UI 정의 --------------------------------------------------------------
output$ui_prompt <- renderUI({
  tagList(
    column(
      width = 8,
      tagAppendAttributes(textInput("chat_prompt",
                                    label = NULL,
                                    value = "",
                                    width = "100%",
                                    placeholder = "프롬프트를 입력하세요."),
                          `data-proxy-click` = "chat_message")
    ),
    column(
      width = 4,
      actionButton("chat_message", label = "채팅",
                   icon = icon("comment"),
                   class = "btn-primary",
                   style = "background-color: #90CAF9; border: none"),

      actionButton("chat_initial", label = "초기화",
                   icon = icon("trash"),
                   class = "btn-primary",
                   style = "background-color: #90CAF9; border: none"),

      downloadButton("downChat", label = "파일", class = "butt"),
      tags$head(tags$style(".butt{background:#90CAF9;} .butt{border: none;}"))
    )
  )
})


## 채팅 메시지 초기화 -------------------------------------------------------------
observeEvent(input$chat_initial, {
  bitGPT:::unset_gptenv("chat_messages")
})


## 채팅 받기 핸들러 --------------------------------------------------------
output$downChat <- downloadHandler(
  filename = function() {
    id <- sprintf("%07d", round(runif(1) * 10 ^ 7))
    paste("chat-", id, ".html", sep = "")
  },
  content = function(file) {
    file.copy(paste(tempdir(), "answer.html", sep = "/"), file)
  },
  contentType = "text/html"
)
