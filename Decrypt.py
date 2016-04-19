from Crypto.Cipher import AES
import binascii
fi = open('keys.txt', 'r')
AES_Key = fi.readline()
fi.close()

filename = raw_input("Enter file name: ")
print ("Decrypting " + filename + "...")
fi = open(filename, 'r')
ciphertxt_hex = fi.read()
ciphertxt = binascii.unhexlify(ciphertxt_hex)
print "size of ciphertxt = " + str(len(ciphertxt))

IVblock = 'This is an IV456'
obj2 = AES.new(AES_Key, AES.MODE_CBC, IVblock)
decipheredtext = obj2.decrypt(ciphertxt)

filename = "DECRYPTED_" + filename
fo = open(filename, 'w')
fo.write(decipheredtext)
fo.close()
print ("File decryption is done!")
