from Crypto.Cipher import AES
filename = 'ov7670_top_deciphered.v'
fi = open('keys.txt', 'r')
AES_Key = fi.readline()
fi.close()
fi = open('cipher.txt', 'r')
ciphertxt = fi.read()
IVblock = 'This is an IV456'
obj2 = AES.new(AES_Key, AES.MODE_CBC, IVblock)
decipheredtext = obj2.decrypt(ciphertxt)
fo = open(filename, 'w')
fo.write(decipheredtext)
fo.close()
print ("File decryption is done!")
