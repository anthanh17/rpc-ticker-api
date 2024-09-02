package gapi

import (
	db "rpc-ticker-api/db/sqlc"
	"rpc-ticker-api/pb"
	"rpc-ticker-api/util"
)

// Server serves gRPC requests for our service.
type Server struct {
	pb.UnimplementedTickerServicerServer
	config util.Config
	store  db.Store
}

// NewServer creates a new gRPC server.
func NewServer(config util.Config, store db.Store) (*Server, error) {
	server := &Server{
		config: config,
		store:  store,
	}

	return server, nil
}
