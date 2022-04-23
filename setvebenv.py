import sys
import os
#
# resolve VeB preference
#
veb_setting_file="C:\AptioV_Tools_ADL_Mod\VisualeBios\configuration\.settings\com.ami.veb.ui.prefs"
veb_project_file="C:\BIOS\EagleStream\EagleStreamCrb.dat"
if len(sys.argv)>1:
    veb_setting_file=sys.argv[1]
if len(sys.argv)>2:
    veb_project_file=sys.argv[2]

pathnames=os.path.splitext(veb_project_file)
veb_project_file=os.path.join(pathnames[0]+'.dat')

ev_cnt=0
evNames=[]
evValues=[]
# npath=os.environ['Path']
npath=""
#
# Resolve VeB global settings
#
if os.path.exists(veb_setting_file):
    veb_setting=open(veb_setting_file).read().split("\n")
    #
    # resolve Environment Variables
    #
    evcnt_prefix="ToolsOptionsEnvVariableCount"
    ecName_prefix="ToolsOptionsEnvVariableName_"
    ecValue_prefix="ToolsOptionsEnvVariableValue_"

    for line in veb_setting:
        if (evcnt_prefix in line):
            ev_cnt=int(line[line.index('=')+1:])
            break
    ev_index=0
    for line in veb_setting:
        if (ecName_prefix in line):
            evNames.append(line[line.index('=')+1:])
            ev_index+=1
            if ev_index==ev_cnt:
                break
    ev_index=0
    for line in veb_setting:
        if (ecValue_prefix in line):
            evValues.append(line[line.index('=')+1:])
            ev_index+=1
            if ev_index==ev_cnt:
                break
    #
    # resolve PATHs
    #
    tdcnt_prefix="ToolsOptionsToolDirCount"
    td_prefix="ToolsOptionsToolDirName"
    tdcnt=0
    td=[]
    for line in veb_setting:
        if (tdcnt_prefix in line):
            tdcnt=int(line[line.index('=')+1:])
            break
    ev_index=0
    for line in veb_setting:
        if (td_prefix in line):
            td.append(line[line.index('=')+1:len(line)])
            ev_index+=1
            if ev_index==tdcnt:
                break
    #
    # make the path string
    #
    for p in td:
        p=p.replace("\\:", ":")
        p=p.replace("\\\\", "\\")
        npath='"'+p+'"'+';'+npath
#
# resolve Project preference
#
import struct
datVarCount=0
if os.path.exists(veb_project_file):
    projectFile=open(veb_project_file, "rb")
    datHeader=struct.unpack('I', projectFile.read(4))
    datCdLen= ord(struct.unpack('c', projectFile.read(1))[0])
    datCd=projectFile.read(datCdLen)
    x=projectFile.read(1)
    datPathCountHigh=struct.unpack('I', projectFile.read(4))[0]
    datPathCountLow =struct.unpack('I', projectFile.read(4))[0]
    encoding = 'utf-8'
    for i in range(datPathCountLow):
        datPathLen= ord(struct.unpack('c', projectFile.read(1))[0])
        datPath=projectFile.read(datPathLen)
        npath='"'+str(datPath, encoding)+'"'+';'+npath

    x=projectFile.read(14)

    datVarCount= struct.unpack('h', projectFile.read(2))[0]
    for i in range(datVarCount):
        datVarNameLen= ord(struct.unpack('c', projectFile.read(1))[0])
        datVarName=projectFile.read(datVarNameLen)
        evNames.append(str(datVarName, encoding))

    datVarCount= struct.unpack('h', projectFile.read(2))[0]
    for i in range(datVarCount):
        datVarNameLen= ord(struct.unpack('c', projectFile.read(1))[0])
        datVarName=projectFile.read(datVarNameLen)
        evValues.append(str(datVarName, encoding))
#
# write the batch file
#
if len(evNames)>0 or (len(npath)>0):
    with open('set_veb_env.bat', 'w') as output_file:
        for i in range(ev_cnt+datVarCount):
            p=evValues[i].replace("\\:", ":")
            p=p.replace("\\\\", "\\")
            output_file.write('set ' + evNames[i] + '=' + p + '\n')
        if len(npath)>0:
            output_file.write('set path='+npath+';'+os.environ['Path'])
    # ToDo: below snippet won't work to replace above, why?
    # for i in range(ev_cnt+datVarCount):
    #     p=evValues[i].replace("\\:", ":")
    #     p=p.replace("\\\\", "\\")
    #     os.environ[evNames[i]] = p
    # os.environ['path'] = npath
