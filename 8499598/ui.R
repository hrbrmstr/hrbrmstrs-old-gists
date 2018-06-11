shinyUI(pageWithSidebar(
	
    headerPanel("SolvoMediocris"),
		
    sidebarPanel(
			
			tags$head(
        tags$style(type="text/css", "input { font-size:10px; width:40px; display:inline-block; }"),
        tags$style(type="text/css", "#lml, #lmml, #lmh, #lmconf { font-size:11px; width:100px; display:inline-block; }"),
        tags$style(type="text/css", "#N { font-size:14px; width:200px; display:inline-block; }"),
        tags$style(type="text/css", "label[for=N] { font-size:14px; display:inline-block; }"),
        tags$style(type="text/css", "label { font-size:10px; display:inline-block; }")
			),
			
			h4("Threat Event Frequency"),
	    numericInput("tefl", "Min:", 10, min = 0, max = 100),
	    numericInput("tefml", "ML:", 20, min = 0, max = 100),
	    numericInput("tefh", "Max:", 100, min = 0, max = 100),
	    numericInput("tefconf", "Conf:", 1, min = 1, max = 5),
			
			h4("Threat Capability"),
	    numericInput("tcapl", "Min:", 20, min = 0, max = 100),
	    numericInput("tcapml", "ML:", 30, min = 0, max = 100),
	    numericInput("tcaph", "Max:", 70, min = 0, max = 100),
	    numericInput("tcapconf", "Conf:", 1, min = 1, max = 5),
			
			h4("Control Strength"),
	    numericInput("csl", "Min:", 40, min = 0, max = 100),
	    numericInput("csml", "ML:", 50, min = 0, max = 100),
	    numericInput("csh", "Max:", 60, min = 0, max = 100),
	    numericInput("csconf", "Conf:", 2, min = 1, max = 5),
			
			h4("Loss Magnitude"),
	    numericInput("lml", "Min:", 100, min = 0),
	    numericInput("lmml", "ML:", 500, min = 0), br(),
	    numericInput("lmh", "Max:", 10000, min = 0),
	    numericInput("lmconf", "Conf:", 1, min = 1, max = 5), br(),
	    
			numericInput("N", "# Iterations:", 50000, min = 1000, step=1000), br(),
			
			actionButton("runmodel", "Run Model"),
			
			div(HTML("<br/><small>(App brought to you by <a href='http://datadrivensecurity.info'>Data Driven Security</a>)</small>"))
			
    ),
		
    mainPanel(
        tabsetPanel(
            tabPanel("Distribution", plotOutput("plot")),
            tabPanel("Detail", verbatimTextOutput("detail"), verbatimTextOutput("detail2"))
        )
    )
		
))