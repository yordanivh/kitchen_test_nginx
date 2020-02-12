# packer_nginx64
This repo is containing code that can deploy a virtual machine image with nginx created by packer.

# What is this repo for
With this repo you can create a Virtual machine image , that has some packages provisioned, using packer.Specifically it has `nginx` installed.
And that image can be used to deploy a vm box using vagrant. In the `How to use this repo` section you can find an example of the repo works and how you can try it for yourself.

# Why you need to use this repo
You can use this repo to gain an understanding of how Packer works together with Vagrant to create a Virtual machine image and 
run a virtual machine off of that image.

# How to use this repo

* You need to have packer and vagrant installed on you workstation
   *  for MacOS
   
    ```
    brew install vagrant
    brew install packer
    ```
  
   *  for any other OS click [here](https://packer.io/downloads.html) for Packer and [here](https://www.vagrantup.com/downloads.html) for vagrant  
  
* This "How to" will cover macOS specifically, it may vary for other systems.

* Clone this repo locally to a folder of your choice
```
git clone git@github.com:yordanivh/packer_nginx64.git
```
* Go inside the newly created folder of the repo

```
cd packer_nginx64
```

* You will see there two folders one containing provisioning scripts and one containig configuration that are done during installation of the virtual machine.

* Packer is used to create a virtual machine image.This is done by creating an actual machine and making changes to that machine while running. In the end the only thing left is the machine image. This packer script works with virtual box so you need to have that virtual machine provider installed

  * Download VirtualBox [here](https://www.virtualbox.org/wiki/Downloads)

* To start packer enter the folowing command

```
packer build -force template.json
```
* The log of the operation will start to output to the screen.In the end this is what you should expect to get as output
```
==> Builds finished. The artifacts of successful builds are:
--> ubuntu-1604-lts-vbox: VM files in directory: output-nginx64-vbox
--> ubuntu-1604-lts-vbox: 'virtualbox' provider box: nginx64-vbox.box
```
* If you list the contents of the folder now you will see there are some new files and folders.
`packer_cache` containing the iso image for the virtual machine install.
`nginx64-vbox.box` which is the actual image to use with Vagrant.
`output-nginx64-vbox` containing an ovf file and vmdk file that can be used by VirtualBox.

* The next step is to initialize a vagrant environment in the current folder
```
vagrant init -m nginx64
```

* Add the box to vagrant

```
vagrant box add nginx64 ./nginx64-vbox.box --provider virtualbox --force

==> box: Successfully added box 'nginx64' (v0) for 'virtualbox'!
```
* Start the VM

```
vagrant up
```

* After this is successfull you can login to the machine with the vagrant user and the vagrant public ssh key allready set up by packer

```
vagrant ssh
```
  * Here is where packer set up the ssh access
```
==> nginx64-vbox: Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.128.133|:443... connected.
==> nginx64-vbox: HTTP request sent, awaiting response... 200 OK
==> nginx64-vbox: Length: 409 [text/plain]
==> nginx64-vbox: Saving to: ‘/home/vagrant/.ssh/authorized_keys’
==> nginx64-vbox:
==> nginx64-vbox:      0K                                                       100% 84.2M=0s
==> nginx64-vbox:
==> nginx64-vbox: 2020-02-07 14:01:00 (84.2 MB/s) - ‘/home/vagrant/.ssh/authorized_keys’ saved [409/409]
==> nginx64-vbox:

```

* After you login to the machine you can check for nginx if it is installed on the server

```
vagrant@nginx64:~$ nginx -v
nginx version: nginx/1.10.3 (Ubuntu)
```


* After you are done with the tests remove the VM machine and delete all the files created by packer and vagrant. This step should be done only if you wish to go bakc the the initial state of the repo.

```
vagrant halt
vagrant destroy
vagrant box remove ubuntu-1604-lts
rm -rf .vagrant Vagrantfile output-ubuntu-1604-lts-vbox ubuntu-1604-lts-vbox.box packer_cache
```



