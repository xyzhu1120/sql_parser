/*
  +----------------------------------------------------------------------+
  | PHP Version 7                                                        |
  +----------------------------------------------------------------------+
  | Copyright (c) 1997-2014 The PHP Group                                |
  +----------------------------------------------------------------------+
  | This source file is subject to version 3.01 of the PHP license,      |
  | that is bundled with this package in the file LICENSE, and is        |
  | available through the world-wide-web at the following url:           |
  | http://www.php.net/license/3_01.txt                                  |
  | If you did not receive a copy of the PHP license and are unable to   |
  | obtain it through the world-wide-web, please send a note to          |
  | license@php.net so we can mail you a copy immediately.               |
  +----------------------------------------------------------------------+
  | Author:                                                              |
  +----------------------------------------------------------------------+
*/

/* $Id$ */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "php_sql_parser.h"
#include "sql_desc.h"
#include "lex_global.h"
#include <vector>
#include <string>

extern int yyparse(SQL *sql);
extern void scan_buffer(char *str, int len);

extern int yydebug;
/* If you declare any globals in php_sql_parser.h uncomment this:
ZEND_DECLARE_MODULE_GLOBALS(sql_parser)
*/

/* True global resources - no need for thread safety here */
static int le_sql_parser;

/* {{{ PHP_INI
 */
/* Remove comments and fill if you need to have entries in php.ini
PHP_INI_BEGIN()
    STD_PHP_INI_ENTRY("sql_parser.global_value",      "42", PHP_INI_ALL, OnUpdateLong, global_value, zend_sql_parser_globals, sql_parser_globals)
    STD_PHP_INI_ENTRY("sql_parser.global_string", "foobar", PHP_INI_ALL, OnUpdateString, global_string, zend_sql_parser_globals, sql_parser_globals)
PHP_INI_END()
*/
/* }}} */

/* Remove the following function when you have successfully modified config.m4
   so that your module can be compiled into PHP, it exists only for testing
   purposes. */

/* Every user-visible function in PHP should document itself in the source */
/* {{{ proto string confirm_sql_parser_compiled(string arg)
   Return a string to confirm that the module is compiled in */
PHP_FUNCTION(confirm_sql_parser_compiled)
{
	char *arg = NULL;
	size_t arg_len, len;
	char *strg;

	if (zend_parse_parameters(ZEND_NUM_ARGS(), "s", &arg, &arg_len) == FAILURE) {
		return;
	}

	len = spprintf(&strg, 0, "Congratulations! You have successfully modified ext/%.78s/config.m4. Module %.78s is now compiled into PHP.", "sql_parser", arg);

	RETVAL_STRINGL(strg, len);
	efree(strg);
}
/* }}} */
/* The previous line is meant for vim and emacs, so it can correctly fold and
   unfold functions in source code. See the corresponding marks just before
   function definition, where the functions purpose is also documented. Please
   follow this convention for the convenience of others editing your code.
*/

/* {{{ proto string sql_parser(string str)
    */
PHP_FUNCTION(sql_parser)
{
	char *sql = NULL;
	int argc = ZEND_NUM_ARGS();
	size_t str_len;

	if (zend_parse_parameters(argc TSRMLS_CC, "s", &sql, &str_len) == FAILURE) 
		return;

	//yydebug = 0;

	SQL sql_desc(&global_scanner);
	scan_buffer(sql, str_len);
	yyparse(&sql_desc);
//	if(global_scanner.found_semicolon != NULL){
//		scan_buffer(global_scanner.found_semicolon, strlen(global_scanner.found_semicolon));
//		yyparse(&sql_desc);
//	}

	RETURN_STRINGL(sql, str_len);

}
/* }}} */


/* {{{ php_sql_parser_init_globals
 */
/* Uncomment this function if you have INI entries
static void php_sql_parser_init_globals(zend_sql_parser_globals *sql_parser_globals)
{
	sql_parser_globals->global_value = 0;
	sql_parser_globals->global_string = NULL;
}
*/
/* }}} */

/* {{{ php_sql_parser_class_entry
 */
zend_class_entry *php_sql_parser_class_entry;

/* }}} */

PHP_METHOD(SqlParser, sayHello){
	zval *zv;
	char *c;
	int str_len;
	zv = zend_read_property(Z_OBJCE_P(getThis()), getThis(), ZEND_STRL("sql"), 0, NULL TSRMLS_CC);
	c = Z_STRVAL_P(zv);
	str_len = Z_STRLEN_P(zv);
	RETURN_STRINGL(c, str_len);
}

/*{{{ php_class_functions*/
PHP_METHOD(SqlParser, __construct){
	char *sql = NULL;
	int argc = ZEND_NUM_ARGS();
	size_t str_len;
	if (zend_parse_parameters(argc TSRMLS_CC, "s", &sql, &str_len) == FAILURE){
		return;
	}

	zend_update_property_string(Z_OBJCE_P(getThis()), getThis(), ZEND_STRL("sql"), sql TSRMLS_CC);
}

