#include "config.h"


using namespace std;

CConfig* CConfig::instance = nullptr;

CConfig* CConfig::getInstance(){
	if (!instance){
		instance = new CConfig();
		instance->Init("../config.conf");
	}
	return instance;
}

inline string CConfig::trim_left(const string &s, const string& filt){
	char *head = const_cast<char *>(s.c_str());
	char *p = head;
	while (*p) {
		bool b = false;
		for (size_t i = 0; i < filt.length(); i++) {
			if ((unsigned char)*p == (unsigned char)filt.c_str()[i]) { b = true; break; }
		}
		if (!b) break;
		p++;
	}
	return string(p, 0, s.length() - (p - head));
}

inline string CConfig::trim_right(const string &s, const string& filt){
	if (s.length() == 0) return string();
	char *head = const_cast<char *>(s.c_str());
	char *p = head + s.length() - 1;
	while (p >= head) {
		bool b = false;
		for (size_t i = 0; i < filt.length(); i++) {
			if ((unsigned char)*p == (unsigned char)filt.c_str()[i]) { b = true; break; }
		}
		if (!b) { break; }
		p--;
	}
	return string(head, 0, p + 1 - head);
}

inline void CConfig::decode_pair(const string& s, string& name, string& value) {
	bool find = false;
	char *p = const_cast<char *> (s.c_str());
	char *p1 = p;

	while (*p1 != 0) {
		if (*p1 == '=' || *p1 == '\t' || *p1 == ' ') {
			find = true;
			break;
		}
		p1++;
	}
	if (!find || p1 == p) {
		throw runtime_error(string("CConfig::Load:can not find name: ") + s);
	}
	name = string(p, 0, p1 - p);
	p += s.length();
	find = false;
	while (*p1 != 0) {
		if (*p1 != '=' && *p1 != '\t' && *p1 != ' ') {
			find = true;
			break;
		}
		p1++;
	}
	value = string(p1, 0, p - p1);
}

// #开头的为注释,同时trim \n

inline string CConfig::trim_comment(const string& s) {
	if (s.c_str()[0] == '#') return "";
	size_t pos = s.find("\\n");
	if (pos == string::npos) return s;
	string trimn;
	size_t idex = 0;
	while (pos != string::npos) {
		if (pos > idex) {
			trimn += s.substr(idex, pos - idex);
		}
		trimn += "\n";
		idex = pos + 2;
		pos = s.find("\\n", idex);
	}
	trimn += s.substr(idex, s.length() - idex);
	return trimn;
}


void CConfig::Init(const string& filename) {
	_filename = filename;
	if (_filename == "") throw runtime_error("CConfig::Load: filename is null");

	string sline;
	string sreal;
	ifstream in(_filename.c_str());
	if (!in)
		throw runtime_error(string("CConfig::Load: can not open ") + _filename);
	_pairs.clear();
	string name, value;

	while (getline(in, sline)) {
		sreal = trim_comment(trim_right(trim_left(sline, " \t"), " \t\r\n"));
		if (sreal.length() == 0) continue;
		decode_pair(sreal, name, value);
		_pairs[name] = value;
	}
}

const string& CConfig::operator [](const string& name) const{

	map<string, string >::const_iterator it = _pairs.find(name);
	if (it == _pairs.end()) throw runtime_error(string("CConfig::[") + name + "] is not find");
	return (*it).second;
}

