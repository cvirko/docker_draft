-- 1. Создание роли (если не создана в init.sh)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'developer') THEN
        CREATE ROLE developer;
    END IF;
END
$$;

-- 2. Создание баз данных
CREATE DATABASE sales_db;
CREATE DATABASE logs_db;

-- Даем права пользователю
GRANT ALL PRIVILEGES ON DATABASE sales_db TO developer;
GRANT ALL PRIVILEGES ON DATABASE logs_db TO developer;

-- 3. Работа с базой SALES_DB
\c sales_db

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Таблица в схеме core
CREATE TABLE core.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица в схеме analytics
CREATE TABLE analytics.sales_stats (
    id SERIAL PRIMARY KEY,
    product_id INTEGER,
    sale_date DATE,
    quantity INTEGER
);

-- Наполнение данными
INSERT INTO core.products (name, price) VALUES 
('Laptop', 1200.00),
('Mouse', 25.50),
('Keyboard', 75.00);

INSERT INTO analytics.sales_stats (product_id, sale_date, quantity) VALUES 
(1, CURRENT_DATE, 5),
(2, CURRENT_DATE, 20);

-- Передача прав на схемы и таблицы
GRANT USAGE ON SCHEMA core TO developer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA core TO developer;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA core TO developer;

-- 4. Работа с базой LOGS_DB
\c logs_db

CREATE SCHEMA IF NOT EXISTS system;

CREATE TABLE system.events (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(50),
    description TEXT,
    occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO system.events (event_type, description) VALUES 
('INFO', 'System started'),
('WARNING', 'Low disk space');

GRANT USAGE ON SCHEMA system TO developer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA system TO developer;