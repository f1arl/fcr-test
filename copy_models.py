import shutil
import os
from distutils.dir_util import copy_tree

homedir = os.environ['HOME']
sourcedir = os.getcwd()+'/weights/.insightface/models'
print(sourcedir)
destination = f'{homedir}' 
try:
    shutil.rmtree(f"{destination}/.insightface")
    print(f"{destination}/.insightface deleted")
except:
    print("Folder doesnot exist")
os.mkdir(f"{destination}/.insightface")
os.mkdir(f"{destination}/.insightface/models")
copy_tree(sourcedir, f"{destination}/.insightface/models")
print("Copy Successful")