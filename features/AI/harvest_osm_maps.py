"""
VyaparMap Local Map Harvester (Python CLI)
Harvests real commercial establishments from OpenStreetMap Overpass API
and dumps to SQLite database (data/vyapar_harvested_pois.db).
"""

import sys
import requests
import sqlite3
import json
import os

OVERPASS_URLS = [
    "https://overpass-api.de/api/interpreter",
    "https://maps.mail.ru/osm/tools/overpass/api/interpreter"
]

def harvest(city_name="Jaipur", lat=26.9124, lon=75.7873, radius=2500):
    print(f"Scraping real commercial POIs around {city_name} ({lat}, {lon}) via OpenStreetMap...")

    ql = f"""
    [out:json][timeout:20];
    (
      node["shop"](around:{radius},{lat},{lon});
      node["amenity"~"cafe|restaurant|fast_food|bank|pharmacy"](around:{radius},{lat},{lon});
    );
    out body 100;
    """

    data = None
    for url in OVERPASS_URLS:
        try:
            res = requests.post(url, data={"data": ql}, timeout=12)
            if res.status_code == 200:
                data = res.json()
                break
        except Exception as e:
            continue

    if not data or "elements" not in data:
        print("Overpass API request failed or timed out. Check network connection.")
        return

    elements = data["elements"]
    print(f"Found {len(elements)} raw OpenStreetMap nodes.")

    os.makedirs("data", exist_ok=True)
    conn = sqlite3.connect("data/vyapar_harvested_pois.db")
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS harvested_shops (
            id TEXT PRIMARY KEY,
            name TEXT,
            category TEXT,
            address TEXT,
            city TEXT,
            lat REAL,
            lng REAL,
            source TEXT
        )
    """)

    saved = 0
    for el in elements:
        tags = el.get("tags", {})
        name = tags.get("name") or tags.get("name:en")
        if not name:
            continue

        cat = tags.get("shop") or tags.get("amenity") or "commercial"
        addr = tags.get("addr:street") or f"{city_name} Commercial Zone"
        shop_id = f"osm-{el['id']}"

        cur.execute("""
            INSERT OR REPLACE INTO harvested_shops (id, name, category, address, city, lat, lng, source)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (shop_id, name, cat, addr, city_name, el["lat"], el["lon"], "OSM Live Overpass"))
        saved += 1

    conn.commit()
    conn.close()
    print(f"✓ Successfully saved {saved} verified real shops to data/vyapar_harvested_pois.db!")

if __name__ == "__main__":
    harvest()
