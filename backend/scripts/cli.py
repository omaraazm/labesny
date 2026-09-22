from labesny_api.wardrobe_manager import WardrobeManager
from labesny_api.matching import find_matching_outfits
from labesny_api.colors import ColorConverter

def main():
    wardrobe = WardrobeManager()
    
    while True:
        print("\nWardrobe Manager")
        print("1. Add Item")
        print("2. Remove Item")
        print("3. View All Items")
        print("4. Show Matching Outfits")
        print("5. Show Items with Palettes")
        print("6. Exit")
        
        choice = input("\nEnter your choice (1-6): ")
        
        if choice == "1":
            wardrobe.add_item()
        elif choice == "2":
            wardrobe.remove_item()
        elif choice == "3":
            items = wardrobe.get_items()
            print("\nAll Clothing Items:")
            for item in items:
                print(f"{item.color} {item.type.value} ({item.dresscode.value}, {item.fit.value})")
        elif choice == "4":
            items = wardrobe.get_items()
            matching_outfits = find_matching_outfits(items)
            print("\nMatching Outfits (sorted by score):")
            for shirt, pants, score in matching_outfits:
                print(f"{shirt.color} {shirt.type.value} ({shirt.dresscode.value}, {shirt.fit.value}) with "
                      f"{pants.color} {pants.type.value} ({pants.dresscode.value}, {pants.fit.value})"
                      f" - Score: {score}")
        elif choice == "5":
            items = wardrobe.get_items()
            print("\nClothing Items with their Color Palettes:")
            for item in items:
                rgb_color = ColorConverter.color_to_rgb(item.color)
                if rgb_color:
                    palettes = ColorConverter.find_color_palette(rgb_color)
                    print(f"\n{item.color} {item.type.value}:")
                    if palettes:
                        print("Found in palettes:")
                        for palette in palettes:
                            print(f"- {palette}")
                    else:
                        print("Not found in any palette")
        elif choice == "6":
            break
        else:
            print("\nInvalid choice. Please try again.")
'''
if __name__ == "__main__":
    main()
'''
