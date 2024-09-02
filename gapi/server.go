package gapi

import (
	db "rpc-ticker-api/db/sqlc"
	"rpc-ticker-api/pb"
	"rpc-ticker-api/util"

	"go.uber.org/zap"
)

// Server serves gRPC requests for our service.
type Server struct {
	pb.UnimplementedTickerServicerServer
	config util.Config
	store  db.Store
	logger *zap.Logger
}

// NewServer creates a new gRPC server.
func NewServer(config util.Config, store db.Store, logger *zap.Logger) (*Server, error) {
	server := &Server{
		config: config,
		store:  store,
		logger:       logger,
	}

	return server, nil
}
