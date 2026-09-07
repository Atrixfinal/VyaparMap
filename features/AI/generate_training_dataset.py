"""
VyaparMap Dataset Generator
Generates realistic Indian commercial retail and micro-enterprise training data
for training AI Advisor and Business Finder ML models locally.
"""

import json
import csv
import random
import os

SECTORS = [
    ("leather_footwear", "Traditional Mojari & Footwear", 25000, 150000, True, 350, 0.32),
    ("repair_services", "Computer & Laptop Repair", 150000, 500000, False, 550, 0.30),
    ("agro_food", "Flour & Spices Chakki Mill", 120000, 450000, False, 180, 0.50),
    ("textiles_apparel", "Handblock Printing & Tailoring", 50000, 250000, True, 450, 0.35),
    ("handicrafts_artisan", "Terracotta & Ceramic Pottery", 20000, 100000, True, 120, 0.28),
    ("retail_trade", "Kirana & General Provisions", 80000, 350000, False, 220, 0.78),
    ("urban_commercial_retail", "Shopping Mall & Commercial Arcade", 50000000, 200000000, True, 650, 0.38),
    ("urban_highend_hospitality", "Specialty Artisanal Cafe & Roastery", 3000000, 12000000, True, 380, 0.30),
    ("tech_gaming_electronics", "Authorized Laptop & PC Store (Acer/Asus)", 3500000, 15000000, True, 1800, 0.14),
    ("tech_gaming_electronics", "Esports RTX Gaming Lounge", 1800000, 5000000, False, 250, 0.40),
    ("luxury_wellness_lifestyle", "Luxury Unisex Salon & Med-Spa", 2500000, 8500000, False, 650, 0.32),
    ("commercial_services_coworking", "Managed Coworking Incubator", 5000000, 30000000, True, 4500, 0.35),
    ("fnb_dining", "Highway Dhaba & Pure Veg Dining", 200000, 1200000, False, 140, 0.38),
]

LOCATIONS = [
    ("Sanganer Tehsil, Jaipur", 25, 14000, True),
    ("Chomu Block Mandi, Jaipur Rural", 32, 18000, False),
    ("Bassi Tehsil, Jaipur Rural", 22, 12000, False),
    ("Amer Tehsil Craft Bazaar, Jaipur", 40, 16000, True),
    ("Raja Park Commercial High-Street, Jaipur", 180, 24000, False),
    ("C-Scheme Subhash Marg, Jaipur", 220, 26000, True),
    ("Malviya Nagar GT Central, Jaipur", 195, 28000, True),
    ("Koramangala 4th Block, Bengaluru", 240, 32000, True),
    ("Indiranagar 100ft Rd, Bengaluru", 260, 34000, True),
    ("Connaught Place, New Delhi", 320, 42000, True),
    ("Bandra West Linking Road, Mumbai", 350, 38000, True),
    ("FC Road Deccan, Pune", 180, 25000, True),
]

def generate_dataset(num_samples=2500):
    rows = []
    for i in range(num_samples):
        sec = random.choice(SECTORS)
        sec_id, biz_name, min_budget, max_budget, is_cluster_trade, avg_ticket, cogs = sec
        loc_name, rent_sqft, base_footfall, is_urban_loc = random.choice(LOCATIONS)

        # Capital allocated by user (some undercapitalized, some optimal)
        cap_factor = random.choice([0.2, 0.4, 0.7, 1.0, 1.2, 2.0, 5.0])
        budget = int(min_budget * cap_factor)

        shop_size = random.randint(60, 1500 if is_urban_loc else 400)
        comp_count = random.randint(1, 55)

        # Economic logic calculation
        is_cluster = is_cluster_trade and (comp_count >= 12 or is_urban_loc)
        cap_deficit = budget < min_budget * 0.7

        # Competitor effect
        if is_cluster:
            comp_factor = 1.15
            effective_cogs = max(0.20, cogs - 0.10)
        elif comp_count > 15:
            comp_factor = max(0.40, 1 - (comp_count - 10) * 0.04)
            effective_cogs = cogs
        else:
            comp_factor = 1.0
            effective_cogs = cogs

        conv_rate = (0.024 if is_cluster else 0.012) * comp_factor
        daily_customers = max(2, int(base_footfall * conv_rate * (0.3 if cap_deficit else 1.0)))
        monthly_rev = int(daily_customers * avg_ticket * 30)

        monthly_rent = rent_sqft * shop_size
        monthly_opex = int(monthly_rent + (monthly_rev * effective_cogs) + (15000 if shop_size > 200 else 4000))
        net_profit = monthly_rev - monthly_opex

        # Scoring
        if cap_deficit:
            score = round(random.uniform(1.8, 2.3), 1)
            tier = "High_Risk_Undercapitalized"
        elif not is_cluster and comp_count > 18:
            score = round(random.uniform(2.3, 2.9), 1)
            tier = "High_Risk_Saturated"
        elif monthly_rent > monthly_rev * 0.35:
            score = round(random.uniform(2.5, 3.1), 1)
            tier = "Rent_Distress"
        elif is_cluster and net_profit > 30000:
            score = round(random.uniform(4.4, 4.8), 1)
            tier = "Optimal_Cluster_Synergy"
        elif net_profit > 20000:
            score = round(random.uniform(3.9, 4.3), 1)
            tier = "Viable_Profitable"
        else:
            score = round(random.uniform(3.2, 3.7), 1)
            tier = "Marginal_Viability"

        rows.append({
            "sample_id": i + 1,
            "sector_id": sec_id,
            "business_name": biz_name,
            "location": loc_name,
            "shop_size_sqft": shop_size,
            "budget_inr": budget,
            "min_required_budget": min_budget,
            "rent_per_sqft": rent_sqft,
            "footfall_traffic": base_footfall,
            "competitor_count": comp_count,
            "is_cluster_beneficial": 1 if is_cluster else 0,
            "monthly_revenue_est": monthly_rev,
            "monthly_net_profit_est": net_profit,
            "rent_to_revenue_ratio": round(monthly_rent / max(1, monthly_rev), 3),
            "feasibility_score": score,
            "viability_tier": tier
        })

    os.makedirs("data", exist_ok=True)
    with open("data/training_dataset.json", "w", encoding="utf-8") as f:
        json.dump(rows, f, indent=2)

    with open("data/training_dataset.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)

    print(f"✓ Generated {len(rows)} commercial training records in data/training_dataset.csv & .json")

if __name__ == "__main__":
    generate_dataset()
