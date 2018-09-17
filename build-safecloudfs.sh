#!/bin/sh

# For debugging, build the container from a tag + $branch applied on top.
# $branch contains the C&H changes to the code which we need to build,
# independent from changes in the underlying code base.

branch=feature-safecloudbox
fork_commit=$(git merge-base --fork-point master $branch)

for tag in 0.0.1 0.0.4; do
    git rebase --onto $tag $fork_commit $branch
    docker build -t safecloudfs:"${tag}_${branch}" .
done
