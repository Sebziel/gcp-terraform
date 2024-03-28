USE mydatabase;

CREATE TABLE IF NOT EXISTS orders (
    quantity INT,
    orderdate DATE,
    UUID VARCHAR(36),
    discount FLOAT
);

DROP PROCEDURE IF EXISTS InsertRandomData;

DELIMITER //

CREATE PROCEDURE InsertRandomData()
BEGIN
    DECLARE counter INT DEFAULT 0;
    
    -- Loop to insert random data
    WHILE counter < 5000 DO
        INSERT INTO orders (quantity, orderdate, UUID, discount)
            VALUES (
                FLOOR(RAND() * 100) + 1,
                DATE_ADD(NOW(), INTERVAL -FLOOR(RAND() * 365) DAY),
                UUID(),
                RAND() * 100 + 1
            );
        -- Increment counter
        SET counter = counter + 1;
    END WHILE;
END//

DELIMITER ;

CALL InsertRandomData();