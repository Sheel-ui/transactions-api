package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/sheel-ui/transactions-api/api"
	db "github.com/sheel-ui/transactions-api/db/sqlc"
	"github.com/sheel-ui/transactions-api/util"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
