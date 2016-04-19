#FileEncrypt
from Encrypt import Encrypt
from Decrypt import Decrypt
print "-This is a short file encryption program written in Python"
print "-To encrypt, enter \"encrypt <filename>\""
print "-To decrypt, enter \"decrypt <filename>\""
print "-Please note that you must have a key stored in a text file to use this program"

command = raw_input("Enter program option: ")
print command
commandparse = command.split(" ") #parse command

if commandparse[0] == "encrypt":
	Encrypt(commandparse[1])
elif commandparse[0] == "decrypt":
	Decrypt(commandparse[1])
