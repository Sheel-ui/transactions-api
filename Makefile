DB_URL=postgresql://root:secret@localhost:5432/transactions?sslmode=disable

postgres:
	docker run --name postgres12 --network test-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root transactions

dropdb:
	docker exec -it postgres12 dropdb transactions

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/sheel-ui/transactions-api/db/sqlc Store

dbdocs:
	dbdocs build docs/db.dbml

dbschema:
	dbml2sql --postgres -o docs/schema.sql docs/db.dbml

proto:
	rm -f pb/*.go
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	proto/*.proto

evans:
	evans --host localhost --port 9090 -r repl

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock migratedown1 migrateup1 dbdocs dbschema proto evans