#!/bin/bash
clang_version=$(clang --version | grep -E 'version [0-9]' | sed -E 's/^.* ([0-9]+)\.[0-9]+\.[0-9]+ .*$/\1/')
echo "INFO: running llvm-cov-$clang_version"
exec llvm-cov-"$clang_version" gcov "$@"
