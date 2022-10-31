function I = readimg(number)
filename = num2str(number); %%%读取图像并转换为YCbCr
str1 = ('pic_dir');
str2 = ('.jpg');
imgpath = strcat(str1,filename,str2);
I = imread(imgpath);
