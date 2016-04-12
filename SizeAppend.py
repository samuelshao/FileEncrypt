import os
def SizeAppend(name):
	statinfo = os.stat(name)
	while ((statinfo.st_size % 16 == 0) == False):
		fi = open(name, 'a+')
		fi.write('\n')
		fi.close()
		statinfo = os.stat(name)
	return print("File size appended successfully")