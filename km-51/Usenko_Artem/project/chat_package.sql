CREATE OR REPLACE PACKAGE chat_package IS
    FUNCTION add_chat (
        chat_name   IN          "CHAT".chat_name%TYPE,
        user_id     IN          "User".user_id%TYPE
    ) RETURN NUMBER;

    PROCEDURE add_chat_to_table (
        chat_id     IN          "CHAT".chat_id%TYPE,
        chat_name   IN          "CHAT".chat_name%TYPE,
        user_id     IN          "User".user_id%TYPE
    );

    PROCEDURE chat_update_name (
        chat_id         IN              "CHAT".chat_id%TYPE,
        new_chat_name   IN              "CHAT".chat_name%TYPE
    );

    PROCEDURE chat_delete (
        chat_id   IN        "CHAT".chat_id%TYPE
    );

    TYPE chat_settings_row IS RECORD (
        chat_settings_administrator_id chatsettings.chat_settings_administrator_id%TYPE,
        chat_id chatsettings.chat_id%TYPE,
        chat_settings_information chatsettings.chat_settings_information%TYPE
    );
    TYPE tblgetchatsettings IS
        TABLE OF chat_settings_row;
        
     FUNCTION get_chat_settings (
        chat_id   IN        "CHAT".chat_id%TYPE
    ) RETURN tblgetchatsettings
        PIPELINED;    
END chat_package;
/

CREATE OR REPLACE PACKAGE BODY chat_package IS

    FUNCTION add_chat (
        chat_name   IN          "CHAT".chat_name%TYPE,
        user_id     IN          "User".user_id%TYPE
    ) RETURN NUMBER IS
        maxid   chat.chat_id%TYPE;
    BEGIN
        SELECT
            MAX(chat.chat_id)
        INTO maxid
        FROM
            chat;

        add_chat_to_table(maxid + 1, chat_name, user_id);
        return(0);
    EXCEPTION
        WHEN OTHERS THEN
            return(-1);
    END add_chat;

    PROCEDURE add_chat_to_table (
        chat_id     IN          "CHAT".chat_id%TYPE,
        chat_name   IN          "CHAT".chat_name%TYPE,
        user_id     IN          "User".user_id%TYPE
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

    PROCEDURE chat_update_name (
        chat_id         IN              "CHAT".chat_id%TYPE,
        new_chat_name   IN              "CHAT".chat_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE chat
        SET
            chat.chat_name = new_chat_name
        WHERE
            chat.chat_id = chat_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END chat_update_name;

    PROCEDURE chat_delete (
        chat_id   IN        "CHAT".chat_id%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM chat
        WHERE
            chat.chat_id = chat_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END chat_delete;


        FUNCTION get_chat_settings (
        chat_id   IN        "CHAT".chat_id%TYPE
    ) RETURN tblgetchatsettings
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                chat_settings_administrator_id,
                chat_id,
                chat_settings_information
            FROM
                chatsettings
            WHERE
                chatsettings.chat_id = chat_id
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_user_settings;

END chat_package;