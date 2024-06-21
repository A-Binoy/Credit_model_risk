library(e1071)
library(randomForest)
library(skimr)
library(dplyr)
library(ggplot2)
source("../Credit Risk Assessment/credit_func.R")

credit_data <- read.csv("../Credit Risk Assessment/credit_risk_dataset.csv")

# Remove the columns that are not needed
credit_data <- subset(credit_data, select = -c(person_emp_length, loan_intent, loan_percent_income))

png("../Credit Risk Assessment/person_age_distribution.png")
hist(credit_data$person_age, main = "Distribution of Person Age", xlab = "Age")
dev.off()

png("../Credit Risk Assessment/loan_grade_distribution.png")
barplot(table(credit_data$loan_grade),
        main = "Loan Grade Distribution",
        xlab = "Loan Grade",
        ylab = "Count",
        col = "skyblue")
dev.off()

# Target variable distribution
png("../Credit Risk Assessment/loan_status_distribution.png")
barplot(table(credit_data$loan_status),
        main = "Loan Status Distribution",
        xlab = "Loan Status",
        ylab = "Count",
        col = "lightgreen")
dev.off()

loan_amount_summary <- aggregate(loan_amnt ~ loan_status, data = credit_data, FUN = mean)
png("../Credit Risk Assessment/loan_amount_distribution_bar.png")
barplot(loan_amount_summary$loan_amnt,
        main = "Mean Loan Amount by Loan Status",
        xlab = "Loan Status",
        ylab = "Mean Loan Amount",
        ylim = c(0, 12000),
        names.arg = c("Not Approved", "Approved"),
        col = c("lightcoral", "lightgreen"))
dev.off()

png("../Credit Risk Assessment/home_ownership_distribution.png")
pie(table(credit_data$person_home_ownership),
        main = "Home Ownership Distribution",
        col = rainbow(length(unique(credit_data$person_home_ownership))),
        labels = c("MORTGAGE", "OWN", "RENT"),
        cex = 0.8)
dev.off()

# Data cleaning and preprocessing
credit_data <- na.omit(credit_data) # Check for missing values
credit_data$cb_person_default_on_file <- factor(credit_data$cb_person_default_on_file)
credit_data$loan_grade <- factor(credit_data$loan_grade)
credit_data$person_home_ownership <- factor(credit_data$person_home_ownership)
credit_data$loan_status <- factor(credit_data$loan_status)
print(paste("THE NUMBER OF NA", sum(is.na(credit_data$loan_status))))
duplicated_rows <- duplicated(credit_data)
print(paste("Dimensions of original data:", nrow(credit_data), "rows,", ncol(credit_data), "columns"))
credit_data <- credit_data[!duplicated_rows, ]
print(paste("Dimensions of data after removing duplicates:", nrow(credit_data), "rows,", ncol(credit_data), "columns"))
# Remove rows where age is greater than 80
print(paste("Number of rows with age greater than 80:", nrow(credit_data[credit_data$person_age > 80, ])))
print(paste("Dimensions of original data:", nrow(credit_data), "rows,", ncol(credit_data), "columns"))
credit_data <- credit_data[credit_data$person_age <= 80, ]
print(paste("Dimensions of data after filtering:", nrow(credit_data), "rows,", ncol(credit_data), "columns"))

# feature engineering
credit_data$credit_score <- mapply(Cscore,
                                   credit_data$person_age,
                                   credit_data$person_income,
                                   credit_data$person_home_ownership,
                                   credit_data$loan_grade,
                                   credit_data$loan_amnt,
                                   credit_data$loan_int_rate,
                                   credit_data$loan_status,
                                   credit_data$cb_person_default_on_file,
                                   credit_data$cb_person_cred_hist_length)

# Convert credit_score to numeric
credit_data$credit_score <- as.numeric(credit_data$credit_score)

credit_data_2 <- credit_data %>%
  mutate(person_home_ownership = as.numeric(factor(person_home_ownership)),
         loan_grade = as.numeric(factor(loan_grade)),
         loan_status = as.numeric(factor(loan_status)),
         cb_person_default_on_file = as.numeric(factor(cb_person_default_on_file)))
credit_data_2 <- credit_data_2 %>%
  mutate(across(where(is.factor), as.numeric)) %>%
  mutate(across(where(is.character), as.numeric))


corr <- cor(credit_data_2)
corr_long <- as.data.frame(as.table(corr))
names(corr_long) <- c("Variable1", "Variable2", "Correlation")

