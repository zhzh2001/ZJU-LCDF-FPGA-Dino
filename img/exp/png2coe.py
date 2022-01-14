from PIL import Image
im=Image.open('default.png')
(width,height)=im.size
px=im.load()
with open('default.coe','w') as f:
    print('memory_initialization_radix=2;',file=f)
    print('memory_initialization_vector=',file=f)
    for y in range(0,height,2):
        for x in range(0,width,2):
            if px[x,y]==(247,247,247,255):
                print('01',end=',',file=f)
            elif px[x,y]==(83,83,83,255):
                print('10',end=',',file=f)
            else:
                print('00',end=',',file=f)
        print('',file=f)