processData <- function(url = "./data/table_69_arrest_by_state_2013.csv"){
        #project
        require(dplyr)
        
        
        #Downloading data
        data<-read.table(url,header = TRUE, sep = ',')
        
        #Data processing
        #setting second column to age (can have two values: under 18 and total)
        names(data)[2]<-"Age"
        
        #removing indexes from the column names and states
        names(data)<-sub(pattern = "[0-9]$",replacement = "", names(data))
        data$State<-tolower(sub(pattern = "[0-9]+(.*)",replacement = "", data$State))
        data$State <- tolower(data$State)      
        
        names(data)<-gsub("\\."," ", names(data))
        
        #adding state names to missing values in the column
        for(i in 1:length(data[,1])){
                if(data[i,1]==""){
                        data[i,1]<-data[i-1,1]
                        data[i,35]<-data[i-1,35]
                        data[i,34]<-data[i-1,34]
                }
        }
        
        data <- filter(data,data$State!="district of columbia") 
        
        names(data)[names(data) == "Total all  classes"] <- "All types of crimes"
        
        #removing whitespces from the end
        data$State <- vapply(data$State, function (x){ sub("\\s+$", "", x)}, FUN.VALUE = "vector")
        
        #making state names suitable for gvis
        for(i in 1:length(data$State)){
                data$State[i]<-paste(toupper(substr(data$State[i],1,1)),substr(data$State[i],2,nchar(data$State[i])),sep = "")
                
                if(grepl(" ",data$State[i])){
                        str <- strsplit(data$State[i]," ")
                        data$State[i] <- paste(str[[1]][1],
                                               paste(toupper(substr(str[[1]][2],1,1)),
                                                     substr(str[[1]][2],2,nchar(str[[1]][2])),sep = ""),
                                               sep = " ")
                }
        }
        
        
        data$State <- as.factor(data$State)
        
        #Turning numeric columns from factor to numeric
        data[,3:dim(data)[2]]<- as.numeric(apply(data[,3:dim(data)[2]],
                                             2,function(x){return(gsub(",","",x))}))
        
        #Deviding data into three groups: 
        # Under 18
        # Over 18
        # Total
        
        dataUnder <- data%>%filter(Age == "Under 18")
        dataTotal <- data%>%filter(Age != "Under 18")
        dataOver <- dataTotal[,3:dim(data)[2]]-dataUnder[,3:dim(data)[2]]
        dataOver<- cbind(dataTotal[,1:2],dataOver)
        
        dataOver<-dataOver%>%select(-Age)
        dataUnder<-dataUnder%>%select(-Age)
        dataTotal<-dataTotal%>%select(-Age)
        
        lst<-list("Total" = dataTotal, "Over 18" = dataOver, "Under 18" = dataUnder)
        
        return(lst)
}
