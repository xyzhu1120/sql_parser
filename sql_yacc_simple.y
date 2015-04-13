%{
#define SQL_PARSER
#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>

extern int yylex();
void yyerror(std::vector<std::string *> *cols, const char *s){printf("ERROR: %s\n", s);}

#define YYDEBUG 1

%}

%union{
  std::string *lex_string;
  int token;
}

%parse-param{std::vector<std::string *> *cols}

%token END_OF_INPUT
%token SELECT_SYM
%token FROM
%token DUAL_SYM
%token SQL_NO_CACHE_SYM
%token SQL_CACHE_SYM
%token FOR_SYM
%token LOCKS_SYM
%token IN_SYM
%token SHARE_SYM
%token MODE_SYM
%token UPDATE_SYM
%token AS
%token WHERE
%token GROUP_SYM
%token BY
%token HAVING
%token ORDER_SYM
%token LIMIT
%token OFFSET_SYM
%token LONG_NUM
%token NUM
%token TRUE_SYM
%token OR_SYM
%token NOT_SYM
%token IS
%token FALSE_SYM
%token UNKNOWN_SYM
%token STRAIGHT_JOIN
%token HIGH_PRIORITY
%token DISABLE_SYM
%token SQL_SMALL_RESULT
%token SQL_BIG_RESULT
%token SQL_BUFFER_RESULT
%token SQL_CALC_FOUND_ROWS
%token ALL
%token IDENT
%token IDENT_QUOTED
%token ASCII_SYM             
%token BACKUP_SYM            
%token BEGIN_SYM             
%token BYTE_SYM              
%token CACHE_SYM             
%token CHARSET               
%token CHECKSUM_SYM          
%token CLOSE_SYM             
%token COMMENT_SYM           
%token COMMIT_SYM            
%token CONTAINS_SYM          
%token DEALLOCATE_SYM        
%token DO_SYM                
%token END                   
%token EXECUTE_SYM           
%token FLUSH_SYM             
%token HANDLER_SYM           
%token HELP_SYM              
%token HOST_SYM              
%token INSTALL_SYM           
%token LANGUAGE_SYM          
%token NO_SYM                
%token OPEN_SYM              
%token OPTIONS_SYM           
%token OWNER_SYM             
%token PARSER_SYM            
%token PARTITION_SYM         
%token PORT_SYM              
%token PREPARE_SYM           
%token REMOVE_SYM            
%token REPAIR                
%token RESET_SYM             
%token RESTORE_SYM           
%token ROLLBACK_SYM          
%token SAVEPOINT_SYM         
%token SECURITY_SYM          
%token SERVER_SYM            
%token SIGNED_SYM            
%token SOCKET_SYM            
%token SLAVE                 
%token SONAME_SYM            
%token START_SYM             
%token STOP_SYM              
%token TRUNCATE_SYM          
%token UNICODE_SYM           
%token UNINSTALL_SYM         
%token WRAPPER_SYM           
%token XA_SYM                
%token UPGRADE_SYM           
%token COUNT_SYM
%token NULL_SYM
%token FLOAT_NUM
%token TEXT_STRING




%left   JOIN_SYM INNER_SYM STRAIGHT_JOIN CROSS LEFT RIGHT
/* A dummy token to force the priority of table_ref production in a join. */
%left   TABLE_REF_PRIORITY
%left   SET_VAR
%left   OR_OR_SYM OR_SYM OR2_SYM
%left   XOR
%left   AND_SYM AND_AND_SYM
%left   BETWEEN_SYM CASE_SYM WHEN_SYM THEN_SYM ELSE
%left   EQ EQUAL_SYM GE GT_SYM LE LT NE IS LIKE REGEXP IN_SYM
%left   '|'
%left   '&'
%left   SHIFT_LEFT SHIFT_RIGHT
%left   '-' '+'
%left   '*' '/' '%' DIV_SYM MOD_SYM
%left   '^'
%left   NEG '~'
%right  NOT_SYM NOT2_SYM
%right  BINARY COLLATE_SYM
%left  INTERVAL_SYM

%type <lex_string>
        ident IDENT IDENT_sys

%%

query:
        END_OF_INPUT
        {
        }
        | verb_clause
        ';'
        opt_end_of_input
        {
        }
        | verb_clause END_OF_INPUT
        {
        }
        ;

opt_end_of_input:
        /* empty */
        | END_OF_INPUT
        ;

verb_clause:
          statement
        ;

statement:
          select
        ;


select:
          select_init
          {
          }
        ;

select_init:
           SELECT_SYM select_init2
        | '(' select_paren ')' union_opt
        ;

select_paren:
            SELECT_SYM select_part2
            {
            }
        | '(' select_paren ')'
        ;

/*
select_paren_derived:
          SELECT_SYM select_part2_derived
          {
          }
          |'(' select_paren_derived ')'
          ;
*/

select_init2:
          select_part2
          {
          }
/*          union_clause*/
          ;

select_part2:
          select_options select_item_list select_into select_lock_type
          ;

select_into:
           opt_order_clause opt_limit_clause{}
           | select_from
           ;

select_from:
           FROM join_table_list where_clause group_clause having_clause
           opt_order_clause opt_limit_clause
           {
           }
           | FROM DUAL_SYM where_clause opt_limit_clause
           ;

select_options:

          | select_option_list
          {
          }
          ;

select_option_list:
          select_option_list select_option
          | select_option
          ;

select_option:
             query_expression_option
             | SQL_NO_CACHE_SYM
             {
             }
             | SQL_CACHE_SYM
             {
             }
             ;

