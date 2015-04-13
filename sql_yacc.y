/*
   Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA */

/* sql_yacc.yy */

/**
  @defgroup Parser Parser
  @{
*/

%{
#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>
#include "sql_common.h"
#include "sql_desc.h"

extern int yylex();
void yyerror(SQL *sql, const char *s){printf("ERROR: %s\n", s);}

#ifdef SQL_DEBUG
#define YYDEBUG 1
#endif


%}

%parse-param{SQL *sql}

%union{
  std::string *lex_string;
  int token;
  DB_table *db_table_desc;
  DB_item_list *item_list;
}
%token  ABORT_SYM                     /* INTERNAL (used in lex) */
%token  ACCESSIBLE_SYM
%token  ACTION                        /* SQL-2003-N */
%token  ADD                           /* SQL-2003-R */
%token  ADDDATE_SYM                   /* MYSQL-FUNC */
%token  AFTER_SYM                     /* SQL-2003-N */
%token  AGAINST
%token  AGGREGATE_SYM
%token  ALGORITHM_SYM
%token  ALL                           /* SQL-2003-R */
%token  ALTER                         /* SQL-2003-R */
%token  ANALYSE_SYM
%token  ANALYZE_SYM
%token  AND_AND_SYM                   /* OPERATOR */
%token  AND_SYM                       /* SQL-2003-R */
%token  ANY_SYM                       /* SQL-2003-R */
%token  AS                            /* SQL-2003-R */
%token  ASC                           /* SQL-2003-N */
%token  ASCII_SYM                     /* MYSQL-FUNC */
%token  ASENSITIVE_SYM                /* FUTURE-USE */
%token  AT_SYM                        /* SQL-2003-R */
%token  AUTOEXTEND_SIZE_SYM
%token  AUTO_INC
%token  AVG_ROW_LENGTH
%token  AVG_SYM                       /* SQL-2003-N */
%token  BACKUP_SYM
%token  BEFORE_SYM                    /* SQL-2003-N */
%token  BEGIN_SYM                     /* SQL-2003-R */
%token  BETWEEN_SYM                   /* SQL-2003-R */
%token  BIGINT                        /* SQL-2003-R */
%token  BINARY                        /* SQL-2003-R */
%token  BINLOG_SYM
%token  BIN_NUM
%token  BIT_AND                       /* MYSQL-FUNC */
%token  BIT_OR                        /* MYSQL-FUNC */
%token  BIT_SYM                       /* MYSQL-FUNC */
%token  BIT_XOR                       /* MYSQL-FUNC */
%token  BLOB_SYM                      /* SQL-2003-R */
%token  BLOCK_SYM
%token  BOOLEAN_SYM                   /* SQL-2003-R */
%token  BOOL_SYM
%token  BOTH                          /* SQL-2003-R */
%token  BTREE_SYM
%token  BY                            /* SQL-2003-R */
%token  BYTE_SYM
%token  CACHE_SYM
%token  CALL_SYM                      /* SQL-2003-R */
%token  CASCADE                       /* SQL-2003-N */
%token  CASCADED                      /* SQL-2003-R */
%token  CASE_SYM                      /* SQL-2003-R */
%token  CAST_SYM                      /* SQL-2003-R */
%token  CATALOG_NAME_SYM              /* SQL-2003-N */
%token  CHAIN_SYM                     /* SQL-2003-N */
%token  CHANGE
%token  CHANGED
%token  CHARSET
%token  CHAR_SYM                      /* SQL-2003-R */
%token  CHECKSUM_SYM
%token  CHECK_SYM                     /* SQL-2003-R */
%token  CIPHER_SYM
%token  CLASS_ORIGIN_SYM              /* SQL-2003-N */
%token  CLIENT_SYM
%token  CLOSE_SYM                     /* SQL-2003-R */
%token  COALESCE                      /* SQL-2003-N */
%token  CODE_SYM
%token  COLLATE_SYM                   /* SQL-2003-R */
%token  COLLATION_SYM                 /* SQL-2003-N */
%token  COLUMNS
%token  COLUMN_SYM                    /* SQL-2003-R */
%token  COLUMN_FORMAT_SYM
%token  COLUMN_NAME_SYM               /* SQL-2003-N */
%token  COMMENT_SYM
%token  COMMITTED_SYM                 /* SQL-2003-N */
%token  COMMIT_SYM                    /* SQL-2003-R */
%token  COMPACT_SYM
%token  COMPLETION_SYM
%token  COMPRESSED_SYM
%token  CONCURRENT
%token  CONDITION_SYM                 /* SQL-2003-R, SQL-2008-R */
%token  CONNECTION_SYM
%token  CONSISTENT_SYM
%token  CONSTRAINT                    /* SQL-2003-R */
%token  CONSTRAINT_CATALOG_SYM        /* SQL-2003-N */
%token  CONSTRAINT_NAME_SYM           /* SQL-2003-N */
%token  CONSTRAINT_SCHEMA_SYM         /* SQL-2003-N */
%token  CONTAINS_SYM                  /* SQL-2003-N */
%token  CONTEXT_SYM
%token  CONTINUE_SYM                  /* SQL-2003-R */
%token  CONVERT_SYM                   /* SQL-2003-N */
%token  COUNT_SYM                     /* SQL-2003-N */
%token  CPU_SYM
%token  CREATE                        /* SQL-2003-R */
%token  CROSS                         /* SQL-2003-R */
%token  CUBE_SYM                      /* SQL-2003-R */
%token  CURDATE                       /* MYSQL-FUNC */
%token  CURRENT_SYM                   /* SQL-2003-R */
%token  CURRENT_USER                  /* SQL-2003-R */
%token  CURSOR_SYM                    /* SQL-2003-R */
%token  CURSOR_NAME_SYM               /* SQL-2003-N */
%token  CURTIME                       /* MYSQL-FUNC */
%token  DATABASE
%token  DATABASES
%token  DATAFILE_SYM
%token  DATA_SYM                      /* SQL-2003-N */
%token  DATETIME
%token  DATE_ADD_INTERVAL             /* MYSQL-FUNC */
%token  DATE_SUB_INTERVAL             /* MYSQL-FUNC */
%token  DATE_SYM                      /* SQL-2003-R */
%token  DAY_HOUR_SYM
%token  DAY_MICROSECOND_SYM
%token  DAY_MINUTE_SYM
%token  DAY_SECOND_SYM
%token  DAY_SYM                       /* SQL-2003-R */
%token  DEALLOCATE_SYM                /* SQL-2003-R */
%token  DECIMAL_NUM
%token  DECIMAL_SYM                   /* SQL-2003-R */
%token  DECLARE_SYM                   /* SQL-2003-R */
%token  DEFAULT                       /* SQL-2003-R */
%token  DEFAULT_AUTH_SYM              /* INTERNAL */
%token  DEFINER_SYM
%token  DELAYED_SYM
%token  DELAY_KEY_WRITE_SYM
%token  DELETE_SYM                    /* SQL-2003-R */
%token  DESC                          /* SQL-2003-N */
%token  DESCRIBE                      /* SQL-2003-R */
%token  DES_KEY_FILE
%token  DETERMINISTIC_SYM             /* SQL-2003-R */
%token  DIAGNOSTICS_SYM               /* SQL-2003-N */
%token  DIRECTORY_SYM
%token  DISABLE_SYM
%token  DISCARD
%token  DISK_SYM
%token  DISTINCT                      /* SQL-2003-R */
%token  DIV_SYM
%token  DOUBLE_SYM                    /* SQL-2003-R */
%token  DO_SYM
%token  DROP                          /* SQL-2003-R */
%token  DUAL_SYM
%token  DUMPFILE
%token  DUPLICATE_SYM
%token  DYNAMIC_SYM                   /* SQL-2003-R */
%token  EACH_SYM                      /* SQL-2003-R */
%token  ELSE                          /* SQL-2003-R */
%token  ELSEIF_SYM
%token  ENABLE_SYM
%token  ENCLOSED
%token  END                           /* SQL-2003-R */
%token  ENDS_SYM
%token  END_OF_INPUT                  /* INTERNAL */
%token  ENGINES_SYM
%token  ENGINE_SYM
%token  ENUM
%token  EQ                            /* OPERATOR */
%token  EQUAL_SYM                     /* OPERATOR */
%token  ERROR_SYM
%token  ERRORS
%token  ESCAPED
%token  ESCAPE_SYM                    /* SQL-2003-R */
%token  EVENTS_SYM
%token  EVENT_SYM
%token  EVERY_SYM                     /* SQL-2003-N */
%token  EXCHANGE_SYM
%token  EXECUTE_SYM                   /* SQL-2003-R */
%token  EXISTS                        /* SQL-2003-R */
%token  EXIT_SYM
%token  EXPANSION_SYM
%token  EXPIRE_SYM
%token  EXPORT_SYM
%token  EXTENDED_SYM
%token  EXTENT_SIZE_SYM
%token  EXTRACT_SYM                   /* SQL-2003-N */
%token  FALSE_SYM                     /* SQL-2003-R */
%token  FAST_SYM
%token  FAULTS_SYM
%token  FETCH_SYM                     /* SQL-2003-R */
%token  FILE_SYM
%token  FILTER_SYM
%token  FIRST_SYM                     /* SQL-2003-N */
%token  FIXED_SYM
%token  FLOAT_NUM
%token  FLOAT_SYM                     /* SQL-2003-R */
%token  FLUSH_SYM
%token  FOLLOWS_SYM                  /* MYSQL */
%token  FORCE_SYM
%token  FOREIGN                       /* SQL-2003-R */
%token  FOR_SYM                       /* SQL-2003-R */
%token  FORMAT_SYM
%token  FOUND_SYM                     /* SQL-2003-R */
%token  FROM
%token  FULL                          /* SQL-2003-R */
%token  FULLTEXT_SYM
%token  FUNCTION_SYM                  /* SQL-2003-R */
%token  GE
%token  GENERAL
%token  GEOMETRYCOLLECTION
%token  GEOMETRY_SYM
%token  GET_FORMAT                    /* MYSQL-FUNC */
%token  GET_SYM                       /* SQL-2003-R */
%token  GLOBAL_SYM                    /* SQL-2003-R */
%token  GRANT                         /* SQL-2003-R */
%token  GRANTS
%token  GROUP_SYM                     /* SQL-2003-R */
%token  GROUP_CONCAT_SYM
%token  GT_SYM                        /* OPERATOR */
%token  HANDLER_SYM
%token  HASH_SYM
%token  HAVING                        /* SQL-2003-R */
%token  HELP_SYM
%token  HEX_NUM
%token  HIGH_PRIORITY
%token  HOST_SYM
%token  HOSTS_SYM
%token  HOUR_MICROSECOND_SYM
%token  HOUR_MINUTE_SYM
%token  HOUR_SECOND_SYM
%token  HOUR_SYM                      /* SQL-2003-R */
%token  IDENT
%token  IDENTIFIED_SYM
%token  IDENT_QUOTED
%token  IF
%token  IGNORE_SYM
%token  IGNORE_SERVER_IDS_SYM
%token  IMPORT
%token  INDEXES
%token  INDEX_SYM
%token  INFILE
%token  INITIAL_SIZE_SYM
%token  INNER_SYM                     /* SQL-2003-R */
%token  INOUT_SYM                     /* SQL-2003-R */
%token  INSENSITIVE_SYM               /* SQL-2003-R */
%token  INSERT                        /* SQL-2003-R */
%token  INSERT_METHOD
%token  INSTALL_SYM
%token  INTERVAL_SYM                  /* SQL-2003-R */
%token  INTO                          /* SQL-2003-R */
%token  INT_SYM                       /* SQL-2003-R */
%token  INVOKER_SYM
%token  IN_SYM                        /* SQL-2003-R */
%token  IO_AFTER_GTIDS                /* MYSQL, FUTURE-USE */
%token  IO_BEFORE_GTIDS               /* MYSQL, FUTURE-USE */
%token  IO_SYM
%token  IPC_SYM
%token  IS                            /* SQL-2003-R */
%token  ISOLATION                     /* SQL-2003-R */
%token  ISSUER_SYM
%token  ITERATE_SYM
%token  JOIN_SYM                      /* SQL-2003-R */
%token  KEYS
%token  KEY_BLOCK_SIZE
%token  KEY_SYM                       /* SQL-2003-N */
%token  KILL_SYM
%token  LANGUAGE_SYM                  /* SQL-2003-R */
%token  LAST_SYM                      /* SQL-2003-N */
%token  LE                            /* OPERATOR */
%token  LEADING                       /* SQL-2003-R */
%token  LEAVES
%token  LEAVE_SYM
%token  LEFT                          /* SQL-2003-R */
%token  LESS_SYM
%token  LEVEL_SYM
%token  LEX_HOSTNAME
%token  LIKE                          /* SQL-2003-R */
%token  LIMIT
%token  LINEAR_SYM
%token  LINES
%token  LINESTRING
%token  LIST_SYM
%token  LOAD
%token  LOCAL_SYM                     /* SQL-2003-R */
%token  LOCATOR_SYM                   /* SQL-2003-N */
%token  LOCKS_SYM
%token  LOCK_SYM
%token  LOGFILE_SYM
%token  LOGS_SYM
%token  LONGBLOB
%token  LONGTEXT
%token  LONG_NUM
%token  LONG_SYM
%token  LOOP_SYM
%token  LOW_PRIORITY
%token  LT                            /* OPERATOR */
%token  MASTER_AUTO_POSITION_SYM
%token  MASTER_BIND_SYM
%token  MASTER_CONNECT_RETRY_SYM
%token  MASTER_DELAY_SYM
%token  MASTER_HOST_SYM
%token  MASTER_LOG_FILE_SYM
%token  MASTER_LOG_POS_SYM
%token  MASTER_PASSWORD_SYM
%token  MASTER_PORT_SYM
%token  MASTER_RETRY_COUNT_SYM
%token  MASTER_SERVER_ID_SYM
%token  MASTER_SSL_CAPATH_SYM
%token  MASTER_SSL_CA_SYM
%token  MASTER_SSL_CERT_SYM
%token  MASTER_SSL_CIPHER_SYM
%token  MASTER_SSL_CRL_SYM
%token  MASTER_SSL_CRLPATH_SYM
%token  MASTER_SSL_KEY_SYM
%token  MASTER_SSL_SYM
%token  MASTER_SSL_VERIFY_SERVER_CERT_SYM
%token  MASTER_SYM
%token  MASTER_USER_SYM
%token  MASTER_HEARTBEAT_PERIOD_SYM
%token  MATCH                         /* SQL-2003-R */
%token  MAX_CONNECTIONS_PER_HOUR
%token  MAX_QUERIES_PER_HOUR
%token  MAX_STATEMENT_TIME_SYM
%token  MAX_ROWS
%token  MAX_SIZE_SYM
%token  MAX_SYM                       /* SQL-2003-N */
%token  MAX_UPDATES_PER_HOUR
%token  MAX_USER_CONNECTIONS_SYM
%token  MAX_VALUE_SYM                 /* SQL-2003-N */
%token  MEDIUMBLOB
%token  MEDIUMINT
%token  MEDIUMTEXT
%token  MEDIUM_SYM
%token  MEMORY_SYM
%token  MERGE_SYM                     /* SQL-2003-R */
%token  MESSAGE_TEXT_SYM              /* SQL-2003-N */
%token  MICROSECOND_SYM               /* MYSQL-FUNC */
%token  MIGRATE_SYM
%token  MINUTE_MICROSECOND_SYM
%token  MINUTE_SECOND_SYM
%token  MINUTE_SYM                    /* SQL-2003-R */
%token  MIN_ROWS
%token  MIN_SYM                       /* SQL-2003-N */
%token  MODE_SYM
%token  MODIFIES_SYM                  /* SQL-2003-R */
%token  MODIFY_SYM
%token  MOD_SYM                       /* SQL-2003-N */
%token  MONTH_SYM                     /* SQL-2003-R */
%token  MULTILINESTRING
%token  MULTIPOINT
%token  MULTIPOLYGON
%token  MUTEX_SYM
%token  MYSQL_ERRNO_SYM
%token  NAMES_SYM                     /* SQL-2003-N */
%token  NAME_SYM                      /* SQL-2003-N */
%token  NATIONAL_SYM                  /* SQL-2003-R */
%token  NATURAL                       /* SQL-2003-R */
%token  NCHAR_STRING
%token  NCHAR_SYM                     /* SQL-2003-R */
%token  NDBCLUSTER_SYM
%token  NE                            /* OPERATOR */
%token  NEG
%token  NEVER_SYM
%token  NEW_SYM                       /* SQL-2003-R */
%token  NEXT_SYM                      /* SQL-2003-N */
%token  NODEGROUP_SYM
%token  NONE_SYM                      /* SQL-2003-R */
%token  NOT2_SYM
%token  NOT_SYM                       /* SQL-2003-R */
%token  NOW_SYM
%token  NO_SYM                        /* SQL-2003-R */
%token  NO_WAIT_SYM
%token  NO_WRITE_TO_BINLOG
%token  NULL_SYM                      /* SQL-2003-R */
%token  NUM
%token  NUMBER_SYM                    /* SQL-2003-N */
%token  NUMERIC_SYM                   /* SQL-2003-R */
%token  NVARCHAR_SYM
%token  OFFSET_SYM
%token  ON                            /* SQL-2003-R */
%token  ONE_SYM
%token  ONLY_SYM                      /* SQL-2003-R */
%token  OPEN_SYM                      /* SQL-2003-R */
%token  OPTIMIZE
%token  OPTIMIZER_COSTS_SYM
%token  OPTIONS_SYM
%token  OPTION                        /* SQL-2003-N */
%token  OPTIONALLY
%token  OR2_SYM
%token  ORDER_SYM                     /* SQL-2003-R */
%token  OR_OR_SYM                     /* OPERATOR */
%token  OR_SYM                        /* SQL-2003-R */
%token  OUTER
%token  OUTFILE
%token  OUT_SYM                       /* SQL-2003-R */
%token  OWNER_SYM
%token  PACK_KEYS_SYM
%token  PAGE_SYM
%token  PARAM_MARKER
%token  PARSER_SYM
%token  PARTIAL                       /* SQL-2003-N */
%token  PARTITION_SYM                 /* SQL-2003-R */
%token  PARTITIONS_SYM
%token  PARTITIONING_SYM
%token  PASSWORD
%token  PHASE_SYM
%token  PLUGIN_DIR_SYM                /* INTERNAL */
%token  PLUGIN_SYM
%token  PLUGINS_SYM
%token  POINT_SYM
%token  POLYGON
%token  PORT_SYM
%token  POSITION_SYM                  /* SQL-2003-N */
%token  PRECEDES_SYM                  /* MYSQL */
%token  PRECISION                     /* SQL-2003-R */
%token  PREPARE_SYM                   /* SQL-2003-R */
%token  PRESERVE_SYM
%token  PREV_SYM
%token  PRIMARY_SYM                   /* SQL-2003-R */
%token  PRIVILEGES                    /* SQL-2003-N */
%token  PROCEDURE_SYM                 /* SQL-2003-R */
%token  PROCESS
%token  PROCESSLIST_SYM
%token  PROFILE_SYM
%token  PROFILES_SYM
%token  PROXY_SYM
%token  PURGE
%token  QUARTER_SYM
%token  QUERY_SYM
%token  QUICK
%token  RANGE_SYM                     /* SQL-2003-R */
%token  READS_SYM                     /* SQL-2003-R */
%token  READ_ONLY_SYM
%token  READ_SYM                      /* SQL-2003-N */
%token  READ_WRITE_SYM
%token  REAL                          /* SQL-2003-R */
%token  REBUILD_SYM
%token  RECOVER_SYM
%token  REDOFILE_SYM
%token  REDO_BUFFER_SIZE_SYM
%token  REDUNDANT_SYM
%token  REFERENCES                    /* SQL-2003-R */
%token  REGEXP
%token  RELAY
%token  RELAYLOG_SYM
%token  RELAY_LOG_FILE_SYM
%token  RELAY_LOG_POS_SYM
%token  RELAY_THREAD
%token  RELEASE_SYM                   /* SQL-2003-R */
%token  RELOAD
%token  REMOVE_SYM
%token  RENAME
%token  REORGANIZE_SYM
%token  REPAIR
%token  REPEATABLE_SYM                /* SQL-2003-N */
%token  REPEAT_SYM                    /* MYSQL-FUNC */
%token  REPLACE                       /* MYSQL-FUNC */
%token  REPLICATION
%token  REPLICATE_DO_DB
%token  REPLICATE_IGNORE_DB
%token  REPLICATE_DO_TABLE
%token  REPLICATE_IGNORE_TABLE
%token  REPLICATE_WILD_DO_TABLE
%token  REPLICATE_WILD_IGNORE_TABLE
%token  REPLICATE_REWRITE_DB
%token  REQUIRE_SYM
%token  RESET_SYM
%token  RESIGNAL_SYM                  /* SQL-2003-R */
%token  RESOURCES
%token  RESTORE_SYM
%token  RESTRICT
%token  RESUME_SYM
%token  RETURNED_SQLSTATE_SYM         /* SQL-2003-N */
%token  RETURNS_SYM                   /* SQL-2003-R */
%token  RETURN_SYM                    /* SQL-2003-R */
%token  REVERSE_SYM
%token  REVOKE                        /* SQL-2003-R */
%token  RIGHT                         /* SQL-2003-R */
%token  ROLLBACK_SYM                  /* SQL-2003-R */
%token  ROLLUP_SYM                    /* SQL-2003-R */
%token  ROUTINE_SYM                   /* SQL-2003-N */
%token  ROWS_SYM                      /* SQL-2003-R */
%token  ROW_FORMAT_SYM
%token  ROW_SYM                       /* SQL-2003-R */
%token  ROW_COUNT_SYM                 /* SQL-2003-N */
%token  RTREE_SYM
%token  SAVEPOINT_SYM                 /* SQL-2003-R */
%token  SCHEDULE_SYM
%token  SCHEMA_NAME_SYM               /* SQL-2003-N */
%token  SECOND_MICROSECOND_SYM
%token  SECOND_SYM                    /* SQL-2003-R */
%token  SECURITY_SYM                  /* SQL-2003-N */
%token  SELECT_SYM                    /* SQL-2003-R */
%token  SENSITIVE_SYM                 /* FUTURE-USE */
%token  SEPARATOR_SYM
%token  SERIALIZABLE_SYM              /* SQL-2003-N */
%token  SERIAL_SYM
%token  SESSION_SYM                   /* SQL-2003-N */
%token  SERVER_SYM
%token  SERVER_OPTIONS
%token  SET                           /* SQL-2003-R */
%token  SET_VAR
%token  SHARE_SYM
%token  SHIFT_LEFT                    /* OPERATOR */
%token  SHIFT_RIGHT                   /* OPERATOR */
%token  SHOW
%token  SHUTDOWN
%token  SIGNAL_SYM                    /* SQL-2003-R */
%token  SIGNED_SYM
%token  SIMPLE_SYM                    /* SQL-2003-N */
%token  SLAVE
%token  SLOW
%token  SMALLINT                      /* SQL-2003-R */
%token  SNAPSHOT_SYM
%token  SOCKET_SYM
%token  SONAME_SYM
%token  SOUNDS_SYM
%token  SOURCE_SYM
%token  SPATIAL_SYM
%token  SPECIFIC_SYM                  /* SQL-2003-R */
%token  SQLEXCEPTION_SYM              /* SQL-2003-R */
%token  SQLSTATE_SYM                  /* SQL-2003-R */
%token  SQLWARNING_SYM                /* SQL-2003-R */
%token  SQL_AFTER_GTIDS               /* MYSQL */
%token  SQL_AFTER_MTS_GAPS            /* MYSQL */
%token  SQL_BEFORE_GTIDS              /* MYSQL */
%token  SQL_BIG_RESULT
%token  SQL_BUFFER_RESULT
%token  SQL_CACHE_SYM
%token  SQL_CALC_FOUND_ROWS
%token  SQL_NO_CACHE_SYM
%token  SQL_SMALL_RESULT
%token  SQL_SYM                       /* SQL-2003-R */
%token  SQL_THREAD
%token  SSL_SYM
%token  STACKED_SYM                   /* SQL-2003-N */
%token  STARTING
%token  STARTS_SYM
%token  START_SYM                     /* SQL-2003-R */
%token  STATS_AUTO_RECALC_SYM
%token  STATS_PERSISTENT_SYM
%token  STATS_SAMPLE_PAGES_SYM
%token  STATUS_SYM
%token  NONBLOCKING_SYM
%token  STDDEV_SAMP_SYM               /* SQL-2003-N */
%token  STD_SYM
%token  STOP_SYM
%token  STORAGE_SYM
%token  STRAIGHT_JOIN
%token  STRING_SYM
%token  SUBCLASS_ORIGIN_SYM           /* SQL-2003-N */
%token  SUBDATE_SYM
%token  SUBJECT_SYM
%token  SUBPARTITIONS_SYM
%token  SUBPARTITION_SYM
%token  SUBSTRING                     /* SQL-2003-N */
%token  SUM_SYM                       /* SQL-2003-N */
%token  SUPER_SYM
%token  SUSPEND_SYM
%token  SWAPS_SYM
%token  SWITCHES_SYM
%token  SYSDATE
%token  TABLES
%token  TABLESPACE
%token  TABLE_REF_PRIORITY
%token  TABLE_SYM                     /* SQL-2003-R */
%token  TABLE_CHECKSUM_SYM
%token  TABLE_NAME_SYM                /* SQL-2003-N */
%token  TEMPORARY                     /* SQL-2003-N */
%token  TEMPTABLE_SYM
%token  TERMINATED
%token  TEXT_STRING
%token  TEXT_SYM
%token  THAN_SYM
%token  THEN_SYM                      /* SQL-2003-R */
%token  TIMESTAMP                     /* SQL-2003-R */
%token  TIMESTAMP_ADD
%token  TIMESTAMP_DIFF
%token  TIME_SYM                      /* SQL-2003-R */
%token  TINYBLOB
%token  TINYINT
%token  TINYTEXT
%token  TO_SYM                        /* SQL-2003-R */
%token  TRAILING                      /* SQL-2003-R */
%token  TRANSACTION_SYM
%token  TRIGGERS_SYM
%token  TRIGGER_SYM                   /* SQL-2003-R */
%token  TRIM                          /* SQL-2003-N */
%token  TRUE_SYM                      /* SQL-2003-R */
%token  TRUNCATE_SYM
%token  TYPES_SYM
%token  TYPE_SYM                      /* SQL-2003-N */
%token  UDF_RETURNS_SYM
%token  ULONGLONG_NUM
%token  UNCOMMITTED_SYM               /* SQL-2003-N */
%token  UNDEFINED_SYM
%token  UNDERSCORE_CHARSET
%token  UNDOFILE_SYM
%token  UNDO_BUFFER_SIZE_SYM
%token  UNDO_SYM                      /* FUTURE-USE */
%token  UNICODE_SYM
%token  UNINSTALL_SYM
%token  UNION_SYM                     /* SQL-2003-R */
%token  UNIQUE_SYM
%token  UNKNOWN_SYM                   /* SQL-2003-R */
%token  UNLOCK_SYM
%token  UNSIGNED
%token  UNTIL_SYM
%token  UPDATE_SYM                    /* SQL-2003-R */
%token  UPGRADE_SYM
%token  USAGE                         /* SQL-2003-N */
%token  USER                          /* SQL-2003-R */
%token  USE_FRM
%token  USE_SYM
%token  USING                         /* SQL-2003-R */
%token  UTC_DATE_SYM
%token  UTC_TIMESTAMP_SYM
%token  UTC_TIME_SYM
%token  VALIDATION_SYM                /* MYSQL */
%token  VALUES                        /* SQL-2003-R */
%token  VALUE_SYM                     /* SQL-2003-R */
%token  VARBINARY
%token  VARCHAR                       /* SQL-2003-R */
%token  VARIABLES
%token  VARIANCE_SYM
%token  VARYING                       /* SQL-2003-R */
%token  VAR_SAMP_SYM
%token  VIEW_SYM                      /* SQL-2003-N */
%token  WAIT_SYM
%token  WARNINGS
%token  WEEK_SYM
%token  WEIGHT_STRING_SYM
%token  WHEN_SYM                      /* SQL-2003-R */
%token  WHERE                         /* SQL-2003-R */
%token  WHILE_SYM
%token  WITH                          /* SQL-2003-R */
%token  WITH_CUBE_SYM                 /* INTERNAL */
%token  WITH_ROLLUP_SYM               /* INTERNAL */
%token  WITHOUT_SYM                   /* SQL-2003-R */
%token  WORK_SYM                      /* SQL-2003-N */
%token  WRAPPER_SYM
%token  WRITE_SYM                     /* SQL-2003-N */
%token  X509_SYM
%token  XA_SYM
%token  XID_SYM                       /* MYSQL */
%token  XML_SYM
%token  XOR
%token  YEAR_MONTH_SYM
%token  YEAR_SYM                      /* SQL-2003-R */
%token  ZEROFILL

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
        IDENT IDENT_sys ident simple_ident simple_expr bit_expr predicate bool_pri expr select_alias select_item
        sum_expr

