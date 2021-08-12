#!/bin/env python3

import argparse
import os


def xor(data, key):
	return bytearray([ a ^ ord(key) for a in data])


def encrypt_file(source, dest, xor_key):
	with open(source, 'rb') as in_file:
		data = in_file.read()

	data_enc = xor(data, xor_key)

	with open(dest, 'wb') as out_file:
		out_file.write(data_enc)


def parse_arguments():
	parser = argparse.ArgumentParser(prog='append_file.py', description='XOR encrypt the contents of a file.')
	parser.add_argument('-i', '--input', required=True, action='store', help='File with contents to XOR encrypt.')
	parser.add_argument('-o', '--output', required=True, action='store', help='File to place encrypted contents.')
	parser.add_argument('-k', '--key', required=True, action='store', type=str, help='Single character XOR key.')
	args = parser.parse_args()
	return args


def main():
	args = parse_arguments()
	if args.key and len(args.key) != 1:
		print('XOR key can only be one character long.')
		os.exit(1)

	print('[+] XOR encrypting {} into {} using the following single character encryption key: {}'.format(args.input, args.output, args.key))
	try:
		encrypt_file(args.input, args.output, args.key)
	except:
		print('[-] Encryption failed')
	print('[+] Encryption completed successfully')


if __name__ == '__main__':
	main()