#ifndef SQL_STATEMENT
#define SQL_STATEMENT
#include <string>
#include <vector>
#include "lex_global.h"

class DB_table{
  public:
  DB_table():db(NULL), table(NULL){}
  ~DB_table(){
    delete db;
    delete table;
  }
  DB_table(std::string *db, std::string *table){
    this->db = db;
    this->table = table;
  }
  std::string *db;
  std::string *table;
};

class DB_item_list{
  public:
    ~DB_item_list();
    std::vector<std::string *> items;

    int size(){ return items.size(); }
    void push(std::string *item){ items.push_back(item); }
};

enum class SQL_TYPE{
  UNKOWN,
  SELECT,
  INSERT,
  UPDATE,
  DELETE,
};

class SQL{
  public:
    SQL(): buffer(NULL), type(SQL_TYPE::UNKOWN){
      db_table_desc = new DB_table();
    };
    SQL(Scanner *buffer):type(SQL_TYPE::UNKOWN) {
      this->buffer = buffer;
      db_table_desc = new DB_table();
    }
    ~SQL();
    int get_cols_size()
    {
        return cols->size();
    }

    friend std::ostream& operator << (std::ostream& os, const SQL &sql);
    //properties
    DB_item_list *cols;
    DB_table *db_table_desc;
    Scanner *buffer;
    SQL_TYPE type;
};
#endif
