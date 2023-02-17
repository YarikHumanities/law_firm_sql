CALL move_deal_to_archieve(1, 'Success');

CALL change_status_of_curr_deal(2, 'D');
CALL change_status_of_curr_deal(4, 'C');

CALL get_all_info_about_deal(4);

CALL get_all_info_about_client(9);

CALL get_all_info_about_lawyer(5);

CALL get_stats_of_lawyer(5);

SELECT get_whole_deal_price(2) AS 'Sum of deal';


CALL additional_deal_info(4);

CALL get_regular_customer();

SELECT busiest_lawyer() AS 'Busiest Lawyer ID';

CALL stragnant_deals(1);

CALL hard_judges();

SELECT hard_judges_func() AS 'The hasdest judge';


CALL profit_of_lawyer();

CALL add_hearing_to_deal(4, 2, '2022-01-10', 'aaa'); -- error
CALL add_hearing_to_deal(4, 10, '2022-01-10', 'aaa');
CALL add_hearing_to_deal(4, 5, '2022-01-22', 'bbb'); -- error
CALL add_hearing_to_deal(4, 1, '2022-01-22', 'bbb');
CALL add_hearing_to_deal(4, 7, '2022-01-22', 'bbb'); -- error
CALL add_hearing_to_deal(1, 9, '2022-01-07', 'ccc');


CALL closest_hearings(23);

CALL archieved_deals_of_client(16);

CALL curr_deals_of_lawyer(5);

SELECT the_most_popular_judge_for_lawyer(5) AS 'The most common judge for your lawyer he/she faces';

CALL top_payable_clients();

CALL clients_with_failed_deals_in_period('2021-12-05', '2022-01-10');

    -- CALL move_deal_to_archieve(4, 'Success');
    -- CALL move_deal_to_archieve(11, 'Fail');
    
CALL rate_of_lawyers();