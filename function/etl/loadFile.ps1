
# フォルダ内ファイルを抽出して、目的地に移動
#
# @param    SourceDirCode                           ソースDirectory
# @param    SourceAbsolute                          ソース絶対パス
# @param    SourceRelative                          ソース相対パス
# @param    DestinationDirCode                      目的地Directory
# @param    DestinationAbsolute                     目的地絶対パス
# @param    DestinationRelative                     目的地相対パス

function global:loadFile {
    Param(
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DestinationDirCode = "Test",
        [String] $DestinationAbsolute,
        [String] $DestinationRelative,
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $SourceDirCode = "Temporary",
        [String] $SourceAbsolute,
        [String] $SourceRelative,
        [switch] $Log = $false

    )

    # 目的地Path設定
    $destinationSplatting = @{
        DirCode     = $DestinationDirCode
        Absolute    = $DestinationAbsolute
        Relative    = $DestinationRelative
    }
    $destinationPath = getPath @destinationSplatting
    # ソースPath設定
    $sourceSplatting = @{
        DirCode     = $SourceDirCode
        Absolute    = $SourceAbsolute
        Relative    = $SourceRelative
    }
    $sourcePath = getPath @sourceSplatting


    Set-Location $sourcePath
    $arrowExt = @("TXT", "JPG", "JPEG", "GIF", "PNG", "XLSX", "XLS", "MP4")
    $arrowExt | ForEach-Object {
        $file = Get-ChildItem -File | extractExt -Ext1 $_
        for ($i=0; $i -lt $file.count; $i++){
            Move-Item $file[$i].Name $destinationPath
        }
        if ($Log) {
            Write-Output $_
            $file | Select-Object Length, fullname, LastWriteTime
            Write-Output ========================================
        }
    }
}