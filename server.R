library(shiny)
library(sars2app)
load("csc_corrected.rda")
if (!exists("nytc")) nytc = nytimes_county_data()
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
 output$lastdate = renderText({
  paste("The most recent date for which COVID-19 incidence data are available for this display is ", 
      max(nytc$date), ".", sep=" ")
  })
 output$incplot = renderPlot({
  validate(need(nchar(input$city)>0 & nchar(input$state)>0, " "))
  cou = csc_corrected$COUNTY[ which(csc_corrected$CITY == input$city & csc_corrected$STATE == input$state) ]
  validate(need(nchar(cou)>0 & nchar(input$state)>0, " "))
  ee = cumulative_events_nyt_county(nytc, statename=input$state, countyname=cou)
  iee = form_incident_events(ee)
  lastdate = max(nytc$date)
  if (input$trim) iee = trim_from(iee, lastdate-30)
  plot(iee)
  })

}
 
  
   
