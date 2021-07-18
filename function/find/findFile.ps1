
# 対象Directory内のFileまたはDirectoryをタイトルで検索する
#
# @param    Title                           検索タイトル
# @param    DirCode                         検索対象 Directory
# @param    Absolute                        検索対象 絶対Path
# @param    Relative                        検索対象 相対Path
# @param    Include                         File名に含む文字列
# @param    Exclude                         File名に含まない文字列
# @param    Type                            File or Directory
# @param    Unrecurse                       非再帰検索フラグ
# @param    OutPut                          テキスト出力フラグ
# @param    OutputTitle                     出力テキストタイトル
# @param    OutputHeader                    出力テキストヘッダー
# @param    OutputDirCode                   出力テキストDirectory
# @param    OutputAbsolute                  出力テキスト絶対パス
# @param    OutputRelative                  出力テキスト相対パス
#
# @return   検索結果
function global:findFile {
    Param (
        [String] $Title,
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = $STR_CURR,
        [String] $Absolute,
        [String] $Relative,
        [String] $Include,
        [String] $Exclude,
        [ValidateSet("File", "Directory")][String] $Type = $STR_FILE,
        [switch] $Unrecurse = $false,
        [switch] $OutPut = $false,
        [String] $OutputTitle,
        [String] $OutputHeader,
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $OutputDirCode = $STR_EMP,
        [String] $OutputAbsolute,
        [String] $OutputRelative
    )
    $splatting = @{
        Title                       = $Title
        DirCode                     = $DirCode
        Absolute                    = $Absolute
        Relative                    = $Relative
        Include                     = $Include
        Exclude                     = $Exclude
        Type                        = $Type
        BeforeLike                  = $true
        AfterLike                   = $true
        Recurse                     = !$Unrecurse
    }

    $result = find @splatting

    # テキスト出力
    if ($OutPut -and ![string]::IsNullOrEmpty($result)) {
        # Path設定
        $splatting = @{
            DirCode     = $OutputDirCode
            Absolute    = $OutputAbsolute
            Relative    = $OutputRelative
        }
        $outputPath = getPath @splatting

        # Title設定
        if ([string]::IsNullOrEmpty($OutputTitle)) {
            if ([string]::IsNullOrEmpty($Title)) {
                $OutputTitle = createRandomStr -Type $STR_CHR -ByteSize 10
            } else {
                $OutputTitle = $Title
            }
        }
        $outputSplatting = @{
            Title       = $OutputTitle
            Body        = $result
            Header      = $OutputHeader
            Path        = $outputPath
            ExtCode     = $STR_TXT
        }
        outputText @outputSplatting
    } else {
        Write-Output $result
    }
}

Set-Alias fdf findFile
