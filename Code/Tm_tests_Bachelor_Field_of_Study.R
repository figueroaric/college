library(tm)

FieldofStudy_Earnings_for_rep = read.csv("C:/Users/figue/Documents/Collegeboard_data/Field_of_Studies_Earn_rep.csv", stringsAsFactors = FALSE)
dim(FieldofStudy_Earnings_for_rep)
colnames(FieldofStudy_Earnings_for_rep)


#CIPDESC is the description . I would like to analyze

docs = FieldofStudy_Earnings_for_rep$CIPDESC

#Vector Source can create a Corpuse from the vector

Field.Corpus = VCorpus(VectorSource(docs))

inspect(Field.Corpus)

#transformations.

#Conver to lower case

Field.Corpus = tm_map(Field.Corpus, content_transformer(tolower))

#inspect contents of second record

inspect(Field.Corpus[[2]])




#there are still dots
#remove stop words

Field.Corpus = tm_map(Field.Corpus, removeWords, stopwords("english"))

#punctuation still ther

Field.Corpus = tm_map(Field.Corpus, removePunctuation)

#Document term matrix

Field.matrix = DocumentTermMatrix(Field.Corpus)

#applying pca https://www.datacamp.com/community/tutorials/pca-analysis-r

Field.matrix.pca = prcomp(Field.matrix , center= TRUE, scale = TRUE)

summary(Field.matrix.pca)

str(Field.matrix.pca)

biplot(Field.matrix.pca)

#biplots do not mean that much.
#Maybe we should only keep flags for words that repeat the most

max(Field.matrix)

sapply(Field.matrix,max, simplify=TRUE)




inspect(Field.matrix)

#apply some function
#terms that repeat 3 times
#findFreqTerms(Field.matrix,3)



#how to use pca
#https://www.hvitfeldt.me/blog/using-pca-for-word-embedding-in-r/
#https://www.displayr.com/text-analysis-hooking-up-your-term-document-matrix-to-custom-r-code/

# Convert to normal matrix in r
r.field.matrix = as.matrix(Field.matrix)

#Add the description names to 

rownames(r.field.matrix) = FieldofStudy_Earnings_for_rep$CIPDESC

#find most commong words
count_of_word = apply(r.field.matrix,2,sum)

count_of_word = count_of_word[order(count_of_word,decreasing=TRUE)]

#the most common is general 3,456 times

#there a total of 380 words. How many repeat more than 200 times in degreese

sum(count_of_word>200)

# 72. Keep those 72

count_of_word  = count_of_word [count_of_word>200]

#now just keep those columns in the r.field.matrix

r.field.matrix.red = r.field.matrix[,names(count_of_word)]

r.field.matrix.red = cbind(r.field.matrix.red, FieldofStudy_Earnings_for_rep[,c("STABBR","ADM_RATE","SAT_AVG","Salary_10Y_4Y_Tui")])
#change state to Factor
r.field.matrix.red$STABBR = as.factor(r.field.matrix.red$STABBR)
# now add more fields that can be used for first linear regression

lm.Ear.cost = lm(Salary_10Y_4Y_Tui ~ . , data=r.field.matrix.red)

summary(lm.Ear.cost)

# of the states, Territories, it seems like only one important is Puerto Rico. We can eliminate the state variable, and add flag for Puerto Rico
#Admission rates and SATs are very telling
#also have to remove items with na



# Add a flag for Insitutions in Puerto Rico

r.field.matrix.red$Puerto_Rico = ifelse(r.field.matrix.red$STABBR=="PR",1,0)

#remove STABBR not required for lm



r.field.matrix.red = r.field.matrix.red[,!colnames(r.field.matrix.red)=="STABBR"]

#another lm

lm.Ear.cost2 = lm(Salary_10Y_4Y_Tui ~ . , data=r.field.matrix.red)


summary(lm.Ear.cost2)

# have to use lasso to eliminate fields that are not good from a linear perspective
# The pca to do two dimensional chart
#homework 3 stanford

#use omit to remove records with na

r.field.matrix.red.nna = na.omit(r.field.matrix.red)

#linear regression with no nas

lm.Ear.cost3 = lm(Salary_10Y_4Y_Tui ~ . , data=r.field.matrix.red.nna)