%type <db_table_desc>
        table_ident table_ref table_factor esc_table_ref derived_table_list

%type <item_list>
        select_item_list
%%

/*
  Indentation of grammar rules:

rule: <-- starts at col 1
          rule1a rule1b rule1c <-- starts at col 11
          { <-- starts at col 11
            code <-- starts at col 13, indentation is 2 spaces
          }
        | rule2a rule2b
          {
            code
          }
        ; <-- on a line by itself, starts at col 9

  Also, please do not use any <TAB>, but spaces.
  Having a uniform indentation in this file helps
  code reviews, patches, merges, and make maintenance easier.
  Tip: grep [[:cntrl:]] sql_yacc.yy
  Thanks.
*/

query:
          END_OF_INPUT
          {
          }
        | verb_clause
          {
           sql->buffer->found_semicolon = sql->buffer->yy_cursor;
          }
          ';'
          opt_end_of_input
        | verb_clause END_OF_INPUT
          {
          sql->buffer->found_semicolon = NULL;
          }
        ;

opt_end_of_input:
          /* empty */
        | END_OF_INPUT
        ;

verb_clause:
          statement
        | begin
        ;

/* Verb clauses, except begin */
statement:
          alter
        | analyze
        | binlog_base64_event
        | call
        | change
        | check
        | checksum
        | commit
        | create
        | deallocate
        | delete
        | describe
        | do
        | drop
        | execute
        | flush
        | get_diagnostics
        | grant
        | handler
        | help
        | insert
        | install
        | kill
        | load
        | lock
        | optimize
        | keycache
        | partition_entry
        | preload
        | prepare
        | purge
        | release
        | rename
        | repair
        | replace
        | reset
        | resignal_stmt
        | revoke
        | rollback
        | savepoint
        | select                {}
        | set                   {}
        | signal_stmt
        | show
        | slave
        | start
        | truncate
        | uninstall
        | unlock
        | update
        | use
        | xa
        ;

deallocate:
          deallocate_or_drop PREPARE_SYM ident
          {
          }
        ;

deallocate_or_drop:
          DEALLOCATE_SYM
        | DROP
        ;

prepare:
          PREPARE_SYM ident FROM prepare_src
          {
          }
        ;

prepare_src:
          TEXT_STRING_sys
          {
          }
        | '@' ident_or_text
          {
          }
        ;

execute:
          EXECUTE_SYM ident
          {
          }
          execute_using
          {}
        ;

execute_using:
          /* nothing */
        | USING execute_var_list
        ;

execute_var_list:
          execute_var_list ',' execute_var_ident
        | execute_var_ident
        ;

execute_var_ident:
          '@' ident_or_text
          {
          }
        ;

/* help */

help:
          HELP_SYM
          {
          }
          ident_or_text
          {
          }
        ;

/* change master */

change:
          CHANGE MASTER_SYM TO_SYM
          {
          }
          master_defs
          {}
        | CHANGE REPLICATION FILTER_SYM
          {
          }
          filter_defs
          {}
        ;

filter_defs:
          filter_def
        | filter_defs ',' filter_def
        ;
filter_def:
          REPLICATE_DO_DB EQ opt_filter_db_list
          {
          }
        | REPLICATE_IGNORE_DB EQ opt_filter_db_list
          {
          }
        | REPLICATE_DO_TABLE EQ opt_filter_table_list
          {
          }
        | REPLICATE_IGNORE_TABLE EQ opt_filter_table_list
          {
          }
        | REPLICATE_WILD_DO_TABLE EQ opt_filter_string_list
          {
          }
        | REPLICATE_WILD_IGNORE_TABLE EQ opt_filter_string_list
          {
          }
        | REPLICATE_REWRITE_DB EQ opt_filter_db_pair_list
          {
          }
        ;
opt_filter_db_list:
          '(' ')'
          {
          }
        | '(' filter_db_list ')'
          {
          }
        ;

filter_db_list:
          filter_db_ident
          {
          }
        | filter_db_list ',' filter_db_ident
          {
          }
        ;

filter_db_ident:
          ident /* DB name */
          {
          }
        ;
opt_filter_db_pair_list:
          '(' ')'
          {
          }
        |'(' filter_db_pair_list ')'
          {
          }
        ;
filter_db_pair_list:
          '(' filter_db_ident ',' filter_db_ident ')'
          {
          }
        | filter_db_pair_list ',' '(' filter_db_ident ',' filter_db_ident ')'
          {
          }
        ;
opt_filter_table_list:
          '(' ')'
          {
          }
        |'(' filter_table_list ')'
          {
          }
        ;

filter_table_list:
          filter_table_ident
          {
          }
        | filter_table_list ',' filter_table_ident
          {
          }
        ;

filter_table_ident:
          ident '.' ident /* qualified table name */
          {
          }
        ;

opt_filter_string_list:
          '(' ')'
          {
          }
        |'(' filter_string_list ')'
          {
          }
        ;

filter_string_list:
          filter_string
          {
          }
        | filter_string_list ',' filter_string
          {
          }
        ;

filter_string:
          filter_wild_db_table_string
          {
          }
        ;

master_defs:
          master_def
        | master_defs ',' master_def
        ;

master_def:
          MASTER_HOST_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_BIND_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_USER_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_PASSWORD_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_PORT_SYM EQ ulong_num
          {
          }
        | MASTER_CONNECT_RETRY_SYM EQ ulong_num
          {
          }
        | MASTER_RETRY_COUNT_SYM EQ ulong_num
          {
          }
        | MASTER_DELAY_SYM EQ ulong_num
          {
          }
        | MASTER_SSL_SYM EQ ulong_num
          {
          }
        | MASTER_SSL_CA_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_SSL_CAPATH_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_SSL_CERT_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_SSL_CIPHER_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_SSL_KEY_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_SSL_VERIFY_SERVER_CERT_SYM EQ ulong_num
          {
          }
        | MASTER_SSL_CRL_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_SSL_CRLPATH_SYM EQ TEXT_STRING_sys_nonewline
          {
          }

        | MASTER_HEARTBEAT_PERIOD_SYM EQ NUM_literal
          {
          }
        | IGNORE_SERVER_IDS_SYM EQ '(' ignore_server_id_list ')'
          {
           }
        |
        MASTER_AUTO_POSITION_SYM EQ ulong_num
          {
          }
        |
        master_file_def
        ;

ignore_server_id_list:
          /* Empty */
          | ignore_server_id
          | ignore_server_id_list ',' ignore_server_id
        ;

ignore_server_id:
          ulong_num
          {
          }

master_file_def:
          MASTER_LOG_FILE_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | MASTER_LOG_POS_SYM EQ ulonglong_num
          {
          }
        | RELAY_LOG_FILE_SYM EQ TEXT_STRING_sys_nonewline
          {
          }
        | RELAY_LOG_POS_SYM EQ ulong_num
          {
          }
        ;

/* create a table */

create:
          CREATE opt_table_options TABLE_SYM opt_if_not_exists table_ident
          {
          }
          create2
          {
          }
        | CREATE opt_unique INDEX_SYM ident key_alg ON table_ident
          {
          }
          '(' key_list ')' normal_key_options
          {
          }
          opt_index_lock_algorithm {}
        | CREATE fulltext INDEX_SYM ident init_key_options ON
          table_ident
          {
          }
          '(' key_list ')' fulltext_key_options
          {
          }
          opt_index_lock_algorithm {}
        | CREATE spatial INDEX_SYM ident init_key_options ON
          table_ident
          {
          }
          '(' key_list ')' spatial_key_options
          {
          }
          opt_index_lock_algorithm {}
        | CREATE DATABASE opt_if_not_exists ident
          {
          }
          opt_create_database_options
          {
          }
        | CREATE
          {
          }
          view_or_trigger_or_sp_or_event
          {}
        | CREATE USER clear_privileges grant_list
          {
          }
        | CREATE LOGFILE_SYM GROUP_SYM logfile_group_info
          {
          }
        | CREATE TABLESPACE tablespace_info
          {
          }
        | CREATE SERVER_SYM ident_or_text FOREIGN DATA_SYM WRAPPER_SYM
          ident_or_text OPTIONS_SYM '(' server_options_list ')'
          {
          }
        ;

server_options_list:
          server_option
        | server_options_list ',' server_option
        ;

server_option:
          USER TEXT_STRING_sys
          {
          }
        | HOST_SYM TEXT_STRING_sys
          {
          }
        | DATABASE TEXT_STRING_sys
          {
          }
        | OWNER_SYM TEXT_STRING_sys
          {
          }
        | PASSWORD TEXT_STRING_sys
          {
          }
        | SOCKET_SYM TEXT_STRING_sys
          {
          }
        | PORT_SYM ulong_num
          {
          }
        ;

event_tail:
          EVENT_SYM opt_if_not_exists sp_name
          {
          }
          ON SCHEDULE_SYM ev_schedule_time
          opt_ev_on_completion
          opt_ev_status
          opt_ev_comment
          DO_SYM ev_sql_stmt
          {
          }
        ;

ev_schedule_time:
          EVERY_SYM expr interval
          {
          }
          ev_starts
          ev_ends
        | AT_SYM expr
          {
          }
        ;

opt_ev_status:
          /* empty */ {}
        | ENABLE_SYM
          {
          }
        | DISABLE_SYM ON SLAVE
          {
          }
        | DISABLE_SYM
          {
          }
        ;

ev_starts:
          /* empty */
          {
          }
        | STARTS_SYM expr
          {
          }
        ;

ev_ends:
          /* empty */
        | ENDS_SYM expr
          {
          }
        ;

opt_ev_on_completion:
          /* empty */ {}
        | ev_on_completion
        ;

ev_on_completion:
          ON COMPLETION_SYM PRESERVE_SYM
          {
          }
        | ON COMPLETION_SYM NOT_SYM PRESERVE_SYM
          {
          }
        ;

opt_ev_comment:
          /* empty */ {}
        | COMMENT_SYM TEXT_STRING_sys
          {
          }
        ;

ev_sql_stmt:
          {
          }
          ev_sql_stmt_inner
          {
          }
        ;

ev_sql_stmt_inner:
          sp_proc_stmt_statement
        | sp_proc_stmt_return
        | sp_proc_stmt_if
        | case_stmt_specification
        | sp_labeled_block
        | sp_unlabeled_block
        | sp_labeled_control
        | sp_proc_stmt_unlabeled
        | sp_proc_stmt_leave
        | sp_proc_stmt_iterate
        | sp_proc_stmt_open
        | sp_proc_stmt_fetch
        | sp_proc_stmt_close
        ;

clear_privileges:
          /* Nothing */
          {
         }
        ;

sp_name:
          ident '.' ident
          {
          }
        | ident
          {
          }
        ;

sp_a_chistics:
          /* Empty */ {}
        | sp_a_chistics sp_chistic {}
        ;

sp_c_chistics:
          /* Empty */ {}
        | sp_c_chistics sp_c_chistic {}
        ;

/* Characteristics for both create and alter */
sp_chistic:
          COMMENT_SYM TEXT_STRING_sys
          {}
        | LANGUAGE_SYM SQL_SYM
          {}
        | NO_SYM SQL_SYM
          {}
        | CONTAINS_SYM SQL_SYM
          {}
        | READS_SYM SQL_SYM DATA_SYM
          {}
        | MODIFIES_SYM SQL_SYM DATA_SYM
          {}
        | sp_suid
          {}
        ;

/* Create characteristics */
sp_c_chistic:
          sp_chistic            {}
        | DETERMINISTIC_SYM     {}
        | not DETERMINISTIC_SYM {}
        ;

sp_suid:
          SQL_SYM SECURITY_SYM DEFINER_SYM
          {
          }
        | SQL_SYM SECURITY_SYM INVOKER_SYM
          {
          }
        ;

call:
          CALL_SYM sp_name
          {
          }
          opt_sp_cparam_list {}
        ;

/* CALL parameters */
opt_sp_cparam_list:
          /* Empty */
        | '(' opt_sp_cparams ')'
        ;

opt_sp_cparams:
          /* Empty */
        | sp_cparams
        ;

sp_cparams:
          sp_cparams ',' expr
          {
          }
        | expr
          {
          }
        ;

/* Stored FUNCTION parameter declaration list */
sp_fdparam_list:
          /* Empty */
        | sp_fdparams
        ;

sp_fdparams:
          sp_fdparams ',' sp_fdparam
        | sp_fdparam
        ;

sp_init_param:
          /* Empty */
          {
          }
        ;

sp_fdparam:
          ident sp_init_param type_with_opt_collate
          {
          }
        ;

/* Stored PROCEDURE parameter declaration list */
sp_pdparam_list:
          /* Empty */
        | sp_pdparams
        ;

sp_pdparams:
          sp_pdparams ',' sp_pdparam
        | sp_pdparam
        ;

sp_pdparam:
          sp_opt_inout sp_init_param ident type_with_opt_collate
          {
          }
        ;

sp_opt_inout:
          /* Empty */ {}
        | IN_SYM      {}
        | OUT_SYM     {}
        | INOUT_SYM   {}
        ;

sp_proc_stmts:
          /* Empty */ {}
        | sp_proc_stmts  sp_proc_stmt ';'
        ;

sp_proc_stmts1:
          sp_proc_stmt ';' {}
        | sp_proc_stmts1  sp_proc_stmt ';'
        ;

sp_decls:
          /* Empty */
          {
          }
        | sp_decls sp_decl ';'
          {
          }
        ;

sp_decl:
          DECLARE_SYM           /*$1*/
          sp_decl_idents        /*$2*/
          {
          }
          type_with_opt_collate /*$4*/
          sp_opt_default        /*$5*/
          {
          }
        | DECLARE_SYM ident CONDITION_SYM FOR_SYM sp_cond
          {
          }
        | DECLARE_SYM sp_handler_type HANDLER_SYM FOR_SYM
          {
          }
          sp_hcond_list sp_proc_stmt
          {
          }
        | DECLARE_SYM   /*$1*/
          ident         /*$2*/
          CURSOR_SYM    /*$3*/
          FOR_SYM       /*$4*/
          {
          }
          select        /*$6*/
          {
          }
        ;

sp_handler_type:
          EXIT_SYM      {}
        | CONTINUE_SYM  {}
        /*| UNDO_SYM      {} */
        ;

sp_hcond_list:
          sp_hcond_element
          {}
        | sp_hcond_list ',' sp_hcond_element
          {}
        ;

sp_hcond_element:
          sp_hcond
          {
          }
        ;

sp_cond:
          ulong_num
          {
          }
        | sqlstate
        ;

sqlstate:
          SQLSTATE_SYM opt_value TEXT_STRING_literal
          {
          }
        ;

opt_value:
          /* Empty */  {}
        | VALUE_SYM    {}
        ;

sp_hcond:
          sp_cond
          {
          }
        | ident /* CONDITION name */
          {
          }
        | SQLWARNING_SYM /* SQLSTATEs 01??? */
          {
          }
        | not FOUND_SYM /* SQLSTATEs 02??? */
          {
          }
        | SQLEXCEPTION_SYM /* All other SQLSTATEs */
          {
          }
        ;

signal_stmt:
          SIGNAL_SYM signal_value opt_set_signal_information
          {
          }
        ;

signal_value:
          ident
          {
          }
        | sqlstate
          {}
        ;

opt_signal_value:
          /* empty */
          {}
        | signal_value
          {}
        ;

opt_set_signal_information:
          /* empty */
          {}
        | SET signal_information_item_list
          {}
        ;

signal_information_item_list:
          signal_condition_information_item_name EQ signal_allowed_expr
          {
          }
        | signal_information_item_list ','
          signal_condition_information_item_name EQ signal_allowed_expr
          {
          }
        ;

/*
  Only a limited subset of <expr> are allowed in SIGNAL/RESIGNAL.
*/
signal_allowed_expr:
          literal
          {}
        | variable
          {
          }
        | simple_ident
          {}
        ;

/* conditions that can be set in signal / resignal */
signal_condition_information_item_name:
          CLASS_ORIGIN_SYM
          {}
        | SUBCLASS_ORIGIN_SYM
          {}
        | CONSTRAINT_CATALOG_SYM
          {}
        | CONSTRAINT_SCHEMA_SYM
          {}
        | CONSTRAINT_NAME_SYM
          {}
        | CATALOG_NAME_SYM
          {}
        | SCHEMA_NAME_SYM
          {}
        | TABLE_NAME_SYM
          {}
        | COLUMN_NAME_SYM
          {}
        | CURSOR_NAME_SYM
          {}
        | MESSAGE_TEXT_SYM
          {}
        | MYSQL_ERRNO_SYM
          {}
        ;

