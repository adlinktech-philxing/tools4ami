import os
import sys
import git
import shutil
import stat

def file_is_hidden(p):
    return p.startswith('.') #linux-osx

def rmtree(top):
    for root, dirs, files in os.walk(top, topdown=False):
        for name in files:
            filename = os.path.join(root, name)
            os.chmod(filename, stat.S_IWUSR)
            os.remove(filename)
        for name in dirs:
            os.rmdir(os.path.join(root, name))
    os.rmdir(top)      

repo_url='git@GitLab.Adlinktech.com:CRB/AMI_Build_Tool.git'
repo_folder='C:\BIOS\AMI_Build_Tool'
zip_folder='C:\BIOS\AMI_Build_Tools'
if len(sys.argv) > 1:
    repo_url=sys.argv[1]

if len(sys.argv) > 2:
    repo_folder=sys.argv[2]

if len(sys.argv) > 3:
    zip_folder=sys.argv[3]

if os.path.isdir(repo_folder):
    rmtree(repo_folder)
repo = git.Repo.clone_from(repo_url, repo_folder)
os.chdir(zip_folder)

for zipname in os.listdir("."):
    if zipname.endswith(".zip"):
        # clear target
        os.chdir(repo_folder)
        file_list = [f for f in os.listdir(repo_folder) if not file_is_hidden(f)]
        for p in file_list:
            if os.path.isdir(p):
                shutil.rmtree(p, ignore_errors=True)
            else:
                os.remove(p)
        os.chdir(zip_folder)

        # clear zip target
        folder=os.path.splitext(zipname)[0]
        tagname=folder[len("Aptio_5.x_TOOLS_"):]
        if os.path.isdir(folder):
            shutil.rmtree(folder, ignore_errors=True)
        # unzip source
        shutil.unpack_archive(zipname)
        # move to target
        for file in os.listdir(folder):
            shutil.move(os.path.join(folder,file), os.path.join(repo_folder,file))
        # git commit change
        repo.git.add('.')
        repo.git.commit('-m',folder)
        repo.create_tag(tagname)
        print('tag ',tagname, ' ', folder)
        