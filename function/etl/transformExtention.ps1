
# フォルダ内拡張子変換
#
# @param    TransformedExtCode                  変換対象拡張子
# @param    TransformExtCode                    変換先拡張子
# @param    TransformDirCode                    拡張子変換対象Directory
# @param    TransformAbsolute                   拡張子変換対象絶対パス
# @param    TransformRelative                   拡張子変換対象相対パス
# @param    Log                                 ログ出力

function global:transformExtention {
    Param(
        [ArgumentCompleter({getAllExtCode})][ValidateScript({$_ -in $(getAllExtCode)})][String] $TransformedExtCode = "JPEG",
        [ArgumentCompleter({getAllExtCode})][ValidateScript({$_ -in $(getAllExtCode)})][String] $TransformExtCode = "JPG",
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $TransformDirCode = "Test",
        [String] $TransformAbsolute,
        [String] $TransformRelative,
        [switch] $Log = $false
    )

    # Path設定
    $splatting = @{
        DirCode     = $TransformDirCode
        Absolute    = $TransformAbsolute
        Relative    = $TransformRelative
    }
    $path = getPath @splatting

    Set-Location $path
    $file = Get-ChildItem -File | extractExt -Ext1 $TransformedExtCode
    for ($i=0; $i -lt $file.count; $i++){
        $newName = $file[$i].Basename + (getExtCode -ExtCode $TransformExtCode)
        Rename-Item $file[$i].Name $newName
    }
    if ($Log) {
        Write-Output $_
        $file | Select-Object Length, fullname, LastWriteTime
        Write-Output ========================================
    }
}