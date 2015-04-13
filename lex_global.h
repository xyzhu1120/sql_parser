#ifndef LEX_GLOBAL
#define LEX_GLOBAL
enum scanner_state {
  SCANNER_START,
  SCANNER_END,
};

class Scanner{
  public:
  int fd;
  char *yy_cursor, *yy_limit, *yy_marker, *yy_text;
  int state, yy_leng;
  char *found_semicolon;

  Scanner():yy_cursor(NULL), yy_limit(NULL), yy_marker(NULL), yy_text(NULL), state(SCANNER_START){}

  bool eof(){
    return yy_cursor >= yy_limit ? true:false;
  }

  bool has_next_sql(){
    return (found_semicolon != NULL) && !eof();
  }
};

extern Scanner global_scanner;
#endif
