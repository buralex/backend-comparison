SELECT
    au.id AS user_id,
    au.email AS user_email,
    au.full_name AS user_full_name,
    au.created_at AS user_created_at,
    au.updated_at AS user_updated_at,
    p.id AS post_id,
    p.title AS post_title,
    p.app_user_id AS post_user_id,
    p.created_at AS post_created_at,
    p.updated_at AS post_updated_at
FROM
    app_user AS au
LEFT JOIN
    post AS p
ON
    au.id = p.app_user_id;