from SizeAppend import SizeAppend
from Crypto.Cipher import AES
import os
import binascii
filename = raw_input("Enter file name: ")
print ("encrypting " + filename + "...")

plaintxt = SizeAppend(filename)
#fi = open(tempfile, 'r')
#plaintxt = fi.read()
#fi.close()
#os.remove(tempfile)

fi = open('keys.txt', 'r')
AES_Key = fi.readline()
fi.close()

IVblock = 'This is an IV456'
obj = AES.new(AES_Key, AES.MODE_CBC, IVblock)
ciphertext = obj.encrypt(plaintxt)

filename = "ENCRYPTED_" + filename
fo = open(filename, 'w')
print "size of ciphertext = " + str(len(ciphertext))
ciphertext_hex = binascii.hexlify(ciphertext)
fo.write(ciphertext_hex)
fo.close()

print ("File encryption is done!")