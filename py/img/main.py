from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont


font18 = ImageFont.truetype("/Users/robertdegen/Downloads/fonts/usr/share/fonts/truetype/freefont/FreeMono.ttf", 18)
font18b = ImageFont.truetype("/Users/robertdegen/Downloads/fonts/usr/share/fonts/truetype/freefont/FreeMonoBold.ttf", 18)

with Image.new("RGB", (132,132), (0,0,180)) as img:
    draw = ImageDraw.Draw(img)
    draw.multiline_text((10,10), "öä\nü", font=font18b, fill=(0xff,0xff,0xff))
    draw.line((30,30))
    img.save("test.jpg", optimize=True, progressive=True, quality=95)