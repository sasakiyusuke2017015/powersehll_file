
Set-Variable -Option constant -Scope global -Name FOLDER_ENUM       -Value "enum"
Set-Variable -Option constant -Scope global -Name FOLDER_FUNCTION   -Value "function"

Set-Variable -Option constant -Scope global -Name DEFAULT_SERVER    -Value "localhost"
Set-Variable -Option constant -Scope global -Name DEFAULT_DATABASE  -Value "orionDBF"

Set-Variable -Option constant -Scope global -Name SYMBOL_EMPTY      -Value ""
Set-Variable -Option constant -Scope global -Name SYMBOL_PLUS       -Value "+"
Set-Variable -Option constant -Scope global -Name SYMBOL_MINUS      -Value "-"
Set-Variable -Option constant -Scope global -Name SYMBOL_ASTALISK   -Value "*"
Set-Variable -Option constant -Scope global -Name SYMBOL_DOT        -Value "."
Set-Variable -Option constant -Scope global -Name SYMBOL_SEMICOLON  -Value ":"
Set-Variable -Option constant -Scope global -Name SYMBOL_UNDERSCORE -Value "_"


Set-Variable -Option constant -Scope global -Name STR_ALL       -Value "ALL"
Set-Variable -Option constant -Scope global -Name STR_CHR       -Value "CHAR"
Set-Variable -Option constant -Scope global -Name STR_CURR      -Value "Current"
Set-Variable -Option constant -Scope global -Name STR_DEF       -Value "Default"
Set-Variable -Option constant -Scope global -Name STR_DIR       -Value "Directory"
Set-Variable -Option constant -Scope global -Name STR_EMP       -Value "Empty"
Set-Variable -Option constant -Scope global -Name STR_EXCE      -Value "Excel"
Set-Variable -Option constant -Scope global -Name STR_FILE      -Value "File"
Set-Variable -Option constant -Scope global -Name STR_INT       -Value "INT"
Set-Variable -Option constant -Scope global -Name STR_NO        -Value "NO"
Set-Variable -Option constant -Scope global -Name STR_NTH       -Value "Nothing"
Set-Variable -Option constant -Scope global -Name STR_OUTP      -Value "Output"
Set-Variable -Option constant -Scope global -Name STR_SJIS      -Value "Sjis"
Set-Variable -Option constant -Scope global -Name STR_STR       -Value "STRING"
Set-Variable -Option constant -Scope global -Name STR_TXT       -Value "TXT"
Set-Variable -Option constant -Scope global -Name STR_UTF8      -Value "Utf8"
Set-Variable -Option constant -Scope global -Name STR_YES       -Value "YES"

Set-Variable -Option constant -Scope global -Name CAP_ALL       -Value $STR_ALL.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_CHR       -Value $STR_CHR.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_CURR      -Value $STR_CURR.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_DIRE      -Value $STR_DIR.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_EMP       -Value $STR_EMP.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_EXCE      -Value $STR_EXCE.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_FILE      -Value $STR_FILE.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_INT       -Value $STR_INT.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_NO        -Value $STR_NO.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_OUTP      -Value $STR_OUTP.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_SJIS      -Value $STR_SJIS.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_STR       -Value $STR_STR.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_TXT       -Value $STR_TXT.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_UTF8      -Value $STR_UTF8.Substring(0, 1)
Set-Variable -Option constant -Scope global -Name CAP_YES       -Value $STR_YES.Substring(0, 1)

$ORIGINALLY_DIRECTORY       = Convert-Path .
$MAIN_DIRECTORY             = Split-Path $MyInvocation.MyCommand.path
$MAIN_DIRECTORY_ENUM        = Join-Path $MAIN_DIRECTORY $FOLDER_ENUM
$MAIN_DIRECTORY_FUNCTION    = Join-Path $MAIN_DIRECTORY $FOLDER_FUNCTION

Set-Location $MAIN_DIRECTORY
.\common.ps1
.\filter.ps1
Get-ChildItem $MAIN_DIRECTORY_ENUM -Recurse | ForEach-Object {
    # ファイルの場合の処理
    writeMessageHost ($_.FullName + ' を読み込みます')
    . $_.FullName
}
Get-ChildItem $MAIN_DIRECTORY_FUNCTION -Recurse | extractExt -Ext1 PS1 | ForEach-Object {
    # ファイルの場合の処理
    writeMessageHost ($_.FullName + ' を読み込みます')
    . $_.FullName
}

# $URL_LIST         = Get-Content \\172.22.136.159\共有\00_共通\06_個人フォルダ\笹木\URL.txt -Encoding UTF8
# $NUMBER_LIST      = Get-Content C:\Users\jntPCadmin\Desktop\work\powershell\setting\number.txt -Encoding UTF8
# $IDIOM_LIST       = Get-Content C:\Users\jntPCadmin\Desktop\work\powershell\setting\idiom.txt -Encoding UTF8
Set-Location $ORIGINALLY_DIRECTORY

# 使用端末判定
Set-Variable -Scope global -Name MAIN_USER -Value $STR_NTH



