CREATE DATABASE IF NOT EXISTS db_service_b;
USE db_service_b;

CREATE USER IF NOT EXISTS 'micro_user'@'%' IDENTIFIED BY 'micro_pass';
GRANT ALL PRIVILEGES ON db_service_b.* TO 'micro_user'@'%';
FLUSH PRIVILEGES;

-- Tabla inicial con algunos datos de ejemplo
CREATE TABLE IF NOT EXISTS orders (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(255) NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL
);

-- Datos de ejemplo
INSERT INTO orders (customer_name, product_id, quantity) VALUES ('Juan Pérez', 1, 2) ON DUPLICATE KEY UPDATE customer_name=customer_name;
INSERT INTO orders (customer_name, product_id, quantity) VALUES ('María López', 2, 1) ON DUPLICATE KEY UPDATE customer_name=customer_name;