# Plot heatmap using ggplot2
heatmap_plot <- ggplot(corr_long, aes(x = Variable1, y = Variable2, fill = Correlation)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                       midpoint = 0, limits = c(-1, 1), name = "Correlation") +
  labs(x = NULL, y = "Variables", title = "Correlation Heatmap") +
  theme(axis.text.x = element_blank())
png("../Credit Risk Assessment/heatmap.png", width = 10, height = 8, units = "in", res = 300)
print(heatmap_plot)
dev.off()

# Percentages of Home Ownership
ownership_counts <- table(credit_data$person_home_ownership)
ownership_percentages <- prop.table(ownership_counts) * 100
print(ownership_percentages)

png("../Credit Risk Assessment/home_ownership_factor.png")
pie(table(credit_data$person_home_ownership),
    main = "Home Ownership Distribution after Factorization",
    col = rainbow(length(levels(credit_data$person_home_ownership))),
    labels = levels(credit_data$person_home_ownership),
    cex = 0.8)
dev.off()

png("../Credit Risk Assessment/person_age_distribution_aft_clean.png")
hist(credit_data$person_age, main = "Distribution of Person Age", xlab = "Age")
dev.off()

png("../Credit Risk Assessment/default_history_pie_chart.png")
pie(table(credit_data$cb_person_default_on_file),
    main = "Default History Distribution",
    col = rainbow(length(levels(credit_data$cb_person_default_on_file))),
    labels = levels(credit_data$cb_person_default_on_file),
    cex = 0.8)
dev.off()

# To ensure we get the same data set every time we set the seed
set.seed(123)
train_index <- sample(nrow(credit_data), 0.7 * nrow(credit_data))  # 70 - 30 split
train_data <- credit_data[train_index, ]
test_data <- credit_data[-train_index, ]

# General Regression Model
logistic_model <- glm(loan_status ~ ., data = train_data, family = binomial)
predictions_logistic <- predict(logistic_model, newdata = test_data, type = "response")
predicted_classes_logistic <- ifelse(predictions_logistic > 0.5, 1, 0)
confusion_matrix_logistic <- table(test_data$loan_status, predicted_classes_logistic)
accuracy_logistic <- sum(diag(confusion_matrix_logistic)) / sum(confusion_matrix_logistic)
precision_logistic <- confusion_matrix_logistic[2,2] / sum(confusion_matrix_logistic[,2])
recall_logistic <- confusion_matrix_logistic[2, 2] / sum(confusion_matrix_logistic[2, ])
print(paste("Logistic Regression Precision:", round(precision_logistic, 2)))
print(paste("Logistic Regression Recall (Sensitivity):", round(recall_logistic, 2)))
print(paste("Logistic Regression Accuracy:", round(accuracy_logistic, 2)))
print("Confusion Matrix for Logistic Regression:")
print(confusion_matrix_logistic)

# Naive Bayes Model
nb_model <- naiveBayes(loan_status ~ ., data = train_data)
predictions_nb <- predict(nb_model, newdata = test_data)
confusion_matrix_nb <- table(test_data$loan_status, predictions_nb)
accuracy_nb <- sum(diag(confusion_matrix_nb)) / sum(confusion_matrix_nb)
precision_nb <- confusion_matrix_nb[2,2] / sum(confusion_matrix_nb[,2])
recall_nb <- confusion_matrix_nb[2, 2] / sum(confusion_matrix_nb[2, ])
print(paste("Naive Bayes Precision:", round(precision_nb, 2)))
print(paste("Naive Bayes Recall (Sensitivity):", round(recall_nb, 2)))
print(paste("Naive Bayes Accuracy:", round(accuracy_nb, 2)))
print("Confusion Matrix for Naive Bayes:")
print(confusion_matrix_nb)

# Random Forest Model
rf_model <- randomForest(loan_status ~ ., data = train_data)
predictions_rf <- predict(rf_model, newdata = test_data)
confusion_matrix_rf <- table(test_data$loan_status, predictions_rf)
accuracy_rf <- sum(diag(confusion_matrix_rf)) / sum(confusion_matrix_rf)
precision_rf <- confusion_matrix_rf[2,2] / sum(confusion_matrix_rf[,2])
recall_rf <- confusion_matrix_rf[2, 2] / sum(confusion_matrix_rf[2, ])
print(paste("Random Forest Precision:", round(precision_rf, 2)))
print(paste("Random Forest Recall (Sensitivity):", round(recall_rf, 2)))
print(paste("Random Forest Accuracy:", round(accuracy_rf, 2)))
print("Confusion Matrix for Random Forest:")
print(confusion_matrix_rf)
