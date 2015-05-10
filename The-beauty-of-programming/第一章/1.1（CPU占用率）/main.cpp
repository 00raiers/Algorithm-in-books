// C++ code to make task manager generate sine graph
// ***********************************************************
// CPU��ռ���ʣ��������������һ��ˢ�������ڣ�CPUæ��ʱ���
// ˢ��������ʱ��ı��ʡ������������ʾ��CPUռ���ʾ���ÿ��
// ˢ��������CPUռ���ʵ�ͳ��ƽ��ֵ��
// ���Ϊ������Ϊ����CPUռ�����ṩ���������ݣ�дһ������
// ��CPUһ���æ��һ���У��Ӷ����Ʊ��ʣ���CPUռ���ʡ�
// ***********************************************************
// ����ô��CPUһ���æһ��������أ�
// ִ�г����ʱ��CPU�ͻ�æ��
// CPU�ڵȴ��û����룬�ȴ�ĳЩ���鷢�����������ߵ�ʱ��ͻ����
// ***********************************************************
// ��һ����������0-2pi֮��Ļ��ȵȷֳ�200�ݽ��г�����
// ����ÿ��������������Ȼ��ÿ��300ms��ʱ��ȡ��һ�������㣬
// ����CPU������Ӧ�����ʱ�䡣
// ������CPU�Ϲ���Ƶ�ʶ�����ֵ�������Ҫ��������������ƽ��һ��ķ���
// ***********************************************************
// GetTickCount���أ�retrieve���Ӳ���ϵͳ����������
// ��������elapsed���ĺ����������ķ���ֵ��DWORD
// ***********************************************************
 //DWORD startTime = 0, intervalTmie = 0;
 //startTime = GetTickCount();
 //........
 //intervalTmie = GetTickCount() - startTime; // ������ʱ��
// ***********************************************************
#include <Windows.h>
#include <stdlib.h>
#include <math.h>

const int sampling_count = 100; // ������
const double PI = 3.14159265; //pi
const int total_interval = 100; // �������

int main()
{
	DWORD busySpan[sampling_count];		// æµʱ������
	DWORD idleSpan[sampling_count];		// ����ʱ������
	int half_interval = total_interval / 2;
	double radian = 0.0; // ��������
	double radianIncrement = 2.0 / (double)sampling_count; // �������ȵ�����

	// ����ÿ������ڵ�æµʱ��Ϳ���ʱ��
	for(int i = 0; i < sampling_count; i++)
	{
		busySpan[i] = (DWORD)(half_interval + (sin(PI * radian) * half_interval));
		idleSpan[i] = total_interval - busySpan[i];
		radian += radianIncrement;
	}

	// ����ÿ������ڵ�æµʱ��Ϳ���ʱ��
	//for(int i = 0; i < sampling_count; i++)
	//{
	//	if (i < sampling_count/2)
	//	{
	//		busySpan[i] = (DWORD)(total_interval);
	//		idleSpan[i] = (DWORD)(0);
	//	}
	//	else
	//	{
	//		busySpan[i] = (DWORD)(0);
	//		idleSpan[i] = (DWORD)(total_interval);
	//	}
	//}
	DWORD startTime = 0;
	int j = 0;

	while(true)
	{
		j = j % sampling_count;
		startTime = GetTickCount();

		// ִ��busySpan[j]ʱ��
		while((GetTickCount() - startTime) <= busySpan[j])
			;

		// ����idleSpan[j]ʱ��
		Sleep(idleSpan[j]);
		j++;
	}
	return 0;
}
