function Descriptor = ColorLayout(Image)
Img = Image;

%%颜色分割%%
%%代表色选择%%

[m,n,k] = size(Img);

cnum = 8;
ch = floor(m/cnum); cw = floor(n/cnum);
t1 = (0:(cnum-1))*ch + 1; t2 = (1:cnum)*ch;
t3 = (0:(cnum-1))*cw + 1; t4 = (1:cnum)*cw;

I = zeros([cnum,cnum,3]);
for i = 1 : cnum
    for j = 1 : cnum 
        lstart=(i-1)*ch;
        hstart=(j-1)*cw;
                   
        temp = Img(t1(i):t2(i), t3(j):t4(j), :); 
        
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

%%DCT转换%%

I=rgb2ycbcr(I);   %转换为YCbCr色彩空间

DCTY  = I(:,:,1);
DCTCb = I(:,:,2);
DCTCr = I(:,:,3);

T=dctmtx(8);
DCTcoe1=blkproc(DCTY,[8,8],'P1*x*P2',T,T');
DCTcoe2=blkproc(DCTCb,[8,8],'P1*x*P2',T,T');
DCTcoe3=blkproc(DCTCr,[8,8],'P1*x*P2',T,T');
 
mask=[1 1 1 1 0 0 0 0
      1 1 1 0 0 0 0 0
      1 1 0 0 0 0 0 0
      1 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0];
  
B1=blkproc(DCTcoe1,[8 8],'P1.*x',mask);
B2=blkproc(DCTcoe2,[8 8],'P1.*x',mask);
B3=blkproc(DCTcoe3,[8 8],'P1.*x',mask);

I(:,:,1)=blkproc(B1,[8 8],'P1*x*P2',T',T);
I(:,:,2)=blkproc(B2,[8 8],'P1*x*P2',T',T);
I(:,:,3)=blkproc(B3,[8 8],'P1*x*P2',T',T);

% Set up array for fast conversion from row/column coordinates to
% zig zag order. 下标从零开始，从MPEG的C代码拷贝过来的
zigzag = [ 0, 1, 8, 16, 9, 2, 3, 10, ...
      17, 24, 32, 25, 18, 11, 4, 5, ...
      12, 19, 26, 33, 40, 48, 41, 34, ...
      27, 20, 13, 6, 7, 14, 21, 28, ...
      35, 42, 49, 56, 57, 50, 43, 36, ...
      29, 22, 15, 23, 30, 37, 44, 51, ...
      58, 59, 52, 45, 38, 31, 39, 46, ...
      53, 60, 61, 54, 47, 55, 62, 63];

zigzag = zigzag + 1;
% 将输入块变成3x64的向量

D(1,:) = reshape(I(:,:,1)',1,64); 
D(2,:) = reshape(I(:,:,2)',1,64);
D(3,:) = reshape(I(:,:,3)',1,64);

Descriptor = D(:,zigzag); % 对I按照查表方式取元素，得到 zig-zag 扫描结果

