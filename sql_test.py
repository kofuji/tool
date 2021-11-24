import sqlite3
from contextlib import closing
dbname = 'database.db'
#■withの処理内容
#「開始」と「終了」がセットになる処理で、
#with文を使って「開始」すると、処理実行後に自動で「終了」してくれる。
#・DBにアクセスし処理後に終了するなど。
with closing(sqlite3.connect(dbname)) as connection:
    cursor = connection.cursor()
    sql = 'create table if not exists test (no integer primary key, question text, answer text, category text)'
    cursor.execute(sql)
    connection.commit()
    connection.close()
    
def add_QA():
    print("登録する問題文を入力してください")
    input_Ques = str(input())
    print("登録する正答を入力してください")
    input_Ans = str(input())
    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()
        sql = 'insert into test (question,answer) values (?,?)'
        data = (input_Ques, input_Ans)
        cursor.execute(sql, data)
        connection.commit()
        connection.close()
    return

def check_QA():
    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()
        sql = 'select * from test'
        for row in cursor.execute(sql):
            print(row)
        connection.close()
    return

def start_QA():
    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()
        sql = 'select question, answer from test'
        cursor.execute(sql)
        for row in cursor.fetchall():
            print(row[0])
            your_ans = str(input())
            if row[1]==your_ans:
                print("正解")
            else:
                print("不正解")
        connection.close()

menu = 1
while menu != 0:
    print("メニューを選択してください")
    print("1:問題を開始する")
    print("2:問題を登録する")
    print("3:登録されている問題を確認する")
    print("0:終了")    
    menu = int(input())
    
    if   menu==1:
        start_QA()
    elif menu==2:
        add_QA()
    elif menu==3:
        check_QA()

