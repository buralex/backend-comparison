INSERT INTO post(title, app_user_id)
VALUES ($1, $2)
RETURNING $table_fields;
