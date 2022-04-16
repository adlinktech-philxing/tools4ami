import sys
txtfile="AllTools\ToolVersionTable.txt"
titleline=2
if len(sys.argv)>1:
    txtfile=sys.argv[1]
if len(sys.argv)>2:
    titleline=int(sys.argv[2])

num_lines = sum(1 for line in open(txtfile))
lines=open(txtfile).readlines()

with open(txtfile, 'w') as output_file:
    position=0
    for line in lines:
        output_file.write(line)
        position=position+1
        if (position>=titleline):
            break

    position=num_lines
    for line in reversed(lines):
        output_file.write(line)
        position=position-1
        if (position<=titleline):
            break
