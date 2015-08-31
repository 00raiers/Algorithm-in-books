%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������K���ڡ�����ϡ���ʾ�������˹������硱ʵ������ʶ��
% ʵ���в��� SPAMS�������Yale�������ݿ�
% SPAMS���ص�ַ �� http://spams-devel.gforge.inria.fr/
% ������Win7��Matlab 2014a
% ʱ�䣺2015-08-30
% ���ֲο����Ӿ�����ѧϰ20����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all

addpath(genpath('spams-matlab'));
addpath(genpath('CNN'))

%% ��������
load trainData.mat;
load testData.mat
nTest = size(Test.y, 2);

%% 1. K ���ڷ���
tic
ID1 = knnclassify(Test.X', Train.X', Train.y);
time(1) = toc;
correctSample = sum(ID1 == Test.y');
accuracy(1) = correctSample / nTest;
fprintf('K ���ڷ��ࣺ        ���� = %.2f%%���ع�ʱ��Ϊ�� %.2fs\n', accuracy(1) * 100, time(1));

%% 2. ϡ���ʾ-OMP���
tic
ID2 = OmpSolver(Train, Test);
time(2) = toc;
correctSample = sum(ID2 == Test.y);
accuracy(2) = correctSample / nTest;
fprintf('ϡ���ʾ-OMP��⣺   ���� = %.2f%%���ع�ʱ��Ϊ�� %.2fs\n', accuracy(2) * 100, time(2));

%% 3. ϡ���ʾ-APG���
tic
ID3 = ApgSolver(Train, Test);
time(3) = toc;
correctSample = sum(ID3 == Test.y);
accuracy(3) = correctSample / nTest;
fprintf('ϡ���ʾ-APG��⣺   ���� = %.2f%%���ع�ʱ��Ϊ�� %.2fs\n', accuracy(3) * 100, time(3));

%% 4. �˹�������-BP���
tic
ID4 = AnnBpSolver(Train, Test);
time(4) = toc;
correctSample = sum(ID4 == Test.y');
accuracy(4) = correctSample / nTest;
fprintf('�˹�������-BP��⣺ ���� = %.2f%%���ع�ʱ��Ϊ�� %.2fs\n', accuracy(4) * 100, time(4));

