#### Причины для реализации DWH через якорную модель:
1. Простота: Якорная модель часто бывает простой и интуитивно понятной. Её структура представляет собой ясную систему с якорями, узлами, атрибутами и связями.
2. Работа с разреженными данными:
Якорная модель эффективно обрабатывает разреженные данные благодаря своему принципу создания отдельных таблиц для каждого атрибута, что сокращает хранение пустых значений.
3. Гибкость и эволюция:
Якорная модель обладает гибкостью в отношении эволюции схемы. Добавление, изменение или удаление атрибутов предполагает внесение изменений в конкретные таблицы, не затрагивая общую структуру.

Этот Docker Compose файл настроен для запуска распределенной системы баз данных PostgreSQL и Kafka с интеграцией Debezium для репликации данных. Включает в себя основную базу данных, реплику и хранилище данных, а также конфигурации для Zookeeper, Kafka и Debezium.

Сервисы
db_primary: Основная база данных PostgreSQL.

container_name: db_primary
image: postgres:14.5
ports: 5432 (только localhost)
volumes: Для хранения данных, конфигураций и инициализации базы данных.
db_replica: Реплика базы данных PostgreSQL.

container_name: db_replica
image: postgres:14.5
ports: 5433 (только localhost)
depends_on: db_primary
db_warehouse: Хранилище данных PostgreSQL.

container_name: db_warehouse
image: postgres:14.5
ports: 5434 (только localhost)
depends_on: db_primary
config_zookeeper: Zookeeper для Kafka.

container_name: config_zookeeper
image: confluentinc/cp-zookeeper:7.3.1
ports: 2181
message_broker: Kafka Broker.

container_name: message_broker
image: confluentinc/cp-kafka:7.3.1
ports: 29092, 9092, 9101
depends_on: config_zookeeper
data_connector: Debezium Connect для репликации данных.

container_name: data_connector
image: debezium/connect:latest
ports: 8083
depends_on: db_primary, message_broker

Для запуска всех сервисов используйте команду:
docker-compose up -d

