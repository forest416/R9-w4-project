#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
# customize html page apperance
tags$head( 
        tags$style(
                HTML( #Arial,Helvetica
                        'body {
                                background-color: #e1f2eb
                        }
                        html {font-size:8t}
                        html {font-family: "Times New Roman", Georgia, Serif}
                        <basefont color="#FF0000" face="Helvetica" size="-3 />
                       '
                )
        )
),
  # Application title
  titlePanel('Predict Horsepower from MPG - 20170429 R9-w4 proj', windowTitle = 'Predict Horsepower from MPG'),
 
  column(  width=12,    
        fluidRow(
                column(4, 
                        sliderInput('sliderMPG', 'Select MPG for HP predict: ' , 10, 35, value=20),
                        p(strong('Model 1: '),'What\'s the predict HP by given MPG?',
                                HTML('<font color="red">'),
                                        strong(textOutput("pred1", inline=T)),
                                HTML('</font>')),
                        checkboxInput('showModel1', 'Show/Hide prediction line. No data excluded', value=T),
                       
                        p(strong('Model 2: '),'And What if exclude certain point(s) from predction modeling?', 
                                HTML('<font color="blue">'),
                                        strong(textOutput("pred2", inline=T)),
                                HTML('</font>
                                     * <span style="font-size:0.8em">
                            Use brush to select points to be excluded for prediction model</span><p/>')),
                        checkboxInput('showModel2', 'Show/Hide prediction line.',  value=T)
                        
                       
                ),
                column(8,
                       plotOutput('distPlot', brush = brushOpts(id='brush1'))
                      
                )
        ),
  fluidRow(
          p('Excluded ',strong(textOutput('text2', inline=T)), 'data point:'),
                #column(2, dataTableOutput('table') )
                column(12, tableOutput('table') )
        )
      )
))
