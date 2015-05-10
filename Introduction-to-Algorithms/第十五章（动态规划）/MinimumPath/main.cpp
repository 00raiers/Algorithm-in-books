#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>

using namespace std;

#define iMaxLength  100

/**
* MinimumPath �������·��
* pathMatrix�� �������  ����
* row��        ��������  ����
* col��        ��������  ����
* return��     ���·��  ���
*/
int MinimumPath(vector<vector<int>> &pathMatrix, int row, int col)
{
	vector<vector<int>> minPath; // �������·����

	/*��ʼ����һ��*/
	vector<int> firstPath(col, iMaxLength);
	firstPath[0] = 0;
	minPath.push_back(firstPath);

	for (int i = 1; i < row; i++)
	{
		vector<int> lastMinPath = minPath[i-1]; // ��һ�еļ�����
		vector<int> currentMinPath; // ��ǰ�н�Ҫ����Ľ��
		for (int j = 0; j < col; j++)
		{
			/*�ҵ� i �� j �е���Сֵ*/
			int currentMinData = iMaxLength;
			for (int k = 0; k < col; k++)
			{
				currentMinData = min(currentMinData, lastMinPath[k] + pathMatrix[j][k]);
			}
			currentMinPath.push_back(currentMinData);
		}
		minPath.push_back(currentMinPath);
	}
	return minPath[row-1][col-1];
}

/**
* ReadFile ��txt�ļ��ж�ȡ���ݾ���
* pathMatrix���������          ���
* fileName��  �ļ����ľ���·��  ����
* row��       ��������          ����
* col��       ��������          ����
*/
template<typename T> void ReadFile(vector<vector<T>> &pathMatrix, string fileName, int row, int col)
{
	fstream file;
	file.open(fileName, ios::in);

	/*�����������*/
	for (int i = 0; i < row; i++)
	{
		vector<T> oneRowData(col, 0);
		for (int j = 0; j < col; j++)
		{
			file >> oneRowData[j];
		}
		pathMatrix.push_back(oneRowData);
	}
	file.close();
}

int main()
{
	string fileName = "lengthOfPath.txt";
	int row = 10;
	int col = 10;

	vector<vector<int>> pathMatrix;
	ReadFile<int>(pathMatrix, fileName, row, col);
	cout << "Minimum Path = " << MinimumPath(pathMatrix, row, col) << endl;

	cout << pathMatrix[8][9] << endl;
	return 0;
}