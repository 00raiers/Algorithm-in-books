function result = OmpSolver(trn, tst)

nTrain = size(trn.X, 2);    % ѵ��������
nTest = size(tst.X, 2);    % ����������
kClass = max(trn.y);       % �����
onesvecs = full(ind2vec(trn.y));    % kClass x nTrain 
   
% OMP ����
param.L = 20;
param.eps = 0.1;
     
% ѵ������һ��
Atilde = zeros(size(trn.X));
for i = 1:nTrain
    Atilde(:,i) = trn.X(:,i) / norm(trn.X(:,i), 2);
end

deltavec = zeros(nTrain, kClass);
residual = zeros(kClass, nTest);

% ���в��������������
for iter = 1:nTest  
    % ����������һ��
    ytilde = tst.X(:, iter);
    ytilde = ytilde / norm(ytilde);        

    % OMP �������
     xp = mexOMP(ytilde, Atilde, param);

    % ����
    for i=1:kClass
        deltavec(:, i) = onesvecs(i, :)' .* xp;
        residual(i, iter) = norm(ytilde - Atilde * deltavec(:, i));
    end
end

[~, IX] = sort(residual); % ��ÿһ�н�������
result = IX(1, :); % ��ȡ��һ��