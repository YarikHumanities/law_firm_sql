ALTER TABLE deals DROP INDEX first_index;
ALTER TABLE lawyers DROP INDEX first_lawyers_index;

CREATE INDEX first_index ON deals(complexity, total_price, comment_);
CREATE INDEX first_lawyers_index ON lawyers(birth_date, experience, phone, comment_, tarrif);

SELECT  deals.deal_id AS 'Chosen deal ID', c_name AS 'Client name', main_connector.service_id AS 'ID of service', 
    services.s_name AS 'Service name', judges.j_name AS 'Judge name', courts.naming AS 'Title of court'
    FROM 
    clients INNER JOIN deals ON deals.deal_id=4 AND deals.client_id=clients.client_id
    INNER JOIN main_connector ON main_connector.deal_id =deals.deal_id
    INNER JOIN services ON main_connector.service_id=services.service_id
    LEFT JOIN judges ON main_connector.judge_id=judges.judge_id
    LEFT JOIN courts ON main_connector.court_id=courts.court_id;
    
    
    
ALTER TABLE archieved_deals DROP INDEX first_arch_deals;

CREATE INDEX first_arch_deals ON archieved_deals(date_of_finish, result);
    SELECT LA.lawyer_id AS 'Lawyer ID', LA.l_name AS 'Name of lawyer',
COUNT(CASE WHEN archieved_deals.result = 'Success' THEN 1 ELSE NULL END) AS 'Success',   
COUNT(CASE WHEN archieved_deals.result = 'Fail' THEN 1 ELSE NULL END) AS 'Failirue',
COUNT(*) AS 'All'
FROM 
 (SELECT * FROM lawyers WHERE lawyers.lawyer_id=5 ) AS LA
    INNER JOIN deals ON deals.lawyer_id=LA.lawyer_id
    INNER JOIN archieved_deals ON deals.deal_id=archieved_deals.deal_id;
    
    

 SELECT SUM(Price) AS 'Sum'
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
 WHERE LA.Deal_ID=4;
 
 ALTER TABLE clients DROP INDEX first_index_client;
 CREATE INDEX first_index_client ON clients(client_id, c_name, birth_date, activity, phone, place_of_residence, comment_);
 SELECT clients.client_id AS 'Client ID', clients.c_name AS 'Client name', COUNT(deals.deal_id) AS 'Times_client_contact_us'
    FROM clients LEFT JOIN deals ON clients.client_id=deals.client_id
    GROUP BY clients.client_id ORDER BY Times_client_contact_us DESC;
    

ALTER TABLE lawyers DROP first_lawyer_index;
CREATE INDEX first_lawyer_index ON lawyers(lawyer_id, l_name, birth_date, experience, phone, comment_, tarrif);
SELECT la2.Law_ID FROM
(SELECT LA.lawyer_ID AS 'Law_ID', LA.lawyer_name, MAX(Count) 
FROM
(
SELECT lawyers.lawyer_id AS 'Lawyer_ID', lawyers.l_name AS 'Lawyer_name', COUNT(current_deals.deal_id) AS 'Count'
    FROM lawyers LEFT JOIN deals ON lawyers.lawyer_id=deals.lawyer_id
    LEFT JOIN current_deals ON deals.deal_id=current_deals.deal_id
    GROUP BY lawyers.lawyer_id ORDER BY Count DESC
    ) AS LA
   ) AS la2;

 
 
 CREATE INDEX first_curr_deal_index ON current_deals(deal_id);
 SELECT current_deals.deal_id, date_of_start, lawyers.lawyer_id, stage FROM 
	current_deals 
    INNER JOIN deals ON current_deals.deal_id=deals.deal_id
    LEFT JOIN lawyers ON deals.lawyer_id=lawyers.lawyer_id WHERE DATEDIFF(curdate(), date_of_start)>=1; 
    
    

 SELECT judges.judge_id AS 'Judge ID', judges.j_name AS 'Judge name', COUNT(archieved_deals.deal_id) AS 'Times_of_fail'
    FROM judges LEFT JOIN main_connector ON main_connector.judge_id=judges.judge_id
    INNER JOIN archieved_deals ON main_connector.deal_id = archieved_deals.deal_id
    GROUP BY judges.judge_id ORDER BY Times_of_fail DESC;