#!/usr/bin/env python

import os

DATA_ROOT =  "/var/tmp/data"

def can_write_to_file(file):
    can_write = False
    writeFile = open(file,"w")
    try:
        writeFile.write("Testing for disk check")
        can_write = True
    except IOError,OSError:
        pass
    finally:
        writeFile.close()
    # clean up
    try:
        os.remove(file)
    except OSError, e:
        pass

    return(can_write)
	
return can_write_to_file("%s/test.txt" % DATA_ROOT)