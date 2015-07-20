
%% ��ջ�������
clc
clear
tic
%% ѵ������Ԥ��������ȡ����һ��

% �������������ź�
load data1 c1
load data2 c2
load data3 c3
load data4 c4

% �ĸ������źž���ϳ�һ������
data(1:500,:) = c1(1:500,:);
data(501:1000,:) = c2(1:500,:);
data(1001:1500,:) = c3(1:500,:);
data(1501:2000,:) = c4(1:500,:);

% �����������,��1άΪ����ʶ����24άΪ���������ź�
input = ones(size(data));
input(:,2:25) = data(:,2:25);

outputClass = data(:, 1);
output(4 .* (0:2000-1)' + outputClass) = 1;
output = (reshape(output, [4, 2000]))';

% �����ȡ1500������Ϊѵ��������500������ΪԤ������
nPerm = randperm(2000); % ��1��2000���������
input_train = input(nPerm(1:1500), :)';
output_train = output(nPerm(1:1500), :)';
input_test = input(nPerm(1501:2000), :)';
output_test = output(nPerm(1501:2000), :)';

% �������ݹ�һ��
[inputn,inputps] = mapminmax(input_train);

%% ����ṹ��ʼ��
innum = 25;
midnum = 26;
outnum = 4;
 
% Ȩֵ��ʼ��
w01 = rands(midnum, innum);
w12 = rands(outnum, midnum);

% ѧϰ��
eta = 0.1;

%% ����ѵ��
iterMax = 50;
eIter = zeros(iterMax, 1);
for iter = 1:iterMax
    for n = 1:1500
        % ȡһ������
        oneIn = inputn(:, n);
        oneOut = output_train(:, n);
        
        % ���ز����             
        hOut = 1 ./ (1 + exp(- w01 * oneIn));

        % ��������
        yOut = w12 * hOut;
        
        % �������
        eOut = oneOut - yOut;     
        eIter(iter) = eIter(iter) + sum(abs(eOut));
        
        % �������������� delta2
        delta2 = eOut;
        
        % �������ز������ delta1
        FI = hOut .* (1 - hOut);
        delta1 = (FI .* (eOut' * w12)');
        
        % ����Ȩ��
        w01 = w01 + eta * delta1 * oneIn';
        w12 = w12 + eta * delta2 * hOut';
    end
end
 

%% ���������źŷ���
inputn_test = mapminmax('apply', input_test, inputps);

% ���ز���� 
hOut = 1 ./ (1 + exp(- w01 * inputn_test));

% ��������
fore = w12 * hOut;

%% �������
% ������������ҳ�������������
[output_fore, ~] = find(bsxfun(@eq, fore, max(fore)) ~= 0);

%BP����Ԥ�����
error = output_fore' - outputClass(nPerm(1501:2000))';

%% ������ȷ��
% �ҳ�ÿ���жϴ���Ĳ���������
kError = zeros(1,4);  
outPutError = bsxfun(@and, output_test, error);
[indexError, ~] = find(outPutError ~= 0);

for class = 1:4
    kError(class) = sum(indexError == class);
end

% �ҳ�ÿ����ܲ���������
kReal = zeros(1, 4);
[indexRight, ~] = find(output_test ~= 0);
for class = 1:4
    kReal(class) = sum(indexRight == class);
end

% ��ȷ��
rightridio = (kReal-kError) ./ kReal
meanRightRidio = mean(rightridio)

toc

%% ��ͼ
% ����Ԥ�����������ʵ����������ķ���ͼ
figure(1)
plot(output_fore,'r')
hold on
plot(outputClass(nPerm(1501:2000))', 'b')
legend('Ԥ���������', 'ʵ���������')

% �������ͼ
figure(2)
plot(error)
title('BP����������', 'fontsize',12)
xlabel('�����ź�', 'fontsize',12)
ylabel('�������', 'fontsize',12)

% ��Ŀ�꺯��
figure(3)
plot(eIter)
title('ÿ�ε����ܵ����', 'fontsize', 12)
xlabel('��������', 'fontsize', 12)
ylabel('������������', 'fontsize', 12)

