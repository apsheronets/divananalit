CREATE TYPE exchange AS ENUM ('bitfinex', 'bitstamp', 'btce');
CREATE TYPE pair AS ENUM ('btcusd');
CREATE TABLE orderbooks (
  id serial NOT NULL,
  exchange exchange,
  pair pair,
  CONSTRAINT orderbooks_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
CREATE UNIQUE INDEX index_unique_orderbooks_on_exchange_and_pair
   ON orderbooks (exchange, pair);
INSERT INTO orderbooks(exchange, pair) VALUES ('bitfinex', 'btcusd');
CREATE TABLE orderbook_updates (
  id serial NOT NULL,
  orderbook_id integer NOT NULL,
  created_at timestamp without time zone,
  CONSTRAINT orderbook_updates_pkey PRIMARY KEY (id),
  CONSTRAINT orderbook_id_fk FOREIGN KEY (orderbook_id)
    REFERENCES orderbooks (id) MATCH SIMPLE
    ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
CREATE INDEX index_orderbook_updates_on_orderbook_id
ON orderbook_updates
USING btree
(orderbook_id);

CREATE TABLE orderbook_records (
  orderbook_update_id integer NOT NULL,
  bid boolean NOT NULL,
  timestamp timestamp without time zone NOT NULL,
  price numeric(16,8) NOT NULL,
  amount numeric(16,8) NOT NULL,
  CONSTRAINT orderbook_update_id_fk FOREIGN KEY (orderbook_update_id)
    REFERENCES orderbook_updates (id) MATCH SIMPLE
    ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
CREATE INDEX index_orderbook_records_on_orderbook_update_id
ON orderbook_records
USING btree
(orderbook_update_id);
CREATE INDEX index_orderbook_records_on_book_id_price_for_bids
ON orderbook_records
USING btree
(orderbook_update_id, price DESC)
WHERE bid = true;
CREATE INDEX index_orderbook_records_on_book_id_price_for_asks
ON orderbook_records
USING btree
(orderbook_update_id, price ASC)
WHERE bid = false;

CREATE TABLE trades (
  id serial NOT NULL,
  orderbook_id integer NOT NULL,
  price numeric(16,8) NOT NULL,
  amount numeric(16,8) NOT NULL,
  buy boolean NULL,
  timestamp timestamp without time zone NOT NULL,
  tid integer NULL, /* bitfinex crap */
  CONSTRAINT trades_pkey PRIMARY KEY (id),
  CONSTRAINT orderbook_id_fk FOREIGN KEY (orderbook_id)
    REFERENCES orderbooks (id) MATCH SIMPLE
    ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
CREATE INDEX index_trades_on_orderbook_id_and_timestamp
ON trades
USING btree
(orderbook_id, timestamp DESC);
CREATE INDEX index_trades_on_orderbook_id_and_tid
ON trades
USING btree
(orderbook_id, tid DESC NULLS LAST);

CREATE TYPE currency AS ENUM ('btc', 'usd', 'ltc');
CREATE TABLE lends (
  exchange exchange NOT NULL,
  currency currency NOT NULL,
  rate numeric(9,4) NOT NULL,
  amount numeric(16,8) NOT NULL,
  timestamp timestamp without time zone NOT NULL
)
WITH (
  OIDS=FALSE
);
CREATE INDEX index_lends_on_currency_and_exchange_and_timestamp
ON lends
USING btree
(currency, exchange, timestamp DESC);

BEGIN;

  CREATE TABLE exchanges (
    id serial NOT NULL,
    name character varying(255) NOT NULL,
    CONSTRAINT exchanges_pkey PRIMARY KEY (id)
  )
  WITH (
    OIDS=FALSE
  );

  CREATE TABLE currencies (
    id serial NOT NULL,
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    CONSTRAINT currencies_pkey PRIMARY KEY (id)
  )
  WITH (
    OIDS=FALSE
  );

  CREATE TABLE pairs (
    id serial NOT NULL,
    a_currency_id integer NOT NULL,
    b_currency_id integer NOT NULL,
    CONSTRAINT exchangess_pkey PRIMARY KEY (id),
    CONSTRAINT a_currency_id_fk FOREIGN KEY (a_currency_id)
      REFERENCES currencies (id) MATCH SIMPLE
      ON DELETE RESTRICT,
    CONSTRAINT b_currency_id_fk FOREIGN KEY (b_currency_id)
      REFERENCES currencies (id) MATCH SIMPLE
      ON DELETE RESTRICT
  )
  WITH (
    OIDS=FALSE
  );

COMMIT;

BEGIN;

  ALTER TABLE orderbooks
  ADD COLUMN exchange_id integer;
  ALTER TABLE orderbooks
  ADD COLUMN pair_id integer;

  INSERT INTO exchanges (name) VALUES ('bitfinex');
  INSERT INTO exchanges (name) VALUES ('bitstamp');
  INSERT INTO exchanges (name) VALUES ('btce');
  INSERT INTO exchanges (name) VALUES ('localbitcoins');

  INSERT INTO currencies (code, name) VALUES ('BTC', 'Bitcoin');
  INSERT INTO currencies (code, name) VALUES ('USD', 'United States Dollar');

  INSERT INTO pairs (a_currency_id, b_currency_id) VALUES ((SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1), (SELECT id FROM currencies WHERE code = 'USD' LIMIT 1));

  UPDATE orderbooks SET pair_id = (
    SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = 'USD' LIMIT 1
    )
    LIMIT 1
  ) where pair = 'btcusd';

  UPDATE orderbooks SET exchange_id = (
    SELECT id FROM exchanges WHERE name = 'bitfinex' LIMIT 1
  ) where exchange = 'bitfinex';

  ALTER TABLE orderbooks DROP COLUMN exchange;
  ALTER TABLE orderbooks DROP COLUMN pair;

  ALTER TABLE orderbooks
  ALTER COLUMN exchange_id SET NOT NULL;
  ALTER TABLE orderbooks
  ALTER COLUMN pair_id SET NOT NULL;

  ALTER TABLE orderbooks
  ADD CONSTRAINT exchange_id_fk FOREIGN KEY (exchange_id)
    REFERENCES exchanges (id) MATCH SIMPLE
    ON DELETE RESTRICT;
  ALTER TABLE orderbooks
  ADD CONSTRAINT pair_id_fk FOREIGN KEY (pair_id)
    REFERENCES pairs (id) MATCH SIMPLE
    ON DELETE RESTRICT;

COMMIT;

BEGIN;

  ALTER TABLE pairs
    ADD CONSTRAINT pairs_unique_c
    UNIQUE (a_currency_id, b_currency_id);
  ALTER TABLE exchanges
    ADD CONSTRAINT name_unique_c
    UNIQUE (name);
  ALTER TABLE currencies
    ADD CONSTRAINT code_unique_c
    UNIQUE (code);

COMMIT;

BEGIN;

  INSERT INTO currencies (code, name) VALUES ('CNY', 'Chinese Yuan Renminbi');
  INSERT INTO pairs (a_currency_id, b_currency_id)
  VALUES (
    (SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1),
    (SELECT id FROM currencies WHERE code = 'CNY' LIMIT 1)
  );
  INSERT INTO orderbooks (exchange_id, pair_id)
  VALUES (
    (SELECT id FROM exchanges WHERE name = 'localbitcoins' LIMIT 1),
    (SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = 'CNY' LIMIT 1
    ) LIMIT 1)
  );

COMMIT;

ALTER TABLE trades
ALTER COLUMN buy DROP NOT NULL; /* we need this for localbitcoins */

DROP TABLE lends;

ALTER TABLE orderbook_records ADD COLUMN id bigserial PRIMARY KEY;


BEGIN;

  DELETE FROM orderbook_records
  WHERE orderbook_update_id IN (
    SELECT id FROM orderbook_updates WHERE created_at < now() - interval '3 months'
  );

  DELETE FROM orderbook_updates
  WHERE created_at < now() - interval '3 months';

  /*DELETE FROM lends
  WHERE "timestamp" < now() - interval '3 months';*/

  /*DELETE FROM trades
  WHERE "timestamp" < now() - interval '3 months';*/

COMMIT;


BEGIN;

  INSERT INTO exchanges (name) VALUES ('huobi');
  INSERT INTO exchanges (name) VALUES ('btcchina');
  INSERT INTO exchanges (name) VALUES ('lakebtc');
  INSERT INTO exchanges (name) VALUES ('kraken');
  INSERT INTO exchanges (name) VALUES ('itbit');
  INSERT INTO exchanges (name) VALUES ('coinbase');
  INSERT INTO exchanges (name) VALUES ('okcoin');

  INSERT INTO currencies (code, name) VALUES ('LTC', 'Litecoin');
  INSERT INTO currencies (code, name) VALUES ('ETH', 'Ethereum');
  INSERT INTO currencies (code, name) VALUES ('DAO', 'The DAO');
  INSERT INTO currencies (code, name) VALUES ('EUR', 'Euro');
  INSERT INTO currencies (code, name)
    SELECT 'RUR', 'Russian Ruble'
    WHERE NOT EXISTS (SELECT 1 FROM currencies WHERE code = 'RUR');
  INSERT INTO currencies (code, name)
    SELECT 'CNY', 'Chinese Yuan Renminbi'
    WHERE NOT EXISTS (SELECT 1 FROM currencies WHERE code = 'CNY');
  INSERT INTO currencies (code, name) VALUES ('NMC', 'Namecoin');
  INSERT INTO currencies (code, name) VALUES ('NVC', 'Novacoin');

  INSERT INTO pairs (a_currency_id, b_currency_id)
  VALUES (
    (SELECT id FROM currencies WHERE code = 'LTC' LIMIT 1),
    (SELECT id FROM currencies WHERE code = 'USD' LIMIT 1)
  );
  INSERT INTO pairs (a_currency_id, b_currency_id)
  VALUES (
    (SELECT id FROM currencies WHERE code = 'LTC' LIMIT 1),
    (SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1)
  );
  INSERT INTO pairs (a_currency_id, b_currency_id)
  VALUES (
    (SELECT id FROM currencies WHERE code = 'ETH' LIMIT 1),
    (SELECT id FROM currencies WHERE code = 'USD' LIMIT 1)
  );
  INSERT INTO pairs (a_currency_id, b_currency_id)
  VALUES (
    (SELECT id FROM currencies WHERE code = 'ETH' LIMIT 1),
    (SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1)
  );

  INSERT INTO orderbooks (exchange_id, pair_id)
  VALUES (
    (SELECT id FROM exchanges WHERE name = 'bitfinex' LIMIT 1),
    (SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = 'LTC' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = 'USD' LIMIT 1
    ) LIMIT 1)
  );
  INSERT INTO orderbooks (exchange_id, pair_id)
  VALUES (
    (SELECT id FROM exchanges WHERE name = 'bitfinex' LIMIT 1),
    (SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = 'LTC' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1
    ) LIMIT 1)
  );

  INSERT INTO orderbooks (exchange_id, pair_id)
  VALUES (
    (SELECT id FROM exchanges WHERE name = 'bitfinex' LIMIT 1),
    (SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = 'ETH' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = 'USD' LIMIT 1
    ) LIMIT 1)
  );

  INSERT INTO orderbooks (exchange_id, pair_id)
  VALUES (
    (SELECT id FROM exchanges WHERE name = 'bitfinex' LIMIT 1),
    (SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = 'ETH' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = 'BTC' LIMIT 1
    ) LIMIT 1)
  );

