%% 读入图像
filename = num2str(1);
str1 = ('PI100_test_dir');
str2 = ('.jpg');
imgpath = strcat(str1,filename,str2);
Img = imread(imgpath);

%% 获取图像尺寸
[m,n,k] = size(Img);

%% 把图像分成 8×8=64 块，并求出每一块的具体位置
cnum = 8;
ch = floor(m/cnum); cw = floor(n/cnum);
h1 = (0:(cnum-1))*ch + 1; h2 = (1:cnum)*ch;
w1 = (0:(cnum-1))*cw + 1; w2 = (1:cnum)*cw;

%% 生成一个三维全零矩阵，用来临时存放每一个分块的数据
I = zeros([cnum,cnum,3]);

%% 利用循环对每个分块进行处理,找出每个分块的代表色
for i = 1 : cnum
    for j = 1 : cnum 
        lstart=(i-1)*ch;
        hstart=(j-1)*cw;
                   
        temp = Img(h1(i):h2(i), w1(j):w2(j), :); 
        
        for p=1:ch
           for q=1:cw
               temp(p,q,1)=Img(p+lstart,q+hstart,1);
               temp(p,q,2)=Img(p+lstart,q+hstart,2);
               temp(p,q,3)=Img(p+lstart,q+hstart,3);  
           end
        end

        temp1=temp(:,:,1);
        temp2=temp(:,:,2);
        temp3=temp(:,:,3);

        tmp1 = temp1(:)';
        tmp2 = temp2(:)';
        tmp3 = temp3(:)';
         
        I(i,j,1) = mean(tmp1);
        I(i,j,2) = mean(tmp2);
        I(i,j,3) = mean(tmp3);
    end
end

%% 转换到YCbCr颜色空间，这个操作会同时将三个维度同时转换
I=rgb2ycbcr(I); 

%% 对每个分块进行DCT变换
DCTY  = I(:,:,1);
DCTCb = I(:,:,2);
DCTCr = I(:,:,3);

T=dctmtx(8);
DCTcoe1=blkproc(DCTY,[8,8],'P1*x*P2',T,T');
DCTcoe2=blkproc(DCTCb,[8,8],'P1*x*P2',T,T');
DCTcoe3=blkproc(DCTCr,[8,8],'P1*x*P2',T,T'); %%%对每个分块应用矩阵式P1×P2进行处理,其中P1=T,P2=T
 
mask=[1 1 1 1 0 0 0 0
      1 1 1 0 0 0 0 0
      1 1 0 0 0 0 0 0
      1 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0]; %% 二值掩模,用来压缩DCT的系数
  
B1=blkproc(DCTcoe1,[8 8],'P1.*x',mask); %% 只保留DCT变换的10个系数
B2=blkproc(DCTcoe2,[8 8],'P1.*x',mask);
B3=blkproc(DCTcoe3,[8 8],'P1.*x',mask);

I(:,:,1)=blkproc(B1,[8 8],'P1*x*P2',T',T); %% 逆DCT变换,用来重构图像
I(:,:,2)=blkproc(B2,[8 8],'P1*x*P2',T',T);
I(:,:,3)=blkproc(B3,[8 8],'P1*x*P2',T',T);