resignal_stmt:
          RESIGNAL_SYM opt_signal_value opt_set_signal_information
          {
          }
        ;

get_diagnostics:
          GET_SYM which_area DIAGNOSTICS_SYM diagnostics_information
          {
          }
        ;

which_area:
        /* If <which area> is not specified, then CURRENT is implicit. */
          {}
        | CURRENT_SYM
          {}
        | STACKED_SYM
          {}
        ;

diagnostics_information:
          statement_information
          {
          }
        | CONDITION_SYM condition_number condition_information
          {
          }
        ;

statement_information:
          statement_information_item
          {
          }
        | statement_information ',' statement_information_item
          {
          }
        ;

statement_information_item:
          simple_target_specification EQ statement_information_item_name
          {
          }

simple_target_specification:
          ident
          {
          }
        | '@' ident_or_text
          {
          }
        ;

statement_information_item_name:
          NUMBER_SYM
          {}
        | ROW_COUNT_SYM
          {}
        ;

/*
   Only a limited subset of <expr> are allowed in GET DIAGNOSTICS
   <condition number>, same subset as for SIGNAL/RESIGNAL.
*/
condition_number:
          signal_allowed_expr
          {}
        ;

condition_information:
          condition_information_item
          {
          }
        | condition_information ',' condition_information_item
          {
          }
        ;

condition_information_item:
          simple_target_specification EQ condition_information_item_name
          {
          }

condition_information_item_name:
          CLASS_ORIGIN_SYM
          {}
        | SUBCLASS_ORIGIN_SYM
          {}
        | CONSTRAINT_CATALOG_SYM
          {}
        | CONSTRAINT_SCHEMA_SYM
          {}
        | CONSTRAINT_NAME_SYM
          {}
        | CATALOG_NAME_SYM
          {}
        | SCHEMA_NAME_SYM
          {}
        | TABLE_NAME_SYM
          {}
        | COLUMN_NAME_SYM
          {}
        | CURSOR_NAME_SYM
          {}
        | MESSAGE_TEXT_SYM
          {}
        | MYSQL_ERRNO_SYM
          {}
        | RETURNED_SQLSTATE_SYM
          {}
        ;

sp_decl_idents:
          ident
          {
          }
        | sp_decl_idents ',' ident
          {
          }
        ;

sp_opt_default:
        /* Empty */
          {}
        | DEFAULT
          {}
          expr
          {
          }
        ;

sp_proc_stmt:
          sp_proc_stmt_statement
        | sp_proc_stmt_return
        | sp_proc_stmt_if
        | case_stmt_specification
        | sp_labeled_block
        | sp_unlabeled_block
        | sp_labeled_control
        | sp_proc_stmt_unlabeled
        | sp_proc_stmt_leave
        | sp_proc_stmt_iterate
        | sp_proc_stmt_open
        | sp_proc_stmt_fetch
        | sp_proc_stmt_close
        ;

sp_proc_stmt_if:
          IF
          {}
          sp_if END IF
          {
          }
        ;

sp_proc_stmt_statement:
          {
          }
          statement
          {
          }
        ;

sp_proc_stmt_return:
          RETURN_SYM    /*$1*/
          {
          }
          expr          /*$3*/
          {
          }
        ;

sp_proc_stmt_unlabeled:
          {
          }
          sp_unlabeled_control
          {
          }
        ;

sp_proc_stmt_leave:
          LEAVE_SYM label_ident
          {
          }
        ;

sp_proc_stmt_iterate:
          ITERATE_SYM label_ident
          {
          }
        ;

sp_proc_stmt_open:
          OPEN_SYM ident
          {
          }
        ;

sp_proc_stmt_fetch:
          FETCH_SYM sp_opt_fetch_noise ident INTO
          {
          }
          sp_fetch_list
          {}
        ;

sp_proc_stmt_close:
          CLOSE_SYM ident
          {
          }
        ;

sp_opt_fetch_noise:
          /* Empty */
        | NEXT_SYM FROM
        | FROM
        ;

sp_fetch_list:
          ident
          {
          }
        | sp_fetch_list ',' ident
          {
          }
        ;

sp_if:
          {
          }
          expr                  /*$2*/
          {
          }
          THEN_SYM              /*$4*/
          sp_proc_stmts1        /*$5*/
          {
          }
          sp_elseifs            /*$7*/
          {
          }
        ;

sp_elseifs:
          /* Empty */
        | ELSEIF_SYM sp_if
        | ELSE sp_proc_stmts1
        ;

case_stmt_specification:
          simple_case_stmt
        | searched_case_stmt
        ;

simple_case_stmt:
          CASE_SYM                      /*$1*/
          {
          }
          expr                          /*$3*/
          {
          }
          simple_when_clause_list       /*$5*/
          else_clause_opt               /*$6*/
          END                           /*$7*/
          CASE_SYM                      /*$8*/
          {
          }
        ;

searched_case_stmt:
          CASE_SYM
          {
          }
          searched_when_clause_list
          else_clause_opt
          END
          CASE_SYM
          {
          }
        ;

simple_when_clause_list:
          simple_when_clause
        | simple_when_clause_list simple_when_clause
        ;

searched_when_clause_list:
          searched_when_clause
        | searched_when_clause_list searched_when_clause
        ;

simple_when_clause:
          WHEN_SYM                      /*$1*/
          {
          }
          expr                          /*$3*/
          {
          }
          THEN_SYM                      /*$5*/
          sp_proc_stmts1                /*$6*/
          {
          }
        ;

searched_when_clause:
          WHEN_SYM                      /*$1*/
          {
          }
          expr                          /*$3*/
          {
          }
          THEN_SYM                      /*$6*/
          sp_proc_stmts1                /*$7*/
          {
          }
        ;

else_clause_opt:
          /* empty */
          {
          }
        | ELSE sp_proc_stmts1
        ;

sp_labeled_control:
          label_ident ':'
          {
          }
          sp_unlabeled_control sp_opt_label
          {
          }
        ;

sp_opt_label:
          /* Empty  */  {}
        | label_ident   {}
        ;

sp_labeled_block:
          label_ident ':'
          {
          }
          sp_block_content sp_opt_label
          {
          }
        ;

sp_unlabeled_block:
          {
          }
          sp_block_content
          {
          }
        ;

sp_block_content:
          BEGIN_SYM
          {
          }
          sp_decls
          sp_proc_stmts
          END
          {
          }
        ;

sp_unlabeled_control:
          LOOP_SYM
          sp_proc_stmts1 END LOOP_SYM
          {
          }
        | WHILE_SYM                     /*$1*/
          {
          }
          expr                          /*$3*/
          {
          }
          DO_SYM                        /*$10*/
          sp_proc_stmts1                /*$11*/
          END                           /*$12*/
          WHILE_SYM                     /*$13*/
          {
          }
        | REPEAT_SYM                    /*$1*/
          sp_proc_stmts1                /*$2*/
          UNTIL_SYM                     /*$3*/
          {
          }
          expr                          /*$5*/
          {
          }
          END                           /*$7*/
          REPEAT_SYM                    /*$8*/
        ;

trg_action_time:
            BEFORE_SYM
            {}
          | AFTER_SYM
            {}
          ;

trg_event:
            INSERT
            {}
          | UPDATE_SYM
            {}
          | DELETE_SYM
            {}
          ;
/*
  This part of the parser contains common code for all TABLESPACE
  commands.
  CREATE TABLESPACE name ...
  ALTER TABLESPACE name CHANGE DATAFILE ...
  ALTER TABLESPACE name ADD DATAFILE ...
  ALTER TABLESPACE name access_mode
  CREATE LOGFILE GROUP_SYM name ...
  ALTER LOGFILE GROUP_SYM name ADD UNDOFILE ..
  ALTER LOGFILE GROUP_SYM name ADD REDOFILE ..
  DROP TABLESPACE name
  DROP LOGFILE GROUP_SYM name
*/
change_tablespace_access:
          tablespace_name
          ts_access_mode
        ;

change_tablespace_info:
          tablespace_name
          CHANGE ts_datafile
          change_ts_option_list
        ;

tablespace_info:
          tablespace_name
          ADD ts_datafile
          opt_logfile_group_name
          tablespace_option_list
        ;

opt_logfile_group_name:
          /* empty */ {}
        | USE_SYM LOGFILE_SYM GROUP_SYM ident
          {
          }
        ;

alter_tablespace_info:
          tablespace_name
          ADD ts_datafile
          alter_tablespace_option_list
          {
          }
        | tablespace_name
          DROP ts_datafile
          alter_tablespace_option_list
          {
          }
        ;

logfile_group_info:
          logfile_group_name
          add_log_file
          logfile_group_option_list
        ;

alter_logfile_group_info:
          logfile_group_name
          add_log_file
          alter_logfile_group_option_list
        ;

add_log_file:
          ADD lg_undofile
        | ADD lg_redofile
        ;

change_ts_option_list:
          /* empty */ {}
          change_ts_options
        ;

change_ts_options:
          change_ts_option
        | change_ts_options change_ts_option
        | change_ts_options ',' change_ts_option
        ;

change_ts_option:
          opt_ts_initial_size
        | opt_ts_autoextend_size
        | opt_ts_max_size
        ;

tablespace_option_list:
          /* empty */
        | tablespace_options
        ;

tablespace_options:
          tablespace_option
        | tablespace_options tablespace_option
        | tablespace_options ',' tablespace_option
        ;

tablespace_option:
          opt_ts_initial_size
        | opt_ts_autoextend_size
        | opt_ts_max_size
        | opt_ts_extent_size
        | opt_ts_nodegroup
        | opt_ts_engine
        | ts_wait
        | opt_ts_comment
        ;

alter_tablespace_option_list:
          /* empty */
        | alter_tablespace_options
        ;

alter_tablespace_options:
          alter_tablespace_option
        | alter_tablespace_options alter_tablespace_option
        | alter_tablespace_options ',' alter_tablespace_option
        ;

alter_tablespace_option:
          opt_ts_initial_size
        | opt_ts_autoextend_size
        | opt_ts_max_size
        | opt_ts_engine
        | ts_wait
        ;

logfile_group_option_list:
          /* empty */
        | logfile_group_options
        ;

logfile_group_options:
          logfile_group_option
        | logfile_group_options logfile_group_option
        | logfile_group_options ',' logfile_group_option
        ;

logfile_group_option:
          opt_ts_initial_size
        | opt_ts_undo_buffer_size
        | opt_ts_redo_buffer_size
        | opt_ts_nodegroup
        | opt_ts_engine
        | ts_wait
        | opt_ts_comment
        ;

alter_logfile_group_option_list:
          /* empty */
        | alter_logfile_group_options
        ;

alter_logfile_group_options:
          alter_logfile_group_option
        | alter_logfile_group_options alter_logfile_group_option
        | alter_logfile_group_options ',' alter_logfile_group_option
        ;

alter_logfile_group_option:
          opt_ts_initial_size
        | opt_ts_engine
        | ts_wait
        ;


ts_datafile:
          DATAFILE_SYM TEXT_STRING_sys
          {
          }
        ;

lg_undofile:
          UNDOFILE_SYM TEXT_STRING_sys
          {
          }
        ;

lg_redofile:
          REDOFILE_SYM TEXT_STRING_sys
          {
          }
        ;

tablespace_name:
          ident
          {
          }
        ;

logfile_group_name:
          ident
          {
          }
        ;

ts_access_mode:
          READ_ONLY_SYM
          {
          }
        | READ_WRITE_SYM
          {
          }
        | NOT_SYM ACCESSIBLE_SYM
          {
          }
        ;

opt_ts_initial_size:
          INITIAL_SIZE_SYM opt_equal size_number
          {
          }
        ;

opt_ts_autoextend_size:
          AUTOEXTEND_SIZE_SYM opt_equal size_number
          {
          }
        ;

opt_ts_max_size:
          MAX_SIZE_SYM opt_equal size_number
          {
          }
        ;

opt_ts_extent_size:
          EXTENT_SIZE_SYM opt_equal size_number
          {
          }
        ;

opt_ts_undo_buffer_size:
          UNDO_BUFFER_SIZE_SYM opt_equal size_number
          {
          }
        ;

opt_ts_redo_buffer_size:
          REDO_BUFFER_SIZE_SYM opt_equal size_number
          {
          }
        ;

opt_ts_nodegroup:
          NODEGROUP_SYM opt_equal real_ulong_num
          {
          }
        ;

opt_ts_comment:
          COMMENT_SYM opt_equal TEXT_STRING_sys
          {
          }
        ;

opt_ts_engine:
          opt_storage ENGINE_SYM opt_equal storage_engines
          {
          }
        ;

ts_wait:
          WAIT_SYM
          {
          }
        | NO_WAIT_SYM
          {
          }
        ;

size_number:
          real_ulonglong_num {}
        | IDENT_sys
          {
          }
        ;

/*
  End tablespace part
*/

create2:
          '(' create2a {}
        | opt_create_table_options
          opt_create_partitioning
          create3 {}
        | LIKE table_ident
          {
          }
        | '(' LIKE table_ident ')'
          {
          }
        ;

create2a:
          create_field_list ')' opt_create_table_options
          opt_create_partitioning
          create3 {}
        |  opt_create_partitioning
           create_select ')'
           {}
           union_opt
           {
           }
        ;

create3:
          /* empty */ {}
        | opt_duplicate opt_as create_select
          {}
          opt_union_clause
          {
          }
        | opt_duplicate opt_as '(' create_select ')'
          {}
          union_opt
          {
          }
        ;

opt_create_partitioning:
          opt_partitioning
          {
          }
        ;

/*
 This part of the parser is about handling of the partition information.

 It's first version was written by Mikael Ronström with lots of answers to
 questions provided by Antony Curtis.

 The partition grammar can be called from three places.
 1) CREATE TABLE ... PARTITION ..
 2) ALTER TABLE table_name PARTITION ...
 3) PARTITION ...

 The first place is called when a new table is created from a MySQL client.
 The second place is called when a table is altered with the ALTER TABLE
 command from a MySQL client.
 The third place is called when opening an frm file and finding partition
 info in the .frm file. It is necessary to avoid allowing PARTITION to be
 an allowed entry point for SQL client queries. This is arranged by setting
 some state variables before arriving here.

 To be able to handle errors we will only set error code in this code
 and handle the error condition in the function calling the parser. This
 is necessary to ensure we can also handle errors when calling the parser
 from the openfrm function.
*/
opt_partitioning:
          /* empty */ {}
        | partitioning
        ;

partitioning:
          PARTITION_SYM have_partitioning
          {
          }
          partition
        ;

have_partitioning:
          /* empty */
          {
          }
        ;

partition_entry:
          PARTITION_SYM
          {
          }
          partition {}
        ;

partition:
          BY part_type_def opt_num_parts opt_sub_part part_defs
        ;

part_type_def:
          opt_linear KEY_SYM opt_key_algo '(' part_field_list ')'
          {
          }
        | opt_linear HASH_SYM
          {}
          part_func {}
        | RANGE_SYM part_func
          {}
        | RANGE_SYM part_column_list
          {}
        | LIST_SYM part_func
          {}
        | LIST_SYM part_column_list
          {}
        ;

opt_linear:
          /* empty */ {}
        | LINEAR_SYM
          {}
        ;

opt_key_algo:
          /* empty */
          {}
        | ALGORITHM_SYM EQ real_ulong_num
          {
          }
        ;

part_field_list:
          /* empty */ {}
        | part_field_item_list {}
        ;

part_field_item_list:
          part_field_item {}
        | part_field_item_list ',' part_field_item {}
        ;

part_field_item:
          ident
          {
          }
        ;

part_column_list:
          COLUMNS '(' part_field_list ')'
          {
          }
        ;


part_func:
          '(' part_func_expr ')'
          {
          }
        ;

sub_part_func:
          '(' part_func_expr ')'
          {
          }
        ;


opt_num_parts:
          /* empty */ {}
        | PARTITIONS_SYM real_ulong_num
          {
          }
        ;

opt_sub_part:
          /* empty */ {}
        | SUBPARTITION_SYM BY opt_linear HASH_SYM sub_part_func
          {}
          opt_num_subparts {}
        | SUBPARTITION_SYM BY opt_linear KEY_SYM opt_key_algo
          '(' sub_part_field_list ')'
          {
          }
          opt_num_subparts {}
        ;

sub_part_field_list:
          sub_part_field_item {}
        | sub_part_field_list ',' sub_part_field_item {}
        ;

sub_part_field_item:
          ident
          {
          }
        ;

part_func_expr:
          bit_expr
          {
          }
        ;

opt_num_subparts:
          /* empty */ {}
        | SUBPARTITIONS_SYM real_ulong_num
          {
          }
        ;

part_defs:
          /* empty */
          {
          }
        | '(' part_def_list ')'
          {
          }
        ;

part_def_list:
          part_definition {}
        | part_def_list ',' part_definition {}
        ;

part_definition:
          PARTITION_SYM
          {
          }
          part_name
          opt_part_values
          opt_part_options
          opt_sub_partition
          {}
        ;

part_name:
          ident
          {
          }
        ;

opt_part_values:
          /* empty */
          {
          }
        | VALUES LESS_SYM THAN_SYM
          {
          }
          part_func_max {}
        | VALUES IN_SYM
          {
          }
          part_values_in {}
        ;

part_func_max:
          MAX_VALUE_SYM
          {
          }
        | part_value_item {}
        ;

part_values_in:
          part_value_item
          {
          }
        | '(' part_value_list ')'
          {
          }
        ;

part_value_list:
          part_value_item {}
        | part_value_list ',' part_value_item {}
        ;

part_value_item:
          '('
          {
          }
          part_value_item_list {}
          ')'
          {
          }
        ;

part_value_item_list:
          part_value_expr_item {}
        | part_value_item_list ',' part_value_expr_item {}
        ;

part_value_expr_item:
          MAX_VALUE_SYM
          {
          }
        | bit_expr
          {
          }
        ;


opt_sub_partition:
          /* empty */
          {
          }
        | '(' sub_part_list ')'
          {
          }
        ;

sub_part_list:
          sub_part_definition {}
        | sub_part_list ',' sub_part_definition {}
        ;

sub_part_definition:
          SUBPARTITION_SYM
          {
          }
          sub_name opt_part_options {}
        ;

sub_name:
          ident_or_text
          {}
        ;

opt_part_options:
         /* empty */ {}
       | opt_part_option_list {}
       ;

opt_part_option_list:
         opt_part_option_list opt_part_option {}
       | opt_part_option {}
       ;

opt_part_option:
          TABLESPACE opt_equal ident_or_text
          {}
        | opt_storage ENGINE_SYM opt_equal storage_engines
          {
          }
        | NODEGROUP_SYM opt_equal real_ulong_num
          {}
        | MAX_ROWS opt_equal real_ulonglong_num
          {}
        | MIN_ROWS opt_equal real_ulonglong_num
          {}
        | DATA_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
          {}
        | INDEX_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
          {}
        | COMMENT_SYM opt_equal TEXT_STRING_sys
          {}
        ;

/*
 End of partition parser part
*/

create_select:
          SELECT_SYM          /* #1 */
          {
          }
          select_options      /* #3 */
          {
          }
          select_item_list    /* #5 */
          {
          }
          table_expression    /* #7 */
          {
          }
        ;

opt_as:
          /* empty */ {}
        | AS {}
        ;

opt_create_database_options:
          /* empty */ {}
        | create_database_options {}
        ;

create_database_options:
          create_database_option {}
        | create_database_options create_database_option {}
        ;

create_database_option:
          default_collation {}
        | default_charset {}
        ;

opt_table_options:
          /* empty */ {}
        | table_options  {}
        ;

table_options:
          table_option {}
        | table_option table_options {}
        ;

table_option:
          TEMPORARY {}
        ;

opt_if_not_exists:
          /* empty */ {}
        | IF not EXISTS {}
        ;

opt_create_table_options:
          /* empty */
        | create_table_options
        ;

create_table_options_space_separated:
          create_table_option
        | create_table_option create_table_options_space_separated
        ;

create_table_options:
          create_table_option
        | create_table_option     create_table_options
        | create_table_option ',' create_table_options
        ;

create_table_option:
          ENGINE_SYM opt_equal storage_engines
          {
          }
        | MAX_ROWS opt_equal ulonglong_num
          {
          }
        | MIN_ROWS opt_equal ulonglong_num
          {
          }
        | AVG_ROW_LENGTH opt_equal ulong_num
          {
          }
        | PASSWORD opt_equal TEXT_STRING_sys
          {
          }
        | COMMENT_SYM opt_equal TEXT_STRING_sys
          {
          }
        | AUTO_INC opt_equal ulonglong_num
          {
          }
        | PACK_KEYS_SYM opt_equal ulong_num
          {
          }
        | PACK_KEYS_SYM opt_equal DEFAULT
          {
          }
        | STATS_AUTO_RECALC_SYM opt_equal ulong_num
          {
          }
        | STATS_AUTO_RECALC_SYM opt_equal DEFAULT
          {
          }
        | STATS_PERSISTENT_SYM opt_equal ulong_num
          {
          }
        | STATS_PERSISTENT_SYM opt_equal DEFAULT
          {
          }
        | STATS_SAMPLE_PAGES_SYM opt_equal ulong_num
          {
          }
        | STATS_SAMPLE_PAGES_SYM opt_equal DEFAULT
          {
          }
        | CHECKSUM_SYM opt_equal ulong_num
          {
          }
        | TABLE_CHECKSUM_SYM opt_equal ulong_num
          {
          }
        | DELAY_KEY_WRITE_SYM opt_equal ulong_num
          {
          }
        | ROW_FORMAT_SYM opt_equal row_types
          {
          }
        | UNION_SYM opt_equal
          {
          }
          '(' opt_table_list ')'
          {
          }
        | default_charset
        | default_collation
        | INSERT_METHOD opt_equal merge_insert_types
          {
          }
        | DATA_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
          {
          }
        | INDEX_SYM DIRECTORY_SYM opt_equal TEXT_STRING_sys
          {
          }
        | TABLESPACE ident
          {}
        | STORAGE_SYM DISK_SYM
          {}
        | STORAGE_SYM MEMORY_SYM
          {}
        | CONNECTION_SYM opt_equal TEXT_STRING_sys
          {
          }
        | KEY_BLOCK_SIZE opt_equal ulong_num
          {
          }
        ;

default_charset:
          opt_default charset opt_equal charset_name_or_default
          {
          }
        ;

default_collation:
          opt_default COLLATE_SYM opt_equal collation_name_or_default
          {
          }
        ;

storage_engines:
          ident_or_text
          {
          }
        ;

known_storage_engines:
          ident_or_text
          {
          }
        ;

