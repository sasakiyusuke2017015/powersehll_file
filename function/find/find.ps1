
# 汎用ファイル検索
#
# @param    Title                           検索タイトル
# @param    DirCode                         検索対象 Directory
# @param    Absolute                        検索対象 絶対Path
# @param    Relative                        検索対象 相対Path
# @param    Include                         File名に含む文字列
# @param    Exclude                         File名に含まない文字列
# @param    Type                            File or Directory
# @param    BeforeLike                      前方Like検索フラグ
# @param    AfterLike                       後方Like検索フラグ
# @param    Recurse                         再帰検索フラグ
# @param    OutPut                          テキスト出力フラグ
# @param    OutputTitle                     出力テキストタイトル
# @param    OutputHeader                    出力テキストヘッダー
# @param    OutputDirCode                   出力テキストDirectory
# @param    OutputAbsolute                  出力テキスト絶対パス
# @param    OutputRelative                  出力テキスト相対パス
#
# @return   検索結果
function global:find {
    Param (
        [String] $Title,
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = $STR_CURR,
        [String] $Absolute,
        [String] $Relative,
        [String] $Include,
        [String] $Exclude,
        [ValidateSet("File", "Directory")][String] $Type = $STR_FILE,
        [switch] $BeforeLike = $false,
        [switch] $AfterLike = $false,
        [switch] $Recurse = $false,
        [switch] $OutPut = $false,
        [String] $OutputTitle,
        [String] $OutputHeader,
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $OutputDirCode = $STR_EMP,
        [String] $OutputAbsolute,
        [String] $OutputRelative
    )

	# Path設定
    $splatting = @{
        DirCode     = $DirCode
        Absolute    = $Absolute
        Relative    = $Relative
    }
    $path = getPath @splatting

    $search = ""
    if (![string]::IsNullOrEmpty($Title)) {
        $search = $Title
        if ($BeforeLike) {
            $search = $SYMBOL_ASTALISK + $search
        }
        if ($AfterLike) {
            $search = $search + $SYMBOL_ASTALISK
        }
    }
    if (![string]::IsNullOrEmpty($Include)) {
        $Include = $SYMBOL_ASTALISK + $Include + $SYMBOL_ASTALISK
    }
    if (![string]::IsNullOrEmpty($Exclude)) {
        $Exclude = $SYMBOL_ASTALISK + $Exclude + $SYMBOL_ASTALISK
    }

    $findSplatting = @{
        Filter      = $search
        Path        = $path
        Recurse     = $Recurse
        File        = ($Type -eq $STR_FILE)
        Directory   = ($Type -eq $STR_DIR)
        Include     = $Include
        Exclude     = $Exclude
    }

    $result = (Get-ChildItem @findSplatting).FullName
    if ([string]::IsNullOrEmpty($result)) {
        writeMessageHost "No Result" -Warn
        return
    }

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
            $OutputTitle = $Title
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

Set-Alias fd find