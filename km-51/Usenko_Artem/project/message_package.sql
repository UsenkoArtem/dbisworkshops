CREATE OR REPLACE PACKAGE message_package IS
    TYPE message_row IS RECORD (
        message_text message.message_text%TYPE,
        message_file_url message.message_file_url%TYPE,
        message_date message.message_date%TYPE
    );
    TYPE tblgetmessage IS
        TABLE OF message_row;
    FUNCTION add_message (
        message_text       IN                 message.message_text%TYPE,
        message_file_url   IN                 message.message_file_url%TYPE,
        user_id            IN                 "User".user_id%TYPE,
        chat_id            IN                 "CHAT".chat_id%TYPE
    ) RETURN NUMBER;

    PROCEDURE add_message_to_table (
        message_id         IN                 message.message_id%TYPE,
        message_text       IN                 message.message_text%TYPE,
        message_file_url   IN                 message.message_file_url%TYPE,
        user_id            IN                 "User".user_id%TYPE,
        chat_id            IN                 "CHAT".chat_id%TYPE
    );

    PROCEDURE message_update_text (
        message_id     IN             message.message_id%TYPE,
        message_text   IN             message.message_text%TYPE
    );

    PROCEDURE message_delete (
        message_id   IN           message.message_id%TYPE
    );

    FUNCTION get_message (
        chat_id   IN        "CHAT".chat_id%TYPE
    ) RETURN tblgetmessage
        PIPELINED;

END message_package;
/

CREATE OR REPLACE PACKAGE BODY message_package IS

    FUNCTION add_message (
        message_text       IN                 message.message_text%TYPE,
        message_file_url   IN                 message.message_file_url%TYPE,
        user_id            IN                 "User".user_id%TYPE,
        chat_id            IN                 "CHAT".chat_id%TYPE
    ) RETURN NUMBER IS
        maxid   message.chat_id%TYPE;
    BEGIN
        SELECT
            MAX(message.chat_id)
        INTO maxid
        FROM
            message;

        add_message_to_table(maxid + 1, chat_name, user_id);
        return(0);
    EXCEPTION
        WHEN OTHERS THEN
            return(-1);
    END add_message;

    PROCEDURE add_message_to_table (
        message_id         IN                 message.message_id%TYPE,
        message_text       IN                 message.message_text%TYPE,
        message_file_url   IN                 message.message_file_url%TYPE,
        user_id            IN                 "User".user_id%TYPE,
        chat_id            IN                 "CHAT".chat_id%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO message (
            message_id,
            message_text,
            message_date,
            chat_id,
            user_id,
            message_file_url
        ) VALUES (
            message_id,
            message_text,
            (
                SELECT
                    systimestamp
                FROM
                    dual
            ),
            chat_id,
            user_id,
            message_file_url
        );

        COMMIT;
    END add_message_to_table;

    PROCEDURE message_update_text (
        message_id     IN             message.message_id%TYPE,
        message_text   IN             message.message_text%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE message
        SET
            message.message_text = message_text,
            message.message_date = (
                SELECT
                    systimestamp
                FROM
                    dual
            )
        WHERE
            message.message_id = message_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END message_update_text;

    PROCEDURE message_delete (
        message_id   IN           message.message_id%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM message
        WHERE
            message.message_id = message_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END message_delete;

    FUNCTION get_message (
        chat_id   IN        "CHAT".chat_id%TYPE
    ) RETURN tblgetmessage
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                message.message_text,
                message.message_file_url,
                message.message_date
            FROM
                message
            WHERE
                message.chat_id = chat_id
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_message;

END message_package;