row_types:
          DEFAULT        {}
        | FIXED_SYM      {}
        | DYNAMIC_SYM    {}
        | COMPRESSED_SYM {}
        | REDUNDANT_SYM  {}
        | COMPACT_SYM    {}
        ;

merge_insert_types:
         NO_SYM          {}
       | FIRST_SYM       {}
       | LAST_SYM        {}
       ;

udf_type:
          STRING_SYM {}
        | REAL {}
        | DECIMAL_SYM {}
        | INT_SYM {}
        ;


create_field_list:
        field_list
        {
        }
        ;

field_list:
          field_list_item
        | field_list ',' field_list_item
        ;

field_list_item:
          column_def
        | key_def
        ;

column_def:
          field_spec opt_check_constraint
        | field_spec references
          {
          }
        ;

key_def:
          normal_key_type opt_ident key_alg '(' key_list ')' normal_key_options
          {
          }
        | fulltext opt_key_or_index opt_ident init_key_options
            '(' key_list ')' fulltext_key_options
          {
          }
        | spatial opt_key_or_index opt_ident init_key_options
            '(' key_list ')' spatial_key_options
          {
          }
        | opt_constraint constraint_key_type opt_ident key_alg
          '(' key_list ')' normal_key_options
          {
          }
        | opt_constraint FOREIGN KEY_SYM opt_ident '(' key_list ')' references
          {
          }
        | opt_constraint check_constraint
          {
          }
        ;

opt_check_constraint:
          /* empty */
        | check_constraint
        ;

check_constraint:
          CHECK_SYM '(' expr ')'
          {
          }

        ;

opt_constraint:
          /* empty */ {}
        | constraint {}
        ;

constraint:
          CONSTRAINT opt_ident {}
        ;

field_spec:
          field_ident
          {
          }
          type opt_attribute
          {
          }
        ;

type:
          int_type opt_field_length field_options
          {
          }
        | real_type opt_precision field_options
          {
          }
        | FLOAT_SYM float_options field_options
          {
          }
        | BIT_SYM
          {
          }
        | BIT_SYM field_length
          {
          }
        | BOOL_SYM
          {
          }
        | BOOLEAN_SYM
          {
          }
        | char field_length opt_binary
          {
          }
        | char opt_binary
          {
          }
        | nchar field_length opt_bin_mod
          {
          }
        | nchar opt_bin_mod
          {
          }
        | BINARY field_length
          {
          }
        | BINARY
          {
          }
        | varchar field_length opt_binary
          {
          }
        | nvarchar field_length opt_bin_mod
          {
          }
        | VARBINARY field_length
          {
          }
        | YEAR_SYM opt_field_length field_options
          {
          }
        | DATE_SYM
          {}
        | TIME_SYM type_datetime_precision
          {
          }
        | TIMESTAMP type_datetime_precision
          {
          }
        | DATETIME type_datetime_precision
          {
          }
        | TINYBLOB
          {
          }
        | BLOB_SYM opt_field_length
          {
          }
        | spatial_type
          {
          }
        | MEDIUMBLOB
          {
          }
        | LONGBLOB
          {
          }
        | LONG_SYM VARBINARY
          {
          }
        | LONG_SYM varchar opt_binary
          {
          }
        | TINYTEXT opt_binary
          {
          }
        | TEXT_SYM opt_field_length opt_binary
          {
          }
        | MEDIUMTEXT opt_binary
          {
          }
        | LONGTEXT opt_binary
          {
          }
        | DECIMAL_SYM float_options field_options
          {
          }
        | NUMERIC_SYM float_options field_options
          {
          }
        | FIXED_SYM float_options field_options
          {
          }
        | ENUM
          {}
          '(' string_list ')' opt_binary
          {
          }
        | SET
          {}
          '(' string_list ')' opt_binary
          {
          }
        | LONG_SYM opt_binary
          {
          }
        | SERIAL_SYM
          {
          }
        ;

spatial_type:
          GEOMETRY_SYM        {}
        | GEOMETRYCOLLECTION  {}
        | POINT_SYM
          {
          }
        | MULTIPOINT          {}
        | LINESTRING          {}
        | MULTILINESTRING     {}
        | POLYGON             {}
        | MULTIPOLYGON        {}
        ;

char:
          CHAR_SYM {}
        ;

nchar:
          NCHAR_SYM {}
        | NATIONAL_SYM CHAR_SYM {}
        ;

varchar:
          char VARYING {}
        | VARCHAR {}
        ;

nvarchar:
          NATIONAL_SYM VARCHAR {}
        | NVARCHAR_SYM {}
        | NCHAR_SYM VARCHAR {}
        | NATIONAL_SYM CHAR_SYM VARYING {}
        | NCHAR_SYM VARYING {}
        ;

int_type:
          INT_SYM   {}
        | TINYINT   {}
        | SMALLINT  {}
        | MEDIUMINT {}
        | BIGINT    {}
        ;

real_type:
          REAL
          {
          }
        | DOUBLE_SYM
          {}
        | DOUBLE_SYM PRECISION
          {}
        ;

float_options:
          /* empty */
          {
          }
        | field_length
          {
          }
        | precision
        ;

precision:
          '(' NUM ',' NUM ')'
          {
          }
        ;


type_datetime_precision:
          /* empty */                {}
        | '(' NUM ')'                {}
        ;

func_datetime_precision:
          /* empty */                {}
        | '(' ')'                    {}
        | '(' NUM ')'
           {
           }
        ;

field_options:
          /* empty */ {}
        | field_opt_list {}
        ;

field_opt_list:
          field_opt_list field_option {}
        | field_option {}
        ;

field_option:
          SIGNED_SYM {}
        | UNSIGNED {}
        | ZEROFILL {}
        ;

field_length:
          '(' LONG_NUM ')'      {}
        | '(' ULONGLONG_NUM ')' {}
        | '(' DECIMAL_NUM ')'   {}
        | '(' NUM ')'           {};

opt_field_length:
          /* empty */  {}
        | field_length
        ;

opt_precision:
          /* empty */
          {
          }
        | precision
        ;

opt_attribute:
          /* empty */ {}
        | opt_attribute_list {}
        ;

opt_attribute_list:
          opt_attribute_list attribute {}
        | attribute
        ;

attribute:
          NULL_SYM
          {
          }
        | not NULL_SYM {}
        | DEFAULT now_or_signed_literal {}
        | ON UPDATE_SYM now
          {
          }
        | AUTO_INC {}
        | SERIAL_SYM DEFAULT VALUE_SYM
          {
          }
        | opt_primary KEY_SYM
          {
          }
        | UNIQUE_SYM
          {
          }
        | UNIQUE_SYM KEY_SYM
          {
          }
        | COMMENT_SYM TEXT_STRING_sys {}
        | COLLATE_SYM collation_name
          {
          }
        | COLUMN_FORMAT_SYM DEFAULT
          {
          }
        | COLUMN_FORMAT_SYM FIXED_SYM
          {
          }
        | COLUMN_FORMAT_SYM DYNAMIC_SYM
          {
          }
        | STORAGE_SYM DEFAULT
          {
          }
        | STORAGE_SYM DISK_SYM
          {
          }
        | STORAGE_SYM MEMORY_SYM
          {
          }
        ;


type_with_opt_collate:
        type opt_collate
        {
        }
        ;


now:
          NOW_SYM func_datetime_precision
          {
          };

now_or_signed_literal:
          now
          {
          }
        | signed_literal
          {}
        ;

charset:
          CHAR_SYM SET {}
        | CHARSET {}
        ;

charset_name:
          ident_or_text
          {
          }
        | BINARY {}
        ;

charset_name_or_default:
          charset_name {}
        | DEFAULT    {}
        ;

opt_load_data_charset:
          /* Empty */ {}
        | charset charset_name_or_default {}
        ;

old_or_new_charset_name:
          ident_or_text
          {
          }
        | BINARY {}
        ;

old_or_new_charset_name_or_default:
          old_or_new_charset_name {}
        | DEFAULT    {}
        ;

collation_name:
          ident_or_text
          {
          }
        ;

opt_collate:
          /* empty */ {}
        | COLLATE_SYM collation_name_or_default {}
        ;

collation_name_or_default:
          collation_name {}
        | DEFAULT    {}
        ;

opt_default:
          /* empty */ {}
        | DEFAULT {}
        ;


ascii:
          ASCII_SYM        {}
        | BINARY ASCII_SYM {}
        | ASCII_SYM BINARY {}
        ;

unicode:
          UNICODE_SYM
          {
          }
        | UNICODE_SYM BINARY
          {
          }
        | BINARY UNICODE_SYM
          {
          }
        ;

opt_binary:
          /* empty */
          {
          }
        | ascii
          {
          }
        | unicode
          {
          }
        | BYTE_SYM
          {
          }
        | charset charset_name opt_bin_mod
          {
          }
        | BINARY
          {
          }
        | BINARY charset charset_name
          {
          }
        ;

opt_bin_mod:
          /* empty */ {}
        | BINARY      {}
        ;

ws_nweights:
        '(' real_ulong_num
        {
        }
        ')'
        {}
        ;

ws_level_flag_desc:
        ASC {}
        | DESC {}
        ;

ws_level_flag_reverse:
        REVERSE_SYM {} ;

ws_level_flags:
        /* empty */ {}
        | ws_level_flag_desc {}
        | ws_level_flag_desc ws_level_flag_reverse {}
        | ws_level_flag_reverse {}
        ;

ws_level_number:
        real_ulong_num
        {
        }
        ;

ws_level_list_item:
        ws_level_number ws_level_flags
        {
        }
        ;

ws_level_list:
        ws_level_list_item {}
        | ws_level_list ',' ws_level_list_item {}
        ;

ws_level_range:
        ws_level_number '-' ws_level_number
        {
        }
        ;

ws_level_list_or_range:
        ws_level_list {}
        | ws_level_range {}
        ;

opt_ws_levels:
        /* empty*/ {}
        | LEVEL_SYM ws_level_list_or_range {}
        ;

opt_primary:
          /* empty */
        | PRIMARY_SYM
        ;

references:
          REFERENCES
          table_ident
          opt_ref_list
          opt_match_clause
          opt_on_update_delete
          {
          }
        ;

opt_ref_list:
          /* empty */
          {}
        | '(' ref_list ')'
        ;

ref_list:
          ref_list ',' ident
          {
          }
        | ident
          {
          }
        ;

opt_match_clause:
          /* empty */
          {}
        | MATCH FULL
          {}
        | MATCH PARTIAL
          {}
        | MATCH SIMPLE_SYM
          {}
        ;

opt_on_update_delete:
          /* empty */
          {
          }
        | ON UPDATE_SYM delete_option
          {
          }
        | ON DELETE_SYM delete_option
          {
          }
        | ON UPDATE_SYM delete_option
          ON DELETE_SYM delete_option
          {
          }
        | ON DELETE_SYM delete_option
          ON UPDATE_SYM delete_option
          {
          }
        ;

delete_option:
          RESTRICT      {}
        | CASCADE       {}
        | SET NULL_SYM  {}
        | NO_SYM ACTION {}
        | SET DEFAULT   {}
        ;

normal_key_type:
          key_or_index {}
        ;

constraint_key_type:
          PRIMARY_SYM KEY_SYM {}
        | UNIQUE_SYM opt_key_or_index {}
        ;

key_or_index:
          KEY_SYM {}
        | INDEX_SYM {}
        ;

opt_key_or_index:
          /* empty */ {}
        | key_or_index
        ;

keys_or_index:
          KEYS {}
        | INDEX_SYM {}
        | INDEXES {}
        ;

opt_unique:
          /* empty */  {}
        | UNIQUE_SYM   {}
        ;

fulltext:
          FULLTEXT_SYM {}
        ;

spatial:
          SPATIAL_SYM
          {
          }
        ;

init_key_options:
          {
          }
        ;

/*
  For now, key_alg initializies lex->key_create_info.
  In the future, when all key options are after key definition,
  we can remove key_alg and move init_key_options to key_options
*/

key_alg:
          init_key_options
        | init_key_options key_using_alg
        ;

normal_key_options:
          /* empty */ {}
        | normal_key_opts
        ;

fulltext_key_options:
          /* empty */ {}
        | fulltext_key_opts
        ;

spatial_key_options:
          /* empty */ {}
        | spatial_key_opts
        ;

normal_key_opts:
          normal_key_opt
        | normal_key_opts normal_key_opt
        ;

spatial_key_opts:
          spatial_key_opt
        | spatial_key_opts spatial_key_opt
        ;

fulltext_key_opts:
          fulltext_key_opt
        | fulltext_key_opts fulltext_key_opt
        ;

key_using_alg:
          USING btree_or_rtree     {}
        | TYPE_SYM btree_or_rtree  {}
        ;

all_key_opt:
          KEY_BLOCK_SIZE opt_equal ulong_num
          {}
        | COMMENT_SYM TEXT_STRING_sys {}
        ;

normal_key_opt:
          all_key_opt
        | key_using_alg
        ;

spatial_key_opt:
          all_key_opt
        ;

fulltext_key_opt:
          all_key_opt
        | WITH PARSER_SYM IDENT_sys
          {
          }
        ;

btree_or_rtree:
          BTREE_SYM {}
        | RTREE_SYM {}
        | HASH_SYM  {}
        ;

key_list:
          key_list ',' key_part order_dir {}
        | key_part order_dir {}
        ;

key_part:
          ident
          {
          }
        | ident '(' NUM ')'
          {
          }
        ;

opt_ident:
          /* empty */ {}
        | field_ident {}
        ;

opt_component:
          /* empty */    {}
        | '.' ident      {}
        ;

string_list:
          text_string {}
        | string_list ',' text_string {};

/*
** Alter table
*/

alter:
          ALTER TABLE_SYM table_ident
          {
          }
          alter_commands
          {
          }
        | ALTER DATABASE ident_or_empty
          {
          }
          create_database_options
          {
          }
        | ALTER DATABASE ident UPGRADE_SYM DATA_SYM DIRECTORY_SYM NAME_SYM
          {
          }
        | ALTER PROCEDURE_SYM sp_name
          {
          }
          sp_a_chistics
          {
          }
        | ALTER FUNCTION_SYM sp_name
          {
          }
          sp_a_chistics
          {
          }
        | ALTER view_algorithm definer_opt
          {
          }
          view_tail
          {}
        | ALTER definer_opt
          /*
            We have two separate rules for ALTER VIEW rather that
            optional view_algorithm above, to resolve the ambiguity
            with the ALTER EVENT below.
          */
          {
          }
          view_tail
          {}
        | ALTER definer_opt EVENT_SYM sp_name
          {
          }
          ev_alter_on_schedule_completion
          opt_ev_rename_to
          opt_ev_status
          opt_ev_comment
          opt_ev_sql_stmt
          {
          }
        | ALTER TABLESPACE alter_tablespace_info
          {
          }
        | ALTER LOGFILE_SYM GROUP_SYM alter_logfile_group_info
          {
          }
        | ALTER TABLESPACE change_tablespace_info
          {
          }
        | ALTER TABLESPACE change_tablespace_access
          {
          }
        | ALTER SERVER_SYM ident_or_text OPTIONS_SYM '(' server_options_list ')'
          {
          }
        | ALTER USER clear_privileges alter_user_list
          {
          }
        ;

alter_user_list:
          alter_user
        | alter_user_list ',' alter_user
        ;

alter_user:
          user PASSWORD EXPIRE_SYM opt_user_password_expiration
          {
          }
        ;

opt_user_password_expiration:
          /* For traditional "ALTER USER <foo> PASSWORD EXPIRE": */
          {
          }
        | INTERVAL_SYM real_ulong_num DAY_SYM
          {
          }
        | NEVER_SYM
          {
          }
        | DEFAULT
          {
          }
        ;

ev_alter_on_schedule_completion:
          /* empty */ {}
        | ON SCHEDULE_SYM ev_schedule_time {}
        | ev_on_completion {}
        | ON SCHEDULE_SYM ev_schedule_time ev_on_completion {}
        ;

opt_ev_rename_to:
          /* empty */ {}
        | RENAME TO_SYM sp_name
          {
          }
        ;

opt_ev_sql_stmt:
          /* empty*/ {}
        | DO_SYM ev_sql_stmt {}
        ;

ident_or_empty:
          /* empty */ {}
        | ident {}
        ;

alter_commands:
          /* empty */
        | DISCARD TABLESPACE
          {
          }
        | IMPORT TABLESPACE
          {
          }
        | alter_list
          opt_partitioning
        | alter_list
          remove_partitioning
        | remove_partitioning
        | partitioning
/*
  This part was added for release 5.1 by Mikael Ronström.
  From here we insert a number of commands to manage the partitions of a
  partitioned table such as adding partitions, dropping partitions,
  reorganising partitions in various manners. In future releases the list
  will be longer.
*/
        | add_partition_rule
        | DROP PARTITION_SYM alt_part_name_list
          {
          }
        | REBUILD_SYM PARTITION_SYM opt_no_write_to_binlog
          all_or_alt_part_name_list
          {
          }
        | OPTIMIZE PARTITION_SYM opt_no_write_to_binlog
          all_or_alt_part_name_list
          {
          }
          opt_no_write_to_binlog
        | ANALYZE_SYM PARTITION_SYM opt_no_write_to_binlog
          all_or_alt_part_name_list
          {
          }
        | CHECK_SYM PARTITION_SYM all_or_alt_part_name_list
          {
          }
          opt_mi_check_type
        | REPAIR PARTITION_SYM opt_no_write_to_binlog
          all_or_alt_part_name_list
          {
          }
          opt_mi_repair_type
        | COALESCE PARTITION_SYM opt_no_write_to_binlog real_ulong_num
          {
          }
        | TRUNCATE_SYM PARTITION_SYM all_or_alt_part_name_list
          {
          }
        | reorg_partition_rule
        | EXCHANGE_SYM PARTITION_SYM alt_part_name_item
          WITH TABLE_SYM table_ident have_partitioning opt_validation
          {
          }
        | DISCARD PARTITION_SYM have_partitioning all_or_alt_part_name_list
          TABLESPACE
          {
          }
        | IMPORT PARTITION_SYM have_partitioning all_or_alt_part_name_list
          TABLESPACE
          {
          }
        ;

opt_validation:
          /* empty */
        | WITH VALIDATION_SYM
        | WITHOUT_SYM VALIDATION_SYM
          {
          }
	    ;

remove_partitioning:
          REMOVE_SYM PARTITIONING_SYM have_partitioning
          {
          }
        ;

all_or_alt_part_name_list:
          ALL
          {
          }
        | alt_part_name_list
        ;

add_partition_rule:
          ADD PARTITION_SYM opt_no_write_to_binlog
          {
          }
          add_part_extra
          {}
        ;

add_part_extra:
          /* empty */
        | '(' part_def_list ')'
          {
          }
        | PARTITIONS_SYM real_ulong_num
          {
          }
        ;

reorg_partition_rule:
          REORGANIZE_SYM PARTITION_SYM opt_no_write_to_binlog
          {
          }
          reorg_parts_rule
        ;

reorg_parts_rule:
          /* empty */
          {
          }
        | alt_part_name_list
          {
          }
          INTO '(' part_def_list ')'
          {
          }
        ;

alt_part_name_list:
          alt_part_name_item {}
        | alt_part_name_list ',' alt_part_name_item {}
        ;

alt_part_name_item:
          ident
          {
          }
        ;

/*
  End of management of partition commands
*/

alter_list:
          alter_list_item
        | alter_list ',' alter_list_item
        ;

add_column:
          ADD opt_column
          {
          }
        ;

alter_list_item:
          add_column column_def opt_place
          {
          }
        | ADD key_def
          {
          }
        | add_column '(' create_field_list ')'
          {
          }
        | CHANGE opt_column field_ident
          {
          }
          field_spec opt_place
          {
          }
        | MODIFY_SYM opt_column field_ident
          {
          }
          type opt_attribute
          {
          }
          opt_place
          {
          }
        | DROP opt_column field_ident opt_restrict
          {
          }
        | DROP FOREIGN KEY_SYM field_ident
          {
          }
        | DROP PRIMARY_SYM KEY_SYM
          {
          }
        | DROP key_or_index field_ident
          {
          }
        | DISABLE_SYM KEYS
          {
          }
        | ENABLE_SYM KEYS
          {
          }
        | ALTER opt_column field_ident SET DEFAULT signed_literal
          {
          }
        | ALTER opt_column field_ident DROP DEFAULT
          {
          }
        | RENAME opt_to table_ident
          {
          }
        | RENAME key_or_index field_ident TO_SYM field_ident
          {
          }
        | CONVERT_SYM TO_SYM charset charset_name_or_default opt_collate
          {
          }
        | create_table_options_space_separated
          {
          }
        | FORCE_SYM
          {
          }
        | alter_order_clause
          {
          }
        | alter_algorithm_option
        | alter_lock_option
        ;

opt_index_lock_algorithm:
          /* empty */
        | alter_lock_option
        | alter_algorithm_option
        | alter_lock_option alter_algorithm_option
        | alter_algorithm_option alter_lock_option

alter_algorithm_option:
          ALGORITHM_SYM opt_equal DEFAULT
          {
          }
        | ALGORITHM_SYM opt_equal ident
          {
          }
        ;

alter_lock_option:
          LOCK_SYM opt_equal DEFAULT
          {
          }
        | LOCK_SYM opt_equal ident
          {
          }
        ;

opt_column:
          /* empty */ {}
        | COLUMN_SYM {}
        ;

opt_ignore:
          /* empty */ {}
        | IGNORE_SYM {}
        ;

opt_restrict:
          /* empty */ {}
        | RESTRICT    {}
        | CASCADE     {}
        ;

opt_place:
          /* empty */ {}
        | AFTER_SYM ident
          {
          }
        | FIRST_SYM
          {
          }
        ;

opt_to:
          /* empty */ {}
        | TO_SYM {}
        | EQ {}
        | AS {}
        ;

slave:
          START_SYM SLAVE opt_slave_thread_option_list
          {
          }
          slave_until
          slave_connection_opts
          {
          }
        | STOP_SYM SLAVE opt_slave_thread_option_list
          {
          }
        ;

start:
          START_SYM TRANSACTION_SYM opt_start_transaction_option_list
          {
          }
        ;

opt_start_transaction_option_list:
          /* empty */
          {
          }
        | start_transaction_option_list
          {
          }
        ;

start_transaction_option_list:
          start_transaction_option
          {
          }
        | start_transaction_option_list ',' start_transaction_option
          {
          }
        ;

start_transaction_option:
          WITH CONSISTENT_SYM SNAPSHOT_SYM
          {
          }
        | READ_SYM ONLY_SYM
          {
          }
        | READ_SYM WRITE_SYM
          {
          }
        ;

