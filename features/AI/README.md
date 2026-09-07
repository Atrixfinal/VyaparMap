# VyaparMap Local Python AI & Machine Learning Toolkit

This folder (`features/AI/`) contains the complete offline Machine Learning suite for **VyaparMap** (SIH Problem Statement 26091 - MoSJE).

> [!IMPORTANT]
> **This folder is kept local on your laptop** for offline data training and model experimentation. It is added to `.gitignore` so it is **NOT uploaded to Vercel/production**.

---

## What is Inside

| File | Purpose |
| :--- | :--- |
| `generate_training_dataset.py` | Generates 2,500+ commercial data rows across Indian metros, tehsils, and craft clusters. |
| `train_advisor_model.py` | Trains Scikit-Learn **Gradient Boosting & Random Forest** regressors to predict viability scores & monthly net profit. Saves to `models/advisor_feasibility_model.joblib`. |
| `train_finder_recommender.py` | Trains collaborative/content recommendation model for Business Finder. |
| `harvest_osm_maps.py` | Live Python scraper querying OpenStreetMap Overpass API for real shops in any city/tehsil, saving to SQLite. |
| `predict_score_cli.py` | Interactive command-line testing tool. |
| `run_1click_training.bat` | **1-Click double-click training script for Windows**. |

---

## 1-Click Training Instructions

### On Windows:
Double-click `run_1click_training.bat`. It will automatically:
1. Install `scikit-learn`, `pandas`, `numpy`, `requests`, `joblib`.
2. Generate the dataset in `data/training_dataset.csv`.
3. Train the model and report MAE / $R^2$ accuracy.
4. Save the trained model to `models/advisor_feasibility_model.joblib`.
5. Run a live test prediction in the terminal!

### Running Manual Predictions:
```bash
python predict_score_cli.py --capital 100000 --shop_size 120 --competitors 45 --cluster 1
```
