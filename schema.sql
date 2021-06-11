


CREATE DATABASE IF NOT EXISTS inventory CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

use inventory;

-- ////////////////////////////////////////////////////////////TABLES

create   table IF NOT EXISTS hibernate_sequence (next_val bigint) engine=InnoDB;
insert into hibernate_sequence values ( 1 );

CREATE TABLE IF NOT EXISTS user_account (
                                            id BIGINT NOT NULL,
                                            creation_date TIMESTAMP,
                                            is_account_non_expired BOOLEAN,
                                            is_account_non_locked BOOLEAN,
                                            is_credentials_non_expired BOOLEAN,
                                            is_enabled BOOLEAN,
                                            modified_date TIMESTAMP,
                                            password VARCHAR(255),
                                            user_roles VARCHAR(255),
                                            username VARCHAR(255) unique,
                                            PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS supplier (
                                        id VARCHAR(36) NOT NULL,
                                        address VARCHAR(255),
                                        created_date TIMESTAMP,
                                        first_name VARCHAR(255),
                                        last_name VARCHAR(255),
                                        modified_date TIMESTAMP,
                                        PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS activity (
                                        id BIGINT NOT NULL,
                                        created TIMESTAMP,
                                        last_updated TIMESTAMP,
                                        entity VARCHAR(255),
                                        expires VARCHAR(255),
                                        ip VARCHAR(255),
                                        parameter VARCHAR(255),
                                        request_method VARCHAR(255),
                                        response_status INTEGER,
                                        url VARCHAR(255),
                                        user_agent VARCHAR(255),
                                        user_id BIGINT,
                                        PRIMARY KEY (id),
                                        foreign key (user_id) references user_account(id)
);
CREATE TABLE IF NOT EXISTS customer (
                                        id VARCHAR(36) NOT NULL,
                                        address VARCHAR(255),
                                        created_date TIMESTAMP,
                                        first_name VARCHAR(255),
                                        last_name VARCHAR(255),
                                        modified_date TIMESTAMP,
                                        PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS product (
                                       id VARCHAR(36) NOT NULL,
                                       created_date TIMESTAMP,
                                       modified_date TIMESTAMP,
                                       name VARCHAR(255),
                                       price DECIMAL(19 , 2 ),
                                       sale_price DECIMAL(19 , 2 ),
                                       description VARCHAR(255),
                                       image_available boolean default false,
                                       PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS purchase_invoice (
                                                id VARCHAR(36) NOT NULL,
                                                created_date TIMESTAMP,
                                                modified_date TIMESTAMP,
                                                supplier_id VARCHAR(36),
                                                PRIMARY KEY (id),
                                                foreign key (supplier_id) references supplier (id)
);
CREATE TABLE IF NOT EXISTS purchase_transaction (
                                                    id VARCHAR(36) NOT NULL,
                                                    created_date TIMESTAMP,
                                                    description VARCHAR(255),
                                                    modified_date TIMESTAMP,
                                                    price DECIMAL(19 , 2 ),
                                                    quantity BIGINT,
                                                    invoice_id VARCHAR(36),
                                                    product_id VARCHAR(36) ,
                                                    product_name varchar(255),
                                                    PRIMARY KEY (id),
                                                    foreign key (invoice_id) references purchase_invoice (id),
                                                    foreign key (product_id) references product (id)
);
CREATE TABLE IF NOT EXISTS sale_invoice (
                                            id VARCHAR(36) NOT NULL,
                                            created_date TIMESTAMP,
                                            modified_date TIMESTAMP,
                                            customer_id VARCHAR(36),
                                            PRIMARY KEY (id),
                                            foreign key (customer_id) references customer (id)
);
CREATE TABLE IF NOT EXISTS sale_transaction (
                                                id VARCHAR(36) NOT NULL,
                                                created_date TIMESTAMP,
                                                description VARCHAR(255),
                                                modified_date TIMESTAMP,
                                                price DECIMAL(19 , 2 ),
                                                quantity BIGINT,
                                                invoice_id VARCHAR(36),
                                                product_id VARCHAR(36) ,
                                                product_name varchar(255),
                                                PRIMARY KEY (id),
                                                foreign key (invoice_id) references sale_invoice (id),
                                                foreign key (product_id) references product (id)
);


CREATE TABLE IF NOT EXISTS user_account_user_permissions (
                                                             user_account_id BIGINT NOT NULL,
                                                             user_permissions VARCHAR(255),
                                                             foreign key (user_account_id) references user_account (id)
);
CREATE TABLE IF NOT EXISTS user_session (
                                            username VARCHAR(255) NOT NULL,
                                            token LONGTEXT,
                                            PRIMARY KEY (username)
);
CREATE TABLE IF NOT EXISTS user_profile (
                                            id VARCHAR(36) NOT NULL,
                                            created_date TIMESTAMP,
                                            first_name VARCHAR(255),
                                            last_name VARCHAR(255),
                                            photo_path VARCHAR(255),
                                            modified_date TIMESTAMP,
                                            account_id BIGINT NOT NULL,
                                            PRIMARY KEY (id),
                                            foreign key (account_id) references user_account (id)
);


-- ////////////////////////////////////////////////////////////CONSTRAINTS

-- alter table user_account add constraint UK_castjbvpeeus0r8lbpehiu0e4 unique (username);
-- alter table activity add constraint FKb0e1g6c44ampoe1ondy9t6v8w foreign key (user_id) references user_account;
-- alter table user_profile add constraint UK_k3d1y1iufa28c7v4vtxsqw9aa unique (account_id);
-- alter table purchase_invoice add constraint FKqtx4kjstn77n9v4wowt0mlxkx foreign key (supplier_id) references supplier (id);
-- alter table purchase_transaction add constraint FKk5ila2wwhg03dmjj09xc5pikb foreign key (invoice_id) references purchase_invoice (id);
-- alter table purchase_transaction add constraint FK850huaktm1ev5g3jefeb8qdat foreign key (product_id) references product (id);
-- alter table sale_invoice add constraint FKt1eli7jvci5frjgs50tba9p15 foreign key (customer_id) references customer (id);
-- alter table sale_transaction add constraint FK8aggg6jsmks0iklv5wq0i8wpd foreign key (invoice_id) references sale_invoice (id);
-- alter table sale_transaction add constraint FKwbltmowgsigtquwnn824c20a foreign key (product_id) references product (id);
-- alter table user_account_user_permissions add constraint FKajmdd9jsygg62yohq6fe9ppbn foreign key (user_account_id) references user_account (id);
-- alter table user_profile add constraint FKp581a3prvwt8w63lu5s4w9jub foreign key (account_id) references user_account (id);
# SET @dbname = DATABASE();
# SET @tablename = "product";
# SET @columnname = "image_available";
# SET @preparedStatement = (SELECT IF(
#                                              (
#                                                  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
#                                                  WHERE
#                                                      (table_name = @tablename)
#                                                    AND (table_schema = @dbname)
#                                                    AND (column_name = @columnname)
#                                              ) > 0,
#                                              "SELECT 1",
#                                              CONCAT("ALTER TABLE ", @tablename, " ADD ", @columnname, " boolean DEFAULT false;")
#                                      ));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- ////////////////////////////////////////////////////////////INDEXES
-- create index IDXkiyy7m3fwm4vo5nil9ibp5846 on customer (first_name, last_name);
ALTER TABLE customer ADD INDEX (first_name, last_name);
-- create index IDXnejv48oro0mjt6v13jl7t3l8k on supplier (first_name, last_name);
ALTER TABLE supplier ADD INDEX (first_name, last_name);
-- create index IDXjmivyxk9rmgysrmsqw15lqr5b on product (name);
ALTER TABLE product ADD INDEX (name);
-- create index IDXcastjbvpeeus0r8lbpehiu0e4 on user_account (username);
ALTER TABLE user_account ADD INDEX (username);
-- create index IDXshil01lken9uud5fvqe7g1t58 on user_profile (first_name, last_name);
ALTER TABLE user_profile ADD INDEX (first_name, last_name);

-- ////////////////////////////////////////////////////////////PRODUCT_VIEW

CREATE OR REPLACE VIEW product_view AS
(SELECT
     p.id AS id,

     p.name AS name,
     p.description AS description,
     p.price AS price,
     p.sale_price AS SALE_PRICE,
     p.created_date AS CREATED_DATE,
     p.image_available ,

     (CASE WHEN it.quantity IS NOT NULL THEN it.quantity ELSE 0 END ) - (CASE
                                                                             WHEN s.quantity IS NOT NULL THEN s.quantity
                                                                             ELSE 0
         END) AS quantity
FROM
    product p
        LEFT JOIN
    (SELECT
         pt.product_id, (SUM(pt.quantity)) AS quantity
     FROM
         purchase_transaction pt
     GROUP BY pt.product_id) AS it ON p.id = it.product_id
        LEFT JOIN
    (SELECT
         st.product_id, (SUM(st.quantity)) AS quantity
     FROM
         sale_transaction st
     GROUP BY st.product_id) AS s ON p.id = s.product_id) LIMIT 100;

-- ////////////////////////////////////////////////////////////INVOICE_VIEW
CREATE OR REPLACE VIEW invoice_view AS
(SELECT
     pi.id AS id,
     CONCAT(first_name, ' ', last_name) AS NAME,
     'purchase' AS TYPE,
     created_date
FROM
    purchase_invoice pi
        LEFT JOIN
    (SELECT
         id, first_name, last_name
     FROM
         supplier) AS s ON pi.supplier_id = s.id
UNION ALL SELECT
              si.id AS id,
              CONCAT(first_name, ' ', last_name) AS NAME,
              'sale' AS TYPE,
              created_date
FROM
    sale_invoice si
        LEFT JOIN
    (SELECT
         id, first_name, last_name
     FROM
         customer) AS c ON si.customer_id = c.id)
LIMIT 100;

-- ////////////////////////////////////////////////////////////TRANSACTION_VIEW
CREATE OR REPLACE VIEW transaction_view AS
(SELECT
     t.id,
     t.product_name,
     t.price,
     t.quantity,
     t.type,
     t.created_date
FROM
    (SELECT
         *, 'purchase' AS TYPE
     FROM
         purchase_transaction tr UNION ALL SELECT
                                               *, 'sale' AS TYPE
     FROM
         sale_transaction st) AS t
    )LIMIT 100
