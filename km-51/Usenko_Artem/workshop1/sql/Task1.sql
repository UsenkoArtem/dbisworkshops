INSERT INTO chat (
    chat_id,
    chat_name
) VALUES (
    chat_seq.NEXTVAL,
    'Test chat'
);

INSERT INTO user_chat (
    user_id,
    chat_id
) VALUES (
    (
        SELECT
            "User".user_id
        FROM
            "User"
        WHERE
            "User".user_email = 'usenko@gmail.com'
    ),
    (
        SELECT
            chat.chat_id
        FROM
            chat
        WHERE
            chat.chat_name = 'Test chat'
    )
);

INSERT INTO message (
    message_id,
    chat_id,
    message_text,
    message_date,
    message_owner
) VALUES (
    message_seq.NEXTVAL,
    (
        SELECT
            chat.chat_id
        FROM
            chat
        WHERE
            chat.chat_name = 'Test chat'
    ),
    ( 'Lab4' ),
    (
        SELECT
            systimestamp
        FROM
            dual
    ),
    (
        SELECT
            "User".user_id
        FROM
            "User"
        WHERE
            "User".user_email = 'usenko1@gmail.com'
    )
);
