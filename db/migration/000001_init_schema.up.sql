CREATE TABLE "tickers" (
  "id" bigserial PRIMARY KEY,
  "symbol" varchar NOT NULL,
  "description" varchar NOT NULL,
  "exchange" varchar NOT NULL,
  "currency" varchar NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

ALTER TABLE tickers ADD CONSTRAINT unique_symbol_exchange UNIQUE (symbol, exchange);
