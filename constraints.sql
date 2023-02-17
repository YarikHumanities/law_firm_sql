ALTER TABLE lawyers
ADD CHECK(age>=18),
ADD CHECK(age-experience>=18);
ALTER TABLE lawyers DROP CHECK lawyers_chk_2;
ALTER TABLE lawyers DROP CHECK lawyers_chk_1;
ALTER TABLE lawyers DROP CHECK lawyers_chk_3;
ALTER TABLE lawyers DROP CHECK lawyers_chk_4;
ALTER TABLE lawyers DROP CHECK lawyers_chk_5;
ALTER TABLE lawyers DROP CHECK lawyers_chk_6;
ALTER TABLE clients DROP CHECK clients_chk_1;
ALTER TABLE clients DROP CONSTRAINT upper_case;
ALTER TABLE clients DROP CONSTRAINT upper_case2;
ALTER TABLE judges DROP CHECK judges_chk_1;
ALTER TABLE judges DROP CHECK judges_chk_2;
ALTER TABLE courts DROP CHECK courts_chk_1;
ALTER TABLE courts DROP CHECK courts_chk_2;
ALTER TABLE lawyers
ADD CHECK(phone REGEXP '^\+?3?8?(0(66|95|99)\d{7})$');
ALTER TABLE clients
ADD CHECK(phone REGEXP '^\+?3?8?(0(66|95|99)\d{7})$');
-- ALTER TABLE lawyers
-- ADD column birth_date DATE AFTER l_name;
ALTER TABLE judges
ADD CHECK(phone REGEXP '^\+?3?8?(0(66|95|99)\d{7})$');
ALTER TABLE clients 
ADD CONSTRAINT upper_case CHECK (c_name REGEXP '^[A_Z]');
ALTER TABLE clients 
ADD CONSTRAINT upper_case2 CHECK (place_of_residence REGEXP '^[A_Z]');
ALTER TABLE lawyers 
ADD CHECK (l_name REGEXP '^[A_Z]');
ALTER TABLE judges 
ADD CHECK (j_name REGEXP '^[A_Z]');
ALTER TABLE courts 
ADD CHECK (naming REGEXP '^[A_Z]');
-- ALTER TABLE lawyers
-- MODIFY age INT;



-- -------------------------------
-- a few more constraints were implemented via triggers die to some situations and circumstances
ALTER TABLE judges
ADD CONSTRAINT upper_case_judges CHECK(j_name REGEXP '^[A-Z]');

ALTER TABLE clients
ADD CONSTRAINT upper_case_clients CHECK(c_name REGEXP '^[A-Z]');

ALTER TABLE lawyers
ADD CONSTRAINT upper_case_lawyers CHECK(l_name REGEXP '^[A-Z]');

ALTER TABLE clients
ADD CONSTRAINT upper_case_clients_place CHECK(place_of_residence REGEXP '^[A-Z]');

ALTER TABLE lawyers
ADD CONSTRAINT exp_check CHECK(experience>=0);

ALTER TABLE judges
ADD CONSTRAINT exp_check_judge CHECK(experience>=0);

ALTER TABLE lawyers
ADD CONSTRAINT tarrif_check CHECK(tarrif>=0);

ALTER TABLE services
ADD CONSTRAINT price_check CHECK(price>0);