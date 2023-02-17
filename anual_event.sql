SET GLOBAL event_scheduler= ON;

CREATE EVENT yearly_plus_exp
ON SCHEDULE EVERY 365 DAY
STARTS CURRENT_TIMESTAMP
DO CALL update_exp_plus_one();



