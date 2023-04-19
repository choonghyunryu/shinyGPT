##==============================================================================
## 02.01. Right controller
##==============================================================================
controlbar_menu <- controlbarMenu(
  id = "controlbarMenu",
  controlbarItem(
    icon = icon("paintbrush"),
    title = "Skin",
    tags$head(tags$script(js_change_skin)),
    selectInput(
      inputId = "skin_color",
      label = "스킨 색상",
      c("블루" = "blue", "오렌지" = "yellow", "화이트" = "black",
        "퍼플" = "purple", "그린" = "green", "레드" = "red")
    )
  )
)

##==============================================================================
## Define header
##==============================================================================
header <- dashboardHeader(
  title = tagList(
    span("shinyGPT")),

  leftUi = tagList(
    dropdownBlock(
      id = "set_images",
      title = "Setup Images",
      icon = icon("sliders"),
      badgeStatus = NULL,
      prettyRadioButtons(
        inputId = "img_size",
        label = "이미지 크기:",
        choices = c("1024x1024" = "1024x1024",
                    "512x512" = "512x512",
                    "256x256" = "256x256"))
    )
  )
)


##==============================================================================
## Define sidebar
##==============================================================================
sidebar <- dashboardSidebar(
  id = "gpt_sidebar",
  sidebarMenu(
    menuItem("무엇이든 물어보세요", tabName = "tab_chat",  icon = icon("comments")),
    menuItem("무엇이든 그려보세요", tabName = "tab_image", icon = icon("image"))
  )
)


################################################################################
## 04. Body structures
################################################################################
##==============================================================================
## 04.01. Left side menus
##==============================================================================
body <- dashboardBody(
  ## Spinner somewhere in UI
  add_busy_spinner(
    spin = "fading-circle",
    margins = c(50, 50),
    height = "60px",
    width  = "60px"
  ),

  useShinyjs(),

  # tags$script(HTML("$('body').addClass('fixed');")),

  tabItems(
    tabItem(
      tabName = "tab_chat",
      uiOutput("ui_chat")
    ),
    tabItem(
      tabName = "tab_image",
      uiOutput("ui_image")
    )
  )
)

ui <- dashboardPage(
  useShinyjs(),

  header = header,
  sidebar = sidebar,

  controlbar = dashboardControlbar(
    id = "filters",
    width = 300,
    skin = "dark",
    controlbar_menu
  ),
  body = body,

  footer = dashboardFooter(
    left = "with bitGPT packages",
    right = "bitR, 2023"
  ),

  skin = 'blue'
)

