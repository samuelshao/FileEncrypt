import os
def SizeAppend(name):
	fi = open(name, 'rw')
	statinfo = os.stat(name)
	
	return statinfo.st_size