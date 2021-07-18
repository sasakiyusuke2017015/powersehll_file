
# フォルダ内ファイル名採番
#
# @param    PaddingByteSize                     採番桁数
# @param    TransformDirCode                    ファイル名変換対象Directory
# @param    TransformAbsolute                   ファイル名変換対象絶対パス
# @param    TransformRelative                   ファイル名変換対象相対パス
# @param    Log                                 ログ出力

function global:transformName {
    Param(
        [ValidateRange(3, 10)][int] $PaddingByteSize = 10,
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
    $arrowExt = @("TXT", "JPG", "JPEG", "GIF", "PNG", "XLSX", "XLS", "MP4")
    $arrowExt | ForEach-Object {
        $file = Get-ChildItem -File | extractExt -Ext1 $_ | Sort-Object -Descending Length
        for ($i=0; $i -lt $file.count; $i++){
            $newName = $_ + (paddingStr ($i + 1) -ByteSize $PaddingByteSize) + (getExtCode -ExtCode $_)
            Rename-Item $file[$i].Name $newName
        }
        if ($Log) {
            Write-Output $_
            $file | Select-Object Length, fullname, LastWriteTime
            Write-Output ========================================
        }
    }
}