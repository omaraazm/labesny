import json
from typing import Set, Dict, Any
from .clothes import ClothingItem
from .enums import ClothingType, DressCode, ClothingFit

class WardrobeStorage:
    def __init__(self, filename: str = "data/wardrobe.json"):
        self.filename = filename

    def save_items(self, items: Set[ClothingItem]) -> None:
        """Save clothing items to JSON file"""
        items_data = []
        for item in items:
            items_data.append({
                "type": item.type.value,
                "color": item.color,
                "code": item.dresscode.value,
                "fit": item.fit.value
                # "image": 
            })
        
        with open(self.filename, 'w') as f:
            json.dump(items_data, f, indent=4)

    def load_items(self) -> Set[ClothingItem]:
        """Load clothing items from JSON file"""
        try:
            with open(self.filename, 'r') as f:
                items_data = json.load(f)
            
            items = set()
            for item_data in items_data:
                item = ClothingItem(
                    type=ClothingType(item_data["type"]),
                    color=item_data["color"],
                    dresscode=DressCode(item_data["code"]),
                    fit=ClothingFit(item_data["fit"])
                    #image_url= 
                )
                items.add(item)
            return items
            
        except FileNotFoundError:
            return set()  
