---
layout: post
title: "Setting up mysql replication locally"
date: 2014-07-04 13:11
comments: true
description: "Setting up mysql replication for rails (with octopus gem) locally"
keywords: rails, mysql, octopus, virtualbox, replication
categories: [Developing, Web, Administration]
---


Mysql Replication setup manual

This two tutorials helped me to solve several issues during setup, so strongly recommend:
http://dev.mysql.com/doc/refman/5.5/en/replication-howto-repuser.html
http://scriptingmysql.wordpress.com/2013/02/21/mysql-replication-creating-a-new-masterslave-topology-with-or-without-virtual-machines/

I decided to set up different mysql instances using virtualbox. So in my case I have:
 * host machine with ubuntu 12.04, x64
 * guest OS running inside virtualbox (same ubuntu 12.04, but 32 bit) Networking using bridge
Both running mysql 5.5
master is on host machine, slave - on virtual one.

<!-- more -->

Steps:

1 . Set up master mysql. 
It’s just about up uncommenting binlog location and server id lines in my.cnf (requires server restart). Make sure the binlog file located in the directory that is exists and have correct owner (mysql). In my case it is /var/log/mysql/mysql-bin.log (which I think to change later since it seems to be cleared by the OS on each reboot). For server id I put “1”
also comment out this line both for master and slave node’s configs:
bind-address 127.0.0.1

2 . Set up slave mysql (or several ones)
Even easier. Just setting server id variable (each mysql node should have uniq id), I put “2” for this case.

3 . Set up replication user on master which will be used by slave (or by all of them) to read data from master.
Login to master mysql: 

`$ mysql -uroot -p`
general form of user creation command looks like this:

`mysql> CREATE USER 'repl_user'@'%.mydomain.com' IDENTIFIED BY 'slavepass';`

but as my virtual machine has no domain or fixed ip address I used different form to allow connections from all domains:

`mysql> CREATE USER 'repl_user'@'% IDENTIFIED BY 'slavepass';`

and add required privileges to the user:

`mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl_user'@'%';`

4 . Get binlog details for slaves
connect to master using mysql command and then type:
`mysql> show master status\G;`
you’ll see something like this:

```sh
*************************** 1. row ***************************
            File: mysql-bin.000001
        Position: 107
    Binlog_Do_DB: 
Binlog_Ignore_DB: 
1 row in set (0.00 sec)

ERROR: 
No query specified
we would need those File and Position parameters to specify on slaves.
```

5 . Create data snapshot from master node and push it to slaves
`$ mysqldump --all-databases --master-data > dbdump.db -uroot -p`
then on virtual machine get this dump file (you can use shared folder between host OS and guest OS) and push it to slave mysql node (but before this stop slave mode -
`mysql> stop slave;` ) :
`$ mysql < dbdump.db -uroot -p`
then run slave again:
`mysql> start slave;`

6 . Create user on slave that will be used by octopus

```sh
mysql> CREATE USER 'slave_user'@'%' IDENTIFIED BY 'slavepass';
mysql> GRANT all priveleges on database_name.* TO 'slave_user'@'%';
mysql> flush priveleges;
```

7 . Giving master's information to slave

On slave mysql console run:
```sh
mysql> CHANGE MASTER TO MASTER_HOST='192.168.1.6', MASTER_USER='repl_user', MASTER_PASSWORD='slavepass', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=107;
```
after this you will be able to run slave:
`mysql> start slave;`

Then to make sure it is connected, run `mysql> show slave status\G;`

```sh
mysql> SHOW SLAVE STATUS\G
*************************** 1. row ***************************
             Slave_IO_State: Waiting for master to send event
                Master_Host: 192.168.1.6
                Master_User: repl_user
                Master_Port: 3306
              Connect_Retry: 3
            Master_Log_File: mysql-bin.000001
        Read_Master_Log_Pos: 107
             Relay_Log_File: mysql-relay-bin.005
              Relay_Log_Pos: 548
      Relay_Master_Log_File: mysql-bin.005
           Slave_IO_Running: Yes
          Slave_SQL_Running: Yes
            Replicate_Do_DB:
        Replicate_Ignore_DB:
         Replicate_Do_Table:
     Replicate_Ignore_Table:
    Replicate_Wild_Do_Table:
Replicate_Wild_Ignore_Table:
                 Last_Errno: 0
                 Last_Error:
               Skip_Counter: 0
        Exec_Master_Log_Pos: 79
            Relay_Log_Space: 552
            Until_Condition: None
             Until_Log_File:
              Until_Log_Pos: 0
         Master_SSL_Allowed: No
         Master_SSL_CA_File:
         Master_SSL_CA_Path:
            Master_SSL_Cert:
          Master_SSL_Cipher:
             Master_SSL_Key:
      Seconds_Behind_Master: 8
```

Here two lines indicates that everything is ok:

`Slave_IO_Running: Yes`

`Slave_SQL_Running: Yes`

If it is not, then they will contain error message.


8 . Setup octopus config
octopus config is located inside config/shards.yml file.
in my case virtual machine has address 192.168.1.12 in my local network so putting this address inside config as well as user data from step 6: 

```sh
octopus:
  environments:
    - development
    - production
  replicated: true
  fully_replicated: true 
  development:
    slave1:
      host: 192.168.1.12
      adapter: mysql2
      database: database_name
      username: slave_user
      password: slavepass
      reconnect: false
```

Now we can run rails server and it should connect to all databases automatically.
The log from rails app looks like this if everything correct:

[Shard: slave1]  User Load (1.5ms)  SELECT `users`.* FROM `users` WHERE `users`.`remember_token` = '065c1bf9e95585b240e682cb380accee50551544' LIMIT 1
  Rendered layouts/_header.html.erb (3.2ms)
  Rendered layouts/_messages.html.erb (0.2ms)
  Rendered layouts/_footer.html.haml (0.9ms)
Completed 200 OK in 57ms (Views: 49.4ms | ActiveRecord: 6.2ms)

Note `[Shard: slave1]` that indicates which shard (slave) was used to get data from.
