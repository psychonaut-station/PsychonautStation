from PIL import Image

im0 = Image.open(r'D:\CODE GIGAS\PsychonautStationMy\scratch\tile_0_0.png').convert('RGB')
im1 = Image.open(r'D:\CODE GIGAS\PsychonautStationMy\scratch\tile_1_0.png').convert('RGB')

skull0 = im0.crop((0, 24, 32, 64)).resize((32*4, 40*4), Image.NEAREST)
skull1 = im1.crop((0, 24, 32, 64)).resize((32*4, 40*4), Image.NEAREST)

skull0.save(r'D:\CODE GIGAS\PsychonautStationMy\scratch\body0.png')
skull1.save(r'D:\CODE GIGAS\PsychonautStationMy\scratch\body1.png')
print("Saved body0 and body1")
