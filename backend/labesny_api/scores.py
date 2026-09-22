from .rules import ColorMatchingRules, FitMatchingRules
from .enums import DressCode, ClothingFit
from .colors import ColorConverter

def calculate_match_score(top, bottom):
    score = 0
    '''
    # Color compatibility (0-10 points)
    if are_colors_complementary(top.colour, bottom.colour):
        score += 10
    elif are_colors_analogous(top.colour, bottom.colour):
        score += 8
    elif are_colors_neutral(top.colour, bottom.colour):
        score += 6

'''
    if ColorMatchingRules.are_colors_identical(top.color, bottom.color):
        score += 3  
    else:
        rgb1 = ColorConverter.color_to_rgb(top.color)
        rgb2 = ColorConverter.color_to_rgb(bottom.color)
        if rgb1 and rgb2 and ColorConverter.are_colors_in_same_palette(rgb1, rgb2):
            score += 5  
    
    if top.dresscode == bottom.dresscode:
        score += 5
    elif top.dresscode == DressCode.FORMAL and bottom.dresscode == DressCode.CASUAL:
        score += 3
    elif top.dresscode == DressCode.CASUAL and bottom.dresscode == DressCode.FORMAL:
        score += 4
    
    # could be made with are_fits_compatible(rules) but scores more costumizable this way 
    if FitMatchingRules.are_fits_identical(top.fit, bottom.fit):
        score += 5
    elif top.fit == ClothingFit.SLIM and bottom.fit == ClothingFit.OVERSIZED:
        score += 3
    elif (top.fit == ClothingFit.SLIM and bottom.fit == ClothingFit.REGULAR):
        score += 3
    elif (top.fit == ClothingFit.REGULAR and bottom.fit == ClothingFit.OVERSIZED):
        score += 4
    elif (top.fit == ClothingFit.OVERSIZED and bottom.fit == ClothingFit.REGULAR):
        score += 4
    
    return score