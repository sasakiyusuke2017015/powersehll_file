# �m�F�_�C�A���O���o�͂���
#
# @param    Title       �^�C�g��
# @param    Message     �m�F���b�Z�[�W
# @param    TipYes      Yes�{�^��
# @param    TipNo       No�{�^��
#
# @return   ���ʁiY=0 | N=1�j
function global:confirmYesNoDialog {
    Param (
        [string] $Title = "*** ���s�m�F ***",
        [string] $Message = "���s���Ă�낵���ł����H",
        [string] $TipYes = "���s����",
        [string] $TipNo = "���s���Ȃ�"
    )
    $objYes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",$TipYes
    $objNo = New-Object System.Management.Automation.Host.ChoiceDescription "&No",$TipNo
    $objOptions = [System.Management.Automation.Host.ChoiceDescription[]]($objYes, $objNo)

    return $host.ui.PromptForChoice($Title, $Message, $objOptions, 1)
}

# Host�Ɋm�F���b�Z�[�W��\������
#
# @param    Title               �^�C�g��
# @param    confirmMessage      �m�F���b�Z�[�W
# @param    Tip                 �ǋL����
# @param    errorMessage        �G���[�����b�Z�[�W
#
# @return   ���ʁiY=0 | N=1�j
function global:confirmYesNoHost {
    Param(
        [string] $Title = "*** ���s�m�F ***",
        [string] $confirmMessage = "���s���Ă�낵���ł����H",
        [string] $Tip = " �͂�=Y ������=N",
        [string] $errorMessage = " �͂�=Y ������=N ����I�΂�܂���ł����B"
    )

    Write-Output $Title
    try {
        [ValidateSet("y","Y","n","N")]$responce = Read-Host $confirmMessage $tip
    } catch {
        Write-Output $errorMessage
        break
    }

    return convertYesNo($responce)
}

# YesNo�l�ɕϊ�
#
# @param    YesNo   Y or N
#
# @return   ���ʁiY=0 | N=1�j
function global:convertYesNo ($YesNo) {
    switch ($YesNo.ToUpper()) {
        $CAP_YES {
            return 1
        }
        $CAP_NO {
            return 0
        }
        default {
            writeMessageHost "Y �܂��� N �ł͂���܂���" -Break
        }
    }
}

#�t�@�C���R���e���c�擾
#
# @param    FILE
# @param    �����R�[�h
# @param    ��Ӓ��o�t���O
#
# @return   �t�@�C���R���e���c
function global:getContent {
    Param (
        [String] $File,
        [ValidateSet("Default", "UTF8")][String] $Encode = "Default",
        [switch] $Unique = $false
    )

    # $File ���ݒ肳��Ă��Ȃ�
    if ([string]::IsNullOrEmpty($File)) {
        $File = openExplore
    }

    $result = $SYMBOL_EMPTY
    if (Test-Path $File) {
        $result = Get-Content -Path $File -Encoding $Encode
    } else {
        writeMessageHost "�w��t�@�C���͑��݂��܂���" -Break
    }

    if ($Unique) {
        #����,�d���폜
        $result = $result | Sort-Object | Get-Unique
    }

    return $result
}

# �w�肵���t�@�C���̊g���q���擾
#
# @param    File    �t�@�C��
#
# @return   �g���q
function global:getExtention {
    Param (
        [string] $File
    )
    # $File ���ݒ肳��Ă��Ȃ��ꍇ
    if ([string]::IsNullOrEmpty($File)) {
        $File = openExplore
    }
    return [System.IO.Path]::GetExtension($File)
}

# Path�̎擾
#  ���ׂĂ� �� �̏ꍇ �� ��ԋp
#
# @param    DirCode     �o�^Directory
# @param    Absolute    ��΃p�X
# @param    Relative    ���΃p�X
#
# @return   Path
function global:getPath {
    Param(
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = $STR_CURR,
        [String] $Absolute,
        [String] $Relative
    )
    $dir = getDirCode -DirCode $DirCode
    if ([string]::IsNullOrEmpty($dir) -and [string]::IsNullOrEmpty($Absolute) -and [string]::IsNullOrEmpty($Relative)) {
        return $SYMBOL_EMPTY
    } elseif ([string]::IsNullOrEmpty($Absolute)) {
		$path = Join-Path $dir $Relative
	} else {
		$path = Join-Path $Absolute $Relative
    }
    if (!(Test-Path $path)) {
        writeMessageHost "Path ���s���ł�" -Break
    }

    return $path
}

# �G�N�X�v���[���[���J���t�@�C����I��������
#
# @param    DirCode             �o�^Directory
# @param    Multi               �����I���t���O
#
# @return   �I��FILE
function global:openExplore {
    Param(
        [ArgumentCompleter({getAllDirCode})][ValidateScript({$_ -in $(getAllDirCode)})][String] $DirCode = "PowerShell",
        [switch] $Multi = $false
    )
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = $SYMBOL_EMPTY
    $dialog.InitialDirectory = (getDirCode -DirCode $DirCode)
    $dialog.Title = "�t�@�C����I�����Ă�������"
    # �����I���������������� Multiselect ��ݒ肷��
    $dialog.Multiselect = $Multi

    # �_�C�A���O��\��
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
        # �����I���������Ă��鎞�� $dialog.FileNames �𗘗p����
        return $dialog.FileNames
    }
}

