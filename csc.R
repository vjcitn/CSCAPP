library(shiny)
library(sars2app)
load("csc_corrected.rda")
if (!exists("nytc")) nytc = nytimes_county_data()
ui = fluidPage(
 sidebarLayout(
  sidebarPanel(
   helpText(" "),
   helpText("select state and city of interest"),
   selectInput("state", "state", choices=csc_corrected$STATE, selected="Massachusetts"),
   uiOutput("citychooser")
   ),
  mainPanel(
   textOutput("note"),
   plotOutput("incplot")
   )
  )
 )
server = function(input, output, session) {
 output$citychooser = renderUI({
  validate(need(nchar(input$state)>0, " "))
  selectInput("city", "city", choices=csc_corrected$CITY[which(csc_corrected$STATE==input$state)])
  })
 output$note = renderText({
  validate(need(nchar(input$city)>0, "select state and city"))
  paste(input$city, " is in the county of ", 
        csc_corrected$COUNTY[ which(csc_corrected$CITY == input$city & csc_corrected$STATE == input$state) ],
        ", ", input$state, sep="")
  })
 output$incplot = renderPlot({
  validate(need(nchar(input$city)>0 & nchar(input$state)>0, " "))
  cou = csc_corrected$COUNTY[ which(csc_corrected$CITY == input$city & csc_corrected$STATE == input$state) ]
  ee = cumulative_events_nyt_county(nytc, statename=input$state, countyname=cou)
  iee = form_incident_events(ee)
  plot(iee)
  })

}
runApp(list(ui=ui, server=server))
 
  
   
