from PIL import Image
im=Image.open('cloud.png')
(width,height)=im.size
px=im.load()
with open('cloud.coe','w') as f:
    print('memory_initialization_radix=2;',file=f)
    print('memory_initialization_vector=',file=f)
    for y in range(height):
        for x in range(width):
            if px[x,y]==(218,218,218,255):
                print('1',end=',',file=f)
            else:
                print('0',end=',',file=f)
        print('',file=f)