% ���ܣ���ʾ Kernel SVM�㷨
% ʱ�䣺2015-07-13

clc
clear all
close all

%% ��������
dataLength = 2;
dataNumber = [50, 50];

% ��һ��
x1 = randn(dataLength, dataNumber(1));
y1 = ones(1, dataNumber(1));

% �ڶ���
x2 = 3.5 + randn(dataLength, dataNumber(2));
y2 = -ones(1, dataNumber(2));

% xrand = 8 * (rand(dataLength, dataNumber(1)+dataNumber(2)) - 0.5);
% % ��һ��-Բ
% x1 = xrand(:, sum(xrand .* xrand, 1) > 3) + 3;
% dataNumber(1) = size(x1, 2);
% y1 = ones(1, dataNumber(1));
% 
% % �ڶ���-Բ
% x2 = xrand(:, sum(xrand .* xrand, 1) <= 3) + 3;
% dataNumber(2) = size(x2, 2);
% y2 = -ones(1, dataNumber(2));

% ��ʾ
figure(1);
plot(x1(1,:), x1(2,:), 'bx', x2(1,:), x2(2,:), 'k.');
axis([-3 8 -3 8]);
title('Kernel SVM')
hold on

% �ϲ�����
X = [x1, x2];       
Y = [y1, y2];      

% ��������˳��
index = randperm(sum(dataNumber));
X(:, index) = X;
Y(:, index) = Y;

%% Kernel SVM ѵ��
kernelType = 'poly';
[alpha, b] = kernelSvmTrainMine(X, Y, kernelType);

%% ��ȡ SV
epsilon = 1e-5; 
indexSV = find(alpha > epsilon);

%% ��� SV
plot(X(1,indexSV), X(2,indexSV), 'ro');
hold on

%% �������
[x1, x2] = meshgrid(-2:0.1:7, -2:0.1:7);
[rows, cols] = size(x1);
nt = rows * cols;                 
Xt = [reshape(x1,1,nt); reshape(x2,1,nt)];

Yd = sign(sum(bsxfun(@times, alpha(indexSV) .* Y(indexSV)', kernel(X(:, indexSV), Xt, kernelType))) + b);

Yd = reshape(Yd, rows, cols);
contour(x1,x2,Yd,[0 0],'m');   
hold off;