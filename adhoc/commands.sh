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
