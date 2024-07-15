# Loan Eligibility Prediction Model

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Data](#data)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Cleaning](#data-cleaning)
- [Feature Engineering](#feature-engineering)
- [Methodology](#methodology)
- [Results](#results)
- [Discussion](#discussion)
- [Conclusion](#conclusion)

## Introduction
Access to credit in the form of loans is crucial as it allows for economic growth and individual financial stability. Banks use various assessment techniques to determine if someone should qualify for a loan. Most of these involve using a credit score, which may not be accurate, available, or reliable for all individuals,
especially in emerging markets or for those with limited credit history. The objective of this project is to create and validate a model that predicts whether someone should receive a loan or not when their credit score is not available.

## Features

- Predict loan eligibility without using a credit score.
- Utilizes various machine learning models: Logistic Regression, Naive Bayes, and Random Forest.
- Provides a new feature (C-score) to enhance model performance.

## Data
I obtained a dataset from Kaggle. The link for the dataset is [here](https://www.kaggle.com/datasets/laotse/credit-risk-dataset)

## Exploratory Data Analysis
I performed exploratory data analysis on this dataset and generated various graphs in order to access the variables that need to be processed further. 
## Exploratory Data Analysis

During the exploratory data analysis (EDA) phase, several graphs were created to visualize the data and understand the relationships between different variables. The following graphs were included in the EDA:

### Graphs

- **Distribution of Person Age:** This histogram shows the distribution of ages among the persons in the dataset. ![View Graph](../Credit_model_risk/person_age_distribution.png)

- **Loan Grade Distribution:** This bar plot illustrates the distribution of loan grades assigned to the loans. ![View Graph](../Credit_model_risk/loan_grade_distribution.png)

- **Loan Status Distribution:** This bar plot depicts the distribution of loan statuses, indicating how many loans were approved versus not approved. ![View Graph](../Credit_model_risk/loan_status_distribution.png)

- **Mean Loan Amount by Loan Status:** This bar plot displays the average loan amount for approved and not approved loans. ![View Graph](../Credit_model_risk/loan_amount_distribution_bar.png)

- **Home Ownership Distribution:** This pie chart shows the distribution of home ownership statuses among the persons in the dataset. ![View Graph](../Credit_model_risk/home_ownership_distribution.png)

- **Correlation Heatmap:** This heatmap visualizes the correlation between different variables in the dataset, helping to identify patterns and relationships. ![View Graph](../Credit_model_risk/heatmap.png)

- **Home Ownership Distribution after Factorization:** This pie chart shows the distribution of home ownership statuses after the factorization process. ![View Graph](../Credit_model_risk/home_ownership_factor.png)

- **Distribution of Person Age after Cleaning:** This histogram shows the distribution of ages after data cleaning. ![View Graph](../Credit_model_risk/person_age_distribution_aft_clean.png)

- **Default History Distribution:** This pie chart illustrates the distribution of default history among the persons in the dataset. ![View Graph](../Credit_model_risk/default_history_pie_chart.png)


## Data Cleaning 
- Removed data for individuals older than 80 years due to the improbability of ages above 80.
- Removed NA values and duplicates.
- Dropped variables employment length and loan intent due to potential bias and high cost of data acquisition.
- Dropped the variable percent income due to its dependency on person income and loan amount.

## Feature Engineering
A new feature, C-score, was introduced to improve model performance. This feature acts as a rudimentary credit score with a point system based on various attributes:

### Person Age:
- < 25 years: 1 point
- 25-34 years: 2 points
- 35-44 years: 3 points
- 45-54 years: 4 points
- ≥ 55 years: 5 points

### Person Income:
- < $30,000: 1 point
- $30,000-$49,999: 2 points
- $50,000-$74,999: 3 points
- $75,000-$99,999: 4 points
- ≥ $100,000: 5 points

### Person Home Ownership:
- Owns Home: 5 points
- Mortgage: 4 points
- Rent: 2 points
- Other: 1 point

### Person Employment Length:
- < 1 year: 1 point
- 1-3 years: 2 points
- 4-7 years: 3 points
- 8-10 years: 4 points
- ≥ 10 years: 5 points

### Loan Intent:
- Home Purchase: 5 points
- Debt Consolidation: 4 points
- Small Business: 3 points
- Education: 2 points
- Other: 1 point

### Loan Grade:
- Grade A: 5 points
- Grade B: 4 points
- Grade C: 3 points
- Grade D: 2 points
- Grade E or below: 1 point

### Loan Amount:
- < $5,000: 5 points
- $5,000-$9,999: 4 points
- $10,000-$19,999: 3 points
- $20,000-$49,999: 2 points
- ≥ $50,000: 1 point

### Loan Interest Rate:
- < 5%: 5 points
- 5%-9.99%: 4 points
- 10%-14.99%: 3 points
- 15%-19.99%: 2 points
- ≥ 20%: 1 point

### Loan Status:
- Non-default (0): 5 points
- Default (1): 0 points

### Loan Percent Income:
- < 10%: 5 points
- 10%-19.99%: 4 points
- 20%-29.99%: 3 points
- 30%-39.99%: 2 points
- ≥ 40%: 1 point

### Credit Bureau Default Record:
- No: 5 points
- Yes: 0 points

### Credit Bureau Credit History Length:
- < 1 year: 1 point
- 1-3 years: 2 points
- 4-6 years: 3 points
- 7-9 years: 4 points
- ≥ 10 years: 5 points

## Methodology

### Holdout Validation:
- Dataset split into 70% training and 30% testing sets.
- Seed set to 123 for reproducibility.

### Models Used:
- **Logistic Regression:**
  - Useful for binary classification tasks.
  - Easy to implement and interpret.
  - Limitations: Assumes a linear relationship, not suitable for highly non-linear data.

- **Naive Bayes Classifier:**
  - Suitable for binary classification with discrete data and independent variables.
  - Pros: Simple and fast, performs well with small datasets.
  - Limitations: Assumes independence between variables, sensitivity to skewed distributions.

- **Random Forest:**
  - Prioritizes accuracy, handles complex non-linear relationships.
  - Pros: Highly accurate, handles large datasets with high dimensionality.
  - Limitations: Computationally expensive, less interpretable.

#### Note:
L2 regularization used in logistic regression model due to data separability.

## Results

### Logistic Regression:
- Precision: 0.9
- Recall: 0.49
- Accuracy: 0.88


### Naive Bayes:
- Precision: 0.62
- Recall: 0.72
- Accuracy: 0.84
  

### Random Forest:
- Precision: 0.99
- Recall: 0.98
- Accuracy: 0.97


## Discussion 
Going over all of each of these models and their performance markers, it is quite clear that the Navie Bayes classifier should be given the lowest preference. One possible reason for the is the dependance between some of the variables such as the age of the person and the length of the credit history of the person. As seen in the heatmap these terms are correlated. It is possible that these terms are dependent on one another. 
The other two models are logistic regression and random forest. Which one to use is highly dependent on the volume of data given. Random forest models are extremely computationally intense and would not perform well on high volumes of data. If one is dealing with a large volume of data it might be better to use a logistic regression model, in spite of being more accurate. While the logistic regression model is not as accurate, it might be the better model when accounting for computational intensity. 

## Conclusion 
To conclude, it can be said that it is possible to make and validate a model that predicts whether someone should receive a loan or not, without using a credit score. The model was built using data that is easy to obtain and verify. Considering that the data is specific to any region, it is reasonable to assume that this model could be implemented for data from any part of the world. 
