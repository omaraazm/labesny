from pydantic import BaseModel
from typing import List, Optional


class ClothingItemBase(BaseModel):
    id: Optional[str] = None
    type: str
    color: str
    dresscode: str
    fit: str
    image_url: Optional[str] = None

class Outfit(BaseModel):
    shirt: ClothingItemBase
    pants: ClothingItemBase
    score: float

class ColorPalette(BaseModel):
    item: ClothingItemBase
    palettes: List[str]