summary(lm.Ear.cost3)

#Coefficients: (9 not defined because of singularities)
#due to colinearity
#have to remove the items that are colinear
#identify items that are perfectly correlated
(cor(r.field.matrix.red.nna[,c(1:72)])>.9)["teacher",]

r.field.matrix.red.nna[,c(1:72)]

#have to write function to eliminate correlation do this with r.field.matrix.red

matrix = cor(r.field.matrix.red)
#apply counts to see which are equal

# I can use apply to see the ones that add up to the same
# and remove the columns with duplicated numbers r keep the ones that are unique
colnames(r.field.matrix.red[,c(1:72)])[!duplicated(apply(r.field.matrix.red[,c(1:72)],2,sum))]

r.field.matrix.red_nocor = r.field.matrix.red[,c(colnames(r.field.matrix.red[,c(1:72)])[!duplicated(apply(r.field.matrix.red[,c(1:72)],2,sum))],"Puerto_Rico","ADM_RATE","SAT_AVG","Salary_10Y_4Y_Tui")]

#Do a linear regression

lm.Ear.cost4 = lm(Salary_10Y_4Y_Tui ~ . , data=r.field.matrix.red_nocor)

#areas seem to be highly correlated. Remove and try again

r.field.matrix.red_nocor = r.field.matrix.red_nocor[,colnames(r.field.matrix.red_nocor)!="areas"]

lm.Ear.cost4 = lm(Salary_10Y_4Y_Tui ~ . , data=r.field.matrix.red_nocor)

#now we can do Lasso to find which fields to remove.
#then PCA for visualization

# e) train a new model using lasso

library(glmnet)
#have to create a grid of values
grid = 10^seq(10,-2, length =100)

#I cannot use lasso because it is sparse matrix
#conver dataframes to matrix or vectors:
#have to divide predictors by standard deviation using all of original data. I will not recenter them

X.train=scale(as.matrix(r.field.matrix.red_nocor[,1:65]), center = FALSE, scale = apply(r.field.matrix.red_nocor[,1:65], 2, sd, na.rm = TRUE))

Y.train = as.matrix(r.field.matrix.red_nocor[,26])

# create multiple models using the grid of lambda values
lasso.mod =glmnet (X.train,Y.train,alpha =1, lambda =grid)
plot(lasso.mod)

#perform cross validation to choose best lambda
cv.out=cv.glmnet(X.train,Y.train,alpha =1)
plot(cv.out)
(bestlam=cv.out$lambda.min)

#see which coefficients become zero
lasso.coef=predict(lasso.mod,type="coefficients",s=bestlam )[1:22 ,]
lasso.coef


####
#I will remove coefficients that are not significant more than .05

lm.Ear.cost4$coefficients[2]

# retrieve the names of the variables that are significan
names.to.keep = names(summary(lm.Ear.cost4)[["coefficients"]][,"Pr(>|t|)"])[summary(lm.Ear.cost4)[["coefficients"]][,"Pr(>|t|)"]<.05] 

#except for intercept these are names in r.field.matrix.red_nocor. Remember that we also have to keep Salary_10Y_4Y_Tui

r.field.matrix.red_nocor.sig = r.field.matrix.red_nocor[,c(colnames(r.field.matrix.red_nocor)[colnames(r.field.matrix.red_nocor) %in% names.to.keep], "Salary_10Y_4Y_Tui")]

lm.Ear.cost5 = lm(Salary_10Y_4Y_Tui ~ . , data=r.field.matrix.red_nocor.sig)

#let's see if PCA is meaningful

#applying pca https://www.datacamp.com/community/tutorials/pca-analysis-r

# have to remove NAs/missing values
r.field.matrix.red_nocor.sig.nna = na.omit(r.field.matrix.red_nocor.sig)
r.field.matrix.red_nocor.sig.pca = prcomp(as.matrix(r.field.matrix.red_nocor.sig.nna) , center= TRUE, scale = TRUE)

summary(r.field.matrix.red_nocor.sig.pca)

str(r.field.matrix.red_nocor.sig.pca)

biplot(r.field.matrix.red_nocor.sig.pca)

#PCA is not relevant. Maybe use another methods like interactions or something like that