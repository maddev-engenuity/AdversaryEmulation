#!/bin/env python3

import argparse


def auto_int(x):
	return int(x, 0)


def append_file(source, dest, seek=None):

	with open(source, 'rb') as in_file:
		data = in_file.read()

	with open(dest, 'ab') as out_file:
		if seek:
			seek_length = seek - out_file.tell()
			out_file.write(bytearray((chr(0) * seek_length).encode('utf-8')))

		print(source + ' start byte is: 0x%0.8x' % out_file.tell())
		out_file.write(data)
		print(source + ' end byte is: 0x%0.8x' % out_file.tell())


def parse_arguments():
	parser = argparse.ArgumentParser(prog='append_file.py', description='Append the binary contents of a file to another file at a specific offset.')
	parser.add_argument('-s', '--source', required=True, action='store', help='File with contents to append to other file.')
	parser.add_argument('-d', '--dest', required=True, action='store', help='File to append contents to.')
	parser.add_argument('--seek', type=auto_int, action='store', help='Offset on destination file to seek to before appending contents. Seek value should be greater than destination file length.')
	args = parser.parse_args()
	return args


def main():
	args = parse_arguments()
	append_file(args.source, args.dest, args.seek)


if __name__ == '__main__':
	main()