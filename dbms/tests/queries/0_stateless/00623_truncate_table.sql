DROP DATABASE IF EXISTS truncate_test;
DROP TABLE IF EXISTS truncate_test.test_log;
DROP TABLE IF EXISTS truncate_test.test_memory;
DROP TABLE IF EXISTS truncate_test.test_tiny_log;
DROP TABLE IF EXISTS truncate_test.test_stripe_log;
DROP TABLE IF EXISTS truncate_test.test_merge_tree;
DROP TABLE IF EXISTS truncate_test.test_materialized_view;
DROP TABLE IF EXISTS truncate_test.test_materialized_depend;
DROP TABLE IF EXISTS truncate_test.test_distributed_depend;
DROP TABLE IF EXISTS truncate_test.test_distributed;

CREATE DATABASE truncate_test;
CREATE TABLE truncate_test.test_set(id UInt64) ENGINE = Set;
CREATE TABLE truncate_test.test_log(id UInt64) ENGINE = Log;
CREATE TABLE truncate_test.test_memory(id UInt64) ENGINE = Memory;
CREATE TABLE truncate_test.test_tiny_log(id UInt64) ENGINE = TinyLog;
CREATE TABLE truncate_test.test_stripe_log(id UInt64) ENGINE = StripeLog;
CREATE TABLE truncate_test.test_merge_tree(p Date, k UInt64) ENGINE = MergeTree(p, k, 1);
CREATE TABLE truncate_test.test_materialized_depend(p Date, k UInt64) ENGINE = Null;
CREATE MATERIALIZED VIEW truncate_test.test_materialized_view ENGINE = MergeTree(p, k, 1) AS SELECT * FROM truncate_test.test_materialized_depend;
CREATE TABLE truncate_test.test_distributed_depend (x UInt64, s String) ENGINE = MergeTree ORDER BY x;
CREATE TABLE truncate_test.test_distributed AS truncate_test.test_distributed_depend ENGINE = Distributed(test_shard_localhost, truncate_test, test_distributed_depend);

SELECT '======Before Truncate======';
INSERT INTO truncate_test.test_set VALUES(0);
INSERT INTO truncate_test.test_log VALUES(1);
INSERT INTO truncate_test.test_memory VALUES(1);
INSERT INTO truncate_test.test_tiny_log VALUES(1);
INSERT INTO truncate_test.test_stripe_log VALUES(1);
INSERT INTO truncate_test.test_merge_tree VALUES('2000-01-01', 1);
INSERT INTO truncate_test.test_materialized_depend VALUES('2000-01-01', 1);
INSERT INTO truncate_test.test_distributed_depend VALUES (1, 'hello');
SELECT * FROM system.numbers WHERE number NOT IN truncate_test.test_set LIMIT 1;
SELECT * FROM truncate_test.test_log;
SELECT * FROM truncate_test.test_memory;
SELECT * FROM truncate_test.test_tiny_log;
SELECT * FROM truncate_test.test_stripe_log;
SELECT * FROM truncate_test.test_merge_tree;
SELECT * FROM truncate_test.test_materialized_view;
SELECT * FROM truncate_test.test_distributed;

SELECT '======After Truncate And Empty======';
TRUNCATE TABLE truncate_test.test_set;
TRUNCATE TABLE truncate_test.test_log;
TRUNCATE TABLE truncate_test.test_memory;
TRUNCATE TABLE truncate_test.test_tiny_log;
TRUNCATE TABLE truncate_test.test_stripe_log;
TRUNCATE TABLE truncate_test.test_merge_tree;
TRUNCATE TABLE truncate_test.test_materialized_view;
TRUNCATE TABLE truncate_test.test_distributed;
SELECT * FROM system.numbers WHERE number NOT IN truncate_test.test_set LIMIT 1;
SELECT * FROM truncate_test.test_log;
SELECT * FROM truncate_test.test_memory;
SELECT * FROM truncate_test.test_tiny_log;
SELECT * FROM truncate_test.test_stripe_log;
SELECT * FROM truncate_test.test_merge_tree;
SELECT * FROM truncate_test.test_materialized_view;
SELECT * FROM truncate_test.test_distributed;

SELECT '======After Truncate And Insert Data======';
INSERT INTO truncate_test.test_set VALUES(0);
INSERT INTO truncate_test.test_log VALUES(1);
INSERT INTO truncate_test.test_memory VALUES(1);
INSERT INTO truncate_test.test_tiny_log VALUES(1);
INSERT INTO truncate_test.test_stripe_log VALUES(1);
INSERT INTO truncate_test.test_merge_tree VALUES('2000-01-01', 1);
INSERT INTO truncate_test.test_materialized_depend VALUES('2000-01-01', 1);
INSERT INTO truncate_test.test_distributed_depend VALUES (1, 'hello');
SELECT * FROM system.numbers WHERE number NOT IN truncate_test.test_set LIMIT 1;
SELECT * FROM truncate_test.test_log;
SELECT * FROM truncate_test.test_memory;
SELECT * FROM truncate_test.test_tiny_log;
SELECT * FROM truncate_test.test_stripe_log;
SELECT * FROM truncate_test.test_merge_tree;
SELECT * FROM truncate_test.test_materialized_view;
SELECT * FROM truncate_test.test_distributed;

DROP TABLE IF EXISTS truncate_test.test_set;
DROP TABLE IF EXISTS truncate_test.test_log;
DROP TABLE IF EXISTS truncate_test.test_memory;
DROP TABLE IF EXISTS truncate_test.test_tiny_log;
DROP TABLE IF EXISTS truncate_test.test_stripe_log;
DROP TABLE IF EXISTS truncate_test.test_merge_tree;
DROP TABLE IF EXISTS truncate_test.test_materialized_view;
DROP TABLE IF EXISTS truncate_test.test_materialized_depend;
DROP TABLE IF EXISTS truncate_test.test_distributed;
DROP TABLE IF EXISTS truncate_test.test_distributed_depend;
DROP DATABASE IF EXISTS truncate_test;
