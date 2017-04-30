#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny);library(plotly);library(data.table)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        model1 <-lm (hp ~ mpg, data=mtcars)
        
        model2 <-reactive ( {
                mtcars.names <- names(mtcars)
                mtcars.subset <- brushedPoints(mtcars, input$brush1, yvar='hp', xvar='mpg')
                if (dim(mtcars.subset)[1] != 0) {
                        #mtcars.remain <- setDT(mtcars)[!mtcars.subset, key=mtcars.names]
                        dt1 <- data.table(mtcars, key=mtcars.names)
                        dt2 <- data.table(mtcars.subset)
                        mtcars.remain <- dt1[!dt2]
                        lm(hp ~ mpg, data = mtcars.remain)
                } else  {
                        NULL
                }
                
                # dataframe minus operation
                # Credit: http://stackoverflow.com/questions/16143445/minus-operation-of-data-frames
                # dt1 <- data.table(df1, key=c('c1', 'c2',...)
                # dt2 <- data.table(df2)
                # dt1[!dt2]
                # 
                # or one-line cmd
                # setDT(df1[!df2, on='c1'])
                # manual:
                # setDT(x, keep.rownames=FALSE, key=NULL, check.names=FALSE)
                
                
        })
        # dt1 <- data.table(df1, key=c('c1', 'c2',...)
        # dt2 <- data.table(df2)
        # dt1[!dt2]
        
        
        
        
        model1pred <- reactive( {
                predict(model1, newdata= data.frame(mpg=input$sliderMPG))
        })
        model2pred <- reactive( {
                if (is.null(model2())) {NULL}
                else {
                        predict(model2(), newdata=data.frame(mpg=input$sliderMPG))   
                }
                
        })
        

output$distPlot <- renderPlot({
        mpgInput <-input$sliderMPG
        par(5.1,4.1,2,2)
        plot(mtcars$mpg, mtcars$hp, xlab = 'Miles per Gallon',
                       ylab='house power', bty = 'n', col=levels(as.factor(mtcars$cyl)), pch=16, cex=1)
        legend('topright', legend=paste('cylinder: ',unique(mtcars$cyl)), col=levels(as.factor(mtcars$cyl)), pch=16)
        
        #plot_ly(mtcars, x=~mpg, y=~hp, xlab = 'Miles per Gallon',
        # p <- ggplot(mtcars, aes(x=mpg, y=hp)) +
        #         geom_point(aes(mpg,hp)) +
        #         geom_jetter(aes(mpg, hp),color = 'green') +
        #         #geom_smooth(aes(mpg,hp), method = lm, color='red',se=F)
        #         geom_line(data=prediectv)
        # ggplotly(p) %>% layout(dragmode = 'select')
        
        if(input$showModel1) {
                abline(model1, col = 'red', lwd=2)
        }
        if(input$showModel2 ) {
                if (!is.null(model2())) {
                        abline(model2(), col = rgb(0,1,1, alpha=.4), lwd=2)
                        }
        }

        points(mpgInput, model1pred(), col = 'red', pch = 16, cex=2)
        points(mpgInput, model2pred(), col = 'blue', pch=16, cex=2)
  })
  output$pred1 <- renderText(model1pred())
  output$pred2 <- renderText(model2pred())
 
   xystr<-function(x){
          xname<-names(x)[1]
          yname<-names(x)[2]
          lines<-apply(x,1, function(v) paste0(xname, "=", v[1], ", ", yname,"=",v[2], '\n' ))
          lines.txt <- paste0(unlist(lines))
          lines.txt
                       
  }

  output$table <- renderTable((brushedPoints(mtcars, input$brush1, yvar='hp', xvar='mpg')))
  
  output$brushText <- renderText(xystr(brushedPoints(mtcars, input$brush1, yvar='hp', xvar='mpg')))
  
  output$text2 <- renderText(dim(brushedPoints(mtcars, input$brush1, yvar='hp', xvar='mpg'))[1])
  
 
  
})
