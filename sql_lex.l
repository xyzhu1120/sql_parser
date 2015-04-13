#include <string>
#include <vector>
#include <iostream>
#include "sql_desc.h"
#include "sql_yacc.hpp"
#include "lex_global.h"

Scanner global_scanner;

#define YYCTYPE char
#define YYFILL(n)
#define GS(t) global_scanner.t

#define STATE(name) yyc##name
#define BEGIN(name) YYSETCONDITION(STATE(name))
#define YYCURSOR GS(yy_cursor)
#define YYLIMIT GS(yy_limit)
#define YYMARKER GS(yy_marker)
#define yytext ((char *)GS(yy_text))
#define yyleng GS(yy_leng)

#define SAVE_TOKEN do {yyleng = YYCURSOR - yytext; yylval.lex_string = new std::string(yytext, yyleng); }while(0)
int scan(){
  for(;;){
  GS(yy_text) = YYCURSOR;
  /*!re2c
    [;(),+-*]  {return yytext[0];}
    '!' {return NOT2_SYM;}
    '|' {return OR2_SYM;}
    '=' {return EQ;}
    '&&' {return AND_AND_SYM;}
    '<' {return LT;}
    '<=' {return LE;}
    '<>' {return NE;}
    '!=' {return NE;}
    '=' {return EQ;}
    '>' {return GT_SYM;}
    '>=' {return GE;}
    '<<' {return SHIFT_LEFT;}
    '>>' {return SHIFT_RIGHT;}
    '<=>' {return EQUAL_SYM;}

    'select' {return SELECT_SYM;}
    'insert' {return INSERT;}
    'from' {return FROM;}
    'dual' {return DUAL_SYM;}
    'sql_no_cache' {return SQL_NO_CACHE_SYM;}
    'sql_cache' {return SQL_CACHE_SYM;}
    'for' {return FOR_SYM;}
    'lock' {return LOCKS_SYM;}
    'in' {return IN_SYM;}
    'share' {return SHARE_SYM;}
    'mode' {return MODE_SYM;}
    'update' {return UPDATE_SYM;}
    'as' {return AS;}
    'where' {return WHERE;}
    'group' {return GROUP_SYM;}
    'by' {return BY;}
    'having' {return HAVING;}
    'order' {return ORDER_SYM;}
    'limit' {return LIMIT;}
    'offset' {return OFFSET_SYM;}
    [0-9]+ {return LONG_NUM;}
    [0-9]+ {return NUM;}
    'true' {return TRUE_SYM;}
    'or' {return OR_SYM;}
    'not' {return NOT_SYM;}
    'is' {return IS;}
    [ \t] {continue;}
    'false' {return FALSE_SYM;}
    'unknown' {return UNKNOWN_SYM;}
    'straight_join' {return STRAIGHT_JOIN;}
    'high_priority' {return HIGH_PRIORITY;}
    'disable' {return DISABLE_SYM;}
    'sql_small_result' {return SQL_SMALL_RESULT;}
    'sql_big_result' {return SQL_BIG_RESULT;}
    'sql_buffer_result' {return SQL_BUFFER_RESULT;}
    'sql_calc_found_rows' {return SQL_CALC_FOUND_ROWS;}
    'all' {return ALL;}
    'ascii' {return ASCII_SYM;}
    'backup' {return BACKUP_SYM;}
    'begin' {return BEGIN_SYM;}
    'byte' {return BYTE_SYM;}
    'cache' {return CACHE_SYM;}
    'charset' {return CHARSET;}
    'crc32' {return CHECKSUM_SYM;}
    'close' {return CLOSE_SYM;}
    'and' {return AND_SYM;}
    'count' {return COUNT_SYM;}
    [a-zA-Z][a-zA-Z0-9]* {SAVE_TOKEN; return IDENT;}
    [a-z] {return IDENT_QUOTED;}
    [\000] {return END_OF_INPUT;}
   */

  }
return 0;
}

int yylex(){
  if(GS(state) == SCANNER_END) return 0;
  if(GS(yy_cursor) >= GS(yy_limit) || GS(found_semicolon) != NULL){
    GS(state) = SCANNER_END;
    return END_OF_INPUT;
  }
  int token;
  token = scan();
#ifdef SQL_DEBUG
  std::cout << "token lex return is " << token << endl;
#endif
  return token;
}

void scan_buffer(char *str, int len){
  GS(yy_text) =  str;
  GS(yy_limit) = str + len;
  GS(yy_cursor) =  str;
  GS(found_semicolon) = NULL;
  GS(state) = SCANNER_START;
}