PHP_METHOD(SqlParser, getColumns){
	char *sql = NULL;
	size_t sql_len;
	
	zval *zv;
	zv = zend_read_property(Z_OBJCE_P(getThis()), getThis(), ZEND_STRL("sql"), 0, NULL TSRMLS_CC);
	sql = Z_STRVAL_P(zv);
	sql_len = Z_STRLEN_P(zv);

	yydebug = 0;

	SQL sql_desc(&global_scanner);
	scan_buffer(sql, sql_len);
	yyparse(&sql_desc);
//	if(global_scanner.found_semicolon != NULL){
//		scan_buffer(global_scanner.found_semicolon, strlen(global_scanner.found_semicolon));
//		yyparse(&sql_desc);
//	}

	std::vector<std::string *> *items = &(sql_desc.cols->items);
	//zval *return_val = NULL;
	array_init(return_val);
	for(int i = 0; i < items->size(); ++i){
		add_next_index_string(return_val, (*items)[i]->c_str());
	}
}

PHP_METHOD(SqlParser, getSql){
	zval *zv;
	char *c;
	int str_len;
	zv = zend_read_property(Z_OBJCE_P(getThis()), getThis(), ZEND_STRL("sql"), 0, NULL TSRMLS_CC);
	c = Z_STRVAL_P(zv);
	str_len = Z_STRLEN_P(zv);
	RETURN_STRINGL(c, str_len);
}
/*}}}*/

ZEND_BEGIN_ARG_INFO(arg_contruct, 0)
ZEND_ARG_INFO(0, sql)
ZEND_END_ARG_INFO()

/* {{{ php_sql_parser_function_entry */
zend_function_entry php_sql_parser_function_entry[] = {
	PHP_ME(SqlParser, __construct, arg_contruct, ZEND_ACC_PUBLIC|ZEND_ACC_CTOR)
	PHP_ME(SqlParser, sayHello, NULL, ZEND_ACC_PUBLIC)
	PHP_ME(SqlParser, getColumns, NULL, ZEND_ACC_PUBLIC)
	PHP_ME(SqlParser, getSql, NULL, ZEND_ACC_PUBLIC)
	PHP_FE_END
};
/*}}}*/



/* {{{ PHP_MINIT_FUNCTION
 */
PHP_MINIT_FUNCTION(sql_parser)
{
	/* If you have INI entries, uncomment these lines
	REGISTER_INI_ENTRIES();
	*/
	zend_class_entry tmp_ce;
	INIT_CLASS_ENTRY(tmp_ce, "SqlParser", php_sql_parser_function_entry);
	php_sql_parser_class_entry = zend_register_internal_class(&tmp_ce TSRMLS_CC);

	zend_declare_property_null(php_sql_parser_class_entry,ZEND_STRL("sql"), ZEND_ACC_PRIVATE TSRMLS_CC);
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_MSHUTDOWN_FUNCTION
 */
PHP_MSHUTDOWN_FUNCTION(sql_parser)
{
	/* uncomment this line if you have INI entries
	UNREGISTER_INI_ENTRIES();
	*/
	return SUCCESS;
}
/* }}} */

/* Remove if there's nothing to do at request start */
/* {{{ PHP_RINIT_FUNCTION
 */
PHP_RINIT_FUNCTION(sql_parser)
{
#if defined(COMPILE_DL_SQL_PARSER) && defined(ZTS)
	ZEND_TSRMLS_CACHE_UPDATE;
#endif
	return SUCCESS;
}
/* }}} */

/* Remove if there's nothing to do at request end */
/* {{{ PHP_RSHUTDOWN_FUNCTION
 */
PHP_RSHUTDOWN_FUNCTION(sql_parser)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_MINFO_FUNCTION
 */
PHP_MINFO_FUNCTION(sql_parser)
{
	php_info_print_table_start();
	php_info_print_table_header(2, "sql_parser support", "enabled");
	php_info_print_table_end();

	/* Remove comments if you have entries in php.ini
	DISPLAY_INI_ENTRIES();
	*/
}
/* }}} */

/* {{{ sql_parser_functions[]
 *
 * Every user visible function must have an entry in sql_parser_functions[].
 */
const zend_function_entry sql_parser_functions[] = {
	PHP_FE(confirm_sql_parser_compiled,	NULL)		/* For testing, remove later. */
	PHP_FE(sql_parser,	NULL)
	PHP_FE_END	/* Must be the last line in sql_parser_functions[] */
};
/* }}} */

/* {{{ sql_parser_module_entry
 */
zend_module_entry sql_parser_module_entry = {
	STANDARD_MODULE_HEADER,
	"sql_parser",
	sql_parser_functions,
	PHP_MINIT(sql_parser),
	PHP_MSHUTDOWN(sql_parser),
	PHP_RINIT(sql_parser),		/* Replace with NULL if there's nothing to do at request start */
	PHP_RSHUTDOWN(sql_parser),	/* Replace with NULL if there's nothing to do at request end */
	PHP_MINFO(sql_parser),
	PHP_SQL_PARSER_VERSION,
	STANDARD_MODULE_PROPERTIES
};
/* }}} */

#ifdef COMPILE_DL_SQL_PARSER
#ifdef ZTS
ZEND_TSRMLS_CACHE_DEFINE;
#endif
ZEND_GET_MODULE(sql_parser)
#endif

/*
 * Local variables:
 * tab-width: 4
 * c-basic-offset: 4
 * End:
 * vim600: noet sw=4 ts=4 fdm=marker
 * vim<600: noet sw=4 ts=4
 */
