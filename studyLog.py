import sqlite3
import datetime
import csv
from contextlib import closing
#■withの処理内容
#「開始」と「終了」がセットになる処理で、
#with文を使って「開始」すると、処理実行後に自動で「終了」してくれる。
#・DBにアクセスし処理後に終了するなど。

dbname = './database.db'

with closing(sqlite3.connect(dbname)) as connection:
    cursor = connection.cursor()
    sql = 'create table if not exists test_master (no int primary key, question text, answer text, category text)'
    cursor.execute(sql)
    sql = 'create table if not exists read_csv (no integer primary key, question text, answer text, category text)'
    cursor.execute(sql)
    sql = 'create table if not exists study_log (date date, no int, result text)'
    cursor.execute(sql)
    sql = 'create table if not exists Scheduled_Date(no int, last date, Scheduled_Date date, F0 int, F1 int)'
    cursor.execute(sql)

def csv_read():
    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()
        sql = 'delete from read_csv'
        open_csv = open("test.csv")
        read_csv = csv.reader(open_csv)
        rows = []
        
        for row in read_csv:
            rows.append(row)
        sql = 'insert into read_csv (question, answer) VALUES (?, ?)'
        cursor.executemany(sql, rows)
        connection.commit()
        
        sql = "insert into test_master select * from read_csv csv \
        where not exists(\
        select 'X' from test_master \
        where test_master.question = csv.question and test_master.answer = csv.answer)"
        cursor.execute(sql)
        
        connection.commit()
        connection.close()
        open_csv.close()

def add_QA():
    print("登録する問題文を入力してください")
    input_Ques = str(input())
    print("登録する正答を入力してください")
    input_Ans = str(input())
    
    f = open('test.csv', 'a')
    writer = csv.writer(f, lineterminator='\n')
    writer.writerow([input_Ques,input_Ans])
    f.close()

    with closing(sqlite3.connect(dbname)) as connection:
        cursor = connection.cursor()
        cursor.execute("select max(no) from test_master")
        connection.commit()
        maxno = cursor.fetchone()
        
        sql = "insert into test_master (Question, Answer) values (?, ?)"
        data = [input_Ques, input_Ans]
        cursor.execute(sql, data)
        connection.commit()
        
        sql = "insert into Scheduled_Date (no, Scheduled_Date, F0, F1) values (?, 1999/1/1, 1, 0)"
        data = [maxno[0]+1]
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
        sql = 'select no, question, answer from test_master'
        cursor.execute(sql)
        for row in cursor.fetchall():
            print(row[1], sep = "", end = "\n")
            your_ans = str(input())
            if your_ans == "exit()":
                break
            elif row[2]==your_ans:
                flg = "正解"
            else:
                flg = "不正解"
            sql = "insert into study_log (date, no ,result) values (?, ?, ?)"
            data = [datetime.date.today(), row[0], flg]
            cursor.execute(sql, data)
            connection.commit()
            print(flg)
        connection.close()

csv_read()
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

