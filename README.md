# tools4ami:
tools collections for AMI BIOS
* VS_files 
  * *.vscode*: sample json files for project, copy to project folder and adapt it to project
  * *AmiVebEnv*: set command line environment according to com.ami.veb.ui.pref the Veb user setting file, or user default settings if not VeB set.
  * *com.ami.veb.ui.pref*: sample VeB user settings.
  * *CounterOverride*: batch file to mimic project override files for CRB code base, for easy the comparison task.
  * *fbuild.bat*: batch file to make FSP rebuild BIOS in one pass, works with *switchToken.py*, may need user change the token table in the python code.
  * *ReOverride.bat*: update all CIF files according to current overridden file list.
  * *setvebenv.py*: works with xbuild.bat to get VeB user settings to make a batch file to set the building environment.
  * *switchToken.py*: switch Tokens' value in SDL files according to a Token table.
  * *xbuild.bat*: build BIOS by a VEB file.