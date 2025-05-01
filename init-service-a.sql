CREATE DATABASE IF NOT EXISTS db_service_a;
USE db_service_a;

CREATE USER IF NOT EXISTS 'micro_user'@'%' IDENTIFIED BY 'micro_pass';
GRANT ALL PRIVILEGES ON db_service_a.* TO 'micro_user'@'%';
FLUSH PRIVILEGES;

-- Tabla inicial con algunos datos de ejemplo
CREATE TABLE IF NOT EXISTS product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DOUBLE NOT NULL
);

-- Datos de ejemplo
INSERT INTO product (name, price) VALUES ('Laptop', 1200.00) ON DUPLICATE KEY UPDATE name=name;
INSERT INTO product (name, price) VALUES ('Smartphone', 800.00) ON DUPLICATE KEY UPDATE name=name;
INSERT INTO product (name, price) VALUES ('Tablet', 400.00) ON DUPLICATE KEY UPDATE name=name;
