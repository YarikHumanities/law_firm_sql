CREATE ROLE 
    law_dev, 
    law_read, 
    law_write;
    
GRANT ALL 
ON law_firm.* 
TO law_dev;

GRANT SELECT 
ON law_firm.* 
TO law_read;

GRANT INSERT, UPDATE, DELETE
ON law_firm.* 
TO law_write;

CREATE USER law_dev1@localhost IDENTIFIED BY 'Developer';
CREATE USER law_read1@localhost IDENTIFIED BY 'Reader';
CREATE USER law_write1@localhost IDENTIFIED BY 'Writer';


GRANT law_dev 
TO law_dev1@localhost;

GRANT law_read 
TO law_read1@localhost;

GRANT law_read, 
    law_write 
TO law_write1@localhost;

SHOW GRANTS
FOR law_dev1@localhost
USING law_dev;