slave_connection_opts:
          slave_user_name_opt slave_user_pass_opt
          slave_plugin_auth_opt slave_plugin_dir_opt
        ;

slave_user_name_opt:
          {
          }
        | USER EQ TEXT_STRING_sys
          {
          }
        ;

slave_user_pass_opt:
          {
          }
        | PASSWORD EQ TEXT_STRING_sys
          {
          }

slave_plugin_auth_opt:
          {
          }
        | DEFAULT_AUTH_SYM EQ TEXT_STRING_sys
          {
          }
        ;

slave_plugin_dir_opt:
          {
          }
        | PLUGIN_DIR_SYM EQ TEXT_STRING_sys
          {
          }
        ;

opt_slave_thread_option_list:
          /* empty */
          {
          }
        | slave_thread_option_list
          {
          }
        ;

slave_thread_option_list:
          slave_thread_option
          {
          }
        | slave_thread_option_list ',' slave_thread_option
          {
          }
        ;

slave_thread_option:
          SQL_THREAD
          {
          }
        | RELAY_THREAD
          {
          }
        ;

slave_until:
          /*empty*/ {}
        | UNTIL_SYM slave_until_opts
          {
          }
        ;

slave_until_opts:
          master_file_def
        | slave_until_opts ',' master_file_def
        | SQL_BEFORE_GTIDS EQ TEXT_STRING_sys
          {
          }
        | SQL_AFTER_GTIDS EQ TEXT_STRING_sys
          {
          }
        | SQL_AFTER_MTS_GAPS
          {
          }
        ;

checksum:
          CHECKSUM_SYM table_or_tables
          {
          }
          table_list opt_checksum_type
          {}
        ;

opt_checksum_type:
          /* nothing */ {}
        | QUICK         {}
        | EXTENDED_SYM  {}
        ;

repair:
          REPAIR opt_no_write_to_binlog table_or_tables
          {
          }
          table_list opt_mi_repair_type
          {
          }
        ;

opt_mi_repair_type:
          /* empty */ {}
        | mi_repair_types {}
        ;

mi_repair_types:
          mi_repair_type {}
        | mi_repair_type mi_repair_types {}
        ;

mi_repair_type:
          QUICK        {}
        | EXTENDED_SYM {}
        | USE_FRM      {}
        ;

analyze:
          ANALYZE_SYM opt_no_write_to_binlog table_or_tables
          {
          }
          table_list
          {
          }
        ;

binlog_base64_event:
          BINLOG_SYM TEXT_STRING_sys
          {
          }
        ;

check:
          CHECK_SYM table_or_tables
          {
          }
          table_list opt_mi_check_type
          {
          }
        ;

opt_mi_check_type:
          /* empty */ {}
        | mi_check_types {}
        ;

mi_check_types:
          mi_check_type {}
        | mi_check_type mi_check_types {}
        ;

mi_check_type:
          QUICK               {}
        | FAST_SYM            {}
        | MEDIUM_SYM          {}
        | EXTENDED_SYM        {}
        | CHANGED             {}
        | FOR_SYM UPGRADE_SYM {}
        ;

optimize:
          OPTIMIZE opt_no_write_to_binlog table_or_tables
          {
          }
          table_list
          {
          }
        ;

opt_no_write_to_binlog:
          /* empty */ {}
        | NO_WRITE_TO_BINLOG {}
        | LOCAL_SYM {}
        ;

rename:
          RENAME table_or_tables
          {
          }
          table_to_table_list
          {}
        | RENAME USER clear_privileges rename_list
          {
          }
        ;

rename_list:
          user TO_SYM user
          {
          }
        | rename_list ',' user TO_SYM user
          {
          }
        ;

table_to_table_list:
          table_to_table
        | table_to_table_list ',' table_to_table
        ;

table_to_table:
          table_ident TO_SYM table_ident
          {
          }
        ;

keycache:
          CACHE_SYM INDEX_SYM
          {
          }
          keycache_list_or_parts IN_SYM key_cache_name
          {
          }
        ;

keycache_list_or_parts:
          keycache_list
        | assign_to_keycache_parts
        ;

keycache_list:
          assign_to_keycache
        | keycache_list ',' assign_to_keycache
        ;

assign_to_keycache:
          table_ident cache_keys_spec
          {
          }
        ;

assign_to_keycache_parts:
          table_ident adm_partition cache_keys_spec
          {
          }
        ;

key_cache_name:
          ident    {}
        | DEFAULT  {}
        ;

preload:
          LOAD INDEX_SYM INTO CACHE_SYM
          {
          }
          preload_list_or_parts
          {}
        ;

preload_list_or_parts:
          preload_keys_parts
        | preload_list
        ;

preload_list:
          preload_keys
        | preload_list ',' preload_keys
        ;

preload_keys:
          table_ident cache_keys_spec opt_ignore_leaves
          {
          }
        ;

preload_keys_parts:
          table_ident adm_partition cache_keys_spec opt_ignore_leaves
          {
          }
        ;

adm_partition:
          PARTITION_SYM have_partitioning
          {
          }
          '(' all_or_alt_part_name_list ')'
        ;

cache_keys_spec:
          cache_key_list_or_empty
        ;

cache_key_list_or_empty:
          /* empty */ {}
        | key_or_index '(' opt_key_usage_list ')'
          {
          }
        ;

opt_ignore_leaves:
          /* empty */
          {}
        | IGNORE_SYM LEAVES {}
        ;

/*
  Select : retrieve data from table
*/


select:
          select_init
          {
            sql->type = SQL_TYPE::SELECT;
          }
        ;

/* Need select_init2 for subselects. */
select_init:
          SELECT_SYM select_init2
          {
          }
        | '(' select_paren ')' union_opt
          {
          }
        ;

select_paren:
          SELECT_SYM select_part2
          {
          }
        | '(' select_paren ')' {}
        ;

/* The equivalent of select_paren for nested queries. */
select_paren_derived:
          SELECT_SYM select_part2_derived table_expression
          {
          }
        | '(' select_paren_derived ')' {}
        ;

select_init2:
          select_part2 opt_union_clause
          {
          }
        ;

/*
  Theoretically we can merge all 3 right hand sides of the select_part2
  rule into one, however such a transformation adds one shift/reduce
  conflict more.
*/
select_part2:
          select_options_and_item_list
          opt_order_clause
          opt_limit_clause
          opt_select_lock_type
          {
          }
        | select_options_and_item_list into opt_select_lock_type
          {
          }
        | select_options_and_item_list  /* #1 */
          opt_into                      /* #2 */
          from_clause                   /* #3 */
          opt_where_clause              /* #4 */
          opt_group_clause              /* #5 */
          opt_having_clause             /* #6 */
          opt_order_clause              /* #7 */
          opt_limit_clause              /* #8 */
          opt_procedure_analyse_clause  /* #9 */
          opt_into                      /* #10 */
          opt_select_lock_type          /* #11 */
          {
          }
        ;

select_options_and_item_list:
          select_options select_item_list
          {
            sql->cols = $2;
          }
        ;


table_expression:
          opt_from_clause               /* #1 */
          opt_where_clause              /* #2 */
          opt_group_clause              /* #3 */
          opt_having_clause             /* #4 */
          opt_order_clause              /* #5 */
          opt_limit_clause              /* #6 */
          opt_procedure_analyse_clause  /* #7 */
          opt_select_lock_type          /* #8 */
          {
          }
        ;

from_clause:
          FROM table_reference_list {}
        ;

opt_from_clause:
          /* empty */ {}
        | from_clause
        ;

table_reference_list:
          join_table_list
          {
          }
        | DUAL_SYM {}
          /* oracle compatibility: oracle always requires FROM clause,
             and DUAL is system table without fields.
             Is "SELECT 1 FROM DUAL" any better than "SELECT 1" ?
          Hmmm :) */
        ;

select_options:
          /* empty*/
          {
          }
        | select_option_list
        ;

select_option_list:
          select_option_list select_option
          {
          }
        | select_option
        ;

select_option:
          query_spec_option
          {
          }
        | SQL_NO_CACHE_SYM
          {
          }
        | SQL_CACHE_SYM
          {
          }
        | MAX_STATEMENT_TIME_SYM EQ real_ulong_num
          {
          }
        ;

opt_select_lock_type:
          /* empty */ {}
        | FOR_SYM UPDATE_SYM
          {
          }
        | LOCK_SYM IN_SYM SHARE_SYM MODE_SYM
          {
          }
        ;

select_item_list:
          select_item_list ',' select_item
          {
            $1->push($3);
            $$=$1;
          }
        | select_item
          {
            $$ = new DB_item_list();
            $$->push($1);
          }
        | '*'
          {
            $$ = new DB_item_list();
          }
        ;

select_item:
          table_wild {}
        | expr select_alias
          {
            if($2 == NULL){
              $$ = $1;
            }else{
              $$ = $2;
            }
          }
        ;


select_alias:
          /* empty */ {$$ = NULL; }
        | AS ident { $$ = $2; }
        | AS TEXT_STRING_sys {}
        | ident { $$ = $1; }
        | TEXT_STRING_sys {}
        ;

optional_braces:
          /* empty */ {}
        | '(' ')' {}
        ;

/* all possible expressions */
expr:
          expr or expr %prec OR_SYM
          {
          }
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

bool_pri:
          bool_pri IS NULL_SYM %prec IS
          {
          }
        | bool_pri IS not NULL_SYM %prec IS
          {
          }
        | bool_pri EQUAL_SYM predicate %prec EQUAL_SYM
          {
          }
        | bool_pri comp_op predicate %prec EQ
          {
          }
        | bool_pri comp_op all_or_any '(' subselect ')' %prec EQ
          {
          }
        | predicate
        ;

predicate:
          bit_expr IN_SYM '(' subselect ')'
          {
          }
        | bit_expr not IN_SYM '(' subselect ')'
          {
          }
        | bit_expr IN_SYM '(' expr ')'
          {
          }
        | bit_expr IN_SYM '(' expr ',' expr_list ')'
          {
          }
        | bit_expr not IN_SYM '(' expr ')'
          {
          }
        | bit_expr not IN_SYM '(' expr ',' expr_list ')'
          {
          }
        | bit_expr BETWEEN_SYM bit_expr AND_SYM predicate
          {
          }
        | bit_expr not BETWEEN_SYM bit_expr AND_SYM predicate
          {
          }
        | bit_expr SOUNDS_SYM LIKE bit_expr
          {
          }
        | bit_expr LIKE simple_expr opt_escape
          {
          }
        | bit_expr not LIKE simple_expr opt_escape
          {
          }
        | bit_expr REGEXP bit_expr
          {
          }
        | bit_expr not REGEXP bit_expr
          {
          }
        | bit_expr
        ;

bit_expr:
          bit_expr '|' bit_expr %prec '|'
          {
          }
        | bit_expr '&' bit_expr %prec '&'
          {
          }
        | bit_expr SHIFT_LEFT bit_expr %prec SHIFT_LEFT
          {
          }
        | bit_expr SHIFT_RIGHT bit_expr %prec SHIFT_RIGHT
          {
          }
        | bit_expr '+' bit_expr %prec '+'
          {
          }
        | bit_expr '-' bit_expr %prec '-'
          {
          }
        | bit_expr '+' INTERVAL_SYM expr interval %prec '+'
          {
          }
        | bit_expr '-' INTERVAL_SYM expr interval %prec '-'
          {
          }
        | bit_expr '*' bit_expr %prec '*'
          {
          }
        | bit_expr '/' bit_expr %prec '/'
          {
          }
        | bit_expr '%' bit_expr %prec '%'
          {
          }
        | bit_expr DIV_SYM bit_expr %prec DIV_SYM
          {
          }
        | bit_expr MOD_SYM bit_expr %prec MOD_SYM
          {
          }
        | bit_expr '^' bit_expr
          {
          }
        | simple_expr
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

comp_op:
          EQ     {}
        | GE     {}
        | GT_SYM {}
        | LE     {}
        | LT     {}
        | NE     {}
        ;

all_or_any:
          ALL     {}
        | ANY_SYM {}
        ;

simple_expr:
          simple_ident
        | function_call_keyword
        | function_call_nonkeyword
        | function_call_generic
        | function_call_conflict
        | simple_expr COLLATE_SYM ident_or_text %prec NEG
          {
          }
        | literal
        | param_marker {}
        | variable
        | sum_expr
        | simple_expr OR_OR_SYM simple_expr
          {
          }
        | '+' simple_expr %prec NEG
          {
          }
        | '-' simple_expr %prec NEG
          {
          }
        | '~' simple_expr %prec NEG
          {
          }
        | not2 simple_expr %prec NEG
          {
          }
        | '(' subselect ')'
          {
          }
        | '(' expr ')'
          {}
        | '(' expr ',' expr_list ')'
          {
          }
        | ROW_SYM '(' expr ',' expr_list ')'
          {
          }
        | EXISTS '(' subselect ')'
          {
          }
        | '{' ident expr '}'
          {
          }
        | MATCH ident_list_arg AGAINST '(' bit_expr fulltext_options ')'
          {
          }
        | BINARY simple_expr %prec NEG
          {
          }
        | CAST_SYM '(' expr AS cast_type ')'
          {
          }
        | CASE_SYM opt_expr when_list opt_else END
          {
          }
        | CONVERT_SYM '(' expr ',' cast_type ')'
          {
          }
        | CONVERT_SYM '(' expr USING charset_name ')'
          {
          }
        | DEFAULT '(' simple_ident ')'
          {
          }
        | VALUES '(' simple_ident_nospvar ')'
          {
          }
        | INTERVAL_SYM expr interval '+' expr %prec INTERVAL_SYM
          /* we cannot put interval before - */
          {
          }
        ;

/*
  Function call syntax using official SQL 2003 keywords.
  Because the function name is an official token,
  a dedicated grammar rule is needed in the parser.
  There is no potential for conflicts
*/
function_call_keyword:
          CHAR_SYM '(' expr_list ')'
          {
          }
        | CHAR_SYM '(' expr_list USING charset_name ')'
          {
          }
        | CURRENT_USER optional_braces
          {
          }
        | DATE_SYM '(' expr ')'
          {
          }
        | DAY_SYM '(' expr ')'
          {
          }
        | HOUR_SYM '(' expr ')'
          {
          }
        | INSERT '(' expr ',' expr ',' expr ',' expr ')'
          {
          }
        | INTERVAL_SYM '(' expr ',' expr ')' %prec INTERVAL_SYM
          {
          }
        | INTERVAL_SYM '(' expr ',' expr ',' expr_list ')' %prec INTERVAL_SYM
          {
          }
        | LEFT '(' expr ',' expr ')'
          {
          }
        | MINUTE_SYM '(' expr ')'
          {
          }
        | MONTH_SYM '(' expr ')'
          {
          }
        | RIGHT '(' expr ',' expr ')'
          {
          }
        | SECOND_SYM '(' expr ')'
          {
          }
        | TIME_SYM '(' expr ')'
          {
          }
        | TIMESTAMP '(' expr ')'
          {
          }
        | TIMESTAMP '(' expr ',' expr ')'
          {
          }
        | TRIM '(' expr ')'
          {
          }
        | TRIM '(' LEADING expr FROM expr ')'
          {
          }
        | TRIM '(' TRAILING expr FROM expr ')'
          {
          }
        | TRIM '(' BOTH expr FROM expr ')'
          {
          }
        | TRIM '(' LEADING FROM expr ')'
          {
          }
        | TRIM '(' TRAILING FROM expr ')'
          {
          }
        | TRIM '(' BOTH FROM expr ')'
          {
          }
        | TRIM '(' expr FROM expr ')'
          {
          }
        | USER '(' ')'
          {
          }
        | YEAR_SYM '(' expr ')'
          {
          }
        ;

/*
  Function calls using non reserved keywords, with special syntaxic forms.
  Dedicated grammar rules are needed because of the syntax,
  but also have the potential to cause incompatibilities with other
  parts of the language.
  MAINTAINER:
  The only reasons a function should be added here are:
  - for compatibility reasons with another SQL syntax (CURDATE),
  - for typing reasons (GET_FORMAT)
  Any other 'Syntaxic sugar' enhancements should be *STRONGLY*
  discouraged.
*/
function_call_nonkeyword:
          ADDDATE_SYM '(' expr ',' expr ')'
          {
          }
        | ADDDATE_SYM '(' expr ',' INTERVAL_SYM expr interval ')'
          {
          }
        | CURDATE optional_braces
          {
          }
        | CURTIME func_datetime_precision
          {
          }
        | DATE_ADD_INTERVAL '(' expr ',' INTERVAL_SYM expr interval ')'
          %prec INTERVAL_SYM
          {
          }
        | DATE_SUB_INTERVAL '(' expr ',' INTERVAL_SYM expr interval ')'
          %prec INTERVAL_SYM
          {
          }
        | EXTRACT_SYM '(' interval FROM expr ')'
          {
          }
        | GET_FORMAT '(' date_time_type  ',' expr ')'
          {
          }
        | now
          {
          }
        | POSITION_SYM '(' bit_expr IN_SYM expr ')'
          {
          }
        | SUBDATE_SYM '(' expr ',' expr ')'
          {
          }
        | SUBDATE_SYM '(' expr ',' INTERVAL_SYM expr interval ')'
          {
          }
        | SUBSTRING '(' expr ',' expr ',' expr ')'
          {
          }
        | SUBSTRING '(' expr ',' expr ')'
          {
          }
        | SUBSTRING '(' expr FROM expr FOR_SYM expr ')'
          {
          }
        | SUBSTRING '(' expr FROM expr ')'
          {
          }
        | SYSDATE func_datetime_precision
          {
          }
        | TIMESTAMP_ADD '(' interval_time_stamp ',' expr ',' expr ')'
          {
          }
        | TIMESTAMP_DIFF '(' interval_time_stamp ',' expr ',' expr ')'
          {
          }
        | UTC_DATE_SYM optional_braces
          {
          }
        | UTC_TIME_SYM func_datetime_precision
          {
          }
        | UTC_TIMESTAMP_SYM func_datetime_precision
          {
          }
        ;

/*
  Functions calls using a non reserved keyword, and using a regular syntax.
  Because the non reserved keyword is used in another part of the grammar,
  a dedicated rule is needed here.
*/
function_call_conflict:
          ASCII_SYM '(' expr ')'
          {
          }
        | CHARSET '(' expr ')'
          {
          }
        | COALESCE '(' expr_list ')'
          {
          }
        | COLLATION_SYM '(' expr ')'
          {
          }
        | DATABASE '(' ')'
          {
          }
        | IF '(' expr ',' expr ',' expr ')'
          {
          }
        | FORMAT_SYM '(' expr ',' expr ')'
          {
          }
        | FORMAT_SYM '(' expr ',' expr ',' expr ')'
          {
          }
        | MICROSECOND_SYM '(' expr ')'
          {
          }
        | MOD_SYM '(' expr ',' expr ')'
          {
          }
        | PASSWORD '(' expr ')'
          {
          }
        | QUARTER_SYM '(' expr ')'
          {
          }
        | REPEAT_SYM '(' expr ',' expr ')'
          {
          }
        | REPLACE '(' expr ',' expr ',' expr ')'
          {
          }
        | REVERSE_SYM '(' expr ')'
          {
          }
        | ROW_COUNT_SYM '(' ')'
          {
          }
        | TRUNCATE_SYM '(' expr ',' expr ')'
          {
          }
        | WEEK_SYM '(' expr ')'
          {
          }
        | WEEK_SYM '(' expr ',' expr ')'
          {
          }
        | WEIGHT_STRING_SYM '(' expr opt_ws_levels ')'
          {
          }
        | WEIGHT_STRING_SYM '(' expr AS CHAR_SYM ws_nweights opt_ws_levels ')'
          {
          }
        | WEIGHT_STRING_SYM '(' expr AS BINARY ws_nweights ')'
          {
          }
        | WEIGHT_STRING_SYM '(' expr ',' ulong_num ',' ulong_num ',' ulong_num ')'
          {
          }
        | geometry_function
        ;

geometry_function:
          CONTAINS_SYM '(' expr ',' expr ')'
          {
          }
        | GEOMETRYCOLLECTION '(' expr_list ')'
          {
          }
        | LINESTRING '(' expr_list ')'
          {
          }
        | MULTILINESTRING '(' expr_list ')'
          {
          }
        | MULTIPOINT '(' expr_list ')'
          {
          }
        | MULTIPOLYGON '(' expr_list ')'
          {
          }
        | POINT_SYM '(' expr ',' expr ')'
          {
          }
        | POLYGON '(' expr_list ')'
          {
          }
        ;

/*
  Regular function calls.
  The function name is *not* a token, and therefore is guaranteed to not
  introduce side effects to the language in general.
  MAINTAINER:
  All the new functions implemented for new features should fit into
  this category. The place to implement the function itself is
  in sql/item_create.cc
*/
function_call_generic:
          IDENT_sys '(' opt_udf_expr_list ')'
          {
          }
        | ident '.' ident '(' opt_expr_list ')'
          {
          }
        ;

fulltext_options:
          opt_natural_language_mode opt_query_expansion
          {}
        | IN_SYM BOOLEAN_SYM MODE_SYM
          {}
        ;

opt_natural_language_mode:
          /* nothing */                         {}
        | IN_SYM NATURAL LANGUAGE_SYM MODE_SYM  {}
        ;

opt_query_expansion:
          /* nothing */                         {}
        | WITH QUERY_SYM EXPANSION_SYM          {}
        ;

opt_udf_expr_list:
        /* empty */     {}
        | udf_expr_list {}
        ;

udf_expr_list:
          udf_expr
          {
          }
        | udf_expr_list ',' udf_expr
          {
          }
        ;

udf_expr:
          expr select_alias
          {
          }
        ;

sum_expr:
          AVG_SYM '(' in_sum_expr ')'
          {
          }
        | AVG_SYM '(' DISTINCT in_sum_expr ')'
          {
          }
        | BIT_AND  '(' in_sum_expr ')'
          {
          }
        | BIT_OR  '(' in_sum_expr ')'
          {
          }
        | BIT_XOR  '(' in_sum_expr ')'
          {
          }
        | COUNT_SYM '(' opt_all '*' ')'
          {
            $$ = new std::string("COUNT(*)");
          }
        | COUNT_SYM '(' in_sum_expr ')'
          {
          }
        | COUNT_SYM '(' DISTINCT expr_list ')'
          {
          }
        | MIN_SYM '(' in_sum_expr ')'
          {
          }
        /*
          According to ANSI SQL, DISTINCT is allowed and has
          no sense inside MIN and MAX grouping functions; so MIN|MAX(DISTINCT ...)
          is processed like an ordinary MIN | MAX()
        */
        | MIN_SYM '(' DISTINCT in_sum_expr ')'
          {
          }
        | MAX_SYM '(' in_sum_expr ')'
          {
          }
        | MAX_SYM '(' DISTINCT in_sum_expr ')'
          {
          }
        | STD_SYM '(' in_sum_expr ')'
          {
          }
        | VARIANCE_SYM '(' in_sum_expr ')'
          {
          }
        | STDDEV_SAMP_SYM '(' in_sum_expr ')'
          {
          }
        | VAR_SAMP_SYM '(' in_sum_expr ')'
          {
          }
        | SUM_SYM '(' in_sum_expr ')'
          {
          }
        | SUM_SYM '(' DISTINCT in_sum_expr ')'
          {
          }
        | GROUP_CONCAT_SYM '(' opt_distinct
          expr_list opt_gorder_clause
          opt_gconcat_separator
          ')'
          {
          }
        ;

