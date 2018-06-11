library(shiny)
library(shinydashboard)
library(sparkline)
library(httr)
library(jsonlite)
library(data.table)
library(dplyr)
library(rvest)
library(magrittr)
library(XML)

# Simple header -----------------------------------------------------------

dm <- dropdownMenu(type="messages")
mm <- dropdownMenu(type="notifications")
tm <- dropdownMenu(type="tasks")

header <- dashboardHeader(title="CYBER Dashboard", dm, mm, tm)

# No sidebar --------------------------------------------------------------

sm <- sidebarMenu(
  menuItem(
    text="Situational Awareness",
    tabName="main",
    icon=icon("eye"))
)

sidebar <- dashboardSidebar(sm)

# Compose dashboard body --------------------------------------------------

botnet <- xmlParse("http://www.team-cymru.org/stats/data/traffic_bots.xml")
nettraffic <- xmlParse("http://www.team-cymru.org/stats/data/nettraffic-daily.xml")
dns <- xmlParse("http://www.team-cymru.org/stats/data/port53-daily.xml")

body <- dashboardBody(

  tabItems(
    tabItem(
      tabName="main",

      fluidPage(

        fluidRow(
          div(style="text-align:right; width:100%",
              "Internet Traffic Rate (30d)",
              sparkline(as.numeric(xpathSApply(nettraffic, "//row/number", xmlValue))),
              icon("caret-right"),
              "Avg Botnet Traffic (30d)",
              sparkline(as.numeric(xpathSApply(botnet, "//row/number", xmlValue))),
              icon("caret-right"),
              "DNS Req Rate (30d)",
              sparkline(as.numeric(xpathSApply(dns, "//row[2]/number", xmlValue))),
              icon("caret-left"),
              Sys.Date(),
              hr(noshade=TRUE, size=1)
          )
        ),

        fluidRow(
          a(href="http://isc.sans.org/",
            target="_blank", uiOutput("infocon")),
          a(href="http://www.symantec.com/security_response/threatcon/",
            target="_blank", uiOutput("threatcon")),
          a(href="http://webapp.iss.net/gtoc/",
            target="_blank", uiOutput("alertcon"))
        )
      )
    )
  )
)

# Setup Shiny app UI components -------------------------------------------

ui <- dashboardPage(header, sidebar, body, skin="black")

# Setup Shiny app back-end components -------------------------------------

server <- function(input, output) {

# Header ------------------------------------------------------------------

  output$header <- renderUI({
    h3(Sys.Date())
  })

# Pull SANS Infocon from DShield API --------------------------------------


  output$infocon <- renderUI({

    infocon_url <- "https://isc.sans.edu/api/infocon?json"
    infocon <- fromJSON(content(GET(infocon_url)))

    valueBox(
      "Yellow", "SANS Infocon", icon = icon("bullseye"),
      color = ifelse(infocon$status=="test", "blue", infocon$status)
    )

  })


# Extract Symantec ThreatCon from web page --------------------------------

  output$threatcon <- renderUI({

    pg <- html("http://www.symantec.com/security_response/#")
    pg %>%
      html_nodes("div.colContentThreatCon > a") %>%
      html_text() %>%
      extract(1) -> threatcon_text

    tcon_map <- c("green", "yellow", "orange", "red")
    names(tcon_map) <- c("Level 1", "Level 2", "Level 3", "Level 4")
    threatcon_color <- unname(tcon_map[gsub(":.*$", "", threatcon_text)])

    threatcon_text <- gsub("^.*:", "", threatcon_text)

    valueBox(
      threatcon_text, "Symantec ThreatCon", icon = icon("tachometer"),
      color = threatcon_color
    )

  })

# Extract IBM X-Force AlertCon from web page ------------------------------

  output$alertcon <- renderUI({

    pg <- html("http://xforce.iss.net/")
    pg %>%
      html_nodes(xpath="//td[@class='newsevents']/p") %>%
      html_text() %>%
      gsub(" -.*$", "", .) -> alertcon_text

    acon_map <- c("green", "blue", "yellow", "red")
    names(acon_map) <- c("AlertCon 1", "AlertCon 2", "AlertCon 3", "AlertCon 4")
    alertcon_color <- unname(acon_map[alertcon_text])

    valueBox(
      alertcon_text, "IBM X-Force", icon = icon("warning"),
      color = alertcon_color
    )

  })

}

# Render Shiny app --------------------------------------------------------

shinyApp(ui, server)
