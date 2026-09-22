import json
from typing import Dict, Any
from .clothes import ClothingItem
from .enums import ClothingType, DressCode, ClothingFit

class WardrobeStorage:
    def __init__(self, filename: str = "data/wardrobe.json"):
        self.filename = filename

    def save_items(self, items: Dict[str, ClothingItem]) -> None:
        """Save clothing items to JSON file"""
        items_data = []
        for item in items.values():
            items_data.append({
                "id": item.id,
                "type": item.type.value,
                "color": item.color,
                "code": item.dresscode.value,
                "fit": item.fit.value,
                "image_url": item.image_url,
            })

        with open(self.filename, 'w') as f:
            json.dump(items_data, f, indent=4)

    def load_items(self) -> Dict[str, ClothingItem]:
        """Load clothing items from JSON file"""
        try:
            with open(self.filename, 'r') as f:
                items_data = json.load(f)

            items: Dict[str, ClothingItem] = {}
            for item_data in items_data:
                kwargs: Dict[str, Any] = dict(
                    type=ClothingType(item_data["type"]),
                    color=item_data["color"],
                    dresscode=DressCode(item_data["code"]),
                    fit=ClothingFit(item_data["fit"]),
                    image_url=item_data.get("image_url"),
                )
                if item_data.get("id"):
                    kwargs["id"] = item_data["id"]
                item = ClothingItem(**kwargs)
                items[item.id] = item
            return items

        except FileNotFoundError:
            return {}
