import webcolors
from typing import Tuple, Optional, List
from PIL.ImageColor import getrgb  # More explicit import
import numpy as np
import palettable

class ColorConverter:
    @staticmethod
    def color_to_rgb(color_name: str) -> Optional[Tuple[int, int, int]]:
        """Convert a color name to its RGB value using webcolors."""
        try:
            return webcolors.name_to_rgb(color_name.lower())
        except ValueError:
            try:
                return getrgb(color_name)
            except ValueError:
                return None

    @staticmethod
    def is_valid_color(color_name: str) -> bool:
        """Check if a color name can be converted to RGB."""
        return ColorConverter.color_to_rgb(color_name) is not None

    @staticmethod
    def rgb_to_hex(rgb: Tuple[int, int, int]) -> str:
        """Convert RGB tuple to hex color code."""
        return '#{:02x}{:02x}{:02x}'.format(rgb[0], rgb[1], rgb[2])
    
    @staticmethod
    def rgb_distance(color1, color2):
        """Calculate Euclidean distance between two RGB colors"""
        return np.linalg.norm(np.array(color1) - np.array(color2))
    
    @staticmethod
    def find_closest_palette_color(input_color, palettes):
        """Find the closest color and its palette"""
        closest_color = None
        min_distance = float("inf")
        best_palette = None

        for palette_name, palette in palettes.items():
            for color in palette:
                dist = ColorConverter.rgb_distance(input_color, color)
                if dist < min_distance:
                    min_distance = dist
                    closest_color = color
                    best_palette = palette_name

        return best_palette, closest_color, min_distance
    
    @staticmethod
    def get_available_palettes():
        """Get a dictionary of available palettes"""
        palettes = {
            'Set3_12': palettable.colorbrewer.qualitative.Set3_12.colors,
            'Tableau_10': palettable.tableau.Tableau_10.colors,
            'Balance_20': palettable.cmocean.diverging.Balance_20.colors
        }
        return palettes
    
    @staticmethod
    def are_colors_in_same_palette(color1_rgb: Tuple[int, int, int], 
                                 color2_rgb: Tuple[int, int, int], 
                                 threshold: float = 100.0) -> bool:
        """Check if two RGB colors exist in the same palette"""
        palettes = ColorConverter.get_available_palettes()
        
        for palette_colors in palettes.values():
            min_dist1 = min(ColorConverter.rgb_distance(color1_rgb, palette_color) 
                          for palette_color in palette_colors)
            min_dist2 = min(ColorConverter.rgb_distance(color2_rgb, palette_color) 
                          for palette_color in palette_colors)
            
            if min_dist1 < threshold and min_dist2 < threshold:
                return True
                
        return False
    
    @staticmethod
    def find_color_palette(color_rgb: Tuple[int, int, int], threshold: float = 100.0) -> List[str]:
        """Find all palettes that contain this color"""
        matching_palettes = []
        palettes = ColorConverter.get_available_palettes()
        
        for palette_name, palette_colors in palettes.items():
            min_dist = min(ColorConverter.rgb_distance(color_rgb, palette_color) 
                         for palette_color in palette_colors)
            if min_dist < threshold:
                matching_palettes.append(palette_name)
                
        return matching_palettes
'''
# Example usage:
if __name__ == "__main__":
    converter = ColorConverter()
    
    # Test with a specific color
    test_color = "white"
    rgb_color = converter.color_to_rgb(test_color)
    
    if rgb_color:
        palettes = converter.get_available_palettes()
        best_palette, closest_color, distance = converter.find_closest_palette_color(rgb_color, palettes)
        
        if closest_color is None:
            print(f"No matching color found in any palette for {test_color}")
        else:
            print(f"Input color: {test_color} (RGB: {rgb_color})")
            print(f"Closest color found in palette: {closest_color}")
            print(f"From palette: {best_palette}")
            print(f"Distance: {distance:.2f}")
    else:
        print(f"Color '{test_color}' not found in known color names")
        '''