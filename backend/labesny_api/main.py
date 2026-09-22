from fastapi import FastAPI, HTTPException, Request, File, UploadFile
from typing import List
from .wardrobe_manager import WardrobeManager
from .matching import find_matching_outfits
from .colors import ColorConverter
import uuid
from .models import ClothingItemBase, Outfit, ColorPalette
import logging
import boto3  # For AWS S3
from fastapi.responses import JSONResponse
import os

app = FastAPI()
logging.basicConfig(level=logging.DEBUG)  # Enable logging
wardrobe = WardrobeManager()

# Create a directory to store uploaded images
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.post("/items/", response_model=ClothingItemBase)
async def add_item(item: ClothingItemBase):
    try:
        new_item = wardrobe.add_item(
            #id=item.id,
            type=item.type,
            color=item.color,
            dresscode=item.dresscode,
            fit=item.fit
            #image_url=image_url
        )
        return new_item
    except Exception as e:
        logging.error(f"Error adding item: {str(e)}", exc_info=True)
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/upload-image/")
async def upload_image(file: UploadFile = File(...)):
    try:
        # Generate a unique filename
        file_extension = file.filename.split(".")[-1]
        filename = f"{uuid.uuid4()}.{file_extension}"
        file_path = os.path.join(UPLOAD_DIR, filename)
        
        # Save the file to the upload directory
        with open(file_path, "wb") as buffer:
            buffer.write(await file.read())
        
        # Generate a local URL (for testing purposes)
        image_url = f"http://localhost:8000/{UPLOAD_DIR}/{filename}"
        
        return JSONResponse(content={"image_url": image_url})
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

@app.delete("/items/{item_id}")
async def remove_item(item_id: int):
    try:
        wardrobe.remove_item(item_id)
        return {"message": "Item removed successfully"}
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))

@app.get("/items/", response_model=List[ClothingItemBase])
async def get_items():
    items = wardrobe.get_items()
    if not items:
        raise HTTPException(
            status_code=404,
            detail="The wardrobe is empty. No items found."
        )
    # Convert ClothingItem objects to dictionaries for serialization
    return [
        {
            "type": item.type.value,
            "color": item.color,
            "dresscode": item.dresscode.value,
            "fit": item.fit.value
        }
        for item in items
    ]

@app.get("/outfits/", response_model=List[Outfit])
async def get_matching_outfits():
    items = wardrobe.get_items()
    matching_outfits = find_matching_outfits(items)
    
    if not matching_outfits:
        raise HTTPException(
            status_code=404,
            detail="No matching outfits found."
        )
    
    return [
        Outfit(
            shirt=ClothingItemBase(
                type=shirt.type.value,
                color=shirt.color,
                dresscode=shirt.dresscode.value,
                fit=shirt.fit.value
            ),
            pants=ClothingItemBase(
                type=pants.type.value,
                color=pants.color,
                dresscode=pants.dresscode.value,
                fit=pants.fit.value
            ),
            score=score
        )
        for shirt, pants, score in matching_outfits
    ]

@app.get("/outfits/random/", response_model=Outfit)
async def get_random_outfit():
    """Returns a random outfit with its score."""
    random_outfit = wardrobe.get_random_outfit()
    if not random_outfit:
        raise HTTPException(
            status_code=404,
            detail="No matching outfits found."
        )
    
    shirt, pants, score = random_outfit
    return Outfit(
        shirt=ClothingItemBase(
            type=shirt.type.value,
            color=shirt.color,
            dresscode=shirt.dresscode.value,
            fit=shirt.fit.value
        ),
        pants=ClothingItemBase(
            type=pants.type.value,
            color=pants.color,
            dresscode=pants.dresscode.value,
            fit=pants.fit.value
        ),
        score=score
    )

@app.get("/outfits/best/", response_model=Outfit)
async def get_best_outfit():
    """Returns the outfit with the highest score."""
    items = wardrobe.get_items()
    matching_outfits = find_matching_outfits(items)
    
    if not matching_outfits:
        raise HTTPException(
            status_code=404,
            detail="No matching outfits found."
        )
    
    # Get the outfit with the highest score
    best_outfit = max(matching_outfits, key=lambda x: x[2])
    shirt, pants, score = best_outfit
    
    return Outfit(
        shirt=ClothingItemBase(
            type=shirt.type.value,
            color=shirt.color,
            dresscode=shirt.dresscode.value,
            fit=shirt.fit.value
        ),
        pants=ClothingItemBase(
            type=pants.type.value,
            color=pants.color,
            dresscode=pants.dresscode.value,
            fit=pants.fit.value
        ),
        score=score
    )

@app.get("/items/palettes/", response_model=List[ColorPalette])
async def get_items_with_palettes():
    items = wardrobe.get_items()
    result = []
    
    for item in items:
        rgb_color = ColorConverter.color_to_rgb(item.color)
        palettes = []
        if rgb_color:
            palettes = ColorConverter.find_color_palette(rgb_color)
        
        result.append(ColorPalette(
            item=ClothingItemBase(
                type=item.type.value,
                color=item.color,
                dresscode=item.dresscode.value,
                fit=item.fit.value
            ),
            palettes=palettes
        ))
    
    return result



