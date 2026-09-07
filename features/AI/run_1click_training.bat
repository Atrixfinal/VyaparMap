@echo off
echo ===================================================
echo     VyaparMap Local Machine Learning 1-Click Trainer
echo ===================================================
echo.
echo 1. Checking Python environment...
python --version
if errorlevel 1 (
    echo Python is not installed or not in PATH! Please install Python 3.9+.
    pause
    exit /b
)

echo.
echo 2. Installing ML dependencies from requirements.txt...
pip install -r requirements.txt

echo.
echo 3. Generating real-world commercial dataset...
python generate_training_dataset.py

echo.
echo 4. Training AI Advisor Feasibility Model (Random Forest + Gradient Boosting)...
python train_advisor_model.py

echo.
echo 5. Training Business Finder Recommendation Engine...
python train_finder_recommender.py

echo.
echo 6. Running sample inference test...
python predict_score_cli.py --capital 100000 --shop_size 120 --competitors 45 --cluster 1

echo.
echo ===================================================
echo   Local Training Complete! Models saved in models/
echo ===================================================
pause
