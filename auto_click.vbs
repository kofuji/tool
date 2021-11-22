Option Explicit
Dim Excel
Set Excel = WScript.CreateObject("Excel.Application")
Dim strHostName
strHostName = LCase(Mid(WScript.FullName, InStrRev(WScript.FullName,"\") + 1))

'もしホストがwscript.exeなら
If strHostName = "wscript.exe" Then
    MsgBox "cscript.exeで実行してください。"
    'スクリプトを終了する
    WScript.Quit()
End If

'cscript.exeなら処理が続行する
WScript.StdOut.WriteLine "Start the process:"

Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")

'マウス定数
Const MOUSEEVENTF_ABSOLUTE = &H8000
Const MOUSE_MOVE = &H1
Const MOUSEEVENTF_LEFTDOWN = &H2
Const MOUSEEVENTF_LEFTUP = &H4

Sub API_mouse_event(dwFlags, dx, dy, dwData, dwExtraInfo)
	Call Excel.ExecuteExcel4Macro("CALL(""user32"",""mouse_event"",""JJJJJj"", " & dwFlags & "," & dx & "," &  dy & "," &  dwData & "," &  dwExtraInfo & ")")
End Sub

Sub API_SetCursorPos(x,y)
	Call Excel.ExecuteExcel4Macro("CALL(""user32"",""SetCursorPos"",""JJJJJ"", " & x & "," &  y & ")")
End Sub

'Function API_GetCursorPos()
'	API_GetCursorPos = Array(0)
'	API_GetCursorPos = Excel.ExecuteExcel4Macro("CALL(""user32"",""GetCursorPos"",""JJ"")")
'End Function

Function API_GetMessagePos()
    Dim strHex, x, y
    strHex = Right("00000000" & Hex(Excel.ExecuteExcel4Macro("CALL(""user32"",""GetMessagePos"",""J"")")), 8)
    x = CLng("&H" & Right(strHex, 4))
    y = CLng("&H" &  Left(strHex, 4))
    API_GetMessagePos = Array(x, y)
End Function

'メッセージ表示
WScript.StdOut.WriteLine "クリックしたい場所にカーソルを合わせて[Enter]を押してください"
'1行読み込む（［Enter］キーを押すことに対応）
WScript.StdIn.ReadLine()
Dim point
point = API_GetMessagePos()
WScript.StdOut.WriteLine "x = "& point(0) & ", y = " & point(1)

WScript.StdOut.WriteLine "繰り返しの回数を数字で入力し、[Enter]を押してください。"
WScript.StdOut.WriteLine "[Ctrl]+C.で中止します"

Dim n
n = WScript.StdIn.ReadLine()

if n <= 0 Then
    WScript.Echo "Please enter a value >= 1"
    WScript.Quit()
elseif n >= 1 Then
    WScript.Echo "Repeats the specified number of times (i = 1 to " & n & ")"
end if

Dim i
for i = 1 to n
	WScript.StdOut.WriteLine "Count: " & i
	Call API_SetCursorPos(point(0),  point(1))
	Call API_mouse_event(MOUSEEVENTF_LEFTDOWN Or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
	WshShell.SendKeys "{PGDN}"
	WScript.Sleep 1000
	
	Dim intCounter
	For intCounter = 1 To 10 '何秒待つか
	    '1秒待つ
	    WScript.Sleep 1000
	    '進捗を示す■を表示する
	    WScript.StdOut.Write "■"
	Next
	'改行する
	WScript.StdOut.Write vbCrLf
Next
