# this py will be called twice while refrsh FSP.fd to enabled FSP building and Normal BIOS building
# check fbuild.bat for more details

import sys
from os.path import exists

valueLabel="Value"

if len(sys.argv)>1:
    newSwitch=sys.argv[1]
else:
    sys.exit(1)

# argument 1 as FSP enabling control: 1 to enable FSP re-fresh
if (newSwitch=="1"):
    newSwOffset=2
else:
    newSwOffset=3
    
#     4 fields for Token control to re-fresh FSP.fd:
#     SDL file name, Token Name, FSP enabled value, FSP disabled value
switchTokens = ["AdlinkModulePkg\Baseboard\Baseboard.sdl,             AMI_FSP_BIN_SUPPORT, 1, 0", 
                "AdlinkModulePkg\Baseboard\MeBackDoor\MeBackDoor.sdl, ME_BACKDOOR_SUPPORT, 0, 1" ]

for sdlfile in switchTokens:
    fileToken=sdlfile.split(',')
    if (exists(fileToken[0])):
        with open(fileToken[0], 'r+') as sdlFileH:
            sdlFileLines=sdlFileH.readlines()
            sdlFileH.seek(0)
            changeValue=False
            newlines=[]
            for line in sdlFileLines:
                if (changeValue):
                    if valueLabel in line:
                        words=line.split()
                        line=line.replace(words[2],'"'+fileToken[newSwOffset].strip()+'"')
                        changeValue=False
                else:
                    if ((fileToken[1].strip() in line) and ('Name' in line)):
                        changeValue=True
                newlines.append(line)

            sdlFileH.writelines(newlines)

