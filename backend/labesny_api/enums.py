from enum import Enum

class DressCode(Enum):
    FORMAL = "formal"
    CASUAL = "casual"

class ClothingType(Enum):
    SHIRT = "shirt" 
    PANTS = "pants"
    #HOODIE = "hoodie"

class ClothingFit(Enum):
    SLIM = "slim"
    REGULAR = "regular"
    OVERSIZED = "oversized"
