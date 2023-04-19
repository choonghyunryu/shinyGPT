shinyServer(function(input, output, session) {

  ## load source for menu
  for (file in list.files(c("menu"), pattern = "\\.(r|R)$", full.names = TRUE)) {
    source(file, local = TRUE)
  }

  observeEvent(input$skin_color, {
    session$sendCustomMessage("change_skin", paste0("skin-", input$skin_color))
  })
})
