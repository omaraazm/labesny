from typing import Set, List, Tuple
from .clothes import ClothingItem
from .rules import ColorMatchingRules, FitMatchingRules
from .scores import calculate_match_score

def matches(item1: ClothingItem, item2: ClothingItem) -> bool:
    """Check if two clothing items match based on score threshold."""
    score = calculate_match_score(item1, item2)
    return score >= 0  # Minimum acceptable score

def find_matching_outfits(items: Set[ClothingItem]) -> List[Tuple[ClothingItem, ClothingItem, int]]:
    """Find all valid outfit combinations from a set of clothing items."""
    matches_list = []
    
    # Get all shirts and pants 
    # Add other ClothingItems later law 3ayez
    shirts = [item for item in items if item.is_shirt]
    pants = [item for item in items if item.is_pants]
    
    # Match each shirt with compatible pants
    # lessa me7taga ba3bas after adding other clothing types
    for shirt in shirts:
        for pant in pants:
            score = calculate_match_score(shirt, pant)
            if matches(shirt, pant):
                matches_list.append((shirt, pant, score))
    
    # Sort by score in descending order (cursor)
    matches_list.sort(key=lambda x: x[2], reverse=True)
    return matches_list
