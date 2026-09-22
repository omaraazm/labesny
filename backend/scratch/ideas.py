# THIS FILE IS USELESS AND IS MADE PURELY FOR TESTING STUFF OUT, TRYING OUT NEW IDEAS
# OR DUMPING IN CODE YOU'RE STILL NOT SO SURE ABOUT DELETING




import matplotlib.pyplot as plt
from palettable.cmocean.diverging import Balance_20

colors = Balance_20.colors

# Create a figure
fig, ax = plt.subplots(figsize=(10, 2))

# Display colors as a horizontal bar
for i, color in enumerate(colors):
    ax.add_patch(plt.Rectangle((i, 0), 1, 1, color=[c/255 for c in color]))

ax.set_xlim(0, len(colors))
ax.set_ylim(0, 1)
ax.set_xticks([])
ax.set_yticks([])
plt.show()


# Get RGB values
balance_rgb = Balance_20.colors

# Print RGB values
for i, color in enumerate(balance_rgb):
    print(f"Color {i + 1}: {color}")
