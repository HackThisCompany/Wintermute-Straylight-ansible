#!/bin/bash -xe

TMP=$(mktemp -d)
#trap "{ rm -rf $TMP; }" EXIT

yum install -y \
  python3 \
  python3-pip \
  git-core

# Download role
git clone https://github.com/HackThisCompany/Wintermute-Straylight-ansible.git $TMP/Wintermute-Straylight-ansible

# Prepare virtualenv & activate
python3 -m venv $TMP/venv
. $TMP/venv/bin/activate

# Install ansible and install requirements
pip3 install ansible

cat << EOF > $TMP/playbook.yml
- name: 'Provide Wintermute-Straylight server'
  hosts: localhost
  become: yes
  connection: local
  roles:
    - role: $TMP/Wintermute-Straylight-ansible
      vars:
        ansible_python_interpreter: python3
EOF

# Run playbook
ansible-playbook -i localhost, $TMP/playbook.yml
