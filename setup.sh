repo=$(git remote get-url origin | cut -d ":" -f 2 | cut -d "/" -f 1-2)
issue=$(echo audit | gh issue create -l bug -a "megamanics" -t "[Audit]" -R ${}repo} -F -)
echo $issue
issueno=$(echo $issue | cut -f7 -d/)
branch=branch-4-issue-${issueno}
gh issue edit ${issueno} -t "[Audit] ${issueno}"
gh issue comment  ${issueno} --body ":octocat:"
gh api /repos/${repo}/issues/${issueno}/reactions -f content='heart' --silent
git checkout -b ${branch}
echo "#${issueno}" >> setup.sh
git commit -m "update setup for #${issueno}" setup.sh
git push   --set-upstream origin  ${branch}
git branch --set-upstream-to=origin/${branch}  ${branch}
git pull   --rebase --autostash --all --ff
git push   --set-upstream origin  ${branch}
git push
gh pr create -a "@me" -b "close #${issueno}" -B main -f
gh pr merge  -b "merged"     -r -d --auto
