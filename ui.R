require(shiny)
require(slidify)
require(knitr)
require(slidifyLibraries)
require(dplyr)
require(googleVis)

source("./supportCode/processData.R")

dataList <<- processData()
states <- levels(dataList$Total$State)


shinyUI(
        navbarPage("Selection",
                tabPanel("Reports",
                         navbarPage("Arrests",
                                    
                                    
                                   ##Inside tab panel 1
                                    
                                    tabPanel("Arrests U.S. map",pageWithSidebar(
                                            headerPanel(""),
                                            sidebarPanel(
                                                    selectInput(inputId = "age", label = "Choose age category", 
                                                                names(dataList)),
                                                            selectInput(inputId = "crime", label = "Choose crime", 
                                                                       names(dataList$Total)[2:32]),
                                                    submitButton(text = "Show")
                                                            
                                            ),
                                            mainPanel(                                 
                                                    textOutput("arrested"),
                                                    textOutput("crime"),
                                                    htmlOutput("map")
                                            )
                                    )),
                                   
                                   ##Inside tab panel 2
                                   
                                    tabPanel("Arrests by state",pageWithSidebar(
                                            headerPanel(""),
                                            sidebarPanel(
                                                    selectInput(inputId = "state", label = "Choose state", 
                                                                states),
                                                    checkboxGroupInput(inputId = "crime.for.state", label = "Select crime", 
                                                                       names(dataList$Total)[2:32]),
                                                    submitButton(text = "Show")
                                                    
                                            ),
                                            mainPanel(                   
                                                    textOutput("states"),
                                           fluidRow(
                                                   column(imageOutput("map.state"),width = 3),
                                                   column(htmlOutput("pie"),width = 7, offset = 2)
                                            ),
                                      
                                            fluidRow(
                                                    dataTableOutput("table")
                                            )
                                            )
                                            
                                    )),
                                    
                                   ##Inside tab panel 3
                                   
                                   
                                    tabPanel("Compare States",pageWithSidebar(
                                            headerPanel(""),
                                            sidebarPanel(
                                                    
                                                    radioButtons("scale", label = "Scale",
                                                                 c("No","Yes")),
                                                    h3("Choose crimes to compare"),
                                                    
                                                    selectInput(inputId = "crimeId1", label="",
                                                               choices = names(dataList$Total)[2:32]),
                                                    selectInput(inputId = "crimeId2", label="",
                                                                choices = names(dataList$Total)[2:32]),
                                                    selectInput(inputId = "crimeId3", label="",
                                                                choices = names(dataList$Total)[2:32]),
                                                    
                                                    h3("Choose States to compare"),
                                                    
                                                    selectInput(inputId = "stateId1", label="",
                                                                choices = states),
                                                    selectInput(inputId = "stateId2", label="",
                                                                choices = states),
                                                    selectInput(inputId = "stateId3", label="",
                                                                choices = states),
                                                    submitButton(text = "Compare")
                                                    ),
                                                    
                                                    mainPanel(  
                                                            h3("Compare States"),
                                                            htmlOutput("plt"),
                                                            h3("Table View"),
                                                            htmlOutput("gtab")
                                                    )
                                            ))
                                            
                                    )
                                    
                                    
                         ),
                tabPanel("Description",
                         fluidPage(
                                 div(
                                         shiny::p("This report I aimed to visualize the \"Arrests, by State, 2013\" 
                                                FBI data that can be 
                                                downloaded from"), 
                                                a(href = "https://www.fbi.gov/about-us/cjis/ucr/crime-in-the-u.s/2013/crime-in-the-u.s.-2013/tables/table-69/table_69_arrest_by_state_2013.xls","https://www.fbi.gov/about-us/cjis/ucr/crime-in-the-u.s/2013/crime-in-the-u.s.-2013/tables/table-69/table_69_arrest_by_state_2013.xls"),
                                                p("The data was devided into three tables: Total(data for all ages), Under 18 and Over 18(for juveniles and not)."),
                                                p("The application consists of four main tabs and two of them have three sub tabs inside:"),
                                       
                                         p("1. ",tags$span(style="color:blue", "Reports")),
                                                        
                                         p("                       - Arrests U.S. map "), 
                                         p(" tab is displaying The USA map with states that are colored from green through yellow to red according to the selected crime and data table type. Here user needs to select age category and crime type, then press \"Show\" button to view the results. "),
                                           p("                       - Arrests by state  "), 
                                         p("shows the state map user had selected and a pie chart of most often arrests in that state. The side panel also has all types of crimes available in the data base. By selecting types of crimes and pressing \"Show\" the  user views only the crime types he/she interested in."),
                                         p("                       - Compare States        "),
                                         p("lets users to compare up to three states and up to three crimes. The scale radio button offers the ability to log scale the data to be able to view  figures of the same type that differ greatly."),
                                         p("Note: scaled data is only used in a plot, not in table view!!!"),    
                                         p("            2. ",tags$span(style="color:blue", "Description")),
                                                p("        3. ",tags$span(style="color:blue", "How to use")),
                                         p("Here you can find an image guide on how to use the application. The guide is devided into the same three tabs as the Report page for ease of navigation"),                
                                               p("             - Arrests U.S. map"),        
                                                  p("              - Arrests by state"),        
                                                 p("           - Compare States        "),
                                                    p("    4. ",tags$span(style="color:blue", "Source code")),
                                         p("   Contains github link")
                                         )
                         )
                ),
                tabPanel("How to use",
                         navbarPage("User guide",                                    
                                    
                            ##Inside help panel 1
                            
                            tabPanel("Arrests U.S. map",
                                     fluidPage(
                                             mainPanel(
                                                     h3("1. In this tab you first have to choose the data table:"),
                                                     img(src = "selectage.png"),
                                                     h3("2. Now choose the crime type:"),
                                                     img(src = "selectcrime.png"),
                                                     h3("3. Push the button to see the results:"),
                                                     img(src = "show.png")
                                             )
                                        )
                                     ),
                            ##Inside help panel 1
                            tabPanel("Arrests by state",
                                     fluidPage(
                                             mainPanel(
                                                     
                                                     h3("Here you can see the map of the selected state and a pie chart with 5 most often arrest types"),
                                                     img(src = "tab2.png"),
                                                     h3("1. Select state:"),
                                                     img(src = "state2.png"),
                                                     h3("2. Now choose the crime type:"),
                                                     img(src = "crime2.png"),
                                                     h3("3. Push the button to see the results:"),
                                                     img(src = "show2.png")
                                             )      
                                     ) 
                                     
                            ),
                            ##Inside help panel 3
                            
                            
                            tabPanel("Compare States",
                                     fluidPage(
                                             mainPanel(
                                                     
                                                     h3("Compare states tab allows you to compare up to three states and up to three crimes"),
                                                     h3("1. Choose up to three crime types and states:"),
                                                     img(src = "crime3.png"),
                                                      h3("2. Press Compare button to view results:"),
                                                     img(src = "compare.png"),
                                                     h3("Some figures in the data are much smaller than others, so it is hard to see them on the plot. Please use scale option to see them."),
                                                     img(src = "scale.png")
                                             )      
                                     ) 
                         )
                         
                         
                        
                         
                 )),
                tabPanel("Source Code",
                         fluidPage(
                                        h3("For the source code please visit:"),
                                        a("https://github.com/dimakg/ArrestsUSA", href = "https://github.com/dimakg/ArrestsUSA")
                                 )
                         )
        )
                
)