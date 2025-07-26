-- Create early_bird table for storing early bird signups
CREATE TABLE IF NOT EXISTS early_bird (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50),
    company VARCHAR(255),
    terms_accepted BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index for email lookups
CREATE INDEX IF NOT EXISTS idx_early_bird_email ON early_bird(email);

-- Create index for created_at for sorting
CREATE INDEX IF NOT EXISTS idx_early_bird_created_at ON early_bird(created_at);