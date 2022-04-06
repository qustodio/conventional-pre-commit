# QUSTODIO conventional-pre-commit

A [`pre-commit`](https://pre-commit.com) hook to check commit messages for
[Conventional Commits](https://conventionalcommits.org) formatting.

Forked from https://github.com/compilerla/conventional-pre-commit

- Warns the user instead of failing
- Ignore default merge commit messages
- Ignore default revert commit messages
- Ignore default git flow Bump version messages

## Usage

Make sure `pre-commit` is [installed](https://pre-commit.com#install).

Create a blank configuration file at the root of your repo, if needed:

```console
touch .pre-commit-config.yaml
```

Add a new repo entry to your configuration file:

```yaml
repos:

# - repo: ...

  - repo: https://github.com/qustodio/conventional-pre-commit
    rev: <git sha or tag>
    hooks:
      - id: conventional-pre-commit
        stages: [commit-msg]
        args: [] # optional: list of Conventional Commits types to allow
```

Install the `pre-commit` script:

```console
pre-commit install --hook-type commit-msg
```

## Actual qustodio version: v1.2.0-Qustodio

This tag differs from the orginal repo v1.2.0 in the following points
- Warns about a non-conventional commit beeing made instead of failing
- Ignores commit messages if they start with "Merged in " or "This reverts commit " in order to ignore merges or reverts

## Developing for this repo

There are two main files to modify:
- conventional-pre-commit.sh is the script that is executed in order to validate a commit message, it receives a commit message file as input and an array of arguments that specify the commit types to use.
- tests.sh is the script that test this repo.

## License

[Apache 2.0](LICENSE)

Inspired by matthorgan's [`pre-commit-conventional-commits`](https://github.com/matthorgan/pre-commit-conventional-commits).
