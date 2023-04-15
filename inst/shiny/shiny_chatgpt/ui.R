navbarPage(
  theme = shinythemes::shinytheme("cerulean"),
  "shinyGPT",

  ## 이미지 생성 및 변형 UI ----------------------------------------------------
  tabPanel(
    "무엇이든 그려보세요",
    mainPanel(
      style = "padding-top:10px;padding-bottom:0px",

      fluidRow(
        add_busy_spinner(spin = "fading-circle"),
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
        )
      ),

      wellPanel(
        imageOutput("img_created",
                    height = "512px")
      ),
      width = 12
    ),
    icon = icon("image")
  ),

  ## 채팅 완성하기 UI ----------------------------------------------------------
  tabPanel(
    "무엇이든 물어보세요",
    useShinyjs(),
    mainPanel(
      add_busy_spinner(spin = "fading-circle"),
      style = "padding-top:10px;padding-bottom:0px",

      wellPanel(
        useShinyjs(), # shinyjs 라이브러리 사용
        htmlOutput("chat_created")
      ),

      fluidRow(
        tags$head(tags$script(HTML(jscode))),
        uiOutput("ui_prompt")

      ),
      width = 12
    ),
    icon = icon("comments")
  )
)