COMMIT;


BEGIN;

  CREATE TABLE lendbooks (
    id serial NOT NULL,
    exchange_id integer NOT NULL,
    currency_id integer NOT NULL,
    CONSTRAINT lendbooks_pkey PRIMARY KEY (id),
    CONSTRAINT exchange_id_fk FOREIGN KEY (exchange_id)
      REFERENCES exchanges (id) MATCH SIMPLE
      ON DELETE RESTRICT,
    CONSTRAINT currency_id_fk FOREIGN KEY (currency_id)
      REFERENCES currencies (id) MATCH SIMPLE
      ON DELETE RESTRICT
  )
  WITH (
    OIDS=FALSE
  );
  CREATE UNIQUE INDEX index_unique_lendbooks_on_exchange_id_and_currency_id
     ON lendbooks (exchange_id, currency_id);

  CREATE TABLE lendbook_updates (
    id bigserial NOT NULL,
    lendbook_id integer NOT NULL,
    created_at timestamp without time zone,
    CONSTRAINT lendbook_updates_pkey PRIMARY KEY (id),
    CONSTRAINT lendbook_id_fk FOREIGN KEY (lendbook_id)
      REFERENCES lendbooks (id) MATCH SIMPLE
      ON DELETE RESTRICT
  )
  WITH (
    OIDS=FALSE
  );
  CREATE INDEX index_lendbook_updates_on_lendbook_id
  ON lendbook_updates
  USING btree
  (lendbook_id);

  CREATE TABLE lendbook_records (
    id bigserial NOT NULL,
    lendbook_update_id integer NOT NULL,
    bid boolean NOT NULL,
    frr boolean NOT NULL DEFAULT false,
    timestamp timestamp without time zone NOT NULL,
    rate numeric(16,8) NOT NULL,
    amount numeric(16,8) NOT NULL,
    period smallint NOT NULL,
    CONSTRAINT lendbook_recordss_pkey PRIMARY KEY (id),
    CONSTRAINT lendbook_update_id_fk FOREIGN KEY (lendbook_update_id)
      REFERENCES lendbook_updates (id) MATCH SIMPLE
      ON DELETE RESTRICT
  )
  WITH (
    OIDS=FALSE
  );
  CREATE INDEX index_lendbook_records_on_lendbook_update_id
  ON lendbook_records
  USING btree
  (lendbook_update_id);
  CREATE INDEX index_lendbook_records_on_book_id_rate_for_bids
  ON lendbook_records
  USING btree
  (lendbook_update_id, rate DESC)
  WHERE bid = true;
  CREATE INDEX index_lendbook_records_on_book_id_rate_for_asks
  ON lendbook_records
  USING btree
  (lendbook_update_id, rate ASC)
  WHERE bid = false;

  INSERT INTO lendbooks (exchange_id, currency_id)
  SELECT
    (SELECT id FROM exchanges WHERE name = 'bitfinex' LIMIT 1),
    currencies.id
  FROM currencies
  WHERE code IN ('BTC', 'USD', 'LTC', 'ETH');

COMMIT;

BEGIN;

  INSERT INTO currencies (code, name) VALUES ('BFX', 'Bitfinex tokens');
  INSERT INTO pairs (a_currency_id, b_currency_id)
  VALUES (
    (SELECT id FROM currencies WHERE code = 'BFX' LIMIT 1),
    (SELECT id FROM currencies WHERE code = 'USD' LIMIT 1)
  );
  INSERT INTO orderbooks (exchange_id, pair_id)
  VALUES (
    (SELECT id FROM exchanges WHERE name = 'bitfinex' LIMIT 1),
    (SELECT id FROM pairs
    WHERE a_currency_id = (
      SELECT id FROM currencies WHERE code = 'BFX' LIMIT 1
    ) AND b_currency_id = (
      SELECT id FROM currencies WHERE code = 'USD' LIMIT 1
    ) LIMIT 1)
  );

COMMIT;

