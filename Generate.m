function effect = Generate(Img,H,W,sc)
% Stroke Structure Generation

% Smooth the picture
h = ones(3,3) /9;
Img = imfilter(Img,h);

% Find the edge by gradient
[Gmag,Gdir] = imgradient(Img,'sobel');
% figure(1);
% imshow(Gmag);

% Create a horizantal direction kernel
ker = zeros(9);
ker(5,:) = 1;

% Find the max response direction
response = zeros(H,W,8);
for i = 1:8
    kernel = imrotate(ker,(i-1)*180/8,'bilinear','crop');
    response(:,:,i) = conv2(Gmag,kernel,'same');
end
[~,index] = max(response,[],3);
C = zeros(H,W,8);
for j = 1:8
    C(:,:,j) = (Gmag).*(index == j);
end

Spn = zeros(H, W, 8);
for n=1:8
    kernel2 = imrotate(ker, (n-1)*180/8, 'bilinear', 'crop');
    Spn(:,:,n) = conv2(C(:,:,n), kernel2, 'same');
%     figure();
%     imshow(Spn(:,:,j));
end
Sp = sum(Spn, 3);
Sp = (Sp - min(Sp(:))) / (max(Sp(:)) - min(Sp(:)));
S = 1 - Sp;
% figure(2);
% imshow(S);

%% Rendering

% Texture Pic
I = imread('textureO.jpeg');
I = rgb2gray(I);
I = im2double(I);


% Tone Mapping
ToneImg = Img;
% Distribution weights
w1 = 0.52;
w2 = 0.37;
w3 = 0.11;
dark = random('norm',90,11,[round(H*W*w3),1]);
mid = random('unif',105,225,[round(H*W*w2),1]);
% need to be changed to laplacian dist
bright = random('exp',9,[round(H*W*w1),1]); 

for len = 1:length(bright)
    bright(len) = 255-round(bright(len));
end
% figure();
% hist(bright);

combine = zeros(256,1);
% ATTENTION: Bugs Here: ceil/round/floor
for d = 1:length(mid)
    combine(floor(mid(d))) = combine(floor(mid(d)))+1;
end
for e = 1:length(dark)
    combine(floor(dark(e))) = combine(floor(dark(e)))+1;
end
for f = 1:length(bright)
    combine(ceil(bright(f))) = combine(ceil(bright(f)))+1;
end
sum1 = cumsum(combine);


% Histogram Specification
[counts,x] = imhist(ToneImg);
sum2 = cumsum(counts);
% figure();
% plot(combine);

for a = 1:H
   for b = 1:W
       probInd = sum2(floor(ToneImg(a,b).*255)+1);
       for index = 1:255          
          if sum1(index) == probInd
              ToneImg(a,b) = index./256;
          elseif sum1(index) < probInd && sum1(index+1) > probInd
               ToneImg(a,b) = (index+1)./256;
          end
       end
   end
end


% Texture Rendering
% Resize the texture size to be the same as the image size
texture = imresize(I,[H W]);
lambda =0.2;

[r,c,~] = size(texture);
k = r*c;
logT = log(texture + eps);
logT = logT(:);
logJ = log(ToneImg + eps);
logJ = logJ(:);

dx = ones(k,1);
dx = dx(:);

dy = ones(k,1);
dy = dy(:);

B(:,1) = dx;
B(:,2) = dy;
d = [-r,-1];
A = spdiags(B,d,k,k);

e = padarray(dx, r,'post'); e = e(r+1:end);
w = padarray(dx, r,'pre');  w = w(1:end-r);
s = padarray(dy, 1,'post'); s = s(2:end);
n = padarray(dy, 1,'pre');  n = n(1:end-1);

D = -(e+w+s+n);
A = lambda*(A + A' + spdiags(D,0,k,k)) + spdiags(logT.*logT,0,k,k);
b = logJ.*logT;

%Solve 
beta = pcg(A,b,1e-6,60);
beta = reshape(beta,r,c);
beta = (beta - min(beta(:))) / (max(beta(:)) - min(beta(:))) * 4;
T_R = (texture).^beta;


effect = S.*T_R;


end