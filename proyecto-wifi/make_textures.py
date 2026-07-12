from PIL import Image, ImageDraw
import random

# Piso: Tiles / Terrazo
img = Image.new('RGB', (256, 256), color=(230, 230, 230))
draw = ImageDraw.Draw(img)
for _ in range(8000):
    x, y = random.randint(0, 255), random.randint(0, 255)
    c = random.choice([(50,50,50), (150,150,150), (100,100,100), (255,255,255)])
    draw.point((x,y), fill=c)
for i in range(0, 256, 64):
    draw.line([(0, i), (256, i)], fill=(180, 180, 180), width=2)
    draw.line([(i, 0), (i, 256)], fill=(180, 180, 180), width=2)
img.save("textures/floor.png")

# Madera
img2 = Image.new('RGB', (256, 256), color=(120, 65, 20))
draw2 = ImageDraw.Draw(img2)
for _ in range(150):
    y = random.randint(0, 255)
    c = random.randint(80, 140)
    draw2.line([(0, y), (256, y)], fill=(c, int(c*0.5), int(c*0.15)), width=random.randint(1,4))
img2.save("textures/wood.png")

# Pared
img3 = Image.new('RGB', (256, 256), color=(250, 250, 250))
draw3 = ImageDraw.Draw(img3)
for _ in range(3000):
    x, y = random.randint(0, 255), random.randint(0, 255)
    c = random.randint(235, 255)
    draw3.point((x,y), fill=(c,c,c))
img3.save("textures/wall.png")
