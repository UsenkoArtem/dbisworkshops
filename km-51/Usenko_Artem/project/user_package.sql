CREATE OR REPLACE PACKAGE user_package IS
    TYPE rowchat IS RECORD (
        chat_name chat.chat_name%TYPE
    );
    TYPE tblgetchats IS
        TABLE OF rowchat;
    TYPE user_settings_row IS RECORD (
        user_settings_notification usersettings.user_settings_notification%TYPE,
        user_settings_information usersettings.user_settings_information%TYPE,
        user_settings_position_on_job usersettings.user_settings_position_on_job%TYPE
    );
    TYPE tblgetusersettings IS
        TABLE OF user_settings_row;
    TYPE user_row IS RECORD (
        user_id "User".user_id%TYPE,
        userfirstname "User".user_first_name%TYPE,
        usersecondname "User".user_second_name%TYPE,
        pass "User".user_password%TYPE,
        email "User".user_email%TYPE
    );
    TYPE tblgetusers IS
        TABLE OF user_row;
    FUNCTION get_user_chats (
        userid   IN       "User".user_id%TYPE
    ) RETURN tblgetchats
        PIPELINED;

    FUNCTION get_user_settings (
        userid   IN       "User".user_id%TYPE
    ) RETURN tblgetusersettings
        PIPELINED;

    FUNCTION get_user (
        userid   IN       "User".user_id%TYPE
    ) RETURN tblgetusers
        PIPELINED;

    FUNCTION get_users RETURN tblgetusers
        PIPELINED;

    FUNCTION adduser (
        userfirstname    IN               "User".user_first_name%TYPE,
        usersecondname   IN               "User".user_second_name%TYPE,
        pass             IN               "User".user_password%TYPE,
        email            IN               "User".user_email%TYPE
    ) RETURN NUMBER;

    PROCEDURE addusertodatabase (
        user_id          IN               "User".user_id%TYPE,
        userfirstname    IN               "User".user_first_name%TYPE,
        usersecondname   IN               "User".user_second_name%TYPE,
        pass             IN               "User".user_password%TYPE,
        email            IN               "User".user_email%TYPE
    );

    PROCEDURE user_update_first_name (
        user_id          IN               "User".user_id%TYPE,
        new_first_name   IN               "User".user_first_name%TYPE
    );

    PROCEDURE user_update_second_name (
        user_id           IN                "User".user_id%TYPE,
        new_second_name   IN                "User".user_second_name%TYPE
    );

    PROCEDURE user_update_password (
        user_id        IN             "User".user_id%TYPE,
        new_password   IN             "User".user_password%TYPE
    );

    PROCEDURE user_update_email (
        user_id     IN          "User".user_id%TYPE,
        new_email   IN          "User".user_email%TYPE
    );

    PROCEDURE user_delete (
        user_id   IN        "User".user_id%TYPE
    );

    PROCEDURE user_add_chat (
        chat_id   chat.chat_id%TYPE,
        user_id   "User".user_id%TYPE
    );

    FUNCTION login_user (
        useremail      "User".user_email%TYPE,
        userpassword   "User".user_password%TYPE
    ) RETURN NUMBER;

END user_package;
/

CREATE OR REPLACE PACKAGE BODY user_package IS

    FUNCTION login_user (
        useremail      "User".user_email%TYPE,
        userpassword   "User".user_password%TYPE
    ) RETURN NUMBER IS
        count_user   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO count_user
        FROM
            "User"
        WHERE
            "User".user_email = useremail
            AND "User".user_password = userpassword;

        IF count_user = 1 THEN
            return(0);
        END IF;
        return(-1);
    END login_user;

    PROCEDURE user_add_chat (
        chat_id   chat.chat_id%TYPE,
        user_id   "User".user_id%TYPE
    ) IS
    BEGIN
        INSERT INTO user_chat_admin (
            chat_id,
            user_id
        ) VALUES (
            chat_id,
            user_id
        );

    END user_add_chat;

    FUNCTION get_users RETURN tblgetusers
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                "User"
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_users;

    FUNCTION get_user (
        userid   IN       "User".user_id%TYPE
    ) RETURN tblgetusers
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                *
            FROM
                "User"
            WHERE
                "User".user_id = userid
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_user;

    FUNCTION get_user_settings (
        userid   IN       "User".user_id%TYPE
    ) RETURN tblgetusersettings
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                user_settings_notification,
                user_settings_information,
                user_settings_position_on_job
            FROM
                usersettings
            WHERE
                usersettings.user_id = userid
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_user_settings;

    FUNCTION get_user_chats (
        userid   IN       "User".user_id%TYPE
    ) RETURN tblgetchats
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                chat_name
            FROM
                chat
                INNER JOIN user_have_chat ON user_have_chat.chat_id = chat.chat_id
                                             AND user_have_chat.user_id = userid
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_user_chats;

    FUNCTION adduser (
        userfirstname    IN               "User".user_first_name%TYPE,
        usersecondname   IN               "User".user_second_name%TYPE,
        pass             IN               "User".user_password%TYPE,
        email            IN               "User".user_email%TYPE
    ) RETURN NUMBER IS
        maxid   "User".user_id%TYPE;
    BEGIN
        SELECT
            MAX("User".user_id)
        INTO maxid
        FROM
            "User";

        addusertodatabase(maxid + 1, userfirstname, usersecondname, pass, email);
        return(0);
    EXCEPTION
        WHEN OTHERS THEN
            return(-1);
    END adduser;

    PROCEDURE addusertodatabase (
        user_id          IN               "User".user_id%TYPE,
        userfirstname    IN               "User".user_first_name%TYPE,
        usersecondname   IN               "User".user_second_name%TYPE,
        pass             IN               "User".user_password%TYPE,
        email            IN               "User".user_email%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO "User" (
            user_id,
            user_first_name,
            user_second_name,
            user_password,
            user_email
        ) VALUES (
            user_id,
            userfirstname,
            usersecondname,
            pass,
            email
        );

        COMMIT;
    END addusertodatabase;

    PROCEDURE user_update_first_name (
        user_id          IN               "User".user_id%TYPE,
        new_first_name   IN               "User".user_first_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE "User"
        SET
            "User".user_first_name = new_first_name
        WHERE
            "User".user_id = user_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END user_update_first_name;

    PROCEDURE user_update_second_name (
        user_id           IN                "User".user_id%TYPE,
        new_second_name   IN                "User".user_second_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE "User"
        SET
            "User".user_second_name = new_second_name
        WHERE
            "User".user_id = user_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END user_update_second_name;

    PROCEDURE user_update_password (
        user_id        IN             "User".user_id%TYPE,
        new_password   IN             "User".user_password%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE "User"
        SET
            "User".user_password = new_password
        WHERE
            "User".user_id = user_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END user_update_password;

    PROCEDURE user_update_email (
        user_id     IN          "User".user_id%TYPE,
        new_email   IN          "User".user_email%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE "User"
        SET
            "User".user_email = new_email
        WHERE
            "User".user_id = user_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END user_update_email;

    PROCEDURE user_delete (
        user_id   IN        "User".user_id%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM "User"
        WHERE
            "User".user_id = user_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END user_delete;

END user_package;