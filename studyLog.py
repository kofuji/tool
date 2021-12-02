import sqlite3
import datetime
import csv
from contextlib import closing

dbname = './database.db'

with closing(sqlite3.connect(dbname)) as connection:
    cursor = connection.cursor()
    sql = 'create table if not exists test_master (no integer PRIMARY KEY AUTOINCREMENT, question text, answer text, category text, last_date date, scheduled_date date, F0 int, F1 int)'
    cursor.execute(sql)
    sql = 'create table if not exists study_log (date date, no int, result text)'
    cursor.execute(sql)

def add_QA():
    print("登録する問題文を入力してください")
    input_Ques = str(input())
    print("登録する正答を入力してください")
    input_Ans = str(input())
    
    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()        
        sql = "insert into test_master (Question, Answer, scheduled_date, F0, F1) values (?, ?,'1990-01-01',1,0)"
        data = [input_Ques, input_Ans]
        cursor.execute(sql, data)
        connection.commit()
        connection.close()
    return

def check_QA():
    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()
        sql = 'select * from test_master'
        for row in cursor.execute(sql):
            print(row)
        connection.close()
    return

def start_QA():
    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()
        sql = "select no, question, answer from test_master where date('now') >= date(scheduled_date)"
        cursor.execute(sql)
        for row in cursor.fetchall():
            print(row[1], sep = "", end = "\n")
            your_ans = str(input())
            if your_ans == "exit()":
                break
            elif row[2]==your_ans:
                flg = "正解"
                data = [datetime.date.today(), row[0]]
                sql = "update test_master \
                       set last_date = ?, F0 = TM.F1, F1 = TM.F0+TM.F1, scheduled_date = date('now', TM.F1||' days')\
                       from test_master as TM \
                       where TM.no = ? and TM.no=test_master.no"
                cursor.execute(sql, data)
                print(flg)
            else:
                flg = "不正解"
                print("不正解です。正解は"+row[2]+"です。")
                while row[2] != your_ans:
                    print("再挑戦してください")
                    print(row[1])
                    your_ans = str(input())
                    if your_ans == "exit()":
                        break
                    elif row[2]==your_ans:
                        print("正解です。チェックテストを通過しました。")
                        sql = "update test_master set last_date = date('now')  where no = "+str(row[0])
                        cursor.execute(sql)
                    
            sql = "insert into study_log (date, no ,result) values (?, ?, ?)"
            data = [datetime.date.today(), row[0], flg]
            cursor.execute(sql, data)
            connection.commit()
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

