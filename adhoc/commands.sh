ansible app -b -m yum -a "name=python3-pip state=present" # install python pip
ansible app -b -m pip -a "name=django<4 state=present" # install django
ansible app -a "python3 -m django --version" # check django version



ansible db -b -m yum -a "name=mariadb-server state=present" # install mariadb
ansible db -b -m service -a "name=mariadb state=started enabled=yes" # enabled mariadb service

#configure the system firewall to ensure only the app servers can access the database
ansible db -b -m yum -a "name=firewalld state=present"
ansible db -b -m service -a "name=firewalld state=started enabled=yes"
ansible db -b -m firewalld -a "zone=database state=present permanent=yes"
ansible db -b -m firewalld -a "source=10.40.1.0/24 zone=database state=enabled permanent=yes"
ansible db -b -m firewalld -a "port=3306/tcp zone=database state=enabled permanent=yes"




ansible db -b -m yum -a "name=python3-PyMySQL state=present"
ansible db -b -m mysql_user -a "name=django host=% password=12345 priv=*.*:ALL state=present"



ansible app -b -a "systemctl status chronyd"
ansible app -b -a "service chronyd restart" --limit "10.40.1.191"


# Limit hosts with a simple pattern (asterisk is a wildcard).
ansible app -b -a "service chronyd restart" --limit "*.191"


# Limit hosts with a regular expression (prefix with a tilde).
ansible app -b -a "service chronyd restart" --limit ~".*\.4"


# Manage users and groups
ansible app -b -m group -a "name=wheel state=present"
ansible app -b -m user -a "name=hacker group=wheel createhome=yes"
ansible app -b -m user -a "name=hacker state=absent remove=yes" # remove user


# Manage packages
ansible app -b -m package -a "name=git state=present"

# Get information about a file
ansible multi -m stat -a "path=/etc/environment"
ansible multi -m copy -a "src=ansible-learn/adhoc dest=/tmp/test"


# Retrieve a file from the servers
ansible multi -b -m fetch -a "src=/etc/hosts dest=/tmp"
