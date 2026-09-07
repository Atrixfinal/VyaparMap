"""
VyaparMap Local Machine Learning Trainer: AI Advisor Model
Trains RandomForest and GradientBoosting regressors on local business datasets
to predict feasibility score and monthly net profit.
Saves serialized model to models/advisor_feasibility_model.joblib.
"""

import os
import json
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.metrics import mean_absolute_error, r2_score
import joblib

def train_model():
    data_path = "data/training_dataset.csv"
    if not os.path.exists(data_path):
        print("Dataset not found. Generating dataset first...")
        from generate_training_dataset import generate_dataset
        generate_dataset()

    print("Loading commercial training dataset...")
    df = pd.read_csv(data_path)

    # Feature Engineering
    features = [
        "shop_size_sqft",
        "budget_inr",
        "min_required_budget",
        "rent_per_sqft",
        "footfall_traffic",
        "competitor_count",
        "is_cluster_beneficial",
    ]

    # Additional calculated signals
    df["capital_sufficiency_ratio"] = df["budget_inr"] / df["min_required_budget"]
    df["projected_rent"] = df["rent_per_sqft"] * df["shop_size_sqft"]
    features.extend(["capital_sufficiency_ratio", "projected_rent"])

    X = df[features]
    y_score = df["feasibility_score"]
    y_profit = df["monthly_net_profit_est"]

    X_train, X_test, y_score_train, y_score_test, y_profit_train, y_profit_test = train_test_split(
        X, y_score, y_profit, test_size=0.2, random_state=42
    )

    print(f"Training ML Model on {len(X_train)} samples across Indian retail sectors...")

    # Train Score Model (Gradient Boosting)
    score_model = GradientBoostingRegressor(n_estimators=120, max_depth=5, learning_rate=0.08, random_state=42)
    score_model.fit(X_train, y_score_train)

    score_preds = score_model.predict(X_test)
    score_mae = mean_absolute_error(y_score_test, score_preds)
    score_r2 = r2_score(y_score_test, score_preds)

    print(f"✓ Feasibility Score Model Trained: MAE = {score_mae:.3f} | R² = {score_r2:.3f}")

    # Train Profit Model (Random Forest)
    profit_model = RandomForestRegressor(n_estimators=100, max_depth=7, random_state=42)
    profit_model.fit(X_train, y_profit_train)

    profit_preds = profit_model.predict(X_test)
    profit_mae = mean_absolute_error(y_profit_test, profit_preds)

    print(f"✓ Monthly Net Profit Model Trained: MAE = ₹{profit_mae:,.0f}")

    os.makedirs("models", exist_ok=True)
    bundle = {
        "score_model": score_model,
        "profit_model": profit_model,
        "feature_names": features,
        "version": "2.1.0-SIH26091",
        "trained_samples": len(df),
    }

    model_path = "models/advisor_feasibility_model.joblib"
    joblib.dump(bundle, model_path)
    print(f"✓ Model successfully saved to {model_path}")
    print("Ready for local offline inference!")

if __name__ == "__main__":
    train_model()
