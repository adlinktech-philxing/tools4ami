# tool to update AptioV_Tools_ADL_Mod from AMI_Build_Tool
#   python updatetool.py source_dir target_dir
from distutils.cmd import Command
from operator import indexOf
import sys
import os
import subprocess

toolsourcedir="C:\BIOS\AMI_Build_Tool\BuildTools"
tooltargetdir="C:\AptioV_Tools_ADL_Mod"
txtfile="AllTools\ToolVersionTable.txt"
titleline=2
if len(sys.argv)>1:
    toolsourcedir=sys.argv[1]
if len(sys.argv)>2:
    tooltargetdir=int(sys.argv[2])

os.chdir(tooltargetdir)
# num_lines = sum(1 for line in open(txtfile))
lines=open(txtfile).readlines()

tools=lines[0].split()
tools=tools[1:-1]

onlyfiles = [f for f in os.listdir(toolsourcedir) if os.path.isfile(os.path.join(toolsourcedir, f))]

for i, tool in enumerate(tools):
    for f in onlyfiles:
        ext = f.split('.')[1]
        if ext=='jar' or ext=='exe':
            if tool.upper() == f.split('.')[0].upper():
                tools[i] = f
                onlyfiles.remove(f)
                break;

for tool in tools:
    if tool.find('.') < 0:
        continue;
    ext = tool.split('.')[1]
    if ext=='jar':
        p = subprocess.Popen(['java', '-jar' ,os.path.join(toolsourcedir, tool)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if ext=='exe':
        p = subprocess.Popen([os.path.join(toolsourcedir, tool)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out, err = p.communicate()
    print(out)
    print('\n')

print(tools)
# with open(txtfile, 'w') as output_file:
#     position=0
#     for line in lines:
#         output_file.write(line)
#         position=position+1
#         if (position>=titleline):
#             break

#     position=num_lines
#     for line in reversed(lines):
#         output_file.write(line)
#         position=position-1
#         if (position<=titleline):
#             break
