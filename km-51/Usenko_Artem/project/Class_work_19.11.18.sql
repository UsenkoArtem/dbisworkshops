--�����
SELECT
    user_package.login_user('usenkwe@gmail.com', 'sdsas')
FROM
    dual;


--�����������

SELECT
    user_package.adduser('qwe', 'qwew', 'qew', 'tes3232t@gmail.com')
FROM
    dual;

--��� ���� ������������

SELECT
    *
FROM
    TABLE ( user_package.get_user_chats(1) );
    
--��� ��������� c ����

SELECT
    *
FROM
    TABLE ( message_package.get_message(1) );

--��� ��������� �� ���� ����� ������������

SELECT
    *
FROM
    TABLE ( message_package.get_user_message_in_chat(1, 1) );
    
    
-- �������� ���

SELECT
    chat_package.add_chat('TEST CHAT', 1)
FROM
    dual;
    
-- �������� ��� ����

EXECUTE chat_package.chat_update_name(3, 'NEW NAME');

EXECUTE chat_package.chat_delete(1);


SELECT
    *
FROM
    TABLE ( user_package.get_users );