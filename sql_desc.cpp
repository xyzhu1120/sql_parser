#include "sql_desc.h"
#include <iostream>

SQL::~SQL(){
  delete db_table_desc;
  delete cols;
}

DB_item_list::~DB_item_list(){
  for(int i = 0; i < items.size(); ++i){
    delete items[i];
  }
}

std::ostream& operator << (std::ostream &os, const SQL &sql){
  std::string type;
  switch (sql.type){
    case SQL_TYPE::SELECT:
      type = "SELECT";
      break;
    case SQL_TYPE::INSERT:
      type = "INSERT";
      break;
    case SQL_TYPE::UPDATE:
      type = "UPDATE";
    case SQL_TYPE::DELETE:
      type = "DELETE";
    default:
      type = "UNKOWN";
  }
  std::cout << "*****Query type*****\n"
    << type << std::endl;
  std::cout << "------Tables:------ \n"
    << *(sql.db_table_desc->table) << std::endl;

  std::cout << "------Columns:------ \n";
  for(int i = 0; i < sql.cols->size(); ++i){
    std::cout << *(sql.cols->items[i]) << " ";
  }
  std::cout << "\n********END*********"<< std::endl;
  return os;
}
