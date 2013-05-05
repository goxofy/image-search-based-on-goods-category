clear,clc
I=imread('Lena.jpg');
figure,imshow(I),title('原始图像')
I=double(I);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
Y = 0.299*R + 0.587*G + 0.114*B;
U = -0.147*R - 0.289*G + 0.436*B;
V = 0.615*R - 0.515*G - 0.100*B;
J=cat(3,Y,U,V);
figure,imshow(J,[]),title('RGB转化为YUV的图像')
R1 = Y + 1.14*V;
G1 = Y - 0.39*U - 0.58*V;
B1= Y + 2.03*U;
I1=cat(3,R1,G1,B1);
figure,imshow(uint8(I1)),title('YUV转化为RGB的图像')

