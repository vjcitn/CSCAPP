library(shiny)
library(sars2app)
load("csc_corrected.rda")
if (!exists("nytc")) nytc = nytimes_county_data()
ui = fluidPage(
 sidebarLayout(
  sidebarPanel(
   helpText("This app uses New York Times county-level data on counts of confirmed COVID-19 cases by day."),
   textOutput("lastdate"),
   helpText("Select state and city of interest:"),
   selectInput("state", "state", choices=csc_corrected$STATE, selected="Massachusetts"),
   uiOutput("citychooser"),
   checkboxInput("trim", "zoom to last 30d", value=FALSE)
   ),
  mainPanel(
   tabsetPanel(
    tabPanel("incidence",
       helpText(" "),
       textOutput("note"),
       plotOutput("incplot")
       ),
    tabPanel("about",
       helpText("'Incident events' plotted for a calendar day refers to the number of newly confirmed test results reported by the county on that day."),
       helpText("The code for this app is managed at github.com/vjcitn/sars2app.  To request additional
features, file issues at that location.")
       )
     )
   )
  )
 )
