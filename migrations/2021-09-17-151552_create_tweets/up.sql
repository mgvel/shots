CREATE OR REPLACE FUNCTION diesel_manage_updated_at(_tbl regclass) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %s
                    FOR EACH ROW EXECUTE PROCEDURE diesel_set_updated_at()', _tbl);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION diesel_set_updated_at() RETURNS trigger AS
$$
BEGIN
    IF (
            NEW IS DISTINCT FROM OLD AND
            NEW.updated_at IS NOT DISTINCT FROM OLD.updated_at
        ) THEN
        NEW.updated_at := current_timestamp;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS tweets
(
    id         UUID PRIMARY KEY        NOT NULL,
    created_at TIMESTAMP DEFAULT now() NOT NULL,
    message    TEXT                    NOT NULL
);

CREATE TABLE IF NOT EXISTS likes
(
    id         UUID PRIMARY KEY        NOT NULL,
    created_at TIMESTAMP DEFAULT now() NOT NULL,
    tweet_id   UUID                    NOT NULL REFERENCES tweets (id)
);
