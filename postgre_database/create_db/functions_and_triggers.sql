-- Trigger for updated_at when update table 'users'
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Trigger for updated_at when update table 'cryptos'
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON cryptos
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Add trigger when price update is higher than ATH, update ATH, or is lower than ATL, update ATL
CREATE OR REPLACE FUNCTION update_ath_atl()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price > OLD.ath THEN
        NEW.ath = NEW.price;
    ELSIF NEW.price < OLD.atl THEN
        NEW.atl = NEW.price;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_ath_atl
BEFORE UPDATE ON cryptos
FOR EACH ROW EXECUTE FUNCTION update_ath_atl();

-- Update the market_cap and fdv columns whenever the price in the cryptos table is updated
CREATE OR REPLACE FUNCTION update_market_cap_fdv() 
RETURNS TRIGGER AS $$
BEGIN
    NEW.market_cap := NEW.price * OLD.circulating_supply;
    NEW.fdv := NEW.price * OLD.total_supply;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_market_cap_fdv_trigger
BEFORE UPDATE ON cryptos
FOR EACH ROW EXECUTE FUNCTION update_market_cap_fdv();
