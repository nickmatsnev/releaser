# Releaser GitHub Action

## Description

This GHA allows you to create description of last changes if Jira tickets are somehow specified in commits.

Imagine you have a nice commit story in your `develop` branch:
```html
...
[PROJECT-232] adds newer feature (HEAD/develop)
PROJECT-146 fixes bug
PROJECT-32/adds feature (HEAD/master)
...
```

and `master`/`main` branch's head commit is `PROJECT-32/adds feature`. 

Ideally, you want to sum up what's new, and it is `PROJECT-146` and `PROJECT-232` respectively in this simple example.

Long story short, **Releaser** will return you this:

```
PROJECT-232 - description from Jira for 232
PROJECT-146 - description from Jira for 146
```

Here are the steps:


1. It takes ticket numbers, sorts and removes duplicates.
2. Then it looks for these tickets in Jira. 
3. Then it brings you the summary of the tickets in the nice form of output string GitHub variable.
4. Consequently, it allows you usage of this information for your CD processes in the workflow.

## Usage

Example workflow:

```yaml
name: Release Workflow

on:
  push:

jobs:
  gets-description:
    runs-on: ubuntu-latest

    steps:
      - name: Run Releaser Action
        id: releaser  # Unique ID for the step
        uses: API-Developer-Portal/releaser@v0
        with:
          JiraToken: ${{ secrets.JIRA_TOKEN }}
          ProjectName: 'PROJECT'
          GitHubRepoLink: 'https://git.my-company.com/enterprise/repo'
          GitUser: 'nsurname'
          GitToken: ${{ secrets.GIT_TOKEN }}
          MainBranch: 'master'
          DevBranch: 'develop'

      - name: Get the output
        run: echo "The ticket summary is ${{ steps.releaser.outputs.ticketSummary }}"

```

## Additional and helpful links

1. [How to get Jira Token](https://developer.my-company.com/api-reference/its-jira#get-started-section/)
2. [How to get GitHub token](https://docs.github.com/en/enterprise-server@3.9/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
3. [AutoRFC GitHub Action](https://git.my-company.com/API-Developer-Portal/rfc_service)
