Option Explicit
Dim Excel
Set Excel = WScript.CreateObject("Excel.Application")
Dim strHostName
strHostName = LCase(Mid(WScript.FullName, InStrRev(WScript.FullName,"\") + 1))

'�����z�X�g��wscript.exe�Ȃ�
If strHostName = "wscript.exe" Then
    MsgBox "cscript.exe�Ŏ��s���Ă��������B"
    '�X�N���v�g���I������
    WScript.Quit()
End If

'cscript.exe�Ȃ珈�������s����
WScript.StdOut.WriteLine "Start the process:"

Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")

'�}�E�X�萔
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

'���b�Z�[�W�\��
WScript.StdOut.WriteLine "�N���b�N�������ꏊ�ɃJ�[�\�������킹��[Enter]�������Ă�������"
'1�s�ǂݍ��ށi�mEnter�n�L�[���������ƂɑΉ��j
WScript.StdIn.ReadLine()
Dim point
point = API_GetMessagePos()
WScript.StdOut.WriteLine "x = "& point(0) & ", y = " & point(1)

WScript.StdOut.WriteLine "�J��Ԃ��̉񐔂𐔎��œ��͂��A[Enter]�������Ă��������B"
WScript.StdOut.WriteLine "[Ctrl]+C.�Œ��~���܂�"

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
	For intCounter = 1 To 10 '���b�҂�
	    '1�b�҂�
	    WScript.Sleep 1000
	    '�i������������\������
	    WScript.StdOut.Write "��"
	Next
	'���s����
	WScript.StdOut.Write vbCrLf
Next
