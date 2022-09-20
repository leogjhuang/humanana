import shutil
import os

origin = '/Users/georgew/Downloads/img_align_celeba'
target = '/Users/georgew/CodeProjects/PythonProjects/humanana/training/human'

counter = 0
for root, dirs, files in os.walk(origin):
    for file in files:
        counter += 1
        if counter < 1900:
            path_file = os.path.join(root, file)
            shutil.copy2(path_file, target)
        else:
            break
            # counter = 0


#
# for root, dirs, files in os.walk(origin):  # replace the . with your starting directory
#    for file in files:
#       path_file = os.path.join(root,file)
#       shutil.copy2(path_file,target) # change you destination dir