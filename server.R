source("./supportCode/processData.R")
require(reshape2)

dataList <- processData()

shinyServer(
        function(input,output){
        
           ##Inside tab 1
           output$arrested <- renderText(arrested())
           output$crime <- renderText(paste("Crime selected:",input$crime))
                
           output$map<-renderGvis(gvisGeoChart(data(),"State",input$crime,
                    options=list(region="US", displayMode="regions", 
                                 resolution="provinces",
                                 width=500, height=400,
                                 colorAxis="{colors:['#448800', '#b8d000','#bb0000']}"
                    ))
           )
           
           ##Inside tab 2
           output$states <- renderText(paste("State selected:",input$state))
           

        ##images of states
        output$map.state <- renderImage({
               return(
                        list(
                                src = normalizePath(file.path(paste("./data/image/",input$state,".jpg",sep=""))),                               
                                contentType = "image/jpg", height = 300, width = 300,
                                alt = "Unfortunately I could'n find the suitable image"
                                )
                       ) 
                
        }, delete = FALSE)
      
        
        ##pie chart of 5 most often arrests in the selected state
        output$pie<-renderGvis(gvisPieChart(
                        pieData(), options=list(
                                        title = "Most often arrests in the selected state"
                                )
                )
        )
            
        ##state information
        output$table <- renderDataTable({
                data <- processData(); 
                dataT <- data$Total;
                dataT <- dataT[dataT$State == input$state,]
                dataO <- data[["Over 18"]];
                dataO <- dataO[dataO$State == input$state,]
                dataU <- data[["Under 18"]];
                dataU <- dataU[dataU$State == input$state,]
                dataAll<-rbind(dataT,dataU,dataO)
                dataAll$State <- c("Total Arrests", "Arrests Under 18","Arrests Over 18")
                names(dataAll)[1] <- "Age"
                dataAll <- dataAll[,c("Age",input$crime.for.state)]
                dataAll                
        })
        
         
        
        ##Inside tab 3
        output$plt <- renderGvis(
                        gvisColumnChart(data = compare()[["data"]], xvar = "State", 
                                yvar = c(input$crimeId1,input$crimeId2,input$crimeId3),
                                options=list(
                                        legend = "bottom",
                                        vAxes = "[{title: 'Arrests'}]",
                                        hAxes = "[{title: 'States'}]"
                                )
                        )
                        
                )
        
        output$gtab <- renderGvis(
                        gvisTable(
                                     data = compare()[["table"]]
                                )
                )
        
       
        ##Description tab
       
        
        ##Support functions
        
        ##getting selected DB
        data<- reactive(
                {
                        if(input$age == "Total"){
                                renderData<-dataList$Total;
                        }else if(input$age == "Over 18"){
                                renderData<-dataList$Over;  
                        }else{
                                renderData<-dataList$Under; 
                        }
                }
                        )
        arrested <- reactive(
                {
                        if(input$age == "Total"){
                                text<-"Arrested people in total";
                        }else if(input$age == "Over 18"){
                                text<-"Arrested people over 18"; 
                        }else{
                                text<-"Arrested people under 18"; 
                        }
                }
                )
                
        compare <- reactive({
                data = processData()[["Total"]];
                data<-filter(data, State==input$stateId1|State==input$stateId2|State==input$stateId3);
                data<-data[,c("State",input$crimeId1,input$crimeId2,input$crimeId3)];
                dataTable <- as.data.frame(data);
                if(input$scale=="Yes"){
                        scaled<-log(data[,c(input$crimeId1,input$crimeId2,input$crimeId3)]+1);
                        data<-cbind(data["State"],scaled);
                }
                data<-as.data.frame(data);
                dlist<-list("data" = data, "table" = dataTable)
                dlist
        })

        pieData <- reactive({
                data = processData()[["Total"]];
                data<-filter(data, State==input$state);
                data <- data[,3:32];
                data<-melt(data);
                data <- tail(arrange(data,value),5);                
                data
        })

     }          
                
)