INSERT INTO app_user(email, full_name)
VALUES ($1, $2)
RETURNING $table_fields;
