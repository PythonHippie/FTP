#! /bin/bash
#REPO_PARENT_PATH="/home/ubuntu/git/"
REPO_PARENT_PATH="/root/GIT_Migration/"

echo $REPO_PARENT_PATH

#repo_list=("PythonPrograms" "pull_request_template")
repo_list=("server" "connectors" "mobilegateway" "db" "html5") # "toolkit" "metadata" "customerconfig")
OUTPUT=()
output(){
	OUTPUT+=(`git log --date=iso --since="2019-05-01" --no-merges --pretty=format:"{${1},%H,%s,%b,%aN,%ad}" | grep -v "build"`)
}

for i in "${repo_list[@]}"
do
	cd ${REPO_PARENT_PATH}/${i}
	# echo `ls`
	echo "i am in `pwd`"
	`git checkout master &>/dev/null` # both std output and error are redirected to /dev/null
	#`git checkout master 1> /dev/null`
	#break
	if [ `git status | grep "working tree clean" | wc -l` -eq 1 ] || [ `git status | grep "working directory clean" | wc -l` -eq 1 ]
	then
		echo "working directory clean"
		`git fetch --all &>/dev/null` # or `git fetch --all > /dev/null 2>&1` both std output and error are redirected to /dev/null
		#`git fetch --all 1>/dev/null` # only std output are redirected to /dev/null
		`git pull origin master &>/dev/null`
		#OUTPUT+=(`git log --no-merges --pretty=format:'{"commit":"%H","subject":"%s","body":"%b","author_name":"%aN","author_date":"%aD"}'`)
		output ${i}
	else
		#echo "working directory not clean"
		#break
		`git stash &>/dev/null`
		if [ `git status | grep "working tree clean" | wc -l` -eq 1 ] || [ `git status | grep "working directory clean" | wc -l` -eq 1 ]
		then
			#echo "working directory clean"
			#OUTPUT+=(`git log -2 --no-merges --pretty=format:'{"commit":"%H","subject":"%s","body":"%b","author_name":"%aN","author_date":"%aD"}'`)
			output ${i}
		else
			echo "working directory not clean"
		fi
	fi
done
split=`echo ${OUTPUT[@]}`
#split=`echo ${OUTPUT[@]} | cut -d "}" -f 2`
#echo ${split}}
#echo ${split} | sed 's/} /\n/g' | sed 's/{/\n/g' | sed '/^$/d' | sed 's/}/\n/g' | awk -F"," '{ print length($1),length($2),length($3),length($4),length($5)}'
#figlet ondot
echo ${split} | sed 's/} /\n/g' | sed 's/{/\n/g' | sed '/^$/d' | sed 's/}/\n/g' | awk -F"," ' 
BEGIN {
print "==================================================================================================================================================================================================================================================================================================================="
printf "%-20s %-40s %-100s %-100s %-40s %-40s\n","REPO","COMMIT","SUBJECT","BODY","AUTHOR NAME","DATE"
print "==================================================================================================================================================================================================================================================================================================================="
}
{ printf "%-20s %-40s %-100s %-100s %-40s %-40s\n",$1,$2,$3,$4,$5,$6 }'
# awk -F":" '
#BEGIN {
#print "========|===|=====|===============|============="
#printf "%-8s %-3s %-5s %-15s %-15s\n","USER","UID","GID","HOME","SHELL"
#print "========|===|=====|===============|============="
#}
#NR==1,NR==10 { printf "%-8s %3d %5d %-15s %-15s\n",$1,$3,$4,$6,$7 }' /etc/passwd
