library(shiny)
library(shinydashboard)
dashboardPage(
  dashboardHeader(title = "From text to emoticon"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Text",
                    textInput("text_in", "Say something:", "What a good weather!")),
                box(title = "Emoji",
                    textOutput("emoji_out"))
              )),
      tabItem(tabName = "widgets",
              h2("BAZINGA!"),
              h3("(=^.^=)"))
      
    )
  )
)