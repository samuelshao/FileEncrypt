from SizeAppend import SizeAppend
from Crypto.Cipher import AES
import os
import binascii

def Encrypt(filename):
	print ("encrypting " + filename + "...")

	#Calls SizeAppend to make sure content size is a multiple of 16
	plaintxt = SizeAppend(filename)
	
	#Fetches the encryption key
	fi = open('keys.txt', 'r')
	AES_Key = fi.readline()
	fi.close()

	#Cipher-Block Chaining (CBC) mode
	#Each of the ciphertext blocks depends on the
	#current and all previous plaintext blocks
	#An Initialization Vector (IV) is required.
	IVblock = 'This is an IV456'
	obj = AES.new(AES_Key, AES.MODE_CBC, IVblock)
	ciphertext = obj.encrypt(plaintxt)
	
	#Converts the ciphertext from raw binary into hex
	#Writes into a new file
	ciphertext_hex = binascii.hexlify(ciphertext)
	filename = "ENCRYPTED_" + filename
	fo = open(filename, 'w')
	fo.write(ciphertext_hex)
	fo.close()

	print ("File encryption is done!")