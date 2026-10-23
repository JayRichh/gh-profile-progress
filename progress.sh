#!/usr/bin/env bash
set -euo pipefail
me=$(gh api user -q .login)
merged=$(gh api graphql -f query="{ search(query: \"is:pr is:merged author:$me\", type: ISSUE) { issueCount } }" -q .data.search.issueCount)
top=$(gh api graphql -f query="{ user(login: \"$me\") { repositories(first: 1, ownerAffiliations: OWNER, orderBy: {field: STARGAZERS, direction: DESC}) { nodes { name stargazerCount } } } }" -q '.data.user.repositories.nodes[0] | "\(.stargazerCount) \(.name)"')
stars=${top%% *}
next() { local v=$1; shift; for t in "$@"; do if [ "$v" -lt "$t" ]; then echo "$t"; return; fi; done; echo "max"; }
printf '%-12s %-18s %s\n' achievement current next
printf '%-12s %-18s %s\n' "Pull Shark" "$merged merged PRs" "$(next "$merged" 2 16 128 1024)"
printf '%-12s %-18s %s\n' "Starstruck" "$top" "$(next "$stars" 16 128 512 4096)"
