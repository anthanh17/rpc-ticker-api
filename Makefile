HOST = localhost# ex: ec2-18-141-12-199.ap-southeast-1.compute.amazonaws.com
DB_URL = postgresql://root:secret@$(HOST):5432/rd?sslmode=disable

# ----------------------------- Setup database ---------------------------------
databaseup:
	docker compose -f deployments/docker-compose.yaml up -d

databasedown:
	docker compose -f deployments/docker-compose.yaml down

# ------------------- Read schema sql -> crete or update database --------------
# Migarte database all
migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

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

# Start server
server:
	go run main.go

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--openapiv2_out=docs/swagger --openapiv2_opt=allow_merge=true,merge_file_name=rpc_ticker_api \
	proto/*.proto

redis:
	docker run --name redis -p 6379:6379 -d redis:7-alpine

.PHONY: databaseup databasedown migrateup migratedown migrateup1 migratedown1 sqlc server proto redis
