CREATE TABLE clients(
client_id int NOT NULL auto_increment PRIMARY KEY,
c_name VARCHAR(60) NOT NULL,
birth_date DATE,
activity VARCHAR(60),
phone VARCHAR(15),
place_of_residence VARCHAR(60),
comment_ VARCHAR (100)
);

CREATE TABLE lawyers(
lawyer_id INT NOT NULL auto_increment PRIMARY KEY,
l_name VARCHAR(60) NOT NULL,
age INT NOT NULL,
experience INT NOT NULL,
phone VARCHAR(15) NOT NULL,
comment_ VARCHAR(100),
tarrif INT NOT NULL
);

CREATE TABLE deals(
deal_id int NOT NULL auto_increment PRIMARY KEY,
client_id INT NOT NULL,
lawyer_id INT NOT NULL,
complexity ENUM('green', 'yellow', 'orange', 'red', 'extra red'),
total_price DECIMAL(15, 2),
comment_ VARCHAR(100)
);

CREATE TABLE current_deals(
curr_deal_id int NOT NULL auto_increment PRIMARY KEY,
deal_id INT NOT NULL,
date_of_start DATE,
stage ENUM('A', 'B', 'C', 'D', 'E')
);

CREATE TABLE archieved_deals(
arch_deal_id int NOT NULL auto_increment PRIMARY KEY,
deal_id INT NOT NULL,
date_of_finish DATE,
result VARCHAR(60) NOT NULL
);

CREATE TABLE judges(
judge_id int NOT NULL auto_increment PRIMARY KEY,
j_name VARCHAR(60) NOT NULL,
birth_date DATE,
experience INT,
phone VARCHAR(15),
comment_ VARCHAR(100)
);

CREATE TABLE courts(
court_id int NOT NULL auto_increment PRIMARY KEY,
naming VARCHAR(60) NOT NULL,
address VARCHAR(60),
comment_ VARCHAR(100)
);

CREATE TABLE court_hearings(
court_hearing_id int NOT NULL auto_increment PRIMARY KEY,
hearing_date DATE NOT NULL,
comment_ VARCHAR(100)
);

CREATE TABLE services(
service_id int NOT NULL auto_increment PRIMARY KEY,
s_name VARCHAR(60) NOT NULL,
s_description VARCHAR(100) NOT NULL,
price DECIMAL(15, 2)
);

CREATE TABLE main_connector(
connection_id int NOT NULL auto_increment PRIMARY KEY,
deal_id INT NOT NULL,
service_id INT NOT NULL,
court_id INT NOT NULL,
judge_id INT NOT NULL,
court_hearing_id INT
);