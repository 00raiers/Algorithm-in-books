
% ���ܣ���ʾSVM�㷨
% ���� SVM ʵ���������ࣻ
% ʱ�䣺2015-07-11

clc
clear all
close all


%% ��������
dataLength = 2;
dataNumber = [100, 100];

% ��һ��
x1 = randn(dataLength, dataNumber(1));
y1 = ones(1, dataNumber(1));

% �ڶ���
x2 = 5 + randn(dataLength, dataNumber(2));
y2 = -ones(1, dataNumber(2));

% ��ʾ
figure(1);
plot(x1(1,:), x1(2,:), 'bx', x2(1,:), x2(2,:), 'k.');
axis([-3 8 -3 8]);
title('SVM')
hold on

% �ϲ�����
X = [x1, x2];       
Y = [y1, y2];      

% ��������˳��
index = randperm(sum(dataNumber));
X(:, index) = X;
Y(:, index) = Y;

%% SVM ѵ��
% line : w1x1 + w2x2 + b = 0
% weight = [b, w1, w2]
weight = svmTrainMine(X, Y);

%% �������

% y = kx + b
k = -weight(2) / weight(3);
b = weight(1) / weight(3);

xLine = -2:0.1:7;
yLine = k .* xLine - b;
plot(xLine, yLine, 'r')
hold on

%% ����֧������
epsilon = 1e-5;
dist = abs(k .* X(1, :) - X(2,:) - b);
distSort = sort(dist);
i_sv = find(dist <= min(dist(:)) + epsilon);        
plot(X(1,i_sv), X(2,i_sv),'ro');


