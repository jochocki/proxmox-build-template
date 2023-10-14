#!/usr/bin/env bash

set -e
#------------Ubuntu----------------------

echo $TEMPLATE_SSH_PUBLIC_KEY > /tmp/ssh_public_key

qm set 9000 --ciuser $TEMPLATE_SSH_USER
qm set 9000 --sshkeys /tmp/ssh_public_key
qm set 9000 --name ubuntu-ci
#to disable upgrade of packages
#qm set 9000 --ciupgrade 0

rm /tmp/ssh_public_key
qm destroy 8999 --purge || echo "VM already missing."

MESSAGE=$(cat <<-END
Subject: build-template

Successfully built template ubuntu-ci
END
)

echo "$MESSAGE" | proxmox-mail-forward


#------------Debian----------------------

echo $TEMPLATE_SSH_PUBLIC_KEY > /tmp/ssh_public_key

qm set 8000 --ciuser $TEMPLATE_SSH_USER
qm set 8000 --sshkeys /tmp/ssh_public_key
qm set 8000 --name debian-ci
#to disable upgrade of packages
#qm set 8000 --ciupgrade 0

rm /tmp/ssh_public_key
qm destroy 7999 --purge || echo "VM already missing."

MESSAGE=$(cat <<-END
Subject: build-template

Successfully built template debian-ci
END
)

echo "$MESSAGE" | proxmox-mail-forward

#------------Alma9----------------------

echo $TEMPLATE_SSH_PUBLIC_KEY > /tmp/ssh_public_key

qm set 7000 --ciuser $TEMPLATE_SSH_USER
qm set 7000 --sshkeys /tmp/ssh_public_key
qm set 7000 --name alma9-ci
#to disable upgrade of packages
#qm set 7000 --ciupgrade 0

rm /tmp/ssh_public_key
qm destroy 6999 --purge || echo "VM already missing."

MESSAGE=$(cat <<-END
Subject: build-template

Successfully built template alma9-ci
END
)

echo "$MESSAGE" | proxmox-mail-forward