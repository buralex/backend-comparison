CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS app_user (
	id 		   uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	full_name  VARCHAR(200) NOT NULL,
	email 	   VARCHAR NOT NULL UNIQUE,
	created_at TIMESTAMP(3) WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP(3) WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS post (
	id          uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
	title       VARCHAR(200) NOT NULL,
	app_user_id uuid NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
	created_at TIMESTAMP(3) WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP(3) WITH TIME ZONE DEFAULT now()
);
