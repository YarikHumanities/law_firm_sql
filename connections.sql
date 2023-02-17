ALTER TABLE deals
ADD FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
ADD FOREIGN KEY (lawyer_id) REFERENCES lawyers(lawyer_id) ON DELETE CASCADE;


ALTER TABLE current_deals
ADD FOREIGN KEY (deal_id) REFERENCES deals(deal_id) ON DELETE CASCADE;

ALTER TABLE current_deals
DROP FOREIGN KEY current_deals_ibfk_1;

ALTER TABLE archieved_deals
ADD FOREIGN KEY (deal_id) REFERENCES deals(deal_id) ON DELETE CASCADE;

ALTER TABLE current_deals
MODIFY deal_id INT UNIQUE;

ALTER TABLE archieved_deals
MODIFY deal_id INT UNIQUE;

ALTER TABLE main_connector
ADD FOREIGN KEY (deal_id) REFERENCES deals(deal_id) ON DELETE CASCADE,
ADD FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE,
ADD FOREIGN KEY (court_id) REFERENCES courts(court_id) ON DELETE CASCADE,
ADD FOREIGN KEY (judge_id) REFERENCES judges(judge_id) ON DELETE CASCADE,
ADD FOREIGN KEY (court_hearing_id) REFERENCES court_hearings(court_hearing_id) ON DELETE CASCADE;