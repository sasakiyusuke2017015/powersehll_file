enum DirCode {
    Current
    Empty
    Git
    PowerShell
}
function global:getAllDirCode {
    return [enum]::GetNames([DirCode])
}
function global:getDirCode {
    Param (
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = "PowerShell",
        [switch] $Change = $false,
        [switch] $Clip = $false,
        [switch] $Open = $false
    )
    switch ($DirCode) {
        Git {
            $dir = ""
        }
        PowerShell {
            $dir = (getDirCode -DirCode Git) + "\powershell_file"
        }
        Current {
            $dir = Convert-Path .
        }
        Empty {
            $dir = $SYMBOL_EMPTY
        }
        default {
            writeMessageHost "invalid argument" -Break
        }
    }
    if ($Change) {
        Set-Location $dir
    }
    if ($Clip) {
        Set-Clipboard $dir
    }
    if ($Open) {
        Invoke-Item $dir
    }
    return $dir
}
Set-Alias gtd getDirCode