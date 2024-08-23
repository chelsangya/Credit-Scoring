import pandas as pd
from flask import Flask, request, jsonify, make_response
import joblib
import numpy as np
import os
import traceback

app = Flask(__name__)

scaler_path = 'credit_scaler.pkl'

model_path = 'mean_shift_model.pkl'
final_df_path = 'final_df.csv'

scaler = joblib.load(scaler_path)
model = joblib.load(model_path)
final_df = pd.read_csv(final_df_path)

# Remove unnecessary index column if it exists
if 'Unnamed: 0' in final_df.columns:
    final_df = final_df.drop(columns=['Unnamed: 0'])

weights = {
    'payment_history': 1.0,
    'amount_owed': -2.0,
    'length_of_credit': 1.0,
    'credit_mix': 1.0
}

def generate_recommendations(score, credit_mix, amount_owed):
    recommendations = []
    if score < 580:
        recommendations.append("Consider improving your payment history.")
        recommendations.append("Try to reduce your credit utilization.")
        if credit_mix < 2:
            recommendations.append("Increase the diversity of your credit mix.")
        if amount_owed > 100000:
            recommendations.append("Work on reducing the total amount owed.")
    elif 580 <= score < 670:
        recommendations.append("Improve your credit mix and credit length.")
        if credit_mix < 3:
            recommendations.append("Consider having a mix of different types of credit.")
        if amount_owed > 50000:
            recommendations.append("Reduce the amount owed to improve your credit score.")
    elif 670 <= score < 740:
        recommendations.append("Maintain a good payment history.")
    else:
        recommendations.append("Keep up the excellent credit management.")
    return recommendations

class CreditScoreModel:
    def __init__(self, scaler, model, weights):
        self.scaler = scaler
        self.model = model
        self.weights = weights

    def predict_score(self, data, existing_clusters):
        try:
            # Get current min and max clusters from existing data
            current_min_cluster = existing_clusters.min()
            current_max_cluster = existing_clusters.max()

            # Scale and weight the new data
            data_df = pd.DataFrame(data, columns=['payment_history', 'amount_owed', 'length_of_credit', 'credit_mix'])
            print('Data DataFrame:\n', data_df)

            scaled_features = self.scaler.transform(data_df)
            print('Scaled features:\n', scaled_features)

            weighted_scaled_features = scaled_features * np.array([self.weights['payment_history'], self.weights['amount_owed'], self.weights['length_of_credit'], self.weights['credit_mix']])
            print('Weighted scaled features:\n', weighted_scaled_features)

            # Predict clusters for new data
            new_cluster_labels = self.model.predict(weighted_scaled_features)
            print('New cluster labels:', new_cluster_labels)

            # Update min and max clusters if needed
            min_cluster = min(current_min_cluster, new_cluster_labels.min())
            max_cluster = max(current_max_cluster, new_cluster_labels.max())
            print('Min cluster:', min_cluster, 'Max cluster:', max_cluster)

            # Normalize scores for new data
            normalized_scores = 300 + (new_cluster_labels - min_cluster) * (850 - 300) / (max_cluster - min_cluster)
            normalized_scores = np.clip(normalized_scores, 300, 850)
            print('Normalized scores:', normalized_scores)

            return normalized_scores, new_cluster_labels
        except Exception as e:
            print('Error during predict_score:', e)
            traceback.print_exc()
            raise

credit_score_model = CreditScoreModel(scaler, model, weights)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        print('Received data:', data)
        features = pd.DataFrame([[
            data['payment_history'],
            data['amount_owed'],
            data['length_of_credit'],
            data['credit_mix'],
        ]], columns=['payment_history', 'amount_owed', 'length_of_credit', 'credit_mix'])

        print('Features DataFrame:', features)

        # Ensure final_df is initialized properly
        global final_df
        existing_clusters = final_df['cluster'].values
        print('Existing clusters:', existing_clusters)

        normalized_scores, new_clusters = credit_score_model.predict_score(features.values, existing_clusters)
        print('Normalized scores:', normalized_scores[0])

        new_data = features.copy()
        new_data['normalized_score'] = normalized_scores
        new_data['cluster'] = new_clusters

        final_df = pd.concat([final_df, new_data], ignore_index=True)

        min_cluster = final_df['cluster'].min()
        max_cluster = final_df['cluster'].max()
        final_df['normalized_score'] = 300 + (final_df['cluster'] - min_cluster) * (850 - 300) / (max_cluster - min_cluster)
        final_df['normalized_score'] = final_df['normalized_score'].clip(300, 850)

        final_df.to_csv(final_df_path, index=False)

        clipped_prediction = normalized_scores[0]
        recommendations = generate_recommendations(clipped_prediction, data['credit_mix'], data['amount_owed'])

        response = {
            'prediction': float(clipped_prediction),
            'recommendations': [str(rec) for rec in recommendations]
        }

        return jsonify(response)
    except KeyError as e:
        print('KeyError:', e)
        return jsonify({'error': f'Missing key in input data: {e}'}), 400
    except Exception as e:
        print('Unexpected error:', e)
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

@app.route('/predict_csv', methods=['POST'])
def predict_csv():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected for uploading'}), 400

    try:
        df = pd.read_csv(file)
        required_columns = ['annual income', 'creditCards', 'loans', 'loan duration in months', 'amount of loan remaining']
        if not all(column in df.columns for column in required_columns):
            return jsonify({'error': 'Missing one or more required columns'}), 400

        # Extract features
        df['payment_history'] = df['annual income']
        df['credit_mix'] = df['creditCards'] + df['loans']
        df['length_of_credit'] = df['loan duration in months']
        df['amount_owed'] = df['amount of loan remaining']

        features_df = df[['payment_history', 'amount_owed', 'length_of_credit', 'credit_mix']]

        # Process predictions
        global final_df
        existing_clusters = final_df['cluster'].values
        normalized_scores, new_clusters = credit_score_model.predict_score(features_df.values, existing_clusters)

        new_data = features_df.copy()
        new_data['normalized_score'] = normalized_scores
        new_data['cluster'] = new_clusters

        final_df = pd.concat([final_df, new_data], ignore_index=True)

        min_cluster = final_df['cluster'].min()
        max_cluster = final_df['cluster'].max()
        final_df['normalized_score'] = 300 + (final_df['cluster'] - min_cluster) * (850 - 300) / (max_cluster - min_cluster)
        final_df['normalized_score'] = final_df['normalized_score'].clip(300, 850)

        final_df.to_csv(final_df_path, index=False)

        # Add predicted scores and recommendations to original dataframe
        df['Predicted Credit Score'] = normalized_scores
        df['Recommendations'] = df.apply(lambda row: generate_recommendations(row['Predicted Credit Score'], row['credit_mix'], row['amount_owed']), axis=1)
        df['Row Number'] = df.index + 1  # Add row number column

        # Reorder columns as needed
        response_df = df[['Row Number', 'annual income', 'creditCards', 'loans', 'loan duration in months', 'amount of loan remaining', 'Predicted Credit Score', 'Recommendations']]
        response_csv = response_df.to_csv(index=False)

        response = make_response(response_csv)
        response.headers["Content-Disposition"] = "attachment; filename=predictions.csv"
        response.headers["Content-Type"] = "text/csv"
        return response
    except Exception as e:
        print('Unexpected error:', e)
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)