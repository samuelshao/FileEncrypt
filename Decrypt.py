from Crypto.Cipher import AES
import binascii

def Decrypt(filename):

	#Fetch the key
	fi = open('keys.txt', 'r')
	AES_Key = fi.readline()
	fi.close()

	#Read encrypted file and convert into raw binary
	print ("Decrypting " + filename + "...")
	fi = open(filename, 'r')
	ciphertxt_hex = fi.read()
	ciphertxt = binascii.unhexlify(ciphertxt_hex)
	
	#Initialization vector (IV) declaration for
	#Cipher-Block Chaining (CBC)
	IVblock = 'This is an IV456'
	obj2 = AES.new(AES_Key, AES.MODE_CBC, IVblock)
	decipheredtext = obj2.decrypt(ciphertxt)
	
	#Write decrypted content into a new file
	newfilename = filename.replace("ENCRYPTED_", "DECRYPTED_")
	fo = open(newfilename, 'w')
	fo.write(decipheredtext)
	fo.close()
	print ("File decryption is done!")
