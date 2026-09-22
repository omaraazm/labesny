# test_api.py
import requests

BASE_URL = "http://localhost:8000"

# Test adding an item
def test_add_item():
    response = requests.post(f"{BASE_URL}/items/", json={
        "type": "SHIRT",
        "color": "blue",
        "dresscode": "CASUAL",
        "fit": "REGULAR"
    })
    print("Add item response:", response.json())

# Test getting all items
def test_get_items():
    response = requests.get(f"{BASE_URL}/items/")
    print("All items:", response.json())

# Test matching outfits
def test_get_outfits():
    response = requests.get(f"{BASE_URL}/outfits/")
    print("Matching outfits:", response.json())

# Test removing an item
def test_remove_item(item_id: int):
    response = requests.delete(f"{BASE_URL}/items/{item_id}")
    print("Remove item response:", response.json())

# Curl commands:
"""
# Add item
curl -X POST http://localhost:8000/items/ \
-H "Content-Type: application/json" \
-d '{"color":"blue","type":"SHIRT","dresscode":"CASUAL","fit":"REGULAR"}'

# Get all items
curl http://localhost:8000/items/

# Get outfits
curl http://localhost:8000/outfits/

# Remove item
curl -X DELETE http://localhost:8000/items/1
"""