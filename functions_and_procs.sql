-- update experience of lawyers and judges
DROP PROCEDURE IF EXISTS update_exp_plus_one;
DELIMITER //
CREATE PROCEDURE update_exp_plus_one()
BEGIN
UPDATE lawyers SET experience=experience+1;
UPDATE judges SET experience=experience+1;
END //
DELIMITER ;


-- move deal from current deals to archieve
DROP PROCEDURE IF EXISTS move_deal_to_archieve;
DELIMITER //
CREATE PROCEDURE move_deal_to_archieve(IN our_deal_id INT, IN our_result VARCHAR(100))   
BEGIN
INSERT INTO archieved_deals VALUE (NULL,our_deal_id,curdate(),our_result);
DELETE FROM current_deals WHERE deal_id=our_deal_id;
END //
DELIMITER ;

-- change staus of work of current deal
DROP PROCEDURE IF EXISTS change_status_of_curr_deal;
DELIMITER //
CREATE PROCEDURE change_status_of_curr_deal(IN our_deal_id INT, IN our_stage ENUM('A', 'B', 'C', 'D', 'E'))
BEGIN
UPDATE current_deals SET stage=our_stage WHERE deal_id=our_deal_id;
END // 
DELIMITER ;

-- get main info about chosen deal
DROP PROCEDURE IF EXISTS get_all_info_about_deal;
DELIMITER //
CREATE PROCEDURE get_all_info_about_deal(IN our_deal INT)
BEGIN

	SELECT  deals.deal_id AS 'Chosen deal ID', c_name AS 'Client name', main_connector.service_id AS 'ID of service', 
    services.s_name AS 'Service name', judges.j_name AS 'Judge name', courts.naming AS 'Title of court'
    FROM 
    clients INNER JOIN deals ON deals.deal_id=our_deal AND deals.client_id=clients.client_id
    INNER JOIN main_connector ON main_connector.deal_id =deals.deal_id
    INNER JOIN services ON main_connector.service_id=services.service_id
    LEFT JOIN judges ON main_connector.judge_id=judges.judge_id
    LEFT JOIN courts ON main_connector.court_id=courts.court_id;
    
END //
DELIMITER ;

-- get info about particular client
DROP PROCEDURE IF EXISTS get_all_info_about_client;
DELIMITER //
CREATE PROCEDURE get_all_info_about_client(IN our_client_id INT)
BEGIN
	SELECT clients.client_id AS 'Client ID', clients.c_name AS 'Name of client', 
    deals.deal_id AS 'Deals of client', main_connector.service_id AS 'Service ID of current deal', 
    services.s_name AS 'Service name', judges.j_name AS 'Judge name', courts.naming AS 'Title of court'
    FROM
		clients INNER JOIN deals ON clients.client_id=our_client_id AND clients.client_id = deals.client_id
		INNER JOIN main_connector ON main_connector.deal_id =deals.deal_id
		INNER JOIN services ON main_connector.service_id=services.service_id
		LEFT JOIN judges ON main_connector.judge_id=judges.judge_id
		LEFT JOIN courts ON main_connector.court_id=courts.court_id;
END //
DELIMITER ;

-- get info about particular lawyer
DROP PROCEDURE IF EXISTS get_all_info_about_lawyer;
DELIMITER //
CREATE PROCEDURE get_all_info_about_lawyer(IN our_lawyer_id INT)
BEGIN
	SELECT lawyers.lawyer_id AS 'Lawyer ID', lawyers.l_name AS 'Name of lawyer', 
    deals.deal_id AS 'All deals of lawyer', main_connector.service_id AS 'Service ID of current deal', 
    services.s_name AS 'Service name', judges.j_name AS 'Judge name', courts.naming AS 'Title of court'
    FROM
		lawyers INNER JOIN deals ON lawyers.lawyer_id=our_lawyer_id AND lawyers.lawyer_id = deals.lawyer_id
		INNER JOIN main_connector ON main_connector.deal_id =deals.deal_id
		INNER JOIN services ON main_connector.service_id=services.service_id
		LEFT JOIN judges ON main_connector.judge_id=judges.judge_id
		LEFT JOIN courts ON main_connector.court_id=courts.court_id;
END //
DELIMITER ;

-- stats of particular lawyer
DROP PROCEDURE IF EXISTS get_stats_of_lawyer;
DELIMITER //
CREATE PROCEDURE get_stats_of_lawyer(IN our_lawyer_id INT)
BEGIN
DECLARE succ INT;
DECLARE fail INT;

