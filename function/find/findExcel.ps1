
function global:findExcel {
    Param (
        [parameter(mandatory=$true)][String] $Word,
        [String] $Title,
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = $STR_CURR,
        [String] $Absolute,
        [String] $Relative,
        [String] $Include,
        [String] $Exclude,
        [switch] $Unrecurse = $false
    )
    $splatting = @{
        Title       = $Title
        DirCode     = $DirCode
        Absolute    = $Absolute
        Relative    = $Relative
        Include     = $Include
        Exclude     = $Exclude
        Type        = $STR_FILE
        Unrecurse   = $Unrecurse
    }
    $paths = findFile @splatting

    $paths = $paths | extractValidPath | extractExt -Ext1 XLS -Ext2 XLSX  -Ext3 XLSM

    $excel = New-Object -ComObject Excel.Application

    $paths | ForEach-Object {
        $excelPath = $_
        $wb = $excel.Workbooks.Open($excelPath)
        $wb.Worksheets | ForEach-Object {
            $ws = $_
            $wsName = $ws.Name
            $first = $target = $ws.Cells.Find($word)
            while (![string]::IsNullOrEmpty($target)) {
                Write-Output "$excelPath[$wsName)][$($target.Row), $($target.Column)] : $($target.Text)"
                $target = $ws.Cells.FindNext($target)
                if ($target.Address() -eq $first.Address()) {
                    break
                }
            }
        }
        $wb.Close(0)
    }
    $excel.Quit()

    $ws = $null
    $wb = $null
    $excel = $null
    [System.GC]::Collect([System.GC]::MaxGeneration)


}

Set-Alias fde findExcel
