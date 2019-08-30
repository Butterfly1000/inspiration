awk是一个强大的文本分析工具，相对于grep的查找，sed的编辑，awk在其对数据分析并生成报告时，显得尤为强大。
简单来说,awk就是把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行各种分析处理。

★使用方法
awk '{pattern + action}' {filenames}
pattern 表示 AWK 在数据中查找的内容，而 action 是在找到匹配内容时所执行的一系列命令。
花括号（{}）不需要在程序中始终出现，但它们用于根据特定的模式对一系列指令进行分组。
pattern就是要表示的正则表达式，用斜杠括起来。

调用awk
1.命令行方式
awk [-F  field-separator]  'commands'  input-file(s)
其中，commands 是真正awk命令，[-F域分隔符]是可选的。 input-file(s) 是待处理的文件。
在awk中，文件的每一行中，由域分隔符分开的每一项称为一个域。通常，在不指名-F域分隔符的情况下，默认的域分隔符是空格。

2.shell脚本方式
将所有的awk命令插入一个文件，并使awk程序可执行，然后awk命令解释器作为脚本的首行，一遍通过键入脚本名称来调用。
相当于shell脚本首行的：#!/bin/sh
可以换成：#!/bin/awk

3.将所有的awk命令插入一个单独文件，然后调用：
awk -f awk-script-file input-file(s)
其中，-f选项加载awk-script-file中的awk脚本，input-file(s)跟上面的是一样的。

命令行方式实例介绍：
last -n 5 
取出最近登录的五个账号信息。
结果：
admin    pts/0        27.152.138.129   Fri Aug 30 14:38   still logged in   
root    pts/0        117.30.52.105    Wed Aug 21 15:33 - 17:16  (01:43)    
admin    pts/0        117.30.52.105    Tue Aug 20 09:39 - 18:36  (08:56)    
admin    pts/0        27.154.101.20    Thu Aug 15 16:55 - 22:20  (05:25)    
root    pts/0        117.30.53.18     Mon Aug 12 09:32 - 18:43  (09:10)   

last -n 5 | awk '{print $1}'
只显示最近登录的五个账号名。
结果：
admin    
root    
admin    
admin  
root

awk工作流程是这样的：读入有'\n'换行符分割的一条记录，然后将记录按指定的域分隔符划分域，填充域，
$0则表示所有域,$1表示第一个域,$n表示第n个域。默认域分隔符是"空白键" 或 "[tab]键",所以$1表示登录用户，$3表示登录用户ip,以此类推。

cat /etc/passwd
结果：
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

cat /etc/passwd | awk -F ':' '{print $1}'    （只是显示/etc/passwd的账户）
结果：
root
bin
daemon
adm
lp
原理：正常逻辑已'\n'和默认空格分隔，-F ':'将默认空格转化成:冒号分隔符。

如果只是显示/etc/passwd的账户和账户对应的shell,而账户与shell之间以tab键分割 ）（\t）
#cat /etc/passwd |awk  -F ':'  '{print $1"\t"$7}'
结果：
root /bin/bash
bin /sbin/nologin
daemon /sbin/nologin
adm /sbin/nologin
lp /sbin/nologin

如果只是显示/etc/passwd的账户和账户对应的shell,而账户与shell之间以逗号分割,而且在所有行添加列名name,shell,在最后一行添加"blue,/bin/nosh"。
cat /etc/passwd |awk  -F ':'  'BEGIN {print "name,shell"}  {print $1","$7} END {print "blue,/bin/nosh"}'
结果：
name,shell
root,/bin/bash
daemon,/bin/sh
bin,/bin/sh
sys,/bin/sh
....
blue,/bin/nosh
划重点：BEGIN（最先读取） END（最后读取）

搜索/etc/passwd有root关键字的所有行
awk -F: '/root/' /etc/pawwd
cat /etc/passwd | awk -F: '/root/' (这个方法也可以同样实现)
结果：
root:x:0:0:root:/root:/bin/bash

这种是pattern的使用示例，匹配了pattern(这里是root)的行才会执行action(没有指定action，默认输出每行的内容)。
搜索支持正则，例如找root开头的: awk -F: '/^root/' /etc/passwd

