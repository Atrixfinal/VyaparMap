"""
VyaparMap Local CLI Inference
Test predictions locally without any web server.
Usage:
  python predict_score_cli.py --capital 100000 --shop_size 120 --rent 28 --footfall 14000 --competitors 45 --cluster 1
"""

import sys
import argparse
import os
import joblib
import pandas as pd

def predict(capital, shop_size, rent_sqft, footfall, competitors, is_cluster, min_budget=100000):
    model_path = "models/advisor_feasibility_model.joblib"
    if not os.path.exists(model_path):
        print("Trained model not found. Training model now...")
        from train_advisor_model import train_model
        train_model()

    bundle = joblib.load(model_path)
    score_model = bundle["score_model"]
    profit_model = bundle["profit_model"]

    row = {
        "shop_size_sqft": shop_size,
        "budget_inr": capital,
        "min_required_budget": min_budget,
        "rent_per_sqft": rent_sqft,
        "footfall_traffic": footfall,
        "competitor_count": competitors,
        "is_cluster_beneficial": is_cluster,
        "capital_sufficiency_ratio": capital / max(1, min_budget),
        "projected_rent": rent_sqft * shop_size,
    }

    df = pd.DataFrame([row])
    predicted_score = round(float(score_model.predict(df)[0]), 1)
    predicted_profit = int(profit_model.predict(df)[0])

    print("==================================================")
    print("      VYAPARMAP LOCAL AI PREDICTION RESULT        ")
    print("==================================================")
    print(f"Input Capital:        ₹{capital:,.0f}")
    print(f"Floor Space:          {shop_size} sq ft")
    print(f"Nearby Competitors:   {competitors}")
    print(f"Cluster Beneficial:   {'YES (Agglomeration)' if is_cluster else 'NO (Commoditized)'}")
    print("--------------------------------------------------")
    print(f"Predicted Score:      {predicted_score} / 5.0")
    print(f"Predicted Net Profit: ₹{predicted_profit:,.0f} / month")
    print("Verdict:              " + ("EXCELLENT" if predicted_score >= 4.2 else "VIABLE" if predicted_score >= 3.5 else "HIGH RISK"))
    print("==================================================")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--capital", type=int, default=100000)
    parser.add_argument("--shop_size", type=int, default=120)
    parser.add_argument("--rent", type=int, default=28)
    parser.add_argument("--footfall", type=int, default=14000)
    parser.add_argument("--competitors", type=int, default=45)
    parser.add_argument("--cluster", type=int, default=1)
    args = parser.parse_args()

    predict(args.capital, args.shop_size, args.rent, args.footfall, args.competitors, args.cluster)
