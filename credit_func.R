# this file contains a function that calculates a rudementary credit score based on the input variables.
Cscore <- function(age, income, home_ownership, loan_grade,
                     loan_amount, loan_interest_rate, loan_status,
                     default_record, credit_history_length) {

  # Define points for each variable
  age_points <- ifelse(age < 25, 1,
                       ifelse(age <= 34, 2,
                              ifelse(age <= 44, 3,
                                     ifelse(age <= 54, 4, 5))))

  income_points <- ifelse(income < 30000, 1,
                          ifelse(income < 50000, 2,
                                 ifelse(income < 75000, 3,
                                        ifelse(income < 100000, 4, 5))))

  home_ownership_points <- switch(home_ownership,
                                  "OWN" = 5,
                                  "MORTGAGE" = 4,
                                  "RENT" = 2,
                                  1)

  loan_grade_points <- switch(loan_grade,
                              "A" = 5,
                              "B" = 4,
                              "C" = 3,
                              "D" = 2,
                              "E" = 1,
                              "F" = 1,
                              "G" = 1,
                              1)

  loan_amount_points <- ifelse(loan_amount < 5000, 5,
                               ifelse(loan_amount < 10000, 4,
                                      ifelse(loan_amount < 20000, 3,
                                             ifelse(loan_amount < 50000, 2, 1))))

  loan_interest_rate_points <- ifelse(loan_interest_rate < 5, 5,
                                      ifelse(loan_interest_rate < 10, 4,
                                             ifelse(loan_interest_rate < 15, 3,
                                                    ifelse(loan_interest_rate < 20, 2, 1))))

  loan_status_points <- ifelse(loan_status ==  0, 5, 0)

  default_record_points <- ifelse(default_record == "Y", 0, 5)

  credit_history_length_points <- ifelse(credit_history_length < 1, 1,
                                         ifelse(credit_history_length < 3, 2,
                                                ifelse(credit_history_length < 7, 3,
                                                       ifelse(credit_history_length < 10, 4, 5))))

  # Sum points to get the credit score
  credit_score <- age_points + income_points + home_ownership_points +
    loan_grade_points + loan_amount_points + loan_interest_rate_points +
    loan_status_points + default_record_points + credit_history_length_points

  return(credit_score)
}