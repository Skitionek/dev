# Utils
Collection of utility functions to be used internally within our team.

- [Installation](#installation)
- [Usage](#usage)
   - [Autocompletion](#autocompletion)
- [Usage without installation](#usage-without-installation)
- [Available commands](#available-commands)
- [Further development](#further-development)

## Installation 
To take full advantage of prepared scripts I recommend adding them to `~/.bashrc`/`~/.bash-profile`. This can be done automatically by executing:
```bash
./install.sh
```

## Usage
Toolset becomes accessible under `dev` command. Each option can be followed by "help" keyword. To start with please run:
```bash
dev help
```

### Autocompletion 
Scripts have been written assuming extensive usage of autocompletion function. Pressing tab once autocompletes command, pressing it twice lists available options.
 
Example:
```bash
> dev <tab> <tab>
activate      common      git           help          jenkins       kill          port-forward  python        self_check    update 
```
Including more complex scenarios:
```bash
> dev port-forward <tab> <tab>
a     e
b      
c      
d      
```

## Usage without installation
Although installation is advised scripts have been also prepared to be called directly.
```bash
> ./dev.sh git log
* 79f5c47 - (48 minutes ago) added git helpers and installation script - Dominik Maszczyk (HEAD -> master, origin/master, origin/HEAD)
* d06d048 - (2 hours ago) polishing - Dominik Maszczyk
* 61ac7ef - (21 hours ago) first version - basic func and autocomplete - Dominik Maszczyk
* 5834b56 - (28 hours ago) Initial commit - Dominik Maszczyk
```
This approach, however, lacks autocompletion and is path-dependent.

## Available commands
- activate     - helpers to init shell
   - local_profile       - rereads .bash_profile
   - pipenv, pipenv_venv - activate pipenv virtual environment
- common       - low level functions commonly used for interacting with deployments
   - connect \$HOST \$PORT \$NAMESPACE - calls kubernetes port forward with args from env vars
   - kill \$PORT                       - kill process listening on \$PORT
- help         - this information message
- kill         - used to kill processes listening on given port (useful to kill detached processes)
- port-forward - a wrapper around kubectl port-forward focused on forwarding into services (not pods)
- python       - helper functions to work with python
   - unittest            - run tests
   - export_requirements - list dependencies to requirements.txt
   - virtual_env         - activate/create venv
- self_check   - simple auto-diagnostic tests
- git          - usefull git command based scripts
   - last_commit_affecting_docker_image  - based on .dockerignore file finds last commit hash which potentially affects a build process
   - status                              - recursively check git status and show differences if repositories were cloned more than once
   - log, log1, log2                     - colourful human-friendly take on git logs
- update       - updates this toolset

## Further development
Please let me know if any more functionality is needed either by pull-request or opening an issue.
If I find some free time I will prorly port it to [bashly](https://bashly.dannyb.co/usage/getting-started/).
