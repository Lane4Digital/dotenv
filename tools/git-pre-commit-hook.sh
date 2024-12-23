#!/bin/bash

DOCKER_COMPOSE="docker compose"
PUID=$(id -u)
PGID=$(id -g)

user="$(git config user.name)"
branch="$(git rev-parse --abbrev-ref HEAD)"

commits="$(git rev-list --count HEAD ^${branch})"
pattern="^(feature|fix|hotfix)\/[0-9]{6,7}_[a-zA-Z0-9_-]+|:[0-9a-f]{7,40}$"
gitdir="$(git rev-parse --git-dir)"
files=$(git diff --cached --name-only --diff-filter=ACMR -- '*.php')

if [[ -d "${gitdir}/rebase-merge" || -d "${gitdir}/rebase-apply" ]]; then
    exit 0;
fi

if [[ $commits -eq 0 ]]; then
    echo "Validate branch name..."
    if [[ ! $branch_name =~ $pattern ]]; then
        echo -e "\e[1;31mCommit not valid because of branch name '${branch}' !\n\e[0m"
        exit 1;
    fi
fi

echo "Committing as user ${user}"
if [[ $user =~ [.,:'!@#$%^&*()_+'] ]]; then
    echo -e "\e[1;31mThe git username does not match convention!\e[0m"
    exit 1;
fi

if [[ -n "$files" ]]; then
    echo "Processing phpcs:"
    $DOCKER_COMPOSE run -u ${PUID}:${PGID} --rm lane4-php-cli vendor/bin/phpcs phpcs ${files} -
    if [[ "$?" != 0 ]]; then
        exit 1
    fi
fi

exit 0;
