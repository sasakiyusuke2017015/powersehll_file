
#各種コード取得
#
# @param    列挙ディレクトリ
# @param    列挙拡張子
# @param    列挙URL
# @param    列挙使用端末
# @param    チェンジディレクトリ　フラグ
# @param    クリップボードコピー　フラグ
# @param    オープンアプリ　フラグ
# @param    セッティング　フラグ
#
# @return   各種コード
function global:getCode {
    Param (
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = $SYMBOL_EMPTY,
        [ArgumentCompleter({getAllExtCode})][ValidateScript({$_ -in $(getAllExtCode)})][String] $ExtCode = $SYMBOL_EMPTY,
        [ArgumentCompleter({getAllUrlCode})][ValidateScript({$_ -in $(getAllUrlCode)})][String] $UrlCode = $SYMBOL_EMPTY,
        [ArgumentCompleter({getAllUserCode})][ValidateScript({$_ -in $(getAllUserCode)})][String] $UserCode = $SYMBOL_EMPTY,
        [switch] $Change = $false,
        [switch] $Clip = $false,
        [switch] $Open = $false,
        [switch] $Set = $false

    )
    $optionSplatting = @{
        Change  = $Change
        Clip    = $Clip
        Open    = $Open
        Set     = $Set
    }

    if (![string]::IsNullOrEmpty($DirCode)) {
        getDirCode -DirCode $DirCode @optionSplatting
    }
    if (![string]::IsNullOrEmpty($ExtCode)) {
        getExtCode -ExtCode $ExtCode @optionSplatting
    }
    if (![string]::IsNullOrEmpty($UrlCode)) {
        getUrlCode -UrlCode $UrlCode @optionSplatting
    }
    if (![string]::IsNullOrEmpty($UserCode)) {
        getUserCode -UserCode $UserCode @optionSplatting
    }
}


Set-Alias gt getCode
