from typing import Set, Optional, Dict, Any, Tuple
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
        self.items: Set[ClothingItem] = self.storage.load_items()

    
    def add_item(self, 
                    type: str, 
                    color: str, 
                    dresscode: str, 
                    fit: str) -> ClothingItem:
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
            fit=fit_enum
        )
        
        self.items.add(new_item)
        self.storage.save_items(self.items)
        return new_item

    
    def remove_item(self, item_id: Optional[int] = None) -> None:
        """
        Remove an item by ID or interactively
        """
        if not self.items:
            raise ValueError("Wardrobe is empty!")

        # API mode - remove by ID
        if item_id is not None:
            item_to_remove = next((item for item in self.items if item.id == item_id), None)
            if not item_to_remove:
                raise ValueError(f"No item found with ID {item_id}")
            self.items.remove(item_to_remove)
            self.storage.save_items(self.items)
            return

        # Interactive mode
        print("\nSelect item to remove:")
        items_list = list(self.items)
        for i, item in enumerate(items_list, 1):
            print(f"{i}. {item.color} {item.type.value} ({item.dresscode.value}, {item.fit.value})")
        
        try:
            choice = int(input("Enter number to remove (0 to cancel): "))
            if choice == 0:
                return
            removed_item = items_list[choice - 1]
            self.items.remove(removed_item)
            self.storage.save_items(self.items)
            print(f"\nRemoved: {removed_item.color} {removed_item.type.value}")
        except (ValueError, IndexError):
            print("\nInvalid selection. Nothing removed.")
            
    def get_items(self) -> Set[ClothingItem]:
        """Return all items in the wardrobe"""
        return self.items
    
    def get_random_outfit(self) -> Optional[Tuple[ClothingItem, ClothingItem, int]]:
        """Returns a random outfit from the already matched outfits."""
        # Get all matching outfits
        items = self.get_items()
        matching_outfits = find_matching_outfits(items)
        random_outfit = random.choice(matching_outfits)
        
        # If no matches found, return None
        if not matching_outfits:
            return None
        
        # Return a random outfit with its score
        return random_outfit

    def to_dict(self, item: ClothingItem) -> Dict[str, Any]:
        """Convert ClothingItem to a dictionary for API response"""
        return {
            "id": item.id,
            "color": item.color,
            "type": item.type.value,
            "dresscode": item.dresscode.value,
            "fit": item.fit.value
        }