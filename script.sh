#!/bin/bash

jira_token=$1
project_name=$2
link_to_git=$3
git_user=$4
git_token=$5
main_branch=$6
advanced_branch=$7
git_project=$(basename "$link_to_git")
git_origin=${link_to_git#https://}

if [ "$#" -ne 7 ]; then
    echo "Incorrect number of arguments. Please provide the arguments in the following order:"
    echo "1. JIRA Token"
    echo "2. Project Name"
    echo "3. Link to the GitHub Repo"
    echo "4. Git User"
    echo "5. Git Token"
    echo "6. Main Branch Name"
    echo "7. Advanced Branch Name"
    exit 1
fi

git clone -b "${main_branch}" --single-branch https://"${git_user}":"${git_token}"@"${git_origin}"
cd "${git_project}" || { echo "Error after cloning"; exit 1; }

git fetch origin "${advanced_branch}"
git branch "${advanced_branch}" FETCH_HEAD
git checkout "${advanced_branch}"

tickets=()
summaries=()

while read -r line; do
  tickets+=("$line")
done < <(git log --cherry-pick --pretty=format:"%s" ${main_branch}..${advanced_branch} | grep -o "${project_name}-[0-9]\+" | sort | uniq)

for ticket in "${tickets[@]}"; do
  response=$(curl -s -X 'GET' \
    "https://jira.my-company.com/rest/api/2/issue/${ticket}?fields=summary" \
    -H 'accept: application/json' \
    -H "Authorization: Bearer ${jira_token}")
  summary=$(echo "$response" | grep -Po '"summary":\s*"\K[^"]+' )
  summaries+=("$summary")
done

output=""

for (( i=0; i<${#tickets[@]}; i++ )); do
    output+="${tickets[i]} - ${summaries[i]}\n"
    printf "%s - %s\n\n" "${tickets[i]}" "${summaries[i]}"
done

echo "ticketSummary=${output}" >> $GITHUB_OUTPUT