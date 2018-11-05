
DELETE FROM usersettings
WHERE
    user_id IN (
        SELECT
            "User".user_id
        FROM
            "User" left
            JOIN user_chat ON user_chat.user_id = "User".user_id
        WHERE
            user_chat.user_id IS NULL
    );