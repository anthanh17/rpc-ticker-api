HOST = localhost # ex: ec2-18-141-12-199.ap-southeast-1.compute.amazonaws.com
DB_URL = postgresql://root:secret@$(HOST):5432/rd?sslmode=disable

# ----------------------------- Setup database ---------------------------------
databaseup:
	docker compose -f deployments/docker-compose.yaml up -d

databasedown:
	docker compose -f deployments/docker-compose.yaml down

# ------------------- Read schema sql -> crete or update database --------------
# Migarte database all
migrateup:
	migrate -path db/migration -database "" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

# Migarte database lastest
migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

# ------------------- Read schema and query sqlc -> generate code golang -------
sqlc:
	sqlc generate -f ./etc/sqlc.yaml

# Start server http
server:
	go run main.go

.PHONY: databaseup databasedown migrateup migratedown migrateup1 migratedown1 sqlc server