# �t�@�C���o��
#
# @param    Title       �o�̓t�@�C���^�C�g��
# @param    Body        �o�̓t�@�C�����e
# @param    Header      �o�̓t�@�C�����o��
# @param    Path        �o�͐�
# @param    ExtCode     �o�̓t�@�C���g���q
function global:outputText {
    Param (
        [parameter(mandatory = $true)][String] $Title,
        [parameter(mandatory = $true)][String[]] $Body,
        [String] $Header,
        [String] $Path,
        [ArgumentCompleter({getAllExtCode})][ValidateScript({$_ -in $(getAllExtCode)})][String] $ExtCode = $STR_TXT
    )

    # Title�ݒ�
    $Title = (Get-PSCallStack)[1].Command + $SYMBOL_UNDERSCORE + $Title + (getExtCode -ExtCode $ExtCode)
	# Path�ݒ�
    if ([string]::IsNullOrEmpty($Path)) {
        $outputPath = Join-Path (Split-Path (Get-PSCallStack)[1].ScriptName -Parent) $STR_OUTP
        if (!(Test-Path $outputPath)) {
            New-Item -ItemType Directory -Path $outputPath
        }
    }

    $contents = @()
    if (![string]::IsNullOrEmpty($Header)) {
        $contents += @(
            "=====================================HEAD=========================================="
            , $Header
            , "=====================================BODY=========================================="
        )
    }
    $contents += $Body

    $output = Join-Path $outputPath $Title
    $contents > $output
    writeMessageHost ($output + " ���o�͂��܂����B")
}

# Host�ɔėp���b�Z�[�W�o��
#
# @param    Message             ���b�Z�[�W
# @param    Break               �G���[�t���O
# @param    Warn                �x���t���O
function global:writeMessageHost {
    Param(
        [parameter(mandatory = $true)] $Message,
        [switch] $Break = $false,
        [switch] $Warn = $false
    )

    if ($Break) {
        Write-Host (Get-PSCallStack)[1].Location $SYMBOL_SEMICOLON $Message -BackgroundColor Red -ForegroundColor white
        break
    } elseif ($Warn) {
        Write-Host (Get-PSCallStack)[1].Location $SYMBOL_SEMICOLON $Message -BackgroundColor Yellow -ForegroundColor Black
    } else {
        Write-Host (Get-PSCallStack)[1].Location $SYMBOL_SEMICOLON $Message
    }
}


# 10�i��N�i�ϊ�
#
# @param    Number             ���l�i�P�O�i���\�L�j
# @param    Base               �
#
# @return   ���l�iN�i���\�L�j
function global:toBaseN {
    Param (
        [parameter(mandatory = $true)][Int]$Number,
        [ValidateSet(2, 8, 10, 16)][Int]$Base = 16
    )
    return [Convert]::ToString($number,$base)
}

# N�i��10�i�ϊ�
#
# @param    Number             ���l�iN�i���\�L�j
# @param    Base               �
#
# @return   ���l�i�P�O�i���\�L�j
function global:toBase10 {
    Param (
        [parameter(mandatory = $true)]$Number,
        [ValidateSet(2, 8, 10, 16)][Int]$Base = 16
    )
    return [Convert]::ToInt32($number,$base)
}

# �p�f�B���O���s��
#
# @param    Char               �p�f�B���O����
# @param    ByteSize           ����
#
# @return   ������
function global:paddingStr {
    Param (
        [parameter(mandatory = $true)]$String,
        [ValidateLength(0, 1)][String]$Char = "0",
        [int]$ByteSize = 10
    )
    $padding = $Char * $ByteSize + $String
    return $padding.Substring($padding.Length - $ByteSize, $ByteSize)
}

# �����_�������񐶐�
#
# @param    Type               �A���t�@�x�b�g�A����(�L������)�A������I��
# @param    Base               �
# @param    ByteSize           ������
#
# @return   �����_��������
function global:createRandomStr {
    Param (
        [ValidateSet("ALL", "INT", "CHAR")][String]$Type = $STR_INT,
        [ValidateSet(2, 8, 10, 16)][Int]$Base = 10,
        [int]$ByteSize = 10
    )
    # �A�Z���u�����[�h
    Add-type -AssemblyName System.Web

    # �����^�C�v��ݒ�
    $baseMode = 0
    switch ($Type) {
        $STR_ALL {
            $reg1 = "[^a-z0-9]"
            $reg2 = ""
        }
        $STR_INT {
            $baseMode = $Base
            $reg1 = "[^0-9]"
            $reg2 = "^0+"
        }
        $STR_CHR {
            $reg1 = "[^a-z]"
            $reg2 = ""
        } default {
            writeMessageHost "Not matched. CreateRandomStr" -Break
        }
    }
    $ret = ""

    # �K�v�������ɂȂ�܂Ń����_����������
    do {
        # 32�����̃����_���ȕ�����𐶐�
        $randomString = [System.Web.Security.Membership]::GeneratePassword(32, 0)
        # �s�v������u��
        $add = $randomString | ForEach-Object {$_ -replace $reg1, ""} | ForEach-Object {$_ -replace $reg2, ""}
        # �i���ϊ�
        if ($baseMode -gt 0) {
            $add = toBaseN -Number $add -Base $Base
        }
        $ret = $ret + [string]$add
    } while ($ret.Length -le $byteSize)

    # �w�蕶�����ɂ���
    return $ret.Substring(0, $byteSize)
}