# commitlint orb

[![CircleCI Build Status](https://circleci.com/gh/conventional-changelog/commitlint-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/conventional-changelog/commitlint-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/conventional-changelog/commitlint.svg)](https://circleci.com/orbs/registry/orb/conventional-changelog/commitlint) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/conventional-changelog/commitlint-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)



Lint your commit messages in a CircleCI job.

Add this orb's `commitlint/lint` job to your existing CircleCI workflow to utilize [commitlint](https://github.com/conventional-changelog/commitlint) for validating commit messages against the [conventional commit format](https://conventionalcommits.org/).

## Example

This example shows importing the `commitlint` orb into a basic CircleCI 2.1 config file, and adding the `commitlint/lint` job to a workflow. This configuration will lint every commit pushed to the repository.

```yaml
version: 2.1
  orbs:
    commitlint: conventional-changelog/commitlint@1.0
  workflows:
    my-workflow:
      jobs:
        - commitlint/lint
```

CircleCI will report back the status of the `commitlint/lint` job and block a Pull Request from being merged if the job fails.


## Resources

[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/conventional-changelog/commitlint-orb) - The official registry page of this orb for all versions, executors, commands, and jobs described.
[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using and creating CircleCI Orbs.

### How to Contribute

We welcome [issues](https://github.com/conventional-changelog/commitlint-orb/issues) to and [pull requests](https://github.com/conventional-changelog/commitlint-orb/pulls) against this repository!

### How to Publish
* Create and push a branch with your new features.
* When ready to publish a new production version, create a Pull Request from _feature branch_ to `master`.
* The title of the pull request must contain a special semver tag: `[semver:<segment>]` where `<segment>` is replaced by one of the following values.

| Increment | Description|
| ----------| -----------|
| major     | Issue a 1.0.0 incremented release|
| minor     | Issue a x.1.0 incremented release|
| patch     | Issue a x.x.1 incremented release|
| skip      | Do not issue a release|

Example: `[semver:major]`

* Squash and merge. Ensure the semver tag is preserved and entered as a part of the commit message.
* On merge, after manual approval, the orb will automatically be published to the Orb Registry.


For further questions/comments about this or other orbs, visit the Orb Category of [CircleCI Discuss](https://discuss.circleci.com/c/orbs).

