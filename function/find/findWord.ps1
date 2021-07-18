function global:findWord {
	Param (
		[parameter(mandatory = $true)] $Word,
		[string] $Title,
		[switch] $CaseSensitive = $false,
		[ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = $STR_CURR,
		[String] $Absolute,
		[String] $Relative,
		[String] $Include,
		[String] $Exclude,
		[ValidateSet("ALL", "SJIS", "UTF8", "EXCEL")][String] $Type = $STR_ALL,
        [switch] $Unrecurse = $false,
		[switch] $OutPut = $false,
		[String] $OutputTitle,
		[String] $OutputHeader,
		[ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $OutputDirCode = $STR_EMP,
		[String] $OutputAbsolute,
		[String] $OutputRelative
	)
	$result = @()

	if (($Type -eq $STR_ALL -or $Type -eq $STR_EXCE)) {
		$slsSplatting = @{
			Word		= $Word
			Title		= $Title
			DirCode		= $DirCode
			Absolute	= $Absolute
			Relative	= $Relative
			Include		= $Include
			Exclude		= $Exclude
			Unrecurse  	= $Unrecurse
		}
		$result += findExcel @slsSplatting
	}

	if (($Type -eq $STR_ALL) -or ($Type -eq $STR_SJIS) -or ($Type -eq $STR_UTF8)) {
		$splatting = @{
			DirCode	 	= $DirCode
			Absolute	= $Absolute
			Relative	= $Relative
		}

		# 対象Path設定
		$splatting = @{
			Title		= $Title
			DirCode		= $DirCode
			Absolute	= $Absolute
			Relative	= $Relative
			Include		= $Include
			Exclude		= $Exclude
			Type		= $STR_FILE
			Unrecurse	= $Unrecurse
		}
		$searchPaths = findFile @splatting

		$txtSjisPaths = $searchPaths | extractValidPath | extractExt -Ext1 CSS -Ext2 SCSS -Ext3 HTML -Ext4 PS1 -Ext5 TXT -Ext6 VUE
		$txtUtf8Paths = $searchPaths | extractValidPath | extractExt -Ext1 JAVA -Ext2 JS -Ext3 JSON -Ext4 JSX -Ext5 SQL -Ext6 TS -Ext7 TSX -Ext8 PY

		if (![string]::IsNullOrEmpty($txtSjisPaths) -and ($Type -eq $STR_ALL -or $Type -eq $STR_SJIS)) {
			$slsSplatting = @{
				Path			= $txtSjisPaths
				Pattern			= $Word
				CaseSensitive	= $CaseSensitive
				Encoding		= $STR_DEF
			}
			$result += Select-String @slsSplatting
		}
		if (![string]::IsNullOrEmpty($txtUtf8Paths) -and ($Type -eq $STR_ALL -or $Type -eq $STR_UTF8)) {
			$slsSplatting = @{
				Path			= $txtUtf8Paths
				Pattern			= $Word
				CaseSensitive	= $CaseSensitive
			}
			$result += Select-String @slsSplatting
		}
	}

	if ([string]::IsNullOrEmpty($result)) {
		writeMessageHost "No Result" -Warn
		return
	}

    # テキスト出力
	if ($OutPut -and ![string]::IsNullOrEmpty($result)) {
        # Path設定
		$splatting = @{
			DirCode	    = $OutputDirCode
			Absolute	= $OutputAbsolute
			Relative	= $OutputRelative
		}
		$outputPath = getPath @splatting

        # Title設定
        if ([string]::IsNullOrEmpty($OutputTitle)) {
			$OutputTitle = $Word
		}
		$outputSplatting = @{
			Title	    = $OutputTitle
			Body		= $result
			Header	    = $OutputHeader
			Path		= $outputPath
			ExtCode	    = $STR_TXT
		}
		outputText @outputSplatting
	} else {
		Write-Output $result
	}
}

Set-Alias fdw findWord
