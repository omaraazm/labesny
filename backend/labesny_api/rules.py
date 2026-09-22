from typing import Dict, Set, List, Optional
from .enums import DressCode, ClothingFit
from .colors import ColorConverter



class ColorMatchingRules:

    @staticmethod
    def colors_match(color1: str, color2: str) -> bool:
        """Check if two colors match according to palette compatibility."""
        if color1.lower() == color2.lower():
            return True
            
        rgb1 = ColorConverter.color_to_rgb(color1)
        rgb2 = ColorConverter.color_to_rgb(color2)
        
        if rgb1 is None or rgb2 is None:
            return False
            
        return ColorConverter.are_colors_in_same_palette(rgb1, rgb2)
    
    @staticmethod
    def get_matching_colors(color: str) -> Set[str]:
        """Get all colors that match with the given color from palettes."""
        rgb = ColorConverter.color_to_rgb(color)
        if rgb is None:
            return set()
            
        matching_colors = set()
        palettes = ColorConverter.get_available_palettes()
        
        for palette_colors in palettes.values():
            for palette_color in palette_colors:
                if ColorConverter.rgb_distance(rgb, palette_color) < 30.0:
                    matching_colors.add(palette_color)
                    
        return matching_colors
    
    @staticmethod
    def is_valid_color(color: str) -> bool:
        """Check if a color can be converted to RGB."""
        return ColorConverter.is_valid_color(color)
    
    @staticmethod
    def get_all_colors() -> List[str]:
        """Get a list of all available colors."""
        return list(ColorMatchingRules.compatible_colors.keys())
    
    @staticmethod
    def are_colors_identical(color1: str, color2: str) -> bool:
        """Check if both colours are identical"""
        return color1.lower() == color2.lower()
    
    @staticmethod
    def are_dresscodes_compatible(dresscode1: DressCode, dresscode2: DressCode) -> bool:
        """
        Check if dresscodes of different Clothing Items are compatible.
        Returns True for:
        - Formal with Casual
        - Casual with Formal
        """
        return ((dresscode1 == DressCode.FORMAL and dresscode2 == DressCode.CASUAL) or
                (dresscode1 == DressCode.CASUAL and dresscode2 == DressCode.FORMAL))
    
class FitMatchingRules:

    @staticmethod
    def are_fits_identical(fit1:ClothingFit, fit2: ClothingFit) -> bool:
        """Check if both fits are identical"""
        return fit1 == fit2

    @staticmethod
    def are_fits_compatible(fit1: ClothingFit, fit2: ClothingFit) -> bool:
        """
        Check if clothing fits are compatible with each other.
        """
        return((fit1 == ClothingFit.SLIM and fit2 == ClothingFit.OVERSIZED)or
               (fit1 == ClothingFit.SLIM and fit2 == ClothingFit.REGULAR)or
               (fit1 == ClothingFit.REGULAR and fit2 == ClothingFit.OVERSIZED)or
               (fit1 == ClothingFit.OVERSIZED and fit2 == ClothingFit.REGULAR))

    