variable:
          '@' variable_aux {}
        ;

variable_aux:
          ident_or_text SET_VAR expr
          {
          }
        | ident_or_text
          {
          }
        | '@' opt_var_ident_type ident_or_text opt_component
          {
          }
        ;

opt_distinct:
          /* empty */ {}
        | DISTINCT    {}
        ;

opt_gconcat_separator:
          /* empty */
          {
          }
        | SEPARATOR_SYM text_string {}
        ;

opt_gorder_clause:
          /* empty */               {}
        | ORDER_SYM BY gorder_list  {}
        ;

gorder_list:
          gorder_list ',' order_expr
          {
          }
        | order_expr
          {
          }
        ;

in_sum_expr:
          opt_all expr
          {
          }
        ;

cast_type:
          BINARY opt_field_length
          {
          }
        | CHAR_SYM opt_field_length opt_binary
          {
          }
        | NCHAR_SYM opt_field_length
          {
          }
        | SIGNED_SYM
          {
          }
        | SIGNED_SYM INT_SYM
          {
          }
        | UNSIGNED
          {
          }
        | UNSIGNED INT_SYM
          {
          }
        | DATE_SYM
          {
          }
        | TIME_SYM type_datetime_precision
          {
          }
        | DATETIME type_datetime_precision
          {
          }
        | DECIMAL_SYM float_options
          {
          }
        ;

opt_expr_list:
          /* empty */ {}
        | expr_list
        ;

expr_list:
          expr
          {
          }
        | expr_list ',' expr
          {
          }
        ;

ident_list_arg:
          ident_list          {}
        | '(' ident_list ')'  {}
        ;

ident_list:
          simple_ident
          {
          }
        | ident_list ',' simple_ident
          {
          }
        ;

opt_expr:
          /* empty */    {}
        | expr           {}
        ;

opt_else:
          /* empty */  {}
        | ELSE expr    {}
        ;

when_list:
          WHEN_SYM expr THEN_SYM expr
          {
          }
        | when_list WHEN_SYM expr THEN_SYM expr
          {
          }
        ;

/* Equivalent to <table reference> in the SQL:2003 standard. */
/* Warning - may return NULL in case of incomplete SELECT */
table_ref:
          table_factor
        | join_table
          {
          }
        ;

join_table_list:
          derived_table_list
          {
            sql->db_table_desc = $1;
          }
        ;

/*
  The ODBC escape syntax for Outer Join is: '{' OJ join_table '}'
  The parser does not define OJ as a token, any ident is accepted
  instead in $2 (ident). Also, all productions from table_ref can
  be escaped, not only join_table. Both syntax extensions are safe
  and are ignored.
*/
esc_table_ref:
        table_ref
      | '{' ident table_ref '}' {}
      ;

/* Equivalent to <table reference list> in the SQL:2003 standard. */
/* Warning - may return NULL in case of incomplete SELECT */
derived_table_list:
          esc_table_ref
        | derived_table_list ',' esc_table_ref
          {
          }
        ;

/*
  Notice that JOIN is a left-associative operation, and it must be parsed
  as such, that is, the parser must process first the left join operand
  then the right one. Such order of processing ensures that the parser
  produces correct join trees which is essential for semantic analysis
  and subsequent optimization phases.
*/
join_table:
          /* INNER JOIN variants */
          /*
            Use %prec to evaluate production 'table_ref' before 'normal_join'
            so that [INNER | CROSS] JOIN is properly nested as other
            left-associative joins.
          */
          table_ref normal_join table_ref %prec TABLE_REF_PRIORITY
          {
          }
        | table_ref STRAIGHT_JOIN table_factor
          {
          }
        | table_ref normal_join table_ref
          ON
          expr
          {
          }
        | table_ref STRAIGHT_JOIN table_factor
          ON
          expr
          {
          }
        | table_ref normal_join table_ref
          USING
          '(' using_list ')'
          {
          }
        | table_ref NATURAL JOIN_SYM table_factor
          {
          }

          /* LEFT JOIN variants */
        | table_ref LEFT opt_outer JOIN_SYM table_ref
          ON
          expr
          {
          }
        | table_ref LEFT opt_outer JOIN_SYM table_factor
          USING '(' using_list ')'
          {
          }
        | table_ref NATURAL LEFT opt_outer JOIN_SYM table_factor
          {
          }

          /* RIGHT JOIN variants */
        | table_ref RIGHT opt_outer JOIN_SYM table_ref
          ON
          expr
          {
          }
        | table_ref RIGHT opt_outer JOIN_SYM table_factor
          USING '(' using_list ')'
          {
          }
        | table_ref NATURAL RIGHT opt_outer JOIN_SYM table_factor
          {
          }
        ;

normal_join:
          JOIN_SYM {}
        | INNER_SYM JOIN_SYM {}
        | CROSS JOIN_SYM {}
        ;

/*
  table PARTITION (list of partitions), reusing using_list instead of creating
  a new rule for partition_list.
*/
opt_use_partition:
          /* empty */ {}
        | use_partition
        ;

use_partition:
          PARTITION_SYM '(' using_list ')' have_partitioning
          {
          }
        ;

/*
   This is a flattening of the rules <table factor> and <table primary>
   in the SQL:2003 standard, since we don't have <sample clause>

   I.e.
   <table factor> ::= <table primary> [ <sample clause> ]
*/
/* Warning - may return NULL in case of incomplete SELECT */
table_factor:
          table_ident opt_use_partition opt_table_alias opt_key_definition
          {
            $$ = $1;
          }
        | SELECT_SYM select_options select_item_list table_expression
          {
          }
          /*
            Represents a flattening of the following rules from the SQL:2003
            standard. This sub-rule corresponds to the sub-rule
            <table primary> ::= ... | <derived table> [ AS ] <correlation name>

            The following rules have been flattened into query_expression_body
            (since we have no <with clause>).

            <derived table> ::= <table subquery>
            <table subquery> ::= <subquery>
            <subquery> ::= <left paren> <query expression> <right paren>
            <query expression> ::= [ <with clause> ] <query expression body>

            For the time being we use the non-standard rule
            select_derived_union which is a compromise between the standard
            and our parser. Possibly this rule could be replaced by our
            query_expression_body.
          */
        | '(' select_derived_union ')' opt_table_alias
          {
          }
        ;

/*
  This rule accepts just about anything. The reason is that we have
  empty-producing rules in the beginning of rules, in this case
  subselect_start. This forces bison to take a decision which rules to
  reduce by long before it has seen any tokens. This approach ties us
  to a very limited class of parseable languages, and unfortunately
  SQL is not one of them. The chosen 'solution' was this rule, which
  produces just about anything, even complete bogus statements, for
  instance ( table UNION SELECT 1 ).

  Fortunately, we know that the semantic value returned by
  select_derived->value is NULL if it contained a derived table, and a pointer to
  the base table's TABLE_LIST if it was a base table. So in the rule
  regarding union's, we throw a parse error manually and pretend it
  was bison that did it.

  Also worth noting is that this rule concerns query expressions in
  the from clause only. Top level select statements and other types of
  subqueries have their own union rules.
 */
select_derived_union:
          select_derived opt_union_order_or_limit
          {
          }
        | select_derived_union UNION_SYM union_option query_specification
          {
          }
        ;

/* The equivalent of select_part2 for nested queries. */
select_part2_derived:
          {
          }
          opt_query_spec_options select_item_list
          {
            delete $3;
          }
        ;

/* handle contents of parentheses in join expression */
select_derived:
          derived_table_list
          {
          }
        ;

opt_outer:
          /* empty */ {}
        | OUTER {}
        ;

index_hint_clause:
          /* empty */
          {
          }
        | FOR_SYM JOIN_SYM      {}
        | FOR_SYM ORDER_SYM BY  {}
        | FOR_SYM GROUP_SYM BY  {}
        ;

index_hint_type:
          FORCE_SYM  {}
        | IGNORE_SYM {}
        ;

index_hint_definition:
          index_hint_type key_or_index index_hint_clause
          '(' key_usage_list ')'
          {
          }
        | USE_SYM key_or_index index_hint_clause
          '(' opt_key_usage_list ')'
          {
          }
       ;

index_hints_list:
          index_hint_definition
        | index_hints_list index_hint_definition
          {
          }
        ;

opt_index_hints_list:
          /* empty */ {}
        | index_hints_list
        ;

opt_key_definition:
          opt_index_hints_list
        ;

opt_key_usage_list:
          /* empty */
          {
          }
        | key_usage_list
        ;

key_usage_element:
          ident
          {
          }
        | PRIMARY_SYM
          {
          }
        ;

key_usage_list:
          key_usage_element
          {
          }
        | key_usage_list ',' key_usage_element
          {
          }
        ;

using_list:
          ident
          {
          }
        | using_list ',' ident
          {
          }
        ;

interval:
          interval_time_stamp    {}
        | DAY_HOUR_SYM           {}
        | DAY_MICROSECOND_SYM    {}
        | DAY_MINUTE_SYM         {}
        | DAY_SECOND_SYM         {}
        | HOUR_MICROSECOND_SYM   {}
        | HOUR_MINUTE_SYM        {}
        | HOUR_SECOND_SYM        {}
        | MINUTE_MICROSECOND_SYM {}
        | MINUTE_SECOND_SYM      {}
        | SECOND_MICROSECOND_SYM {}
        | YEAR_MONTH_SYM         {}
        ;

interval_time_stamp:
          DAY_SYM         {}
        | WEEK_SYM        {}
        | HOUR_SYM        {}
        | MINUTE_SYM      {}
        | MONTH_SYM       {}
        | QUARTER_SYM     {}
        | SECOND_SYM      {}
        | MICROSECOND_SYM {}
        | YEAR_SYM        {}
        ;

date_time_type:
          DATE_SYM  {}
        | TIME_SYM  {}
        | TIMESTAMP {}
        | DATETIME  {}
        ;

table_alias:
          /* empty */
        | AS
        | EQ
        ;

opt_table_alias:
          /* empty */ {}
        | table_alias ident
          {
          }
        ;

opt_all:
          /* empty */
        | ALL
        ;

opt_where_clause:
          /* empty */  {}
        | WHERE expr
          {
          }
        ;

opt_having_clause:
          /* empty */ {}
        | HAVING expr
          {
          }
        ;

opt_escape:
          ESCAPE_SYM simple_expr {}
        | /* empty */            {}
        ;

/*
   group by statement in select
*/

opt_group_clause:
          /* empty */ {}
        | GROUP_SYM BY group_list olap_opt
          {
          }
        ;

group_list:
          group_list ',' order_expr
          {
          }
        | order_expr
          {
          }
        ;

olap_opt:
          /* empty */   {}
        | WITH_CUBE_SYM {}
            /*
              'WITH CUBE' is reserved in the MySQL syntax, but not implemented,
              and cause LALR(2) conflicts.
              This syntax is not standard.
              MySQL syntax: GROUP BY col1, col2, col3 WITH CUBE
              SQL-2003: GROUP BY ... CUBE(col1, col2, col3)
            */
        | WITH_ROLLUP_SYM {}
            /*
              'WITH ROLLUP' is needed for backward compatibility,
              and cause LALR(2) conflicts.
              This syntax is not standard.
              MySQL syntax: GROUP BY col1, col2, col3 WITH ROLLUP
              SQL-2003: GROUP BY ... ROLLUP(col1, col2, col3)
            */
        ;

/*
  Order by statement in ALTER TABLE
*/

alter_order_clause:
          ORDER_SYM BY alter_order_list
        ;

alter_order_list:
          alter_order_list ',' alter_order_item
        | alter_order_item
        ;

alter_order_item:
          simple_ident_nospvar order_dir
          {
          }
        ;

/*
   Order by statement in select
*/

opt_order_clause:
          /* empty */ {}
        | order_clause
        ;

order_clause:
          ORDER_SYM BY order_list
          {
          }
        ;

order_list:
          order_list ',' order_expr
          {
          }
        | order_expr
          {
          }
        ;

order_dir:
          /* empty */ {}
        | ASC  {}
        | DESC {}
        ;

opt_limit_clause:
          /* empty */ {}
        | limit_clause
        ;

limit_clause:
          LIMIT limit_options
          {
          }
        ;

limit_options:
          limit_option
          {
          }
        | limit_option ',' limit_option
          {
          }
        | limit_option OFFSET_SYM limit_option
          {
          }
        ;

limit_option:
          ident
          {
          }
        | param_marker
          {
          }
        | ULONGLONG_NUM
          {
          }
        | LONG_NUM
          {
          }
        | NUM
          {
          }
        ;

delete_limit_clause:
          /* empty */
          {
          }
        | LIMIT limit_option
          {
          }
        ;

ulong_num:
          NUM           {}
        | HEX_NUM       {}
        | LONG_NUM      {}
        | ULONGLONG_NUM {}
        | DECIMAL_NUM   {}
        | FLOAT_NUM     {}
        ;

real_ulong_num:
          NUM           {}
        | HEX_NUM       {}
        | LONG_NUM      {}
        | ULONGLONG_NUM {}
        | dec_num_error {}
        ;

ulonglong_num:
          NUM           {}
        | ULONGLONG_NUM {}
        | LONG_NUM      {}
        | DECIMAL_NUM   {}
        | FLOAT_NUM     {}
        ;

real_ulonglong_num:
          NUM           {}
        | ULONGLONG_NUM {}
        | LONG_NUM      {}
        | dec_num_error {}
        ;

dec_num_error:
          dec_num
          {}
        ;

dec_num:
          DECIMAL_NUM
        | FLOAT_NUM
        ;

opt_procedure_analyse_clause:
          /* empty */ {}
        | PROCEDURE_SYM ANALYSE_SYM
          '(' opt_procedure_analyse_params ')'
          {
          }
        ;

opt_procedure_analyse_params:
          /* empty */
          {
          }
        | procedure_analyse_param
          {
          }
        | procedure_analyse_param ',' procedure_analyse_param
          {
          }
        ;

procedure_analyse_param:
          NUM
          {
          }
        ;

select_var_list:
          select_var_list ',' select_var_ident
          {
          }
        | select_var_ident
          {
          }
        ;

select_var_ident:
          '@' ident_or_text
          {
          }
        | ident_or_text
          {
          }
        ;

opt_into:
          /* empty */ {}
        | into
        ;

into:
          INTO into_destination
          {
          }
        ;

into_destination:
          OUTFILE TEXT_STRING_filesystem
          opt_load_data_charset
          opt_field_term opt_line_term
          {
          }
        | DUMPFILE TEXT_STRING_filesystem
          {
          }
        | select_var_list {}
        ;

/*
  DO statement
*/

do:
          DO_SYM
          {
          }
          expr_list
          {
          }
        ;

/*
  Drop : delete tables or index or user
*/

drop:
          DROP opt_temporary table_or_tables if_exists
          {
          }
          table_list opt_restrict
          {}
        | DROP INDEX_SYM ident ON table_ident {}
          {
          }
          opt_index_lock_algorithm {}
        | DROP DATABASE if_exists ident
          {
          }
        | DROP FUNCTION_SYM if_exists ident '.' ident
          {
          }
        | DROP FUNCTION_SYM if_exists ident
          {
          }
        | DROP PROCEDURE_SYM if_exists sp_name
          {
          }
        | DROP USER clear_privileges user_list
          {
          }
        | DROP VIEW_SYM if_exists
          {
          }
          table_list opt_restrict
          {}
        | DROP EVENT_SYM if_exists sp_name
          {
          }
        | DROP TRIGGER_SYM if_exists sp_name
          {
          }
        | DROP TABLESPACE tablespace_name drop_ts_options_list
          {
          }
        | DROP LOGFILE_SYM GROUP_SYM logfile_group_name drop_ts_options_list
          {
          }
        | DROP SERVER_SYM if_exists ident_or_text
          {
          }
        ;

table_list:
          table_name
        | table_list ',' table_name
        ;

table_name:
          table_ident
          {
          }
        ;

table_name_with_opt_use_partition:
          table_ident opt_use_partition
          {
          }
        ;

table_alias_ref_list:
          table_alias_ref
        | table_alias_ref_list ',' table_alias_ref
        ;

table_alias_ref:
          table_ident_opt_wild
          {
          }
        ;

if_exists:
          /* empty */ {}
        | IF EXISTS {}
        ;

opt_temporary:
          /* empty */ {}
        | TEMPORARY {}
        ;

drop_ts_options_list:
          /* empty */
        | drop_ts_options

drop_ts_options:
          drop_ts_option
        | drop_ts_options drop_ts_option
        | drop_ts_options_list ',' drop_ts_option
        ;

drop_ts_option:
          opt_ts_engine
        | ts_wait

/*
** Insert : add new data to table
*/

insert:
          INSERT
          {
            sql->type = SQL_TYPE::INSERT;
          }
          insert_lock_option
          opt_ignore insert2
          {
          }
          insert_field_spec opt_insert_update
          {}
        ;

replace:
          REPLACE
          {
          }
          replace_lock_option insert2
          {
          }
          insert_field_spec
          {}
        ;

insert_lock_option:
          /* empty */   {}
        | LOW_PRIORITY  {}
        | DELAYED_SYM
        {
        }
        | HIGH_PRIORITY {}
        ;

replace_lock_option:
          opt_low_priority {}
        | DELAYED_SYM
        {
        }
        ;

insert2:
          INTO insert_table {}
        | insert_table {}
        ;

insert_table:
          table_name_with_opt_use_partition
          {
          };

insert_field_spec:
          insert_values {}
        | '(' ')' insert_values {}
        | '(' fields ')' insert_values {}
        | SET
          {
          }
          ident_eq_list
        ;

fields:
          fields ',' insert_ident {}
        | insert_ident {}
        ;

insert_values:
          VALUES values_list {}
        | VALUE_SYM values_list {}
        | create_select
          {}
          opt_union_clause
          {
          }
        | '(' create_select ')'
          {}
          union_opt
          {
          }
        ;

values_list:
          values_list ','  no_braces
        | no_braces
        ;

ident_eq_list:
          ident_eq_list ',' ident_eq_value
        | ident_eq_value
        ;

ident_eq_value:
          simple_ident_nospvar equal expr_or_default
          {
          }
        ;

equal:
          EQ {}
        | SET_VAR {}
        ;

opt_equal:
          /* empty */ {}
        | equal {}
        ;

no_braces:
          '('
          {
          }
          opt_values ')'
          {
          }
        ;

opt_values:
          /* empty */ {}
        | values
        ;

values:
          values ','  expr_or_default
          {
          }
        | expr_or_default
          {
          }
        ;

expr_or_default:
          expr
          {
          }
        | DEFAULT
          {
          }
        ;

opt_insert_update:
          /* empty */
        | ON DUPLICATE_SYM
          {
          }
          KEY_SYM UPDATE_SYM
          {
          }
          insert_update_list
          {
          }
        ;

/* Update rows in a table */

update:
          UPDATE_SYM            /* #1 */
          {
            sql->type = SQL_TYPE::UPDATE;
          }
          opt_low_priority      /* #3 */
          opt_ignore            /* #4 */
          join_table_list       /* #5 */
          SET                   /* #6 */
          {
          }
          update_list           /* #8 */
          {
          }
          opt_where_clause      /* #10 */
          opt_order_clause      /* #11 */
          {
          }
          delete_limit_clause   /* #13 */
        ;

update_list:
          update_list ',' update_elem
        | update_elem
        ;

update_elem:
          simple_ident_nospvar equal expr_or_default
          {
          }
        ;

insert_update_list:
          insert_update_list ',' insert_update_elem
        | insert_update_elem
        ;

insert_update_elem:
          simple_ident_nospvar equal expr_or_default
          {
          }
        ;

opt_low_priority:
          /* empty */ {}
        | LOW_PRIORITY {}
        ;

/* Delete rows from a table */

delete:
          DELETE_SYM
          {
            sql->type = SQL_TYPE::DELETE;
          }
          opt_delete_options single_multi
        ;

single_multi:
          FROM                  /* #1 */
          table_ident           /* #2 */
          opt_use_partition     /* #3 */
          {
          }
          opt_where_clause      /* #5 */
          opt_order_clause      /* #6 */
          {
          }
          delete_limit_clause   /* #8 */
        | table_wild_list       /* #1 */
          {
          }
          FROM                  /* #3 */
          join_table_list       /* #4 */
          opt_where_clause      /* #5 */
          {
          }
        | FROM                  /* #1 */
          table_alias_ref_list  /* #2 */
          {
          }
          USING                 /* #4 */
          join_table_list       /* #5 */
          opt_where_clause      /* #6 */
          {
          }
        ;

table_wild_list:
          table_wild_one
        | table_wild_list ',' table_wild_one
        ;

table_wild_one:
          ident opt_wild
          {
          }
        | ident '.' ident opt_wild
          {
          }
        ;

opt_wild:
          /* empty */ {}
        | '.' '*' {}
        ;

opt_delete_options:
          /* empty */ {}
        | opt_delete_option opt_delete_options {}
        ;

opt_delete_option:
          QUICK        {}
        | LOW_PRIORITY
        {
        }
        | IGNORE_SYM   {}
        ;

truncate:
          TRUNCATE_SYM opt_table_sym
          {
          }
          table_name
          {
          }
        ;

opt_table_sym:
          /* empty */
        | TABLE_SYM
        ;

opt_profile_defs:
  /* empty */
  | profile_defs;

profile_defs:
  profile_def
  | profile_defs ',' profile_def;

profile_def:
  CPU_SYM
    {
    }
  | MEMORY_SYM
    {
    }
  | BLOCK_SYM IO_SYM
    {
    }
  | CONTEXT_SYM SWITCHES_SYM
    {
    }
  | PAGE_SYM FAULTS_SYM
    {
    }
  | IPC_SYM
    {
    }
  | SWAPS_SYM
    {
    }
  | SOURCE_SYM
    {
    }
  | ALL
    {
    }
  ;

opt_profile_args:
  /* empty */
    {
    }
  | FOR_SYM QUERY_SYM NUM
    {
    }
  ;

/* Show things */

show:
          SHOW
          {
          }
          show_param
        ;

