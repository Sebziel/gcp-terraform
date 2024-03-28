USE mydatabase;

CREATE TABLE IF NOT EXISTS users (
    uuid CHAR(36) PRIMARY KEY,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone_number INT
);

INSERT INTO users (uuid, firstname, lastname, email, phone_number)
VALUES 
('11111111-1111-1111-1111-111111111111', 'BaseUserName1', 'BaseUserLastName1', 'BaseUserEmail1@example.com', '111111111'),
('22222222-2222-2222-2222-222222222222', 'BaseUserName2', 'BaseUserLastName2', 'BaseUserEmail2@example.com', '222222222'),
('33333333-3333-3333-3333-333333333333', 'BaseUserName3', 'BaseUserLastName3', 'BaseUserEmail3@example.com', '333333333'),
('44444444-4444-4444-4444-444444444444', 'BaseUserName4', 'BaseUserLastName4', 'BaseUserEmail4@example.com', '444444444'),
('55555555-5555-5555-5555-555555555555', 'BaseUserName5', 'BaseUserLastName5', 'BaseUserEmail5@example.com', '555555555');