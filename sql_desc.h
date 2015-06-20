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



class SQL{
  public:
    enum SQL_TYPE{
      TYPE_UNKOWN,
      TYPE_SELECT,
      TYPE_INSERT,
      TYPE_UPDATE,
      TYPE_DELETE,
    };
    SQL(): buffer(NULL), type(TYPE_UNKOWN){
      db_table_desc = new DB_table();
    };
    SQL(Scanner *buffer):type(TYPE_UNKOWN) {
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
