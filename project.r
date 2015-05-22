     trainingRaw=read.csv("C:/Users/Rimli/Desktop/Coursera/Week3/Data/pml-training.csv", head=TRUE, sep=",")
     testingRaw=read.csv("C:/Users/Rimli/Desktop/Coursera/Week3/Data/pml-testing.csv", head=TRUE, sep=",")

     trainData <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
     testData <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

      trainingRaw <- read.csv(url(trainData), na.strings=c("NA","#DIV/0!",""))
      testingRaw <- read.csv(url(testData), na.strings=c("NA","#DIV/0!",""))

      Training<-trainingRaw
      Training[ Training == '' | Training == 'NA'] <- NA
      ind <-which(colSums(is.na(Training))!=0)
      Training<-Training[, -ind]
      Training<-Training[,-(1:7)]
      library(lattice)
      library(ggplot2)
      library(caret)
      InTrain  <- createDataPartition(y=Training$classe,p=0.70,list=FALSE)
      NewTrain <- Training[InTrain,]
      NewTest <- Training[-InTrain,]
      
      library(randomForest)
      modelFit <- train(classe~., data=NewTrain, method = "rf", tuneLength = 1, ntree = 25)
      
      confusionMatrix(predict(modelFit, NewTest), NewTest$classe)


      mean(predict(modelFit, NewTest) == NewTest$classe) * 100
      accurate <- c(as.numeric(predict(modelFit,newdata=NewTest[,-ncol(NewTest)])==NewTest$classe))
      Accuracy <- sum(accurate)*100/nrow(NewTest)
      message("Accuracy of Prediction Model set VS Validate Data set = ", format(round(Accuracy, 2), nsmall=2),"%")

      nrow(TestingRaw)
      Predictiontest<-predict(modelFit, testingRaw)

      pml_write_files = function(x){
      n = length(x)
      for(i in 1:n){
      filename = paste0("problem_id_",i,".txt")
      write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
       }
     }

      setwd("C:/Users/Rimli/Desktop/Coursera/Week3/R-Scrpt/Predict on Test data")
      pml_write_files(Predictiontest)
