#include <iostream>
#include <sys/time.h>
#include <unistd.h>
#include <vector>
#include <string>
#include <string.h>
#include "sql_common.h"
#include "lex_global.h"
#include "sql_desc.h"

extern int yyparse(SQL *sql);

extern void scan_buffer(char *str, int len);

extern int yydebug;

int main(int argc, char **argv)
{
  struct timeval start, end;
  char *sql = NULL;
  if(argc == 1) {
    sql = "select abc,fsdaf,fsadf from test;";
  } else {
    sql = argv[1];
  }
  std::cout << "SQL to parse:\n" << sql <<std::endl;
#ifdef SQL_DEBUG
  yydebug = 1;
#endif
  std::vector<SQL *> sqls;
  SQL *sql_desc = new SQL(&global_scanner);

  gettimeofday(&start,NULL);
  //for(int i = 0; i < 1000; ++i){
  scan_buffer(sql, strlen(sql));
  int ret = yyparse(sql_desc);
  if(ret != 0){
    std::cerr << "Syntax Error!" << std::endl;
    delete sql_desc;
    return 0;
  }
  sqls.push_back(sql_desc);

  while(global_scanner.has_next_sql()){
    SQL *sql = new SQL(&global_scanner);
    scan_buffer(global_scanner.found_semicolon, strlen(global_scanner.found_semicolon));
    yyparse(sql);
    sqls.push_back(sql);
  }
  //}
  gettimeofday(&end,NULL);
  for(unsigned int i = 0; i < sqls.size(); ++i){
    std::cout << *(sqls[i]) << std::endl;
    delete sqls[i];
  }
#ifndef SQL_DEBUG
  std::cout << "Time Cost: \n"
    << end.tv_usec - start.tv_usec << std::endl;
#endif
  return 0;
}
