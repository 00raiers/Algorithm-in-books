function result = AnnBpSolver(Train, Test)

nTrain = size(Train.X, 2);    % ѵ��������
kClass = max(Train.y);       % �����

nPerm = randperm(nTrain); % �� 1 �� nTrain ���������
input_train = Train.X;
output_train = zeros(1, kClass * nTrain);
output_train(kClass .* (0:nTrain-1)' + Train.y') = 1;
output_train = reshape(output_train, [kClass, nTrain]);

input_train = input_train(:, nPerm(1 : nTrain));
output_train = output_train(:, nPerm(1 : nTrain));

input_test = Test.X;

%% ����ṹ��ʼ��
inNum = size(Train.X, 1);
midNum = 100;
outNum = kClass;
 
% Ȩֵ��ʼ��
epsilonInit = sqrt(6) / sqrt(inNum + outNum);
W10 = rands(midNum, inNum) * epsilonInit;
W21 = rands(outNum, midNum) * epsilonInit;

% ѧϰ��
eta = 0.05;

% �������ݹ�һ��
[input_train, inputps] = mapminmax(input_train);

%% ����ѵ��
iterMax = 500;
eIter = zeros(iterMax, 1);
step = 10;
for iter = 1:iterMax
    for n = 1:step:nTrain
        nEnd = min(n+step-1, nTrain);
        % ȡһ������
        oneIn = input_train(:, n:nEnd);
        oneOut = output_train(:, n:nEnd);
        oneIn = oneIn';
        oneOut = oneOut';
        
        % ���ز���� 
        hOut = 1 ./ (1 + exp(- oneIn * W10'));

        % ��������
        yOut = hOut * W21';
        
        % �������
        eOut = oneOut - yOut;     
        eIter(iter) = eIter(iter) + sum(sum(abs(eOut)));
        
        % �������������� delta2
        delta2 = eOut;
        
        % �������ز������ delta1
        FI = hOut .* (1 - hOut);
        delta1 = (FI .* (eOut * W21));

        % ����Ȩ��
        W21 = W21 + eta / step * delta2' * hOut;
        W10 = W10 + eta / step * delta1' * oneIn;
    end
end
%% ����
input_test = mapminmax('apply', input_test, inputps);

% ���ز���� 
hOut = 1 ./ (1 + exp(- W10 * input_test));

% ��������
fore = W21 * hOut;

%% �������
% ������������ҳ�������������
[result, ~] = find(bsxfun(@eq, fore, max(fore)) ~= 0);