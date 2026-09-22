from .enums import ClothingType, DressCode, ClothingFit
from dataclasses import dataclass
from typing import Optional

# Using dataclass for automatic initialization and comparison methods
@dataclass(frozen=True) # frozen=True makes it hashable like Swift's Hashable
class ClothingItem:
    type: ClothingType
    color: str
    dresscode: DressCode
    fit: ClothingFit
    
    @property
    def name(self) -> str:
        return f"{self.color} {self.code.value} {self.type.value} {self.fit.value}"
    
    # Helper methods
    # missing some stuff! but not so important ig?
    @property
    def is_shirt(self) -> bool:
        return self.type == ClothingType.SHIRT
    
    @property
    def is_pants(self) -> bool:
        return self.type == ClothingType.PANTS
        
    @property
    def is_formal(self) -> bool:
        return self.code == DressCode.FORMAL
        
    @property
    def is_casual(self) -> bool:
        return self.code == DressCode.CASUAL

    """
    @property
    def is_shoes(self) -> bool:
        return self.type == ClothingType.SHOES
    """
