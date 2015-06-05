%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ܣ���ʾKmeans�����㷨�ڼ�����Ӿ��е�Ӧ��
%ʵ���������Kmeans����ʵ��ͼ��ķָ
%������Win7��Matlab2014a
%Modi: NUDT-VAP
%ʱ�䣺2014-10-17
%
%˵����Labɫ��ģ���������ȣ�L�����й�ɫ�ʵ�a, b����Ҫ����ɡ�L��ʾ���ȣ�Luminosity����
%   ��a��ʾ�����ɫ����ɫ�ķ�Χ��b��ʾ�ӻ�ɫ����ɫ�ķ�Χ��L��ֵ����0��100��L=50ʱ������
%   ������50%�ĺڣ�a��b��ֵ������+127��-128������+127 a���Ǻ�ɫ���������ɵ�-128 a��
%   ��ʱ��ͱ����ɫ��ͬ��ԭ��+127 b�ǻ�ɫ��-128 b����ɫ�����е���ɫ����������ֵ����
%   ���仯����ɡ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;
%% ��ȡ����ͼ��
im = imread('Peppers.bmp');
im = imresize(im, 0.5);
imshow(im), title('Imput image');

%% ת��ͼ�����ɫ�ռ�õ�����
cform = makecform('srgb2lab'); % ����һ����ɫ�任�ṹ,�����任�ṹʹ��srgb��ɫ�ռ�ת����Lab��ɫ�ռ�
lab = applycform(im, cform); % Ӧ�ñ任�ṹC,ʹRGBͼ��ת����Lab��ɫ�ռ�
ab = double(lab(:, :, 2:3)); % ��ȡLab��ɫ�ռ��a��bά
nrows = size(lab, 1); 
ncols = size(lab, 2);
X = reshape(ab, nrows*ncols, 2)';

figure
scatter(X(1,:)', X(2,:)', 3, 'filled');  
box on; %��ʾ��ɫ�ռ�ת����Ķ�ά�����ռ�ֲ�
%print -dpdf 2D1.pdf

%% �������ռ����Kmeans����
k = 3; % �������
max_iter = 100; %����������

[centroids, labels] = run_kmeans(X, k, max_iter); 

%% ��ʾ����ָ���
figure
scatter(X(1,:)', X(2,:)', 3, labels, 'filled'); %��ʾ��ά�����ռ����Ч��
hold on; 

scatter(centroids(1,:), centroids(2,:), 60, 'r', 'filled');
hold on; 

scatter(centroids(1,:), centroids(2,:), 30, 'g', 'filled');
box on; 
hold off;
% print -dpdf 2D2.pdf

pixel_labels = reshape(labels, nrows, ncols);
rgb_labels = label2rgb(pixel_labels); % ת����Ǿ���RGBͼ��

figure
imshow(rgb_labels),
title('Segmented Image')
% print -dpdf Seg.pdf

imwrite(rgb_labels, 'out.jpg')