import pandas as pd

df = pd.read_csv('RESPONSESS.csv')

print("Columns in the DataFrame:")
print(df.columns)

# Strip any leading/trailing whitespace from column names
df.columns = df.columns.str.strip()

# Define encoding mappings
binary_mapping = {'Yes': 1, 'No': 0}
age_group_mapping = {
    '18-28': 1,
    '29-38': 2,
    '39-48': 3,
    '49-58': 4,
    '59-68': 5,
    '69-78': 6
}
gender_mapping = {'Male': 1, 'Female': 0}
frequency_mapping = {
    'Never': 1,
    'Rarely': 2,
    'Occasionally': 3,
    'Frequently': 4,
    'Very frequently': 5
}
creditworthiness_factors_mapping = {
    'Income stability': 1,
    'Credit history': 2,
    'Debt-to-income ratio': 3,
    'Employment status': 4,
    'Other': 5
}
trust_mapping = {
    'Completely trust': 1,
    'Somewhat trust': 2,
    'Neutral': 3,
    'Do not trust': 4
}
importance_mapping = {
    'Very important': 1,
    'Important': 2,
    'Neutral': 3,
    'Not important': 4
}
concern_mapping = {
    'Very concerned': 1,
    'Concerned': 2,
    'Neutral': 3,
    'Not concerned': 4
}
confidence_mapping = {
    'Very confident': 1,
    'Confident': 2,
    'Neutral': 3,
    'Not confident': 4
}
likelihood_mapping = {
    'Very likely': 1,
    'Likely': 2,
    'Neutral': 3,
    'Unlikely': 4,
    'Very unlikely': 5
}

# Flexible column matching function
def match_column(column, target):
    for col in df.columns:
        if target in col:
            return col
    raise KeyError(f"Column containing '{target}' not found.")