show_param:
           DATABASES wild_and_where
           {
           }
         | opt_full TABLES opt_db wild_and_where
           {
           }
         | opt_full TRIGGERS_SYM opt_db wild_and_where
           {
           }
         | EVENTS_SYM opt_db wild_and_where
           {
           }
         | TABLE_SYM STATUS_SYM opt_db wild_and_where
           {
           }
        | OPEN_SYM TABLES opt_db wild_and_where
          {
          }
        | PLUGINS_SYM
          {
          }
        | ENGINE_SYM known_storage_engines show_engine_param
          {}
        | ENGINE_SYM ALL show_engine_param
          {}
        | opt_full COLUMNS from_or_in table_ident opt_db wild_and_where
          {
          }
        | master_or_binary LOGS_SYM
          {
          }
        | SLAVE HOSTS_SYM
          {
          }
        | BINLOG_SYM EVENTS_SYM binlog_in binlog_from
          {
          }
          opt_limit_clause
          {
          }
        | RELAYLOG_SYM EVENTS_SYM binlog_in binlog_from
          {
          }
          opt_limit_clause
          {
          }
        | keys_or_index         /* #1 */
          from_or_in            /* #2 */
          table_ident           /* #3 */
          opt_db                /* #4 */
          opt_where_clause      /* #5 */
          {
          }
        | opt_storage ENGINES_SYM
          {
          }
        | PRIVILEGES
          {
          }
        | COUNT_SYM '(' '*' ')' WARNINGS
          {
          }
        | COUNT_SYM '(' '*' ')' ERRORS
          {
          }
        | WARNINGS opt_limit_clause
          {
          }
        | ERRORS opt_limit_clause
          {
          }
        | PROFILES_SYM
          {
          }
        | PROFILE_SYM opt_profile_defs opt_profile_args opt_limit_clause
          {
          }
        | opt_var_type STATUS_SYM wild_and_where
          {
          }
        | opt_full PROCESSLIST_SYM
          {}
        | opt_var_type  VARIABLES wild_and_where
          {
          }
        | charset wild_and_where
          {
          }
        | COLLATION_SYM wild_and_where
          {
          }
        | GRANTS
          {
          }
        | GRANTS FOR_SYM user
          {
          }
        | CREATE DATABASE opt_if_not_exists ident
          {
          }
        | CREATE TABLE_SYM table_ident
          {
          }
        | CREATE VIEW_SYM table_ident
          {
          }
        | MASTER_SYM STATUS_SYM
          {
          }
        | SLAVE STATUS_SYM NONBLOCKING_SYM
          {
          }
        | SLAVE STATUS_SYM
          {
          }
        | CREATE PROCEDURE_SYM sp_name
          {
          }
        | CREATE FUNCTION_SYM sp_name
          {
          }
        | CREATE TRIGGER_SYM sp_name
          {
          }
        | PROCEDURE_SYM STATUS_SYM wild_and_where
          {
          }
        | FUNCTION_SYM STATUS_SYM wild_and_where
          {
          }
        | PROCEDURE_SYM CODE_SYM sp_name
          {
          }
        | FUNCTION_SYM CODE_SYM sp_name
          {
          }
        | CREATE EVENT_SYM sp_name
          {
          }
        ;

show_engine_param:
          STATUS_SYM
          {}
        | MUTEX_SYM
          {}
        | LOGS_SYM
          {}
        ;

master_or_binary:
          MASTER_SYM
        | BINARY
        ;

opt_storage:
          /* empty */
        | STORAGE_SYM
        ;

opt_db:
          /* empty */  {}
        | from_or_in ident {}
        ;

opt_full:
          /* empty */ {}
        | FULL        {}
        ;

from_or_in:
          FROM
        | IN_SYM
        ;

binlog_in:
          /* empty */            {}
        | IN_SYM TEXT_STRING_sys {}
        ;

binlog_from:
          /* empty */        {}
        | FROM ulonglong_num {}
        ;

wild_and_where:
          /* empty */
        | LIKE TEXT_STRING_sys
          {
          }
        | WHERE expr
          {
          }
        ;

/* A Oracle compatible synonym for show */
describe:
          describe_command table_ident
          {
          }
          opt_describe_column
          {
          }
        | describe_command opt_extended_describe
          {
          }
          explanable_command
        ;

explanable_command:
          select  {}
        | insert
        | replace
        | update
        | delete
        | FOR_SYM CONNECTION_SYM real_ulong_num
          {
          }
        ;

describe_command:
          DESC
        | DESCRIBE
        ;

opt_extended_describe:
          /* empty */
          {
          }
        | EXTENDED_SYM
          {
          }
        | PARTITIONS_SYM
          {
          }
        | FORMAT_SYM EQ ident_or_text
          {
          }
        ;

opt_describe_column:
          /* empty */ {}
        | text_string {}
        | ident
          {
          }
        ;


/* flush things */

flush:
          FLUSH_SYM opt_no_write_to_binlog
          {
          }
          flush_options
          {}
        ;

flush_options:
          table_or_tables
          {
          }
          opt_table_list {}
          opt_flush_lock {}
        | flush_options_list
        ;

opt_flush_lock:
          /* empty */ {}
        | WITH READ_SYM LOCK_SYM
          {
          }
        | FOR_SYM
          {
          }
          EXPORT_SYM
          {
          }
        ;

flush_options_list:
          flush_options_list ',' flush_option
        | flush_option
          {}
        ;

flush_option:
          ERROR_SYM LOGS_SYM
          {}
        | ENGINE_SYM LOGS_SYM
          {}
        | GENERAL LOGS_SYM
          {}
        | SLOW LOGS_SYM
          {}
        | BINARY LOGS_SYM
          {}
        | RELAY LOGS_SYM
          {}
        | QUERY_SYM CACHE_SYM
          {}
        | HOSTS_SYM
          {}
        | PRIVILEGES
          {}
        | LOGS_SYM
          {}
        | STATUS_SYM
          {}
        | DES_KEY_FILE
          {}
        | RESOURCES
          {}
        | OPTIMIZER_COSTS_SYM
          {}
        ;

opt_table_list:
          /* empty */  {}
        | table_list {}
        ;

reset:
          RESET_SYM
          {
          }
          reset_options
          {}
        ;

reset_options:
          reset_options ',' reset_option
        | reset_option
        ;

reset_option:
          SLAVE               {}
          slave_reset_options {}
        | MASTER_SYM          {}
        | QUERY_SYM CACHE_SYM {}
        ;

slave_reset_options:
          /* empty */ {}
        | ALL         {}
        ;

purge:
          PURGE
          {
          }
          purge_options
          {}
        ;

purge_options:
          master_or_binary LOGS_SYM purge_option
        ;

purge_option:
          TO_SYM TEXT_STRING_sys
          {
          }
        | BEFORE_SYM expr
          {
          }
        ;

/* kill threads */

kill:
          KILL_SYM kill_option expr
          {
          }
        ;

kill_option:
          /* empty */ {}
        | CONNECTION_SYM {}
        | QUERY_SYM      {}
        ;

/* change database */

use:
          USE_SYM ident
          {
          }
        ;

/* import, export of files */

load:
          LOAD data_or_xml
          {
          }
          load_data_lock opt_local INFILE TEXT_STRING_filesystem
          {
          }
          opt_duplicate INTO TABLE_SYM table_ident opt_use_partition
          {
          }
          opt_load_data_charset
          {}
          opt_xml_rows_identified_by
          opt_field_term opt_line_term opt_ignore_lines opt_field_or_var_spec
          opt_load_data_set_spec
          {
          }
          ;

data_or_xml:
        DATA_SYM  {}
        | XML_SYM {}
        ;

opt_local:
          /* empty */ {}
        | LOCAL_SYM {}
        ;

load_data_lock:
          /* empty */ {}
        | CONCURRENT  {}
        | LOW_PRIORITY {}
        ;

opt_duplicate:
          /* empty */ {}
        | REPLACE {}
        | IGNORE_SYM {}
        ;

opt_field_term:
          /* empty */             {}
        | COLUMNS field_term_list {}
        ;

field_term_list:
          field_term_list field_term
          {
          }
        | field_term
        ;

field_term:
          TERMINATED BY text_string
          {
          }
        | OPTIONALLY ENCLOSED BY text_string
          {
          }
        | ENCLOSED BY text_string
          {
          }
        | ESCAPED BY text_string
          {
          }
        ;

opt_line_term:
          /* empty */          {}
        | LINES line_term_list {}
        ;

line_term_list:
          line_term_list line_term
          {
          }
        | line_term
        ;

line_term:
          TERMINATED BY text_string
          {
          }
        | STARTING BY text_string
          {
          }
        ;

opt_xml_rows_identified_by:
        /* empty */ {}
        | ROWS_SYM IDENTIFIED_SYM BY text_string
          {};

opt_ignore_lines:
          /* empty */
        | IGNORE_SYM NUM lines_or_rows
          {
          }
        ;

lines_or_rows:
        LINES {}

        | ROWS_SYM {}
        ;

opt_field_or_var_spec:
          /* empty */ {}
        | '(' fields_or_vars ')' {}
        | '(' ')' {}
        ;

fields_or_vars:
          fields_or_vars ',' field_or_var
          {}
        | field_or_var
          {}
        ;

field_or_var:
          simple_ident_nospvar {}
        | '@' ident_or_text
          {
          }
        ;

opt_load_data_set_spec:
          /* empty */ {}
        | SET load_data_set_list {}
        ;

load_data_set_list:
          load_data_set_list ',' load_data_set_elem
        | load_data_set_elem
        ;

load_data_set_elem:
          simple_ident_nospvar equal expr_or_default
          {
          }
        ;

/* Common definitions */

text_literal:
          TEXT_STRING
          {
          }
        | NCHAR_STRING
          {
          }
        | UNDERSCORE_CHARSET TEXT_STRING
          {
          }
        | text_literal TEXT_STRING_literal
          {
          }
        ;

text_string:
          TEXT_STRING_literal
          {
          }
        | HEX_NUM
          {
          }
        | BIN_NUM
          {
          }
        ;

param_marker:
          PARAM_MARKER
          {
          }
        ;

signed_literal:
          literal {}
        | '+' NUM_literal {}
        | '-' NUM_literal
          {
          }
        ;


literal:
          text_literal {}
        | NUM_literal
        | temporal_literal
        | NULL_SYM
          {
          }
        | FALSE_SYM
          {
          }
        | TRUE_SYM
          {
          }
        | HEX_NUM
          {
          }
        | BIN_NUM
          {
          }
        | UNDERSCORE_CHARSET HEX_NUM
          {
          }
        | UNDERSCORE_CHARSET BIN_NUM
          {
          }
        ;

NUM_literal:
          NUM
          {
          }
        | LONG_NUM
          {
          }
        | ULONGLONG_NUM
          {
          }
        | DECIMAL_NUM
          {
          }
        | FLOAT_NUM
          {
          }
        ;


temporal_literal:
        DATE_SYM TEXT_STRING
          {
          }
        | TIME_SYM TEXT_STRING
          {
          }
        | TIMESTAMP TEXT_STRING
          {
          }
        ;




/**********************************************************************
** Creating different items.
**********************************************************************/

insert_ident:
          simple_ident_nospvar {}
        | table_wild           {}
        ;

table_wild:
          ident '.' '*'
          {
          }
        | ident '.' ident '.' '*'
          {
          }
        ;

order_expr:
          expr order_dir
          {
          }
        ;

simple_ident:
          ident
          {
            $$ = $1;
          }
        | simple_ident_q
        ;

simple_ident_nospvar:
          ident
          {
          }
        | simple_ident_q
        ;

simple_ident_q:
          ident '.' ident
          {
          }
        | '.' ident '.' ident
          {
          }
        | ident '.' ident '.' ident
          {
          }
        ;

field_ident:
          ident {}
        | ident '.' ident '.' ident
          {
          }
        | ident '.' ident
          {
          }
        | '.' ident {} /* For Delphi */
        ;

table_ident:
          ident
          {
            $$ = new DB_table(NULL, $1);
          }
        | ident '.' ident
          {
            $$ = new DB_table($1, $3);
          }
        | '.' ident
          {
          }
        ;

table_ident_opt_wild:
          ident opt_wild
          {
          }
        | ident '.' ident opt_wild
          {
          }
        ;

table_ident_nodb:
          ident
          {
          }
        ;

IDENT_sys:
          IDENT { $$ = $1;}
        | IDENT_QUOTED
          {
          }
        ;

TEXT_STRING_sys_nonewline:
          TEXT_STRING_sys
          {
          }
        ;

filter_wild_db_table_string:
          TEXT_STRING_sys_nonewline
          {
          }
        ;

TEXT_STRING_sys:
          TEXT_STRING
          {
          }
        ;

TEXT_STRING_literal:
          TEXT_STRING
          {
          }
        ;

TEXT_STRING_filesystem:
          TEXT_STRING
          {
          }
        ;

ident:
          IDENT_sys    { $$ = $1; }
        | keyword
          {
          }
        ;

label_ident:
          IDENT_sys    {}
        | keyword_sp
          {
          }
        ;

ident_or_text:
          ident           {}
        | TEXT_STRING_sys {}
        | LEX_HOSTNAME {}
        ;

user:
          ident_or_text
          {
          }
        | ident_or_text '@' ident_or_text
          {
          }
        | CURRENT_USER optional_braces
          {
          }
        ;

/* Keyword that we allow for identifiers (except SP labels) */
keyword:
          keyword_sp            {}
        | ASCII_SYM             {}
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
        | FOLLOWS_SYM           {}
        | FORMAT_SYM            {}
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
        | PORT_SYM              {}
        | PRECEDES_SYM          {}
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

/*
 * Keywords that we allow for labels in SPs.
 * Anything that's the beginning of a statement or characteristics
 * must be in keyword above, otherwise we get (harmful) shift/reduce
 * conflicts.
 */
keyword_sp:
          ACTION                   {}
        | ADDDATE_SYM              {}
        | AFTER_SYM                {}
        | AGAINST                  {}
        | AGGREGATE_SYM            {}
        | ALGORITHM_SYM            {}
        | ANALYSE_SYM              {}
        | ANY_SYM                  {}
        | AT_SYM                   {}
        | AUTO_INC                 {}
        | AUTOEXTEND_SIZE_SYM      {}
        | AVG_ROW_LENGTH           {}
        | AVG_SYM                  {}
        | BINLOG_SYM               {}
        | BIT_SYM                  {}
        | BLOCK_SYM                {}
        | BOOL_SYM                 {}
        | BOOLEAN_SYM              {}
        | BTREE_SYM                {}
        | CASCADED                 {}
        | CATALOG_NAME_SYM         {}
        | CHAIN_SYM                {}
        | CHANGED                  {}
        | CIPHER_SYM               {}
        | CLIENT_SYM               {}
        | CLASS_ORIGIN_SYM         {}
        | COALESCE                 {}
        | CODE_SYM                 {}
        | COLLATION_SYM            {}
        | COLUMN_NAME_SYM          {}
        | COLUMN_FORMAT_SYM        {}
        | COLUMNS                  {}
        | COMMITTED_SYM            {}
        | COMPACT_SYM              {}
        | COMPLETION_SYM           {}
        | COMPRESSED_SYM           {}
        | CONCURRENT               {}
        | CONNECTION_SYM           {}
        | CONSISTENT_SYM           {}
        | CONSTRAINT_CATALOG_SYM   {}
        | CONSTRAINT_SCHEMA_SYM    {}
        | CONSTRAINT_NAME_SYM      {}
        | CONTEXT_SYM              {}
        | CPU_SYM                  {}
        | CUBE_SYM                 {}
        /*
          Although a reserved keyword in SQL:2003 (and :2008),
          not reserved in MySQL per WL#2111 specification.
        */
        | CURRENT_SYM              {}
        | CURSOR_NAME_SYM          {}
        | DATA_SYM                 {}
        | DATAFILE_SYM             {}
        | DATETIME                 {}
        | DATE_SYM                 {}
        | DAY_SYM                  {}
        | DEFAULT_AUTH_SYM         {}
        | DEFINER_SYM              {}
        | DELAY_KEY_WRITE_SYM      {}
        | DES_KEY_FILE             {}
        | DIAGNOSTICS_SYM          {}
        | DIRECTORY_SYM            {}
        | DISABLE_SYM              {}
        | DISCARD                  {}
        | DISK_SYM                 {}
        | DUMPFILE                 {}
        | DUPLICATE_SYM            {}
        | DYNAMIC_SYM              {}
        | ENDS_SYM                 {}
        | ENUM                     {}
        | ENGINE_SYM               {}
        | ENGINES_SYM              {}
        | ERROR_SYM                {}
        | ERRORS                   {}
        | ESCAPE_SYM               {}
        | EVENT_SYM                {}
        | EVENTS_SYM               {}
        | EVERY_SYM                {}
        | EXCHANGE_SYM             {}
        | EXPANSION_SYM            {}
        | EXPIRE_SYM               {}
        | EXPORT_SYM               {}
        | EXTENDED_SYM             {}
        | EXTENT_SIZE_SYM          {}
        | FAULTS_SYM               {}
        | FAST_SYM                 {}
        | FOUND_SYM                {}
        | ENABLE_SYM               {}
        | FULL                     {}
        | FILE_SYM                 {}
        | FILTER_SYM               {}
        | FIRST_SYM                {}
        | FIXED_SYM                {}
        | GENERAL                  {}
        | GEOMETRY_SYM             {}
        | GEOMETRYCOLLECTION       {}
        | GET_FORMAT               {}
        | GRANTS                   {}
        | GLOBAL_SYM               {}
        | HASH_SYM                 {}
        | HOSTS_SYM                {}
        | HOUR_SYM                 {}
        | IDENTIFIED_SYM           {}
        | IGNORE_SERVER_IDS_SYM    {}
        | INVOKER_SYM              {}
        | IMPORT                   {}
        | INDEXES                  {}
        | INITIAL_SIZE_SYM         {}
        | IO_SYM                   {}
        | IPC_SYM                  {}
        | ISOLATION                {}
        | ISSUER_SYM               {}
        | INSERT_METHOD            {}
        | KEY_BLOCK_SIZE           {}
        | LAST_SYM                 {}
        | LEAVES                   {}
        | LESS_SYM                 {}
        | LEVEL_SYM                {}
        | LINESTRING               {}
        | LIST_SYM                 {}
        | LOCAL_SYM                {}
        | LOCKS_SYM                {}
        | LOGFILE_SYM              {}
        | LOGS_SYM                 {}
        | MAX_ROWS                 {}
        | MASTER_SYM               {}
        | MASTER_HEARTBEAT_PERIOD_SYM {}
        | MASTER_HOST_SYM          {}
        | MASTER_PORT_SYM          {}
        | MASTER_LOG_FILE_SYM      {}
        | MASTER_LOG_POS_SYM       {}
        | MASTER_USER_SYM          {}
        | MASTER_PASSWORD_SYM      {}
        | MASTER_SERVER_ID_SYM     {}
        | MASTER_CONNECT_RETRY_SYM {}
        | MASTER_RETRY_COUNT_SYM   {}
        | MASTER_DELAY_SYM         {}
        | MASTER_SSL_SYM           {}
        | MASTER_SSL_CA_SYM        {}
        | MASTER_SSL_CAPATH_SYM    {}
        | MASTER_SSL_CERT_SYM      {}
        | MASTER_SSL_CIPHER_SYM    {}
        | MASTER_SSL_CRL_SYM       {}
        | MASTER_SSL_CRLPATH_SYM   {}
        | MASTER_SSL_KEY_SYM       {}
        | MASTER_AUTO_POSITION_SYM {}
        | MAX_CONNECTIONS_PER_HOUR {}
        | MAX_QUERIES_PER_HOUR     {}
        | MAX_STATEMENT_TIME_SYM   {}
        | MAX_SIZE_SYM             {}
        | MAX_UPDATES_PER_HOUR     {}
        | MAX_USER_CONNECTIONS_SYM {}
        | MEDIUM_SYM               {}
        | MEMORY_SYM               {}
        | MERGE_SYM                {}
        | MESSAGE_TEXT_SYM         {}
        | MICROSECOND_SYM          {}
        | MIGRATE_SYM              {}
        | MINUTE_SYM               {}
        | MIN_ROWS                 {}
        | MODIFY_SYM               {}
        | MODE_SYM                 {}
        | MONTH_SYM                {}
        | MULTILINESTRING          {}
        | MULTIPOINT               {}
        | MULTIPOLYGON             {}
        | MUTEX_SYM                {}
        | MYSQL_ERRNO_SYM          {}
        | NAME_SYM                 {}
        | NAMES_SYM                {}
        | NATIONAL_SYM             {}
        | NCHAR_SYM                {}
        | NDBCLUSTER_SYM           {}
        | NEVER_SYM                {}
        | NEXT_SYM                 {}
        | NEW_SYM                  {}
        | NO_WAIT_SYM              {}
        | NODEGROUP_SYM            {}
        | NONE_SYM                 {}
        | NUMBER_SYM               {}
        | NVARCHAR_SYM             {}
        | OFFSET_SYM               {}
        | ONE_SYM                  {}
        | ONLY_SYM                 {}
        | PACK_KEYS_SYM            {}
        | PAGE_SYM                 {}
        | PARTIAL                  {}
        | PARTITIONING_SYM         {}
        | PARTITIONS_SYM           {}
        | PASSWORD                 {}
        | PHASE_SYM                {}
        | PLUGIN_DIR_SYM           {}
        | PLUGIN_SYM               {}
        | PLUGINS_SYM              {}
        | POINT_SYM                {}
        | POLYGON                  {}
        | PRESERVE_SYM             {}
        | PREV_SYM                 {}
        | PRIVILEGES               {}
        | PROCESS                  {}
        | PROCESSLIST_SYM          {}
        | PROFILE_SYM              {}
        | PROFILES_SYM             {}
        | PROXY_SYM                {}
        | QUARTER_SYM              {}
        | QUERY_SYM                {}
        | QUICK                    {}
        | READ_ONLY_SYM            {}
        | REBUILD_SYM              {}
        | RECOVER_SYM              {}
        | REDO_BUFFER_SIZE_SYM     {}
        | REDOFILE_SYM             {}
        | REDUNDANT_SYM            {}
        | RELAY                    {}
        | RELAYLOG_SYM             {}
        | RELAY_LOG_FILE_SYM       {}
        | RELAY_LOG_POS_SYM        {}
        | RELAY_THREAD             {}
        | RELOAD                   {}
        | REORGANIZE_SYM           {}
        | REPEATABLE_SYM           {}
        | REPLICATION              {}
        | REPLICATE_DO_DB          {}
        | REPLICATE_IGNORE_DB      {}
        | REPLICATE_DO_TABLE       {}
        | REPLICATE_IGNORE_TABLE   {}
        | REPLICATE_WILD_DO_TABLE  {}
        | REPLICATE_WILD_IGNORE_TABLE {}
        | REPLICATE_REWRITE_DB     {}
        | RESOURCES                {}
        | RESUME_SYM               {}
        | RETURNED_SQLSTATE_SYM    {}
        | RETURNS_SYM              {}
        | REVERSE_SYM              {}
        | ROLLUP_SYM               {}
        | ROUTINE_SYM              {}
        | ROWS_SYM                 {}
        | ROW_COUNT_SYM            {}
        | ROW_FORMAT_SYM           {}
        | ROW_SYM                  {}
        | RTREE_SYM                {}
        | SCHEDULE_SYM             {}
        | SCHEMA_NAME_SYM          {}
        | SECOND_SYM               {}
        | SERIAL_SYM               {}
        | SERIALIZABLE_SYM         {}
        | SESSION_SYM              {}
        | SIMPLE_SYM               {}
        | SHARE_SYM                {}
        | SHUTDOWN                 {}
        | SLOW                     {}
        | SNAPSHOT_SYM             {}
        | SOUNDS_SYM               {}
        | SOURCE_SYM               {}
        | SQL_AFTER_GTIDS          {}
        | SQL_AFTER_MTS_GAPS       {}
        | SQL_BEFORE_GTIDS         {}
        | SQL_CACHE_SYM            {}
        | SQL_BUFFER_RESULT        {}
        | SQL_NO_CACHE_SYM         {}
        | SQL_THREAD               {}
        | STACKED_SYM              {}
        | STARTS_SYM               {}
        | STATS_AUTO_RECALC_SYM    {}
        | STATS_PERSISTENT_SYM     {}
        | STATS_SAMPLE_PAGES_SYM   {}
        | STATUS_SYM               {}
        | STORAGE_SYM              {}
        | STRING_SYM               {}
        | SUBCLASS_ORIGIN_SYM      {}
        | SUBDATE_SYM              {}
        | SUBJECT_SYM              {}
        | SUBPARTITION_SYM         {}
        | SUBPARTITIONS_SYM        {}
        | SUPER_SYM                {}
        | SUSPEND_SYM              {}
        | SWAPS_SYM                {}
        | SWITCHES_SYM             {}
        | TABLE_NAME_SYM           {}
        | TABLES                   {}
        | TABLE_CHECKSUM_SYM       {}
        | TABLESPACE               {}
        | TEMPORARY                {}
        | TEMPTABLE_SYM            {}
        | TEXT_SYM                 {}
        | THAN_SYM                 {}
        | TRANSACTION_SYM          {}
        | TRIGGERS_SYM             {}
        | TIMESTAMP                {}
        | TIMESTAMP_ADD            {}
        | TIMESTAMP_DIFF           {}
        | TIME_SYM                 {}
        | TYPES_SYM                {}
        | TYPE_SYM                 {}
        | UDF_RETURNS_SYM          {}
        | FUNCTION_SYM             {}
        | UNCOMMITTED_SYM          {}
        | UNDEFINED_SYM            {}
        | UNDO_BUFFER_SIZE_SYM     {}
        | UNDOFILE_SYM             {}
        | UNKNOWN_SYM              {}
        | UNTIL_SYM                {}
        | USER                     {}
        | USE_FRM                  {}
        | VALIDATION_SYM           {}
        | VARIABLES                {}
        | VIEW_SYM                 {}
        | VALUE_SYM                {}
        | WARNINGS                 {}
        | WAIT_SYM                 {}
        | WEEK_SYM                 {}
        | WITHOUT_SYM              {}
        | WORK_SYM                 {}
        | WEIGHT_STRING_SYM        {}
        | X509_SYM                 {}
        | XID_SYM                  {}
        | XML_SYM                  {}
        | YEAR_SYM                 {}
        ;

