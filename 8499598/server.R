library(shiny)
library(mc2d)
library(ggplot2)
library(scales)
 
shinyServer(function(input,output){
	
	values <- reactiveValues() 
	
	values$N <- 50000
	values$run <- "no"
	
	observe({
		
		if (input$runmodel != 0) {
			
			isolate({
				
				values$N <- input$N

				TEFestimate <- data.frame(L = input$tefl,  ML = input$tefml,  H = input$tefh, CONF = input$tefconf)
				TSestimate <- data.frame(L = input$tcapl,  ML = input$tcapml,  H = input$tcaph, CONF = input$tcapconf)
				RSestimate <- data.frame(L = input$csl,  ML = input$csml,  H = input$csh, CONF = input$csconf)
				LMestimate <- data.frame(L = input$lml, ML = input$lmml, H = input$lmh, CONF = 1)
		
				LMsample <- function(x){
				  return(sum(rpert(x, LMestimate$L, LMestimate$ML, LMestimate$H, shape = LMestimate$CONF) ))
				}
		
				TEFsamples <- rpert(values$N, TEFestimate$L, TEFestimate$ML, TEFestimate$H, shape = TEFestimate$CONF)
				TSsamples <- rpert(values$N, TSestimate$L, TSestimate$ML, TSestimate$H, shape = TSestimate$CONF)
				RSsamples <- rpert(values$N, RSestimate$L, RSestimate$ML, RSestimate$H, shape = RSestimate$CONF)
		
				VULNsamples <- TSsamples > RSsamples
				LEF <- TEFsamples[VULNsamples]
		
				values$ALEsamples <- sapply(LEF, LMsample)
				values$VAR <- quantile(values$ALEsamples, probs=(0.95))
				
			})

		}
		
	})
	
	output$detail <- renderPrint({
		if (input$runmodel != 0) {
			print(summary(values$ALEsamples));
		}
	})
	
	output$detail2 <- renderPrint({
		if (input$runmodel != 0) {
			print(paste0("Losses at 95th percentile are $", format(values$VAR, nsmall = 2, big.mark = ",")));
		}
	})
	
		  
	output$plot <- renderPlot({

		if (input$runmodel != 0) {
		
			ALEsamples <- values$ALEsamples 
						
			gg <- ggplot(data.frame(ALEsamples), aes(x = ALEsamples))
			gg <- gg + geom_histogram(binwidth = diff(range(ALEsamples)/50), aes(y = ..density..), color = "black", fill = "white")
			gg <- gg + geom_density(fill = "steelblue", alpha = 1/3)
			gg <- gg + scale_x_continuous(labels = comma)
			gg <- gg + theme_bw()
		
			print(gg)

		}	

	})
     
})