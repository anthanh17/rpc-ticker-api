package main

import (
	"log"
	db "rpc-ticker-api/db/sqlc"
	"rpc-ticker-api/util"

	"go.uber.org/zap"
)

func main() {
	config, err := util.LoadConfig()
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	// Run server grpc
	if err = runGrpcServer(config); err != nil {
		panic(err)
	}
}

func runGrpcServer(config util.Config) error {
	// Logger
	logger, cleanup, err := util.InitializeLogger(config.Log.Level)
	if err != nil {
		cleanup()
		logger.With(zap.Error(err)).Error("cannot initialize logger")
		return err
	}
	defer cleanup()

	// Database Accessor
	store, cleanupFunc, err := db.InitializeUpDB(config.Database, logger)
	if err != nil {
		cleanupFunc()
		logger.Info("error InitializeUpDB")
		return err
	}
	defer cleanupFunc()

	return nil
}
