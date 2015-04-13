CC=g++
CC_FLAG=-Wall -g -O2 -std=c++11

PRG=sql_parser
OBJ=sql_parser.o sql_yacc.o sql_lex.o sql_desc.o

LEXFILE=sql_lex
YACCFILE=sql_yacc

$(PRG):$(OBJ)
	$(CC) $(CC_FLAG) -o sql_parse $(OBJ)

sql_parser.o:sql_parser.cpp sql_common.h
	$(CC) $(CC_FLAG) -c sql_parser.cpp

sql_yacc.o:sql_yacc.cpp sql_common.h
	$(CC) $(CC_FLAG) -c sql_yacc.cpp

sql_lex.o:sql_lex.cpp
	$(CC) $(CC_FLAG) -c sql_lex.cpp

sql_desc.o:sql_desc.cpp
	$(CC) $(CC_FLAG) -c sql_desc.cpp

sql_yacc.cpp:sql_yacc.y
	bison -d -o sql_yacc.cpp sql_yacc.y

sql_lex.cpp:sql_lex.l
	re2c -o sql_lex.cpp sql_lex.l

.PHONY: clean
clean:
	@echo 'cleaning .o'
	rm -f $(PRG) $(OBJ) sql_yacc.cpp sql_lex.cpp sql_yacc.hpp
