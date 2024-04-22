#!/bin/bash
echo "Enter the repository to check for inactive branches"
read repo_name
echo "ENter  username"
read user_name
echo "Enter password"
read -s password # -s is use to hide anything we enter
presentdate=`date +'%s'`
list_of_branches=$(curl -s -u $user_name:$password https://api.github.com/repos/$user_name/$repo_name/branches | jq '.[].name')
for branch in $list_of_branches; do 
api_branch_name=$(echo $branch | cut -d'"' -f 2)
last_updated_date=$(curl -s -u $user_name:$password https://api.github.com/repos/$user_name/$repo_name/branches/$api_branch_name | jq '.commit.commit.author.date')
api_last_updated_date=$(echo $last_updated_date | cut -d'"' -f 2)
last_updated_date_sec=$(date -d $api_last_updated_date +%s)
numberofdays=$(( ($presentdate - $last_updated_date_sec)/(60*60*24) ))
 if [ $numberofdays -gt 60 ] ; then
        
        echo "Branch $api_branch_name is updated $numberofdays days back"
     fi
done