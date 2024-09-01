-- name: CreateTicker :one
INSERT INTO tickers (
  symbol,
  description,
  exchange,
  currency
) VALUES (
  $1, $2, $3, $4
) RETURNING *;

-- name: GetTicker :one
SELECT * FROM tickers
WHERE id = $1 LIMIT 1;

-- name: ListTickers :many
SELECT * FROM tickers
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateDescriptionTicker :one
UPDATE tickers
SET description = $2
WHERE id = $1
RETURNING *;

-- name: DeleteTicker :exec
DELETE FROM tickers
WHERE id = $1;
