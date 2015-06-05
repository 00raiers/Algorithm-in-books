% k-means �ֵ�ѧϰ
% �ο���Learning Feature Representations with K-means
% ����: 
%      1. ͼ��ֿ飬��Ϊ���� 
%      2. �����һ��
%      3. �׻�
%      4. K-means����

clc
clear all
close all

%% ����ͼ��
im = imread('leaves.tif');
if 3 == size(im, 3)
    im = rgb2gray(im);
end

im = double(im);

%% ��ȡͼ���
N = 200; % ÿ��������ͼ���ĸ���
win = 16; % ͼ���Ĵ�СΪwin*win
[row, col] = size(im);
numCol = fix(col / N);
numRow = fix(row / N);

idxLeftUpCol = 1:numCol:col-(win-1);
idxLeftUpRow = 1:numRow:row-(win-1);

winNum = size(idxLeftUpCol, 2) * size(idxLeftUpRow, 2); % ��ĸ���
patchs = zeros(win*win, winNum); % ���п飬����

for i = 1:win
    for j = 1:win
        idx = (i-1) * win + j;
        patchOnePixel = im(idxLeftUpCol + i-1, idxLeftUpRow + j-1);
        patchs(idx, :) = patchOnePixel(:);
    end
end

%% ��һ��
% x = (x-mean(x))/sqrt(var(x) + e)
% �ڳ��Ա�׼���ʱ��Ϊ�˱����ĸΪ0��ѹ�����������Ǹ���׼������һ��С�ĳ�����
% ����[0, 255]��Χ�ĻҶ�ͼ���������10һ����ok��

epsilon = 10; 
centerPatchs = bsxfun(@minus, patchs, mean(patchs, 2)); % 2����ʾÿһ�����ֵ
patchs = bsxfun(@rdivide, centerPatchs, sqrt(var(patchs) + epsilon));

%% �׻�
% [V, D] = eig(cov(x))��Ҳ����˵ VDV' = cov(x)
% x = V(D + epsilon*I)^(-0.5)V'x

epsilonZCA = 0.01;
[V, D] = eig(patchs * patchs'); % VDV' = cov(x)
patchs = V*((D + epsilonZCA * eye(size(D)))^(-0.5))*V'*patchs;

%% ����
NN = 16;
k = NN * NN; % �������
max_iter = 100; %����������

[centroids, labels] = run_kmeans(patchs, k, max_iter); 

%% ��ʾ
dictionary = zeros(NN * 16, NN * 16);
for i = 1:NN
    for j = 1:NN
        dx = reshape(centroids(:, (i-1)*NN+j), 16, 16);
        dx = dx - min(dx(:));
        dx = (dx / max(dx(:)))*255;
        dictionary((i-1)*16+1:i*16, (j-1)*16+1:j*16) = dx;
    end
end
figure
imshow(uint8(dictionary), [])

% imwrite(uint8(dictionary), 'withoutWhitening.jpg')

