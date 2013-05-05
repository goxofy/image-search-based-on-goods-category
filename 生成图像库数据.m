clear;
for number = 0:29
	filename = num2str(number);
	str1 = ('E:\jpeg\');
	str11 = ('E:\jpeg\data\');
	str2 = ('.jpg');
	str3 = ('.dat');
	imgpath = strcat(str1,filename,str2);
	I = imread(imgpath);
	Im = rgb2gray(I);
	imshow(Im);  %%%读入图像并显示出来
	
	[m,n] = size(Im);  %%%获取图像尺寸
	x = zeros(1,256);   %%%生成一个矩阵用于后面保存像素点个数
	
	for y = 0:255
		flag = 0;
		for i = 1:m
			for j = 1:n
				if Im(i,j) == y
					flag = flag + 1;
				end
			end
		end
		x(1,y+1) = flag;
	end   %%%统计出每个灰度值的像素点个数，并放置到 x 矩阵中
	
	datapath = strcat(str11,filename,str3);
	fid = fopen(datapath,'wb');
	fwrite(fid,x,'long');
	fclose(fid);     %%%储存每幅图的矩阵到一个二进制文件中
	
	figure(1),bar(x);
	title('灰度直方图');
	xlabel('灰度值');
	ylabel('出现次数'); %%%画直方图，只能画出最后一幅图的直方图

end