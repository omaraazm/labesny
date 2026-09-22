from pydantic import BaseModel
from typing import List, Optional, Tuple
from uuid import UUID


class ClothingItemBase(BaseModel):
    #id: UUID
    type: str
    color: str
    dresscode: str
    fit: str
    #image_url: Optional[str] = None

class Outfit(BaseModel):
    shirt: ClothingItemBase
    pants: ClothingItemBase
    score: float

class ColorPalette(BaseModel):
    item: ClothingItemBase
    palettes: List[str]
