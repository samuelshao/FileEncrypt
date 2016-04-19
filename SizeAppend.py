import os
def SizeAppend(name):
	filesize = os.stat(name).st_size
	fi = open(name, 'r')
	text = fi.read()
	#print "size of file = " + str(int(filesize))
	#print "size of text = " + str(len(text))
	appendnum = 16 - (int(len(text)) % 16)
	appendstr = ' ' * appendnum
	fi.close()
	text += appendstr
	#print "size of text after appending = " + str(len(text))
	return text