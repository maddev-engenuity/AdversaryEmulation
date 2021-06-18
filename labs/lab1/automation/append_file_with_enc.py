#!/bin/env python3

import argparse
import base64
import os


def xor(data, key):
	return bytearray([ a ^ ord(key) for a in data])


def encode(data):
	enc_data = base64.b64encode(data)
	return enc_data


def append_file(source, dest, to_encode, xor_key, seek=None):

	with open(source, 'rb') as in_file:
		data = in_file.read()

	if to_encode:
		data = encode(data)

	if xor_key:
		data = xor(data, xor_key)

	with open(dest, 'ab') as out_file:
		if seek:
			seek_length = seek - out_file.tell()
			out_file.write(bytearray((chr(0) * seek_length).encode('utf-8')))

		print(source + ' start byte is: 0x%0.8x' % out_file.tell())
		out_file.write(data)
		print(source + ' end byte is: 0x%0.8x' % out_file.tell())


def parse_arguments():
	parser = argparse.ArgumentParser(prog='append_file.py', description='Append the binary contents of a file to another file at a specific offset. Can also encode or XOR encrypt contents before appending. If both encoding and encrypting, encoding happens first.')
	parser.add_argument('-s', '--source', required=True, action='store', help='File with contents to append to other file.')
	parser.add_argument('-d', '--dest', required=True, action='store', help='File to append contents to.')
	parser.add_argument('--seek', action='store', help='Offset on destination file to seek to before appending contents. Seek value should be greater than destination file length.')
	parser.add_argument('-b', action='store_true', dest='to_encode', help='Base64 encode content before appending.')
	parser.add_argument('-x', action='store', dest='xor_key', type=str, help='XOR encrypt content with the specified single character.')
	args = parser.parse_args()
	return args


def main():
	args = parse_arguments()
	if args.xor_key and len(args.xor_key) != 1:
		print('XOR key can only be one character long.')
		os.exit(1)

	append_file(args.source, args.dest, args.to_encode, args.xor_key, args.seek)


if __name__ == '__main__':
	main()