/*
  SQLCOM_SET_OPTION statement.

  Note that to avoid shift/reduce conflicts, we have separate rules for the
  first option listed in the statement.
*/

set:
          SET start_option_value_list
          {
          }
        ;


// Start of option value list
start_option_value_list:
          option_value_no_option_type option_value_list_continued
          {
          }
        | TRANSACTION_SYM transaction_characteristics
          {
          }
        | option_type start_option_value_list_following_option_type
          {
          }
        | PASSWORD equal text_or_password
          {
          }
        | PASSWORD FOR_SYM user equal text_or_password
          {
          }
        ;


// Start of option value list, option_type was given
start_option_value_list_following_option_type:
          option_value_following_option_type option_value_list_continued
          {
          }
        | TRANSACTION_SYM transaction_characteristics
          {
          }
        ;

// Remainder of the option value list after first option value.
option_value_list_continued:
          /* empty */           {}
        | ',' option_value_list {}
        ;

// Repeating list of option values after first option value.
option_value_list:
          option_value
          {
          }
        | option_value_list ',' option_value
          {
          }
        ;

// Wrapper around option values following the first option value in the stmt.
option_value:
          option_type option_value_following_option_type
          {
          }
        | option_value_no_option_type {}
        ;

option_type:
          GLOBAL_SYM  {}
        | LOCAL_SYM   {}
        | SESSION_SYM {}
        ;

opt_var_type:
          /* empty */ {}
        | GLOBAL_SYM  {}
        | LOCAL_SYM   {}
        | SESSION_SYM {}
        ;

opt_var_ident_type:
          /* empty */     {}
        | GLOBAL_SYM '.'  {}
        | LOCAL_SYM '.'   {}
        | SESSION_SYM '.' {}
        ;

// Option values with preceeding option_type.
option_value_following_option_type:
          internal_variable_name equal set_expr_or_default
          {
          }
        ;

// Option values without preceeding option_type.
option_value_no_option_type:
          internal_variable_name        /*$1*/
          equal                         /*$2*/
          set_expr_or_default           /*$3*/
          {
          }
        | '@' ident_or_text equal expr
          {
          }
        | '@' '@' opt_var_ident_type internal_variable_name equal set_expr_or_default
          {
          }
        | charset old_or_new_charset_name_or_default
          {
          }
        | NAMES_SYM equal expr
          {
          }
        | NAMES_SYM charset_name_or_default opt_collate
          {
          }
        ;

internal_variable_name:
          ident
          {
          }
        | ident '.' ident
          {
          }
        | DEFAULT '.' ident
          {
          }
        ;

transaction_characteristics:
          transaction_access_mode opt_isolation_level
          {
          }
        | isolation_level opt_transaction_access_mode
          {
          }
        ;

transaction_access_mode:
          transaction_access_mode_types
          {
          }
        ;

opt_transaction_access_mode:
          /* empty */                 {}
        | ',' transaction_access_mode {}
        ;

isolation_level:
          ISOLATION LEVEL_SYM isolation_types
          {
          }
        ;

opt_isolation_level:
          /* empty */         {}
        | ',' isolation_level {}
        ;

transaction_access_mode_types:
          READ_SYM ONLY_SYM {}
        | READ_SYM WRITE_SYM {}
        ;

isolation_types:
          READ_SYM UNCOMMITTED_SYM {}
        | READ_SYM COMMITTED_SYM   {}
        | REPEATABLE_SYM READ_SYM  {}
        | SERIALIZABLE_SYM         {}
        ;

text_or_password:
          TEXT_STRING {}
        | PASSWORD '(' TEXT_STRING ')'
          {
          }
        ;


set_expr_or_default:
          expr
        | DEFAULT {}
        | ON
          {
          }
        | ALL
          {
          }
        | BINARY
          {
          }
        ;

/* Lock function */

lock:
          LOCK_SYM table_or_tables
          {
          }
          table_lock_list
          {}
        ;

table_or_tables:
          TABLE_SYM
        | TABLES
        ;

table_lock_list:
          table_lock
        | table_lock_list ',' table_lock
        ;

table_lock:
          table_ident opt_table_alias lock_option
          {
          }
        ;

lock_option:
          READ_SYM               {}
        | WRITE_SYM              {}
        | LOW_PRIORITY WRITE_SYM
          {
          }
        | READ_SYM LOCAL_SYM     {}
        ;

unlock:
          UNLOCK_SYM
          {
          }
          table_or_tables
          {}
        ;

/*
** Handler: direct access to ISAM functions
*/

handler:
          HANDLER_SYM table_ident OPEN_SYM opt_table_alias
          {
          }
        | HANDLER_SYM table_ident_nodb CLOSE_SYM
          {
          }
        | HANDLER_SYM           /* #1 */
          table_ident_nodb      /* #2 */
          READ_SYM              /* #3 */
          {
          }
          handler_read_or_scan  /* #5 */
          opt_where_clause      /* #6 */
          opt_limit_clause      /* #7 */
          {
          }
        ;

handler_read_or_scan:
          handler_scan_function       {}
        | ident handler_rkey_function {}
        ;

handler_scan_function:
          FIRST_SYM {}
        | NEXT_SYM  {}
        ;

handler_rkey_function:
          FIRST_SYM {}
        | NEXT_SYM  {}
        | PREV_SYM  {}
        | LAST_SYM  {}
        | handler_rkey_mode
          {
          }
          '(' values ')'
          {
          }
        ;

handler_rkey_mode:
          EQ     {}
        | GE     {}
        | LE     {}
        | GT_SYM {}
        | LT     {}
        ;

/* GRANT / REVOKE */

revoke:
          REVOKE clear_privileges {} revoke_command
          {}
        ;

revoke_command:
          grant_privileges ON opt_table grant_ident FROM grant_list
          {
          }
        | grant_privileges ON FUNCTION_SYM grant_ident FROM grant_list
          {
          }
        | grant_privileges ON PROCEDURE_SYM grant_ident FROM grant_list
          {
          }
        | ALL opt_privileges ',' GRANT OPTION FROM grant_list
          {
          }
        | PROXY_SYM ON user FROM grant_list
          {
          }
        ;

grant:
          GRANT clear_privileges {} grant_command
          {}
        ;

grant_command:
          grant_privileges ON opt_table grant_ident TO_SYM grant_list
          require_clause grant_options
          {
          }
        | grant_privileges ON FUNCTION_SYM grant_ident TO_SYM grant_list
          require_clause grant_options
          {
          }
        | grant_privileges ON PROCEDURE_SYM grant_ident TO_SYM grant_list
          require_clause grant_options
          {
          }
        | PROXY_SYM ON user TO_SYM grant_list opt_grant_option
          {
          }
        ;

opt_table:
          /* Empty */
        | TABLE_SYM
        ;

grant_privileges:
          object_privilege_list
          {
          }
        | ALL opt_privileges
          {
          }
        ;

opt_privileges:
          /* empty */
        | PRIVILEGES
        ;

object_privilege_list:
          object_privilege
        | object_privilege_list ',' object_privilege
        ;

object_privilege:
          SELECT_SYM
          {}
          opt_column_list {}
        | INSERT
          {}
          opt_column_list {}
        | UPDATE_SYM
          {}
          opt_column_list {}
        | REFERENCES
          {}
          opt_column_list {}
        | DELETE_SYM              {}
        | USAGE                   {}
        | INDEX_SYM               {}
        | ALTER                   {}
        | CREATE                  {}
        | DROP                    {}
        | EXECUTE_SYM             {}
        | RELOAD                  {}
        | SHUTDOWN                {}
        | PROCESS                 {}
        | FILE_SYM                {}
        | GRANT OPTION            {}
        | SHOW DATABASES          {}
        | SUPER_SYM               {}
        | CREATE TEMPORARY TABLES {}
        | LOCK_SYM TABLES         {}
        | REPLICATION SLAVE       {}
        | REPLICATION CLIENT_SYM  {}
        | CREATE VIEW_SYM         {}
        | SHOW VIEW_SYM           {}
        | CREATE ROUTINE_SYM      {}
        | ALTER ROUTINE_SYM       {}
        | CREATE USER             {}
        | EVENT_SYM               {}
        | TRIGGER_SYM             {}
        | CREATE TABLESPACE       {}
        ;

opt_and:
          /* empty */ {}
        | AND_SYM {}
        ;

require_list:
          require_list_element opt_and require_list
        | require_list_element
        ;

require_list_element:
          SUBJECT_SYM TEXT_STRING
          {
          }
        | ISSUER_SYM TEXT_STRING
          {
          }
        | CIPHER_SYM TEXT_STRING
          {
          }
        ;

grant_ident:
          '*'
          {
          }
        | ident '.' '*'
          {
          }
        | '*' '.' '*'
          {
          }
        | table_ident
          {
          }
        ;

user_list:
          user
          {
          }
        | user_list ',' user
          {
          }
        ;

grant_list:
          grant_user
          {
          }
        | grant_list ',' grant_user
          {
          }
        ;

grant_user:
          user IDENTIFIED_SYM BY TEXT_STRING
          {
          }
        | user IDENTIFIED_SYM BY PASSWORD TEXT_STRING
          {
          }
        | user IDENTIFIED_SYM WITH ident_or_text
          {
          }
        | user IDENTIFIED_SYM WITH ident_or_text AS TEXT_STRING_sys
          {
          }
        | user
          {
          }
        ;

opt_column_list:
          /* empty */
          {
          }
        | '(' column_list ')'
        ;

column_list:
          column_list ',' column_list_id
        | column_list_id
        ;

column_list_id:
          ident
          {
          }
        ;

require_clause:
          /* empty */
        | REQUIRE_SYM require_list
          {
          }
        | REQUIRE_SYM SSL_SYM
          {
          }
        | REQUIRE_SYM X509_SYM
          {
          }
        | REQUIRE_SYM NONE_SYM
          {
          }
        ;

grant_options:
          /* empty */ {}
        | WITH grant_option_list
        ;

opt_grant_option:
          /* empty */ {}
        | WITH GRANT OPTION {}
        ;

grant_option_list:
          grant_option_list grant_option {}
        | grant_option {}
        ;

grant_option:
          GRANT OPTION {}
        | MAX_QUERIES_PER_HOUR ulong_num
          {
          }
        | MAX_UPDATES_PER_HOUR ulong_num
          {
          }
        | MAX_CONNECTIONS_PER_HOUR ulong_num
          {
          }
        | MAX_USER_CONNECTIONS_SYM ulong_num
          {
          }
        ;

begin:
          BEGIN_SYM
          {
          }
          opt_work {}
        ;

opt_work:
          /* empty */ {}
        | WORK_SYM  {}
        ;

opt_chain:
          /* empty */
          {}
        | AND_SYM NO_SYM CHAIN_SYM {}
        | AND_SYM CHAIN_SYM        {}
        ;

opt_release:
          /* empty */
          {}
        | RELEASE_SYM        {}
        | NO_SYM RELEASE_SYM {}
;

opt_savepoint:
          /* empty */ {}
        | SAVEPOINT_SYM {}
        ;

commit:
          COMMIT_SYM opt_work opt_chain opt_release
          {
          }
        ;

rollback:
          ROLLBACK_SYM opt_work opt_chain opt_release
          {
          }
        | ROLLBACK_SYM opt_work
          TO_SYM opt_savepoint ident
          {
          }
        ;

savepoint:
          SAVEPOINT_SYM ident
          {
          }
        ;

release:
          RELEASE_SYM SAVEPOINT_SYM ident
          {
          }
        ;

/*
   UNIONS : glue selects together
*/


opt_union_clause:
          /* empty */ {}
        | union_list
        ;

union_list:
          UNION_SYM union_option select_init
          {
          }
        ;

union_opt:
          /* Empty */          {}
        | union_list           {}
        | union_order_or_limit {}
        ;

opt_union_order_or_limit:
          /* Empty */          {}
        | union_order_or_limit {}
        ;

union_order_or_limit:
          order_or_limit
          {
          }
        ;

order_or_limit:
          order_clause opt_limit_clause
          {
          }
        | limit_clause {}
        ;

union_option:
          /* empty */ {}
        | DISTINCT  {}
        | ALL       {}
        ;

query_specification:
          SELECT_SYM select_part2_derived table_expression
          {
          }
        | '(' select_paren_derived ')'
          opt_union_order_or_limit
          {
          }
        ;

query_expression_body:
          query_specification
        | query_expression_body UNION_SYM union_option query_specification
          {
          }
        ;

/* Corresponds to <query expression> in the SQL:2003 standard. */
subselect:
          {
          }
          query_expression_body
          {
          }
        ;

opt_query_spec_options:
          /* empty */ {}
        | query_spec_option_list
        ;

query_spec_option_list:
          query_spec_option_list query_spec_option
          {
          }
        | query_spec_option
        ;

query_spec_option:
          STRAIGHT_JOIN       {}
        | HIGH_PRIORITY       {}
        | DISTINCT            {}
        | SQL_SMALL_RESULT    {}
        | SQL_BIG_RESULT      {}
        | SQL_BUFFER_RESULT   {}
        | SQL_CALC_FOUND_ROWS {}
        | ALL                 {}
        ;

/**************************************************************************

 CREATE VIEW | TRIGGER | PROCEDURE statements.

**************************************************************************/

view_or_trigger_or_sp_or_event:
          definer definer_tail
          {}
        | no_definer no_definer_tail
          {}
        | view_replace_or_algorithm definer_opt view_tail
          {}
        ;

definer_tail:
          view_tail
        | trigger_tail
        | sp_tail
        | sf_tail
        | event_tail
        ;

no_definer_tail:
          view_tail
        | trigger_tail
        | sp_tail
        | sf_tail
        | udf_tail
        | event_tail
        ;

/**************************************************************************

 DEFINER clause support.

**************************************************************************/

definer_opt:
          no_definer
        | definer
        ;

no_definer:
          /* empty */
          {
          }
        ;

definer:
          DEFINER_SYM EQ user
          {
          }
        ;

/**************************************************************************

 CREATE VIEW statement parts.

**************************************************************************/

view_replace_or_algorithm:
          view_replace
          {}
        | view_replace view_algorithm
          {}
        | view_algorithm
          {}
        ;

view_replace:
          OR_SYM REPLACE
          {}
        ;

view_algorithm:
          ALGORITHM_SYM EQ UNDEFINED_SYM
          {}
        | ALGORITHM_SYM EQ MERGE_SYM
          {}
        | ALGORITHM_SYM EQ TEMPTABLE_SYM
          {}
        ;

view_suid:
          /* empty */
          {}
        | SQL_SYM SECURITY_SYM DEFINER_SYM
          {}
        | SQL_SYM SECURITY_SYM INVOKER_SYM
          {}
        ;

view_tail:
          view_suid VIEW_SYM table_ident
          {
          }
          view_list_opt AS view_select
        ;

view_list_opt:
          /* empty */
          {}
        | '(' view_list ')'
        ;

view_list:
          ident
            {
            }
        | view_list ',' ident
            {
            }
        ;

view_select:
          {
          }
          view_select_aux view_check_option
          {
          }
        ;

view_select_aux:
          create_view_select
          {
          }
          opt_union_clause
          {
          }
        | '(' create_view_select_paren ')' union_opt
          {
          }
        ;

create_view_select_paren:
          {
          }
          create_view_select
          {
          }
        | '(' create_view_select_paren ')'
        ;

create_view_select:
          SELECT_SYM
          {
          }
          select_part2
          {
          }
        ;

view_check_option:
          /* empty */
          {}
        | WITH CHECK_SYM OPTION
          {}
        | WITH CASCADED CHECK_SYM OPTION
          {}
        | WITH LOCAL_SYM CHECK_SYM OPTION
          {}
        ;

/**************************************************************************

 CREATE TRIGGER statement parts.

**************************************************************************/

trigger_action_order:
            FOLLOWS_SYM
            {}
          | PRECEDES_SYM
            {}
          ;

trigger_follows_precedes_clause:
            /* empty */
            {
            }
          |
            trigger_action_order ident_or_text
            {
            }
          ;

trigger_tail:
          TRIGGER_SYM       /* $1 */
          sp_name           /* $2 */
          trg_action_time   /* $3 */
          trg_event         /* $4 */
          ON                /* $5 */
          table_ident       /* $6 */
          FOR_SYM           /* $7 */
          EACH_SYM          /* $8 */
          ROW_SYM           /* $9 */
          trigger_follows_precedes_clause /* $10 */
          {
          }
          sp_proc_stmt /* $12 */
          {
          }
        ;

/**************************************************************************

 CREATE FUNCTION | PROCEDURE statements parts.

**************************************************************************/

udf_tail:
          AGGREGATE_SYM FUNCTION_SYM ident
          RETURNS_SYM udf_type SONAME_SYM TEXT_STRING_sys
          {
          }
        | FUNCTION_SYM ident
          RETURNS_SYM udf_type SONAME_SYM TEXT_STRING_sys
          {
          }
        ;

sf_tail:
          FUNCTION_SYM /* $1 */
          sp_name /* $2 */
          '(' /* $3 */
          {
          }
          sp_fdparam_list /* $5 */
          ')' /* $6 */
          {
          }
          RETURNS_SYM /* $8 */
          {
          }
          type_with_opt_collate /* $10 */
          {
          }
          sp_c_chistics /* $12 */
          {
          }
          sp_proc_stmt /* $14 */
          {
          }
        ;

sp_tail:
          PROCEDURE_SYM         /*$1*/
          sp_name               /*$2*/
          {
          }
          '('                   /*$4*/
          {
          }
          sp_pdparam_list       /*$6*/
          ')'                   /*$7*/
          {
          }
          sp_c_chistics         /*$9*/
          {
          }
          sp_proc_stmt          /*$11*/
          {
          }
        ;

/*************************************************************************/

xa:
          XA_SYM begin_or_start xid opt_join_or_resume
          {
          }
        | XA_SYM END xid opt_suspend
          {
          }
        | XA_SYM PREPARE_SYM xid
          {
          }
        | XA_SYM COMMIT_SYM xid opt_one_phase
          {
          }
        | XA_SYM ROLLBACK_SYM xid
          {
          }
        | XA_SYM RECOVER_SYM opt_convert_xid
          {
          }
        ;

opt_convert_xid:
          /* empty */ {}
         | CONVERT_SYM XID_SYM {}

xid:
          text_string
          {
          }
          | text_string ',' text_string
          {
          }
          | text_string ',' text_string ',' ulong_num
          {
          }
        ;

begin_or_start:
          BEGIN_SYM {}
        | START_SYM {}
        ;

opt_join_or_resume:
          /* nothing */ {}
        | JOIN_SYM      {}
        | RESUME_SYM    {}
        ;

opt_one_phase:
          /* nothing */     {}
        | ONE_SYM PHASE_SYM {}
        ;

opt_suspend:
          /* nothing */
          {}
        | SUSPEND_SYM
          {}
        | SUSPEND_SYM FOR_SYM MIGRATE_SYM
          {}
        ;

install:
          INSTALL_SYM PLUGIN_SYM ident SONAME_SYM TEXT_STRING_sys
          {
          }
        ;

uninstall:
          UNINSTALL_SYM PLUGIN_SYM ident
          {
          }
        ;

/**
  @} (end of group Parser)
*/