# Apply encodings and replace original columns
df[match_column(df.columns, 'Are you familiar with banking sector?')] = df[match_column(df.columns, 'Are you familiar with banking sector?')].map(binary_mapping)
df[match_column(df.columns, 'Select your age group.')] = df[match_column(df.columns, 'Select your age group.')].map(age_group_mapping)
df[match_column(df.columns, 'Select your gender.')] = df[match_column(df.columns, 'Select your gender.')].map(gender_mapping)
df[match_column(df.columns, 'Do you have a technical background?')] = df[match_column(df.columns, 'Do you have a technical background?')].map(binary_mapping)
df[match_column(df.columns, 'How often do you apply for loans from commercial banks?')] = df[match_column(df.columns, 'How often do you apply for loans from commercial banks?')].map(frequency_mapping)
df[match_column(df.columns, 'What factors do you think are most important in determining creditworthiness for a loan?')] = df[match_column(df.columns, 'What factors do you think are most important in determining creditworthiness for a loan?')].map(creditworthiness_factors_mapping)
df[match_column(df.columns, 'Are you familiar with the concept of credit scoring?')] = df[match_column(df.columns, 'Are you familiar with the concept of credit scoring?')].map(binary_mapping)
df[match_column(df.columns, 'Are you comfortable with banks using predictive analytics to assess your creditworthiness?')] = df[match_column(df.columns, 'Are you comfortable with banks using predictive analytics to assess your creditworthiness?')].map(binary_mapping)
df[match_column(df.columns, 'Would you prefer a bank that uses predictive analytics for credit scoring over one that doesn\'t?')] = df[match_column(df.columns, 'Would you prefer a bank that uses predictive analytics for credit scoring over one that doesn\'t?')].map(binary_mapping)
df[match_column(df.columns, 'Do you think predictive analytics could lead to fairer loan approval processes?')] = df[match_column(df.columns, 'Do you think predictive analytics could lead to fairer loan approval processes?')].map(binary_mapping)
df[match_column(df.columns, 'How much do you trust the accuracy of predictive analytics models used by banks?')] = df[match_column(df.columns, 'How much do you trust the accuracy of predictive analytics models used by banks?')].map(trust_mapping)
df[match_column(df.columns, 'Do you believe predictive analytics can accurately assess an individual\'s creditworthiness?')] = df[match_column(df.columns, 'Do you believe predictive analytics can accurately assess an individual\'s creditworthiness?')].map(binary_mapping)
df[match_column(df.columns, 'Do you believe prescriptive analytics can help banks provide better loan recommendations?')] = df[match_column(df.columns, 'Do you believe prescriptive analytics can help banks provide better loan recommendations?')].map(binary_mapping)
df[match_column(df.columns, 'Are you open to receiving personalized loan recommendations from banks based on prescriptive analytics?')] = df[match_column(df.columns, 'Are you open to receiving personalized loan recommendations from banks based on prescriptive analytics?')].map(binary_mapping)
df[match_column(df.columns, 'How important is it for you to understand how banks use predictive and prescriptive analytics in their loan approval processes?')] = df[match_column(df.columns, 'How important is it for you to understand how banks use predictive and prescriptive analytics in their loan approval processes?')].map(importance_mapping)
df[match_column(df.columns, 'Would you be willing to share additional personal information with banks if it could potentially improve your loan terms?')] = df[match_column(df.columns, 'Would you be willing to share additional personal information with banks if it could potentially improve your loan terms?')].map(binary_mapping)
df[match_column(df.columns, 'Do you think the implementation of predictive and prescriptive analytics could lead to faster loan approval times?')] = df[match_column(df.columns, 'Do you think the implementation of predictive and prescriptive analytics could lead to faster loan approval times?')].map(binary_mapping)
df[match_column(df.columns, 'Are you concerned about the potential misuse of data in predictive and prescriptive analytics by banks?')] = df[match_column(df.columns, 'Are you concerned about the potential misuse of data in predictive and prescriptive analytics by banks?')].map(binary_mapping)
df[match_column(df.columns, 'Do you think the implementation of predictive and prescriptive analytics could lead to more accurate loan interest rates?')] = df[match_column(df.columns, 'Do you think the implementation of predictive and prescriptive analytics could lead to more accurate loan interest rates?')].map(binary_mapping)
df[match_column(df.columns, 'How likely are you to switch banks if a competitor offered better loan terms based on predictive and prescriptive analytics?')] = df[match_column(df.columns, 'How likely are you to switch banks if a competitor offered better loan terms based on predictive and prescriptive analytics?')].map(likelihood_mapping)
df[match_column(df.columns, 'Would you be interested in attending workshops or seminars to learn more about how predictive and prescriptive analytics are used in credit scoring?')] = df[match_column(df.columns, 'Would you be interested in attending workshops or seminars to learn more about how predictive and prescriptive analytics are used in credit scoring?')].map(binary_mapping)
df[match_column(df.columns, 'Do you think the use of predictive and prescriptive analytics could increase financial inclusion by making credit more accessible to underserved populations?')] = df[match_column(df.columns, 'Do you think the use of predictive and prescriptive analytics could increase financial inclusion by making credit more accessible to underserved populations?')].map(binary_mapping)
df[match_column(df.columns, 'How concerned are you about potential biases in predictive analytics models used by banks?')] = df[match_column(df.columns, 'How concerned are you about potential biases in predictive analytics models used by banks?')].map(concern_mapping)
df[match_column(df.columns, 'Do you think the government should regulate the use of predictive and prescriptive analytics in credit scoring?')] = df[match_column(df.columns, 'Do you think the government should regulate the use of predictive and prescriptive analytics in credit scoring?')].map(binary_mapping)
df[match_column(df.columns, 'How confident are you in your ability to understand the outputs of predictive and prescriptive analytics models used by banks?')] = df[match_column(df.columns, 'How confident are you in your ability to understand the outputs of predictive and prescriptive analytics models used by banks?')].map(confidence_mapping)
df[match_column(df.columns, 'Would you be willing to pay higher fees or interest rates for a loan if it was approved using predictive and prescriptive analytics?')] = df[match_column(df.columns, 'Would you be willing to pay higher fees or interest rates for a loan if it was approved using predictive and prescriptive analytics?')].map(binary_mapping)
df[match_column(df.columns, 'Do you believe predictive and prescriptive analytics could help reduce the number of non-performing loans for commercial banks?')] = df[match_column(df.columns, 'Do you believe predictive and prescriptive analytics could help reduce the number of non-performing loans for commercial banks?')].map(binary_mapping)
df[match_column(df.columns, 'How important is transparency in the use of predictive and prescriptive analytics by banks?')] = df[match_column(df.columns, 'How important is transparency in the use of predictive and prescriptive analytics by banks?')].map(importance_mapping)
df[match_column(df.columns, 'How likely are you to recommend a bank that uses predictive and prescriptive analytics for credit scoring to friends or family?')] = df[match_column(df.columns, 'How likely are you to recommend a bank that uses predictive and prescriptive analytics for credit scoring to friends or family?')].map(likelihood_mapping)
df[match_column(df.columns, 'Do you believe predictive and prescriptive analytics could help commercial banks better manage risk?')] = df[match_column(df.columns, 'Do you believe predictive and prescriptive analytics could help commercial banks better manage risk?')].map(binary_mapping)
df[match_column(df.columns, 'How concerned are you about the potential for data breaches or security vulnerabilities in predictive and prescriptive analytics systems used by banks?')] = df[match_column(df.columns, 'How concerned are you about the potential for data breaches or security vulnerabilities in predictive and prescriptive analytics systems used by banks?')].map(concern_mapping)
df[match_column(df.columns, 'Would you be willing to participate in a pilot program testing the effectiveness of predictive and prescriptive analytics in credit scoring for commercial banks?')] = df[match_column(df.columns, 'Would you be willing to participate in a pilot program testing the effectiveness of predictive and prescriptive analytics in credit scoring for commercial banks?')].map(binary_mapping)

# Save encoded DataFrame to CSV
df.to_csv('encoded_survey_responses.csv', index=False)

print("Encoded survey responses saved to 'encoded_survey_responses.csv'")