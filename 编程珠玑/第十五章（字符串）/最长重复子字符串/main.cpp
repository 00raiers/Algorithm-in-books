#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <string>

using namespace std;

/**
* StringCompare �ַ����Ƚ�
* pa���ַ���a��ͷָ�� ����
* pb���ַ���b��ͷָ�� ���
* return��true or false
* ˵����aС��b���� true��a���ڵ���b���� false
*/
bool StringCompare(const char *pa, const char *pb)
{
	while (*pa != '\0' && *pb != '\0' && *pa == *pb)
	{
		pa++;
		pb++;
	}

	if (*pa == '\0' && *pb != '\0') /* С�� */
		return true;
	else if (*pb == '\0') /* ���ڵ��� */
		return false;
	else
		return *pa < *pb;
}

/**
* LengthOfCommon ���������ַ�����ͷ��ʼ��������г���
* p1���ַ���1��ͷָ��  ����
* p2���ַ���2��ͷָ��  ����
* return����ͷ��ʼ�����Ӵ��ĳ���
*/
int LengthOfCommon(const char *p1, const char *p2)
{
	int length = 0;
	while (p1[length] != '\0' && p2[length] != '\0' && p1[length] == p2[length])
		length++;

	return length;
}

/**
* longestRepeatedSubstring �����ַ����е���ظ�������
* s�������ַ��� ����
* return������ַ���
*/
string longestRepeatedSubstring(string s)
{
	string result; // ������

	/* �����׺���� */
	vector<const char*> pStr;
	const char *str = s.c_str();
	for (int i = 0; i < s.size(); i++)
	{
		pStr.push_back(str);
		str++;
	}

	/* �Ժ�׺����������� */
	sort(pStr.begin(), pStr.end(), StringCompare);

	/* ���αȽϺ�׺����������������ַ��� */
	int currentMaxLength = 0;
	int currentIndex = 1;
	for (int i = 1; i < pStr.size(); i++)
	{
		int length = LengthOfCommon(pStr[i-1], pStr[i]);
		if (length > currentMaxLength)
		{
			currentMaxLength = length;
			currentIndex = i;
		}
	}

	/* ��ȡ�������ַ��� */
	for (int i = 0; i < currentMaxLength; i++)
	{
		result += pStr[currentIndex][i];
	}

	return result;
}

/**
* ReadFile ��txt�ļ��ж�ȡ���ݾ���
* str������ַ���               ���
* fileName��  �ļ����ľ���·��  ����
*/
void ReadFile(string &str, string fileName)
{
	fstream file;
	file.open(fileName, ios::in);

	/*�����������*/
	string oneLine;
	while (!file.eof())
	{
		getline(file, oneLine); // getline λ�� <string>��
		str += oneLine;
	}
	file.close();
}

int main()
{
	//string str = "abcdefghigkcdef";
	string str;
	string fileName = "test.txt";
	ReadFile(str, fileName);

	cout << longestRepeatedSubstring(str).c_str() << endl;

	return 0;
}
