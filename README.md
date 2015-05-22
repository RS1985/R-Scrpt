        Project
        https://github.com/RS1985/R-Scrpt/edit/master
        Project Assignment:


        Goal:
        Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data
about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, the goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).
        We will use the data mentioned above to develop a predictive model for this classes.
        The dependent variable is the “classe” variable in the training set.

        The training data for this project is available here:
        https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

        The testing data for this project is available here:
        https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

      I have downloaded the data files from that website and saved into "C:/Users/Rimli/Desktop/Coursera/Week3/Data".

       Data
       Importing data files:
       trainingRaw=read.csv("C:/Users/Rimli/Desktop/Coursera/Week3/Data/pml-training.csv", head=TRUE, sep=",")
       testingRaw=read.csv("C:/Users/Rimli/Desktop/Coursera/Week3/Data/pml-testing.csv", head=TRUE, sep=",")

      OR

      The data files can be imported directly from the given link:
       trainData = "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
       testData = "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

       trainingRaw = read.csv(url(trainData), na.strings=c("NA","#DIV/0!",""))
       testingRaw = read.csv(url(testData), na.strings=c("NA","#DIV/0!",""))

     Loading library used:

      library(lattice)
      library(ggplot2) 
      library(caret) 
      library(randomForest)


        dim(trainingRaw)
        [1] 19622  160
        There are 19622 records with 160 variables.
        nrow(trainingRaw)
        [1]  19622
        ncol(trainingRaw)
        [1]  160

summary(trainingRaw$classe)
    A       B        C       D        E
  5580    3797     3422    3216     3607

The variable we will predict is "classe", and the data has been split up between five classes.

Getting and Cleaning the data set:
At first we will exclude the columns with NA values from trainingRaw data set and make a new training data set:
Training <- trainingRaw
Training[ Training == '' | Training == 'NA']  <-  NA
ind  <- which(colSums(is.na(Training)) != 0)
Training <- Training[, -ind]
In order to look only at the variables related to the goal of the project, we can remove the first seven variables.
Training <- Training[,-(1:7)]

Cross Validation:
Next, we will split Training into a training set to train the model and a validate data set to test how good the model is:
InTrain  <-  createDataPartition(y = Training$classe, p = 0.70, list = FALSE)
NewTrain <- Training[InTrain, ]
NewTest <- Training[-InTrain, ]

Predicting Model:
We will now create a model to predict the "classe" using random forest on the remaining variables (this model took long time to run on my machine.)
library(lattice)
library(ggplot2)
library(caret)
library(randomForest)

randomForest 4.6-10

Type rfNews() to see new features/changes/bug fixes.

modelFit <- train(classe~.,  data = NewTrain,  method = "rf",  tuneLength = 1,  ntree = 25)

modelFit 
Random Forest
 13737 samples
 52 predictors
 5 classes:        'A',       'B',       'C',       'D',       'E'
No pre-processing
Resampling:   Bootstrapped (25 reps)
Summary of sample sizes:    13737,    13737,    13737,    13737,    13737,    13737, ...
Resampling results
                                           Accuracy      Kappa            Accuracy SD        Kappa SD
                                           0.987425     0.9840931         0.001927406       0.002429363
Tuning parameter 'mtry' was held constant at a value of 17


Evaluating the model:

Once we have trained the model on the training data, we can test the model on the validate data set:
mean(predict(modelFit,  NewTest) == NewTest$classe) * 100
[1]  100

Using Confussion Matrix to evaluate the Prediction Model set versus the testing Data set.

confusionMatrix(predict(modelFit,  NewTest), NewTest$classe)

Confusion Matrix and Statistics
  
                                       Reference

               Prediction              A      B      C      D      E
                       A             1163     0      0      0      0
                       B               0     819     0      0      0
                       C               0      0     708     0      0
                       D               0      0      0     672     0
                       E               0      0      0      0     761

 Overall Statistics
                                             Accuracy : 1
                                                95% CI : (0.9991, 1)
                            No Information Rate : 0.2821
                             P-Value [Acc > NIR] : < 2.2e-16

                                                  Kappa : 1
                     Mcnemar's Test P-Value : NA

Statistics by Class:
                                         Class:  A     Class:  B     Class:  C     Class:  D     Class:  E
              Sensitivity                  1.0000        1.0000        1.0000        1.000         1.0000
              Specificity                  1.0000        1.0000        1.0000        1.000         1.0000
              Pos Pred Value               1.0000        1.0000        1.0000        1.000         1.0000
              Neg Pred Value               1.0000        1.0000        1.0000        1.000         1.0000
              Prevalence                   0.2821        0.1986        0.1717        0.163         0.1846
              Detection Rate               0.2821        0.1986        0.1717        0.163         0.1846
              Detection Prevalence         0.2821        0.1986        0.1717        0.163         0.1846
              Balanced Accuracy            1.0000        1.0000        1.0000        1.000         1.0000


Comparing Accuracy of the model:

accurate <- c(as.numeric(predict(modelFit,  newdata = NewTest[, -ncol(NewTest)]) == NewTest$classe))
Accuracy <- sum(accurate)*100/nrow(NewTest)
message("Accuracy of Prediction Model set VS Validate Data set = ", format(round(Accuracy, 2), nsmall=2),"%")
Accuracy of Prediction Model set VS Validate Data set = 100.00%

Conclusion:

Hence the result shows a 100% accuracy which proves that the random forest really fits well in this case.


Prediction on the Testing set:

nrow(testingRaw)
[1]  20
ncol(testingRaw)
[1]   160
Predictiontest <- predict(modelFit,  testingRaw)
Predictiontest
[1]    B   A   B   A   A   E   D   B   A   A   B   C   B   A   E   E   A   B   B   B
Levels:  A   B   C   D   E



Generating Files for the Assignment:
pml_write_files = function(x){
 n = length(x)
 for(i in 1:n) {
 filename = paste0("problem_id_",i,".txt")
 write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
 }
 }

setwd("C:/Users/Rimli/Desktop/Coursera/Week3/R-Scrpt/Predict on Test data")
pml_write_files(Predictiontest)