select_lock_type:
            /*empty*/
            |FOR_SYM UPDATE_SYM
            {
            }
            |LOCKS_SYM IN_SYM SHARE_SYM MODE_SYM
            {
            }
            ;

select_item_list:
            select_item_list ',' select_item
            | select_item
            | '*'
            {
            }
            ;
select_item:
           table_wild
           {
           }
           | ident select_alias
           {
              //std::cout << *($1) << std::endl;
              cols->push_back($1);
           }
           ;

table_wild:
          ident '.' '*'
          {
          }
        | ident '.' ident '.' '*'
          {
          }
        ;

select_alias:
        /*empty*/
        | AS ident
        | ident


where_clause:
        /* empty */
        | WHERE expr
        ;

group_clause:
          /* empty */
        | GROUP_SYM BY group_list
        ;

group_list:
          group_list ',' ident
          | ident
          ;

having_clause:
          /* empty */
          | HAVING expr
          ;

opt_order_clause:
          /* empty */
          | order_clause
          ;

order_clause:
          ORDER_SYM BY order_list
          ;

order_list:
          order_list ',' ident
          | ident
          ;

opt_limit_clause:
            |LIMIT limit_options
            ;

limit_options:
             limit_option
             | limit_option ',' limit_option
             | limit_option OFFSET_SYM limit_option
              ;

limit_option:
            ident
            | LONG_NUM
            | NUM
            ;

expr:
        expr or expr %prec OR_SYM
        | expr XOR expr %prec XOR
          {
          }
        | expr and expr %prec AND_SYM
          {
          }
        | NOT_SYM expr %prec NOT_SYM
          {
          }
        | bool_pri IS TRUE_SYM %prec IS
          {
          }
        | bool_pri IS not TRUE_SYM %prec IS
          {
          }
        | bool_pri IS FALSE_SYM %prec IS
          {
          }
        | bool_pri IS not FALSE_SYM %prec IS
          {
          }
        | bool_pri IS UNKNOWN_SYM %prec IS
          {
          }
        | bool_pri IS not UNKNOWN_SYM %prec IS
          {
          }
        | bool_pri
        ;

or:
          OR_SYM
       | OR2_SYM
       ;

and:
          AND_SYM
       | AND_AND_SYM
       ;

not:
          NOT_SYM
        | NOT2_SYM
        ;

not2:
          '!'
        | NOT2_SYM
        ;

bool_pri:
        bool_pri comp_op predicate
        ;

predicate:
         simple_expr
        ;

simple_expr:
        ident
        |sum_expr
        |literal
        ;

sum_expr:
        COUNT_SYM '(' '*' ')'
        |COUNT_SYM '(' expr ')'
        ;

comp_op:
       |GE
       |GT_SYM
       |LE
       |LT
       |EQ
       |NE
       ;

literal:
       text_literal
       |NUM_literal
       |FALSE_SYM
       |TRUE_SYM
       |NULL_SYM
       ;

NUM_literal:
        NUM
       |FLOAT_NUM
       ;

text_literal:
      TEXT_STRING
      ;

union_opt:
         ;

join_table_list:
          table_ident
          |join_table_list ',' table_ident
          ;

table_ident:
          ident
          {
          }
        | ident '.' ident
          {
          }
        | '.' ident
          {
          }
        ;

query_expression_option:
          STRAIGHT_JOIN
          | HIGH_PRIORITY
          | DISABLE_SYM
          | SQL_SMALL_RESULT
          | SQL_BIG_RESULT
          | SQL_BUFFER_RESULT
          | SQL_CALC_FOUND_ROWS
          | ALL
          ;

ident:
          IDENT_sys    { $$=$1; }
        | keyword
        {}
        ;

IDENT_sys:
          IDENT { $$= $1; }
        | IDENT_QUOTED
        ;
 
keyword:
         ASCII_SYM             {}
        | BACKUP_SYM            {}
        | BEGIN_SYM             {}
        | BYTE_SYM              {}
        | CACHE_SYM             {}
        | CHARSET               {}
        | CHECKSUM_SYM          {}
        | CLOSE_SYM             {}
        | COMMENT_SYM           {}
        | COMMIT_SYM            {}
        | CONTAINS_SYM          {}
        | DEALLOCATE_SYM        {}
        | DO_SYM                {}
        | END                   {}
        | EXECUTE_SYM           {}
        | FLUSH_SYM             {}
        | HANDLER_SYM           {}
        | HELP_SYM              {}
        | HOST_SYM              {}
        | INSTALL_SYM           {}
        | LANGUAGE_SYM          {}
        | NO_SYM                {}
        | OPEN_SYM              {}
        | OPTIONS_SYM           {}
        | OWNER_SYM             {}
        | PARSER_SYM            {}
        | PARTITION_SYM         {}
        | PORT_SYM              {}
        | PREPARE_SYM           {}
        | REMOVE_SYM            {}
        | REPAIR                {}
        | RESET_SYM             {}
        | RESTORE_SYM           {}
        | ROLLBACK_SYM          {}
        | SAVEPOINT_SYM         {}
        | SECURITY_SYM          {}
        | SERVER_SYM            {}
        | SIGNED_SYM            {}
        | SOCKET_SYM            {}
        | SLAVE                 {}
        | SONAME_SYM            {}
        | START_SYM             {}
        | STOP_SYM              {}
        | TRUNCATE_SYM          {}
        | UNICODE_SYM           {}
        | UNINSTALL_SYM         {}
        | WRAPPER_SYM           {}
        | XA_SYM                {}
        | UPGRADE_SYM           {}
        ;

%%
