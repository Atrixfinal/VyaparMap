"""
VyaparMap Business Finder Recommender Trainer
Uses NearestNeighbors / Cosine Similarity to recommend optimal business models
given capital, location tier, risk tolerance, and skillsets.
"""

import os
import json
import pandas as pd
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import StandardScaler
import joblib

def train_recommender():
    data_path = "data/training_dataset.csv"
    if not os.path.exists(data_path):
        from generate_training_dataset import generate_dataset
        generate_dataset()

    df = pd.read_csv(data_path)
    feature_cols = ["budget_inr", "rent_per_sqft", "footfall_traffic", "competitor_count"]

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(df[feature_cols])

    knn = NearestNeighbors(n_neighbors=5, metric="cosine")
    knn.fit(X_scaled)

    os.makedirs("models", exist_ok=True)
    joblib.dump({"model": knn, "scaler": scaler, "df": df}, "models/finder_recommender.joblib")
    print("✓ Business Finder Recommender trained & saved to models/finder_recommender.joblib!")

if __name__ == "__main__":
    train_recommender()
