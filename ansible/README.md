# Standalone DMP Intercom - Ansible Playbook Strategy

## Overview

The provided playbook and inventories are intended to be used to deploy a standalone DMP Intercom instance. The playbook will enable, install, and/or configure the following components:

* Timezone
* Locale
* SSH
* Packages (apt-get)
* WM8960 Soundcard
* Telephone Entry UI
* Users & Groups
* Peripherals/Hardware
* GUI (X11)
* Auto-login

## Setup

Ensure your host machine is booted and connected to the internet. The remote inventory provided targets a host by the name of `testpi.local`. If you have a different hostname, you will need to update the inventory file to reflect that.

From this directory on your controller, run the following commands to setup your controller environment:

```bash
#!/usr/bin/env bash

python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install -r requirements.txt
deactivate
```

This will install the necessary python libraries on your controller to run the playbook.

## Running the Playbook

To run the playbook, run the following commands from this directory on your controller:

```bash
#!/usr/bin/env bash

source .venv/bin/activate
ansible-playbook -i remote-hosts bootstrap.playbook.yml
deactivate
```

The playbook will begin to execute, and should take approximately 20-30 minutes to complete. Once the playbook has completed, the host will reboot and the GUI will be available.
