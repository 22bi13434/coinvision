-- Table: users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT,
    image_url VARCHAR(255),
    portfolio_visibility BOOLEAN DEFAULT TRUE,
    plan VARCHAR(20) DEFAULT 'free' CHECK (plan IN ('free', 'pro')),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: cryptos
CREATE TABLE cryptos (
    id VARCHAR(50) PRIMARY KEY,
    image_url VARCHAR(255),
    name VARCHAR(100) NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    description TEXT,
    price NUMERIC(30, 18),
    change_24h NUMERIC(10, 2),
    volume_24h NUMERIC(18, 2),
    market_cap NUMERIC(18, 2),
    ath NUMERIC(30, 18),
    atl NUMERIC(30, 18),
    private_price NUMERIC(30, 18),
    total_supply NUMERIC(24, 2),
    circulating_supply NUMERIC(24, 2),
    fdv NUMERIC(18, 2),
    total_fundraised NUMERIC(18, 2),
    white_paper_link VARCHAR(255),
    website_link VARCHAR(255),
    x_link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: crypto_logs
CREATE TABLE crypto_logs (
    id SERIAL PRIMARY KEY,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    price NUMERIC(18, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: category
CREATE TABLE category (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- Table: crypto_category
CREATE TABLE crypto_category (
    id SERIAL PRIMARY KEY,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    category_id VARCHAR(50) REFERENCES category(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (crypto_id, category_id)
);

-- Table: blockchains
CREATE TABLE blockchains (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    image_url VARCHAR(255),
    explorer_link VARCHAR(255)
);

-- Table: crypto_blockchains
CREATE TABLE crypto_blockchains (
    id SERIAL PRIMARY KEY,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    blockchain_id INTEGER REFERENCES blockchains(id) ON DELETE CASCADE,
    contract_address VARCHAR(255),
    UNIQUE (crypto_id, blockchain_id)
);

-- Table: exchanges
CREATE TABLE exchanges (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    type VARCHAR(50),
    image_url VARCHAR(255),
    volume_24h NUMERIC(18, 2),
    website_link VARCHAR(255),
    x_link VARCHAR(255),
    rating NUMERIC(3, 2),
    por_link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: exchange_cryptos
CREATE TABLE exchange_cryptos (
    id SERIAL PRIMARY KEY,
    exchange_id VARCHAR(50) REFERENCES exchanges(id) ON DELETE CASCADE,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (exchange_id, crypto_id)
);

-- Table: crypto_explorers
CREATE TABLE crypto_explorers (
    id SERIAL PRIMARY KEY,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    explorer_link VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (crypto_id, explorer_link)
);

-- Table: venture_capitals
CREATE TABLE venture_capitals (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    website_link VARCHAR(255),
    x_link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    image_url VARCHAR(255)
);

-- Table: vc_investment
CREATE TABLE vc_investment (
    id SERIAL PRIMARY KEY,
    vc_id VARCHAR(50) REFERENCES venture_capitals(id) ON DELETE CASCADE,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (vc_id, crypto_id)
);

-- Table: community_posts
CREATE TABLE community_posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    text TEXT,
    status VARCHAR(20) DEFAULT 'active'
);

-- Table: post_like
CREATE TABLE post_like (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    post_id INTEGER REFERENCES community_posts(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: comments
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    post_id INTEGER REFERENCES community_posts(id) ON DELETE CASCADE,
    text TEXT
);

-- Table: post_photos
CREATE TABLE post_photos (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(255),
    post_id INTEGER REFERENCES community_posts(id) ON DELETE CASCADE
);

-- Table: comment_photos
CREATE TABLE comment_photos (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(255),
    comment_id INTEGER REFERENCES comments(id) ON DELETE CASCADE
);

-- Table: portfolio_entries
CREATE TABLE portfolio_entries (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    amount NUMERIC(18, 8),
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('buy', 'sell'))
);

-- Table: portfolio_logs
CREATE TABLE portfolio_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    total_value NUMERIC(18, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: crypto_stats
CREATE TABLE crypto_stats (
    id SERIAL PRIMARY KEY,
    crypto_id VARCHAR(50) REFERENCES cryptos(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: api_keys
CREATE TABLE api_keys (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    api_key VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE system_logs (
    id SERIAL PRIMARY KEY,
    log_text TEXT NOT NULL,
    solved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);