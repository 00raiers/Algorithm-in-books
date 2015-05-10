#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

/**
* LongestCommonSubsequence �����������
* strA������A  ����
* strB������B  ����
* return��     ���
* ˵����δʹ�ö���ı�Ǳ�
*/
string LongestCommonSubsequence(string strA, string strB)
{
	string result; // �����������

	vector<vector<int>> subLCS;
	vector<int> currentRow(strB.size() + 1, 0);
	subLCS.push_back(currentRow); // ��ʼ����һ��Ϊ0

	/*��������������б�*/
	for (int i = 1; i <= strA.size(); i++)
	{
		for (int j = 1; j <= strB.size(); j++)
		{
			currentRow[j] = (strA[i-1] == strB[j-1]) ? (subLCS[i-1][j-1] + 1) : max(currentRow[j-1], subLCS[i-1][j]);
		}
		subLCS.push_back(currentRow);
	}

	/* ��������������б����������Ӵ� */
	int i = strA.size();
	int j = strB.size();
	while (i > 0 && j > 0)
	{
		/* ������һ��������ĸ */
		while (i > 0 && subLCS[i-1][j] == subLCS[i][j]) 
			i--;
		if (strA[i] != strB[j])
		{
			while (j > 0 && subLCS[i][j-1] == subLCS[i][j])
				j--;
		}

		result = strA[i-1] + result; // ��ʱi��j�ض�ָ��һ����ͬ����ĸ
		i--;
		j--;
	}

	return result;
}

int main()
{
	string strA = "ABCBDAB";
	string strB = "BDCABA";

	cout << strA.c_str() << endl;
	cout << strB.c_str() << endl;
	cout << LongestCommonSubsequence(strA, strB).c_str() << endl;

	return 0;
}