from PIL import Image
for i in range(10):
    im=Image.open(str(i)+'.png')
    (width,height)=im.size
    px=im.load()
    with open('horizon2.coe','w') as f:
        print('memory_initialization_radix=2;',file=f)
        print('memory_initialization_vector=',file=f)
        for y in range(0,height,2):
            for x in range(0,width,2):
                if px[x,y]==(0,0,0,0):
                    print('0',end=',',file=f)
                elif px[x,y]==(83,83,83,255):
                    print('1',end=',',file=f)
                else:
                    print('0',end=',',file=f)
            print('',file=f)