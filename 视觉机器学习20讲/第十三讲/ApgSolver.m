function result = ApgSolver(trn, tst)

nTrain = size(trn.X, 2);    % ѵ��������
nTest = size(tst.X, 2);    % ����������
kClass = max(trn.y);       % �����
onesvecs = full(ind2vec(trn.y));    % kClass x nTrain 

% APG ����
param.regul = 'l1';
param.loss = 'square';
param.lambda = 0.001;

% ѵ������һ��
Atilde = zeros(size(trn.X));
for i=1:nTrain
    Atilde(:,i) = trn.X(:,i) / norm(trn.X(:,i), 2);
end

deltavec = zeros(nTrain, kClass);
residual = zeros(kClass, nTest);

% ���в��������������
for iter = 1:nTest  
    % ����������һ��
    ytilde = tst.X(:, iter);
    ytilde = ytilde / norm(ytilde);        

    % APG �������
    beta0 = zeros(nTrain, 1);
    xp = mexFistaFlat(ytilde, Atilde, beta0, param);

    % ����
    for i=1:kClass
        deltavec(:, i) = onesvecs(i, :)' .* xp; % ������ȡÿһ���ϵ��
        residual(i, iter) = norm(ytilde - Atilde * deltavec(:, i));
    end
end

[~, IX] = sort(residual); % ��ÿһ�н�������
result = IX(1, :); % ��ȡ��һ��