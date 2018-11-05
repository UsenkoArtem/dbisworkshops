
UPDATE message
SET
    message.message_text = 'Update text'
WHERE
    message.message_owner IN (
        SELECT
            "User".user_id
        FROM
            "User"
        WHERE
            "User".user_first_name = 'Artem'
            AND "User".user_id IN (
                SELECT
                    user_chat.user_id
                FROM
                    user_chat
                WHERE
                    user_chat.chat_id IN (
                        SELECT
                            chat.chat_id
                        FROM
                            chat
                        WHERE
                            chat.chat_name = 'Test chat'
                    )
            )
    );