import cx_Oracle as cx_Oracle


class Oracle(object):

    def connect(self, username, password, hostname, port, servicename):
        try:
            self.db = cx_Oracle.connect(username, password
                                        , hostname + '/' + servicename)
        except cx_Oracle.DatabaseError as e:

            raise
        return self.db

    def openCursor(self):
        try:
            self.openCursor()
        except cx_Oracle.DatabaseError:
            raise

    def closeCursor(self):
        try:
            self.closeCursor()
        except cx_Oracle.DatabaseError:
            raise

    def disconnect(self):
        try:
            self.db.close()
        except cx_Oracle.DatabaseError:
            pass
