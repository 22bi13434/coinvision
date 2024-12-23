-- Indexes
CREATE INDEX idx_users_username ON users (username);
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_cryptos_symbol ON cryptos (symbol);
CREATE INDEX idx_community_posts_user_id ON community_posts (user_id);
CREATE INDEX idx_community_posts_crypto_id ON community_posts (crypto_id);
CREATE INDEX idx_comments_user_id ON comments (user_id);
CREATE INDEX idx_comments_post_id ON comments (post_id);
CREATE INDEX idx_portfolio_entries_user_id ON portfolio_entries (user_id);
CREATE INDEX idx_crypto_logs_crypto_id ON crypto_logs (crypto_id);
CREATE INDEX idx_post_like_user_id ON post_like (user_id);
CREATE INDEX idx_post_like_post_id ON post_like (post_id);
CREATE INDEX idx_portfolio_logs_user_id ON portfolio_logs (user_id);

-- Add
CREATE INDEX idx_cryptos_price ON cryptos (price);
CREATE INDEX idx_cryptos_market_cap ON cryptos (market_cap);
CREATE INDEX idx_portfolio_entries_user_id_crypto_id ON portfolio_entries (user_id, crypto_id);
CREATE INDEX idx_cryptos_name ON cryptos (name);