
#ifndef __CONFIG_H__
#define __CONFIG_H__
/*
配置接口类

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
	单例的配置读取类，
	key = value形式
	'#' 开头的为注释
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
	void Init(const string& path = "../config.conf"); //加载配置

	 void decode_pair(const string& s, string& name, string& value);

	 inline string trim_left(const string &s, const string& filt = " ");

	 inline string trim_right(const string &s, const string& filt = " ");

	 inline string trim_comment(const string& s); //trim注释和\n符号

	 



private:
	string _filename;
	map<string, string > _pairs;
	static CConfig* instance;
	CConfig(){}
};




#endif //

