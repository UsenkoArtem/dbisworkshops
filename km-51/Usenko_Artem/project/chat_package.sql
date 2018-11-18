CREATE OR REPLACE FUNCTION add_chat (
    chat_name   IN          chat.chat_name%TYPE
) RETURN NUMBER IS
    maxid   chat.chat_id%TYPE;
BEGIN
    SELECT
        MAX(chat.chat_id)
    INTO maxid
    FROM
        chat;

    addusertodatabase(maxid + 1, chat_name);
    return(0);
EXCEPTION
    WHEN OTHERS THEN
        return(-1);
END add_chat;
/

CREATE OR REPLACE PROCEDURE add_chat_to_table (
    chat_id     IN          chat.chat_id%TYPE,
    chat_name   IN          chat.chat_name%TYPE
) IS
    PRAGMA autonomous_transaction;
BEGIN
    INSERT INTO chat (
        chat_id,
        chat_name
    ) VALUES (
        chat_id,
        chat_name
    );

    COMMIT;
END add_chat_to_table;
/

CREATE OR REPLACE PROCEDURE chat_update_name (
    chat_id         IN              chat.chat_id%TYPE,
    new_chat_name   IN              chat.chat_name%TYPE
) IS
    PRAGMA autonomous_transaction;
BEGIN
    UPDATE chat
    SET
        chat.chat_name = new_chat_name
    WHERE
        chat.user_id = chat_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE value_error;
END chat_update_name;

CREATE OR REPLACE PROCEDURE chat_delete (
    chat_id   IN        chat.chat_id%TYPE
) IS
    PRAGMA autonomous_transaction;
BEGIN
    DELETE FROM chat
    WHERE
        chat.user_id = chat_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE value_error;
END chat_delete;