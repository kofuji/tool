Option Explicit

Dim strHostName
strHostName = LCase(Mid(WScript.FullName, _
              InStrRev(WScript.FullName,"\") + 1))


'�}�E�X�萔
Const MOUSEEVENTF_ABSOLUTE = &H8000
Const MOUSE_MOVE = &H1
Const MOUSEEVENTF_LEFTDOWN = &H2
Const MOUSEEVENTF_LEFTUP = &H4

Sub API_mouse_event(dwFlags, dx, dy, dwData, dwExtraInfo)
	With CreateObject("Excel.Application")
	    Call .ExecuteExcel4Macro("CALL(""user32"",""mouse_event"",""JJJJJj"", " & dwFlags & "," & dx & "," &  dy & "," &  dwData & "," &  dwExtraInfo & ")")
	End With
End Sub
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

'���b�Z�[�W�\��
WScript.StdOut.WriteLine "It will count for 10 seconds after you press the [Enter] key"
WScript.StdOut.WriteLine "To stop, press [Ctrl]+C."

'1�s�ǂݍ��ށi�mEnter�n�L�[���������ƂɑΉ��j
Dim n
n = WScript.StdIn.ReadLine()

if n <= 0 Then
    WScript.Echo "Please enter a value >= 1"
    WScript.Quit()
elseif n >= 1 Then
    WScript.Echo "Repeats the specified number of times (n=" & n & ")"
end if

Dim i
for i = 1 to n
	WScript.StdOut.WriteLine "Count: " & i
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
