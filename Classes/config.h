
#ifndef __CONFIG_H__
#define __CONFIG_H__
/*
���ýӿ���

*/

#include <string>
#include <map>
#include <stdexcept>
#include <fstream>
#include "cocos2d.h"
USING_NS_CC;
using namespace std;





#define CONF(__KEY__) ((*CConfig::getInstance())[__KEY__])


#define WIN_SIZE (Director::getInstance()->getVisibleSize())

#define ORIGIN_POS (Director::getInstance()->getVisibleOrigin())



/*
	���������ö�ȡ�࣬
	key = value��ʽ
	'#' ��ͷ��Ϊע��
*/


template<typename T> 
string to_str(const T& t) {
	ostringstream s;
	s << t;
	return s.str();
}

template<typename T> 
T from_str(const string& s) {
	istringstream is(s);
	T t;
	is >> t;
	return t;
}

class CConfig
{

public:
	static CConfig* getInstance();
	const string& operator [](const string& name) const;

protected:
	void Init(const string& path = "../config.conf"); //��������

	 void decode_pair(const string& s, string& name, string& value);

	 inline string trim_left(const string &s, const string& filt = " ");

	 inline string trim_right(const string &s, const string& filt = " ");

	 inline string trim_comment(const string& s); //trimע�ͺ�\n����

	 



private:
	string _filename;
	map<string, string > _pairs;
	static CConfig* instance;
	CConfig(){}
};




#endif //

