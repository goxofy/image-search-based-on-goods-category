clear;

img = 1;      
filename = num2str(img);
str1 = ('path_to_dir');
str2 = ('.dat');
img = strcat(str1,filename,str2);
fid = fopen(img,'rb');
IMG = fread(fid,[1,256],'long');
fclose(fid);        %%%假设检测的是图1,从图像数据库中读取数据并输出到IMG矩阵中

for number = 0:29   %%%利用循环依次读入图像数据库
	filename = num2str(number);
	distance = 0;
	imgdata = strcat(str1,filename,str2);
	fid = fopen(imgdata,'rb');
	Number = fread(fid,[1,256],'long'); 
	distance = sum(abs(IMG - Number));    %%%求出相似度
	
end

d=normest(distance);

