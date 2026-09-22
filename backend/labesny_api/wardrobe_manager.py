from typing import Dict, List, Optional, Any, Tuple
from .clothes import ClothingItem
from .enums import ClothingType, DressCode, ClothingFit
from .rules import ColorMatchingRules
from .wardrobe import WardrobeStorage
from .colors import ColorConverter
from fastapi import FastAPI
from .matching import find_matching_outfits
import random


class WardrobeManager:
    def __init__(self):
        self.storage = WardrobeStorage()
        self.items: Dict[str, ClothingItem] = self.storage.load_items()


    def add_item(self,
                    type: str,
                    color: str,
                    dresscode: str,
                    fit: str,
                    image_url: Optional[str] = None) -> ClothingItem:
        """
        Add a new clothing item
        """
        try:
            type_enum = ClothingType(type)
            dresscode_enum = DressCode(dresscode)
            fit_enum = ClothingFit(fit)
        except ValueError as e:
            raise ValueError(f"Invalid input: {str(e)}")

        if not ColorConverter.is_valid_color(color):
            raise ValueError(f"Invalid color: {color}")

        new_item = ClothingItem(
            type=type_enum,
            color=color,
            dresscode=dresscode_enum,
            fit=fit_enum,
            image_url=image_url,
        )

        self.items[new_item.id] = new_item
        self.storage.save_items(self.items)
        return new_item


    def remove_item(self, item_id: Optional[str] = None) -> None:
        """
        Remove an item by ID or interactively
        """
        if not self.items:
            raise ValueError("Wardrobe is empty!")

        # API mode - remove by ID
        if item_id is not None:
            if item_id not in self.items:
                raise ValueError(f"No item found with ID {item_id}")
            del self.items[item_id]
            self.storage.save_items(self.items)
            return

        # Interactive mode
        print("\nSelect item to remove:")
        items_list = list(self.items.values())
        for i, item in enumerate(items_list, 1):
            print(f"{i}. {item.color} {item.type.value} ({item.dresscode.value}, {item.fit.value})")

        try:
            choice = int(input("Enter number to remove (0 to cancel): "))
            if choice == 0:
                return
            removed_item = items_list[choice - 1]
            del self.items[removed_item.id]
            self.storage.save_items(self.items)
            print(f"\nRemoved: {removed_item.color} {removed_item.type.value}")
        except (ValueError, IndexError):
            print("\nInvalid selection. Nothing removed.")

    def get_items(self) -> List[ClothingItem]:
        """Return all items in the wardrobe"""
        return list(self.items.values())

    def get_random_outfit(self) -> Optional[Tuple[ClothingItem, ClothingItem, int]]:
        """Returns a random outfit from the already matched outfits."""
        # Get all matching outfits
        items = self.get_items()
        matching_outfits = find_matching_outfits(items)

        # If no matches found, return None
        if not matching_outfits:
            return None

        # Return a random outfit with its score
        return random.choice(matching_outfits)

    def to_dict(self, item: ClothingItem) -> Dict[str, Any]:
        """Convert ClothingItem to a dictionary for API response"""
        return {
            "id": item.id,
            "color": item.color,
            "type": item.type.value,
            "dresscode": item.dresscode.value,
            "fit": item.fit.value,
            "image_url": item.image_url,
        }
