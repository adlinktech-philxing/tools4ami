# this py will be checkout the adlink build tool(argv[1]) to the version indicated in *.veb
import sys
import os
import git
from pathlib import Path

aptiov_tools_adl_mod_dir="C:\aptiov_tools_adl_mod"
projectname="NanoX-EL"

action="BuildAll"

if len(sys.argv)>1:
    aptiov_tools_adl_mod_dir=Path(sys.argv[1]).parent
if len(sys.argv)>2:
    projectname=sys.argv[2]

vebfile=projectname+'.veb'

# for debug
# os.chdir('C:\\Temp\\Elkhartlake')

# check existence of VEB file
if (not os.path.exists(vebfile)):
    sys.exit(1)
# get tool version
with open(vebfile, 'r') as sdlFileH:
    sdlFileLines=sdlFileH.readlines()
    sdlFileH.seek(0)
    changeValue=False
    newlines=[]
    for line in sdlFileLines:
        if (action in line):
            words=line.split()
            toolversion=words[4]
            if toolversion[-1]=='"':
                toolversion=words[4][:-1]
            break;
# git reset to the latest commit of tool version indeicated
if len(toolversion) > 0:
    # init Repo
    tool_repo = git.Repo(aptiov_tools_adl_mod_dir)
    # find latest of tool version indicated
    tags=tool_repo.tags
    for i in range(len(tags)):
        if toolversion==tags[i].name:
            if i==len(tags)-1:
                # nexttag=toolversion
                nexttagcommit=tags[i].commit.hexsha
            else:
                # nexttag=tags[i+1].name
                nexttagcommit=tags[i+1].commit.parents[0].hexsha
            break
    tool_repo.git.reset('--hard', nexttagcommit)
    tool_repo.git.clean('-xdf')
    print('Checkout tool to latest', toolversion)
