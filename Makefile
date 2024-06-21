postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root transactions

dropdb:
	docker exec -it postgres12 dropdb transactions

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/transactions?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/transactions?sslmode=disable" -verbose down


.PHONY: postgres createdb dropdb