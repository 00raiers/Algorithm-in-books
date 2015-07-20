
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
input = data(:,2:25);

output1 = data(:, 1);
output(4 .* (0:2000-1)' + output1) = 1;
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
innum = 24;
midnum = 25;
outnum = 4;
 

% Ȩֵ��ʼ��
w1 = rands(midnum, innum);
b1 = rands(midnum, 1);
w2 = rands(midnum, outnum);
b2 = rands(outnum, 1);


% ѧϰ��
xite = 0.1;

%% ����ѵ��
iterMax = 30;
eIter = zeros(iterMax, 1);
for iter = 1:iterMax
    for n = 1:1500
        % ȡһ������
        oneInput = inputn(:, n);
        oneOutput = output_train(:, n);
        
        % ���������       
        hOut = w1 * oneInput + b1;       
        hScore = 1 ./ (1 + exp(-hOut));

        % ��������
        yOut = w2' * hScore + b2;
        
        % �������
        e = oneOutput - yOut;     
        eIter(iter) = eIter(iter) + sum(abs(e));
        
        % ����Ȩֵ�仯��
        dw2 = e * hScore';
        db2 = e';
        
        S = hScore;
        FI = S .* (1 - S);
        
        ew2 = (w2 * e)';
        db1 = FI' .* ew2;
        dw1 = oneInput * db1;
        
        % ����Ȩ��
        w1 = w1 + xite * dw1';
        b1 = b1 + xite * db1';
        w2 = w2 + xite * dw2';
        b2 = b2 + xite * db2';   
    end
end
 

%% ���������źŷ���
inputn_test = mapminmax('apply',input_test,inputps);

% ��������� 
hOut = bsxfun(@plus, w1 *inputn_test, b1);
hScore = 1 ./ (1 + exp(-hOut));

% ��������
fore = bsxfun(@plus, w2' * hScore, b2);


%% �������
% ������������ҳ�������������
[output_fore, ~] = find(bsxfun(@eq, fore, max(fore)) ~= 0);

%BP����Ԥ�����
error = output_fore' - output1(nPerm(1501:2000))';

% ����Ԥ�����������ʵ����������ķ���ͼ
figure(1)
plot(output_fore,'r')
hold on
plot(output1(nPerm(1501:2000))','b')
legend('Ԥ���������','ʵ���������')

% �������ͼ
figure(2)
plot(error)
title('BP����������','fontsize',12)
xlabel('�����ź�','fontsize',12)
ylabel('�������','fontsize',12)

% ��Ŀ�꺯��ֵ
figure(3)
plot(eIter)
title('ÿ�ε����ܵ����','fontsize',12)
xlabel('��������','fontsize',12)
ylabel('������������','fontsize',12)
%% ������ȷ��
%�ҳ��жϴ���ķ���������һ��
kError = zeros(1,4);  
outPutError = bsxfun(@and, output_test, error);
[indexError, ~] = find(outPutError ~= 0);

for n = 1:4
    kError(n) = sum(indexError == n);
end

%�ҳ�ÿ��ĸ����
kReal = zeros(1, 4);
[indexRight, ~] = find(output_test ~= 0);
for n = 1:4
    kReal(n) = sum(indexRight == n);
end

%��ȷ��
rightridio = (kReal-kError) ./ kReal
meanRightRidio = mean(rightridio)
toc