#! /bin/bash

set -e

##change apt source to be inside China to speed up apt
sudo touch /etc/apt/sources.list
sudo mv /etc/apt/sources.list /etc/apt/sources.list.old
sudo cp /vagrant/config/ubuntu.focal.source.list /etc/apt/sources.list

##install ansible
sudo cp /vagrant/config/ubuntu.bionic.source.ansible.list /etc/apt/sources.list.d/ansible.list

maxcount=10          # 最多重试次数
count=${maxcount}    # 记录重试次数
flag=0               # 重试标识，flag=0 表示任务正常，flag=1 表示需要进行重试
while [ 0 -eq 0 ]
do
    echo "**** start install ansible "
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
      sudo apt-get update -y -qq && \
      EBIAN_FRONTEND=noninteractive sudo apt-get install -y -qq ansible --option "Dpkg::Options::=--force-confold"
    
    flag=$?
    # 检查和重试过程   
    if [ ${flag} -eq 0 ]; then     #执行成功，不重试
        echo "**** install ansible complete"
        break;
    fi
    if [ ${count} -eq 0 ]; then     #指定重试次数，重试超过5次即失败
        echo "**** install ansible timeout"
        break
    fi
    count=$[${count}-1]
    echo "**** install ansible failed ${count}/${maxcount}"
    sleep 1
done
