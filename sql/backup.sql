create table smuggling_backup as
select *
from smuggling;

SELECT COUNT(*) FROM smuggling;
SELECT COUNT(*) FROM smuggling_backup;

CREATE TABLE smuggling_import LIKE smuggling;

DESCRIBE smuggling_import;