SELECT LA.lawyer_id AS 'Lawyer ID', LA.l_name AS 'Name of lawyer',
COUNT(CASE WHEN archieved_deals.result = 'Success' THEN 1 ELSE NULL END) AS 'Success',   
COUNT(CASE WHEN archieved_deals.result = 'Fail' THEN 1 ELSE NULL END) AS 'Failirue',
COUNT(*) AS 'All'
FROM 
 (SELECT * FROM lawyers WHERE lawyers.lawyer_id=our_lawyer_id ) AS LA
    INNER JOIN deals ON deals.lawyer_id=LA.lawyer_id
    INNER JOIN archieved_deals ON deals.deal_id=archieved_deals.deal_id;

END //
DELIMITER ;

-- count whole sum for deal
DROP FUNCTION IF EXISTS get_whole_deal_price;
DELIMITER //
CREATE FUNCTION get_whole_deal_price(our_deal_id INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
	DECLARE num DECIMAL(15, 2);
    DECLARE our_lawyer_id INT;
    DECLARE add_price INT;
    SELECT SUM(Price) AS 'Sum'  INTO num
 FROM 
	(
		 SELECT 
		deals.deal_id AS 'Deal_ID', main_connector.service_id AS 'Service_id', services.price AS 'Price'
    FROM 
		deals, main_connector, services 
	WHERE 
		deals.deal_id=main_connector.deal_id 
		AND main_connector.service_id = services.service_id
    ) as LA
 WHERE LA.Deal_ID=our_deal_id;
 
SELECT deals.lawyer_id INTO our_lawyer_id FROM deals WHERE deal_id = our_deal_id;

SELECT tarrif INTO add_price FROM lawyers WHERE lawyer_id=our_lawyer_id;
SET num=num+add_price;
RETURN num;
END //
DELIMITER ;

-- get all additional crucial info about particular deal
DROP PROCEDURE IF EXISTS additional_deal_info;
DELIMITER //
CREATE PROCEDURE additional_deal_info(IN our_deal_id INT)
BEGIN
SELECT  clients.c_name AS 'Name of client', clients.comment_ AS 'Comment about client', 
		lawyers.l_name AS 'Lawyer name', lawyers.comment_ AS 'Comment about lawyer',
		deals.comment_ AS 'Comment about deal',
		judges.j_name AS 'Name of judge', judges.comment_ AS 'Comment about judge',
		courts.naming AS 'Cout naming', courts.comment_ AS 'Court comment'
FROM
		deals INNER JOIN clients ON deals.deal_id=our_deal_id AND deals.client_id=clients.client_id
        INNER JOIN lawyers ON deals.lawyer_id=lawyers.lawyer_id
        INNER JOIN main_connector ON main_connector.deal_id = deals.deal_id
        LEFT JOIN judges ON main_connector.judge_id = judges.judge_id
        LEFT JOIN courts ON main_connector.court_id = courts.court_id;
END //
DELIMITER ;

-- regular customers
DROP PROCEDURE IF EXISTS get_regular_customer;
DELIMITER //
CREATE PROCEDURE get_regular_customer()
BEGIN
	SELECT clients.client_id AS 'Client ID', clients.c_name AS 'Client name', COUNT(deals.deal_id) AS 'Times_client_contact_us'
    FROM clients LEFT JOIN deals ON clients.client_id=deals.client_id
    GROUP BY clients.client_id ORDER BY Times_client_contact_us DESC;
END //
DELIMITER ;

-- the busiest lawyer
DROP FUNCTION IF EXISTS busiest_lawyer;
DELIMITER //
CREATE FUNCTION busiest_lawyer()
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE num INT;
SELECT la2.Law_ID INTO num FROM
(SELECT LA.lawyer_ID AS 'Law_ID', LA.lawyer_name, MAX(Count) 
FROM
(
SELECT lawyers.lawyer_id AS 'Lawyer_ID', lawyers.l_name AS 'Lawyer_name', COUNT(current_deals.deal_id) AS 'Count'
    FROM lawyers LEFT JOIN deals ON lawyers.lawyer_id=deals.lawyer_id
    LEFT JOIN current_deals ON deals.deal_id=current_deals.deal_id
    GROUP BY lawyers.lawyer_id ORDER BY Count DESC
    ) AS LA
   ) AS la2;
RETURN num;

END //
DELIMITER ;

-- stragnant deals
DROP PROCEDURE IF EXISTS stragnant_deals;
DELIMITER //
CREATE PROCEDURE stragnant_deals(IN days INT)
BEGIN
DECLARE fin_days INT;
SELECT current_deals.deal_id, date_of_start, lawyers.lawyer_id, stage FROM 
	current_deals 
    INNER JOIN deals ON current_deals.deal_id=deals.deal_id
    LEFT JOIN lawyers ON deals.lawyer_id=lawyers.lawyer_id WHERE DATEDIFF(curdate(), date_of_start)>=days; 
END //
DELIMITER ;

-- judge those hearings have fails the most
DROP PROCEDURE IF EXISTS hard_judges;
DELIMITER //
CREATE PROCEDURE hard_judges()
BEGIN
	SELECT judges.judge_id AS 'Judge ID', judges.j_name AS 'Judge name', COUNT(archieved_deals.deal_id) AS 'Times_of_fail'
    FROM judges LEFT JOIN main_connector ON main_connector.judge_id=judges.judge_id
    INNER JOIN archieved_deals ON main_connector.deal_id = archieved_deals.deal_id
    GROUP BY judges.judge_id ORDER BY Times_of_fail DESC;
END //
DELIMITER ;

-- similar fuction
DROP FUNCTION IF EXISTS hard_judges_func;
DELIMITER //
CREATE FUNCTION hard_judges_func()
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE num INT;
SELECT secondTab.Judge_ID INTO num FROM
(
SELECT firstTab.Judge_ID, MAX(Times_of_fail) FROM
	(
		SELECT judges.judge_id AS 'Judge_ID', judges.j_name AS 'Judge_name', COUNT(archieved_deals.deal_id) AS 'Times_of_fail'
		FROM judges LEFT JOIN main_connector ON main_connector.judge_id=judges.judge_id
		INNER JOIN archieved_deals ON main_connector.deal_id = archieved_deals.deal_id
		GROUP BY judges.judge_id ORDER BY Times_of_fail DESC
		) AS firstTab
    ) AS secondTab;
    
    RETURN num;
END //
DELIMITER ;

-- how much money get lawyers for all time
DROP PROCEDURE IF EXISTS profit_of_lawyer;
DELIMITER //
CREATE PROCEDURE profit_of_lawyer()
BEGIN
DECLARE add_profit INT;
DECLARE checker INT;  
DECLARE done INT DEFAULT 0;
DECLARE a, b INT;        -- a for deal_id, b for lawyer_id
DECLARE cur1 CURSOR FOR SELECT deal_id, lawyer_id FROM deals_of_lawyer;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

DROP VIEW IF EXISTS deals_of_lawyer;
CREATE VIEW deals_of_lawyer
AS
SELECT deals.deal_id, lawyers.lawyer_id FROM deals, lawyers WHERE deals.lawyer_id=lawyers.lawyer_id;

DROP TABLE IF EXISTS profitTable;
CREATE TEMPORARY TABLE profitTable
(
lawyer_id INT,
profit DECIMAL(15, 2)
);

 OPEN cur1;
 REPEAT
    FETCH cur1 INTO a, b;
    IF NOT done THEN
		-- SELECT COUNT(*) INTO checker FROM profitTable WHERE lawyer_id=b;
		-- IF (checker!=0) THEN
			
			-- UPDATE profitTable SET profit=profit+get_whole_deal_price(b) WHERE lawyer_id=b;
		-- ELSE 
			INSERT INTO profitTable VALUE(b, get_whole_deal_price(a));
		-- END IF;
    END IF;
UNTIL done END REPEAT;

CLOSE cur1;

SELECT lawyer_id, SUM(profit) AS 'Total' FROM profitTable GROUP BY lawyer_id;


-- SELECT * FROM deals_of_lawyer;
-- DROP TABLE profitTable;
END //
DELIMITER ;

-- add court hearing to particular deal
DROP PROCEDURE IF EXISTS add_hearing_to_deal;
DELIMITER //
CREATE PROCEDURE add_hearing_to_deal(IN our_deal_id INT, IN our_service_id INT, IN our_date DATE, IN our_comment VARCHAR(100))
BEGIN
DECLARE CUSTOM_EXCEPTION CONDITION FOR SQLSTATE '45000';
DECLARE needed_hearing INT;
DECLARE checker INT;
INSERT INTO court_hearings VALUE (NULL, our_date, our_comment);
SELECT MAX(court_hearing_id) INTO needed_hearing FROM court_hearings;
SELECT COUNT(*) INTO checker FROM main_connector WHERE deal_id=our_deal_id AND service_id=our_service_id AND judge_id IS NOT NULL AND court_id IS NOT NULL;
IF (checker!=0) THEN
	UPDATE main_connector SET court_hearing_id=needed_hearing WHERE deal_id=our_deal_id AND service_id=our_service_id;
ELSE
	DELETE FROM court_hearings WHERE court_hearing_id = needed_hearing;
    SIGNAL CUSTOM_EXCEPTION
    SET MESSAGE_TEXT = 'Not available';
END IF;

END //
DELIMITER ;

-- closest court hearings
DROP PROCEDURE IF EXISTS closest_hearings;
DELIMITER //
CREATE PROCEDURE closest_hearings(IN our_days INT)
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE a, c, d INT;        -- a for lawyer_id, b for lawyer name, c for deal id, d for  court_hearings.court_hearing_id, e for date
DECLARE b VARCHAR(60);
DECLARE e DATE;
DECLARE cur1 CURSOR FOR SELECT Lawyer_ID, Lawyer_Name, Deal_ID, Hearing, DateHear FROM lawyers_hearings;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

DROP VIEW IF EXISTS lawyers_hearings;
CREATE VIEW lawyers_hearings
AS 
SELECT lawyers.lawyer_id AS "Lawyer_ID", lawyers.l_name AS 'Lawyer_Name', deals.deal_id AS 'Deal_ID', main_connector.court_hearing_id AS 'MC_hear', court_hearings.court_hearing_id AS 'Hearing', court_hearings.hearing_date AS 'DateHear' FROM
lawyers INNER JOIN deals ON deals.lawyer_id=lawyers.lawyer_id
INNER JOIN main_connector ON main_connector.deal_id=deals.deal_id
INNER JOIN court_hearings ON main_connector.court_hearing_id= court_hearings.court_hearing_id;

DROP TABLE IF EXISTS tempTableForHearings;
CREATE TEMPORARY TABLE tempTableForHearings
(
lawyer_id INT,
lawyer_name VARCHAR(60),
deal_id INT,
courtHearing_id INT,
hearing_date DATE
);

OPEN cur1;
 REPEAT
    FETCH cur1 INTO a, b, c, d, e;
    IF NOT done THEN
    
		IF(DATEDIFF(e, curdate())<our_days) THEN
			INSERT INTO tempTableForHearings VALUE (a, b, c, d, e);
		END IF;
        
    END IF;
UNTIL done END REPEAT;

CLOSE cur1;

SELECT * FROM tempTableForHearings;

END //
DELIMITER ;

-- list of achieved and finished deals of client
DROP PROCEDURE IF EXISTS archieved_deals_of_client;
DELIMITER //
CREATE PROCEDURE archieved_deals_of_client(IN our_client INT)
BEGIN
SELECT clients.client_id AS 'Client_ID', clients.c_name AS 'Name_of_client', 
archieved_deals.deal_id AS 'Deal_ID', archieved_deals.date_of_finish AS 'Date_of_finish'
FROM clients INNER JOIN deals ON clients.client_id=our_client AND deals.client_id=clients.client_id
INNER JOIN archieved_deals ON archieved_deals.deal_id=deals.deal_id;
END //
DELIMITER ;

-- list of all current deals of particular lawyer
DROP PROCEDURE IF EXISTS curr_deals_of_lawyer;
DELIMITER //
CREATE PROCEDURE curr_deals_of_lawyer(IN our_lawyer INT)
BEGIN
SELECT 
	lawyers.lawyer_id AS 'Lawyer_ID', 
    lawyers.l_name AS 'Name_of_lawyer', 
    current_deals.deal_id AS 'Current_deal_ID', 
    current_deals.stage AS 'Stage'
FROM 
	lawyers INNER JOIN deals ON lawyers.lawyer_id=our_lawyer AND lawyers.lawyer_id=deals.lawyer_id
    INNER JOIN current_deals ON current_deals.deal_id = deals.deal_id;

END //
DELIMITER ;

-- which judge the particular lawyer faces the most
DROP FUNCTION IF EXISTS the_most_popular_judge_for_lawyer;
DELIMITER //
CREATE FUNCTION the_most_popular_judge_for_lawyer(our_lawyer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE num INT;
SELECT Judge_ID INTO num 
FROM
(
SELECT 
	lawyers.lawyer_id AS 'Lawyer_ID', deals.deal_id AS 'Deal_ID', main_connector.judge_id AS 'Judge_ID'
FROM
	lawyers INNER JOIN deals ON lawyers.lawyer_id=5 AND lawyers.lawyer_id=deals.lawyer_id
    INNER JOIN main_connector ON deals.deal_id=main_connector.deal_id AND 
    main_connector.judge_id IS NOT NULL 
    GROUP BY Judge_ID 
	ORDER BY Judge_ID ASC LIMIT 1) AS LA;
    RETURN num;
END //
DELIMITER ;

-- top of payable clients
DROP PROCEDURE IF EXISTS top_payable_clients;
DELIMITER //
CREATE PROCEDURE top_payable_clients()
BEGIN
DECLARE add_profit INT;
DECLARE checker INT;  
DECLARE done INT DEFAULT 0;
DECLARE a, b INT;        -- a for deal_id, b for client_id
DECLARE cur1 CURSOR FOR SELECT Deal_ID, Client_ID FROM deals_of_clients;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

DROP VIEW IF EXISTS deals_of_clients;
CREATE VIEW deals_of_clients
AS
SELECT deals.deal_id AS 'Deal_ID', clients.client_id 'Client_ID' FROM deals, clients WHERE deals.client_id=clients.client_id;

DROP TABLE IF EXISTS profitTable;
CREATE TEMPORARY TABLE profitTable
(
client_id INT,
money DECIMAL(15, 2)
);

 OPEN cur1;
 REPEAT
    FETCH cur1 INTO a, b;
    IF NOT done THEN
			INSERT INTO profitTable VALUE(b, get_whole_deal_price(a));
    END IF;
UNTIL done END REPEAT;
CLOSE cur1;
SELECT client_id, SUM(money) AS 'Total' FROM profitTable GROUP BY client_id ORDER BY Total DESC LIMIT 5;
END //
DELIMITER ;

-- clients whose deals was failed in some period
DROP PROCEDURE IF EXISTS clients_with_failed_deals_in_period;
DELIMITER //
CREATE PROCEDURE clients_with_failed_deals_in_period(IN first_date DATE, second_date DATE)
BEGIN 
SELECT 
	clients.client_id AS 'Client_ID', deals.deal_id AS 'Failed_deal_ID', archieved_deals.date_of_finish AS 'Date_of_end'
FROM
	clients INNER JOIN deals ON deals.client_id=clients.client_id
    INNER JOIN archieved_deals ON archieved_deals.deal_id=deals.deal_id 
							   AND archieved_deals.date_of_finish>=first_date 
                               AND archieved_deals.date_of_finish<=second_date;
END //
DELIMITER ;

-- give lawyers ratio
DROP PROCEDURE IF EXISTS rate_of_lawyers;
DELIMITER //
CREATE PROCEDURE rate_of_lawyers()
BEGIN
DECLARE checker INT;
DECLARE done INT DEFAULT 0;
DECLARE a, b INT;        
DECLARE c VARCHAR(60);
DECLARE cur1 CURSOR FOR SELECT Lawyer_ID, Deal_ID, Result FROM tempRateTable;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

DROP VIEW IF EXISTS tempRateTable;
CREATE VIEW tempRateTable AS 
SELECT 
	lawyers.lawyer_id AS 'Lawyer_ID', deals.deal_id AS 'Deal_ID', archieved_deals.result AS 'Result' 
FROM
	lawyers INNER JOIN deals ON deals.lawyer_id=lawyers.lawyer_id
    INNER JOIN archieved_deals ON deals.deal_id=archieved_deals.deal_id;
    
DROP TABLE IF EXISTS rateTable;
CREATE TEMPORARY TABLE rateTable
(
lawyer_id INT,
num_of_suc INT,
num_of_fail INT,
num_all INT
-- ratio FLOAT
);

 OPEN cur1;
 REPEAT
    FETCH cur1 INTO a, b, c;
    IF NOT done THEN
			SELECT COUNT(*) INTO checker FROM rateTable WHERE lawyer_id=a;
            IF (checker=0) THEN
			INSERT INTO rateTable VALUE (a, 0, 0, 0);
            END IF;
            IF(c='Success') THEN
				UPDATE rateTable SET num_of_suc=num_of_suc+1 WHERE lawyer_id=a;
                UPDATE rateTable SET num_all=num_all +1 WHERE lawyer_id=a;
            END IF;
            IF(c='Fail') THEN
				UPDATE rateTable SET num_of_fail=num_of_fail+1 WHERE lawyer_id=a;
                UPDATE rateTable SET num_all=num_all +1 WHERE lawyer_id=a;
            END IF;
    END IF;
UNTIL done END REPEAT;
CLOSE cur1;
    
    SELECT 
		lawyer_id AS 'Lawyer_ID', num_of_suc AS 'Success', num_of_fail AS 'Fail', num_all AS 'All', num_of_suc/num_all AS 'Ratio'
	FROM rateTable ORDER BY Ratio DESC;
		
END //
DELIMITER ;