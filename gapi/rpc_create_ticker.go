package gapi

import (
	"context"
	db "rpc-ticker-api/db/sqlc"
	"rpc-ticker-api/pb"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func (s *Server) CreateTicker(ctx context.Context, req *pb.CreateTickerRequest) (*pb.CreateTickerResponse, error) {
	arg := db.CreateTickerParams{
		Symbol:      req.GetSymbol(),
		Description: req.GetDescription(),
		Exchange:    req.GetExchange(),
		Currency:    req.GetCurrency(),
	}

	ticker, err := s.store.CreateTicker(ctx, arg)
	if err != nil {
		s.logger.Info("cannot CreateUser")
		if db.ErrorCode(err) == db.UniqueViolation {
			return nil, status.Errorf(codes.AlreadyExists, "ticker already exists: %s", err)
		}
		return nil, status.Errorf(codes.Internal, "failed to create ticker: %s", err)
	}

	rsp := &pb.CreateTickerResponse{
		Ticker: &pb.Ticker{
			Id:          uint64(ticker.ID),
			Symbol:      ticker.Symbol,
			Description: ticker.Description,
			Exchange:    ticker.Exchange,
			Currency:    ticker.Currency,
			CreatedAt:   timestamppb.New(ticker.CreatedAt),
		},
	}

	return rsp, nil
}
