
# �t�H���_���t�@�C���𒊏o���āA�ړI�n�Ɉړ�
#
# @param    SourceDirCode                           �\�[�XDirectory
# @param    SourceAbsolute                          �\�[�X��΃p�X
# @param    SourceRelative                          �\�[�X���΃p�X
# @param    DestinationDirCode                      �ړI�nDirectory
# @param    DestinationAbsolute                     �ړI�n��΃p�X
# @param    DestinationRelative                     �ړI�n���΃p�X

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

    # �ړI�nPath�ݒ�
    $destinationSplatting = @{
        DirCode     = $DestinationDirCode
        Absolute    = $DestinationAbsolute
        Relative    = $DestinationRelative
    }
    $destinationPath = getPath @destinationSplatting
    # �\�[�XPath�ݒ�
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