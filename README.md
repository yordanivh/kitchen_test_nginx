# kitchen_test_nginx
This is a repo that uses kitchen-test to make sure our box have all what we require, in our case we are checking for specific packages to be installed but other tests can be done with [inspec](https://www.inspec.io/).

# What is this repo for

With this repo you can make a kitchen test to see if particular packages are installed on a packer image.

# Why you need to use this repo

You can use this repo to get a better understanding of how kitchen tests work

# Pre-requisites

* You need to have packer and vagrant installed on you workstation
   *  for MacOS
   
    ```
    brew install vagrant
    brew install packer
    ```
  
   *  for any other OS click [here](https://packer.io/downloads.html) for Packer and [here](https://www.vagrantup.com/downloads.html) for vagrant  
   
* Clone this repo locally to a folder of your choice
```
git clone git@github.com:yordanivh/kitchen_test_nginx.git
```
* Go inside the newly created folder of the repo

```
cd kitchen_test_nginx
```
   
* You need to have ruby installed on the system with all the dependencies

```
brew install ruby rbenv
```
* To be able to run kitchen test you need to make sure the environment is set up corectly.Run these commands to do so from the current directory.

```
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
rbenv install 2.6.3
rbenv local 2.6.3
rbenv versions
gem install bundler
bundle install
```

# How to use this repo

* This "How to" will cover macOS specifically, it may vary for other systems.

* Go inside the newly created folder of the repo

```
cd kitchen_test_nginx
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
--> nginx64-vbox: VM files in directory: output-nginx64-vbox
--> nginx64-vbox: 'virtualbox' provider box: nginx64-vbox.box
```

* The next step is to add the created image of nginx64 to vagrant - here is the command for that

```
vagrant  box add nginx64 ./nginx64-vbox.box --provider virtualbox --force
```

* Here is the output that can be expected

```
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'nginx64' (v0) for provider: 
    box: Unpacking necessary files from: file:///Users/yhalachev/repos/Packer/kitchen_test_nginx/nginx64-vbox.box
==> box: Successfully added box 'nginx64' (v0) for 'virtualbox'!
```

* Run the kitchen test with tese commands , below them is the expected output

```
bundle exec kitchen converge
```
Expected output
```
-----> Starting Test Kitchen (v2.3.4)
-----> Creating <default-vbox-nginx64>...
       Bringing machine 'default' up with 'virtualbox' provider...
       ==> default: Importing base box 'nginx64'...
==> default: Matching MAC address for NAT networking...
       ==> default: Setting the name of the VM: kitchen-kitchen_test_nginx-default-vbox-nginx64-d8a4e8de-070a-4874-8dc3-ffd29b7641f0
       ==> default: Clearing any previously set network interfaces...
       ==> default: Preparing network interfaces based on configuration...
           default: Adapter 1: nat
       ==> default: Forwarding ports...
           default: 22 (guest) => 2222 (host) (adapter 1)
       ==> default: Running 'pre-boot' VM customizations...
       ==> default: Booting VM...
       ==> default: Waiting for machine to boot. This may take a few minutes...
           default: SSH address: 127.0.0.1:2222
           default: SSH username: vagrant
           default: SSH auth method: private key
           default: 
           default: Vagrant insecure key detected. Vagrant will automatically replace
           default: this with a newly generated keypair for better security.
           default: 
           default: Inserting generated public key within guest...
           default: Removing insecure key from the guest if it's present...
           default: Key inserted! Disconnecting and reconnecting using new SSH key...
       ==> default: Machine booted and ready!
       ==> default: Checking for guest additions in VM...
       ==> default: Setting hostname...
       ==> default: Machine not provisioned because `--no-provision` is specified.
       [SSH] Established
       Vagrant instance <default-vbox-nginx64> created.
       Finished creating <default-vbox-nginx64> (0m36.31s).
-----> Converging <default-vbox-nginx64>...
       Preparing files for transfer
       Preparing script
       No provisioner script file specified, skipping
       Transferring files to <default-vbox-nginx64>
       Downloading files from <default-vbox-nginx64>
       Finished converging <default-vbox-nginx64> (0m0.01s).
-----> Setting up <default-vbox-nginx64>...
       Finished setting up <default-vbox-nginx64> (0m0.00s).
```

```
bundle exec kitchen verify
```
Expected output:

```
-----> Starting Test Kitchen (v2.3.4)
-----> Setting up <default-vbox-nginx64>...
       Finished setting up <default-vbox-nginx64> (0m0.00s).
-----> Verifying <default-vbox-nginx64>...
       Loaded tests from {:path=>".Users.yhalachev.repos.Packer.kitchen_test_nginx.test.integration.default"} 

Profile: tests from {:path=>"/Users/yhalachev/repos/Packer/kitchen_test_nginx/test/integration/default"} (tests from {:path=>".Users.yhalachev.repos.Packer.kitchen_test_nginx.test.integration.default"})
Version: (not specified)
Target:  ssh://vagrant@127.0.0.1:2222

  System Package wget
     ✔  is expected to be installed
  System Package language-pack-en
     ✔  is expected to be installed
  System Package nginx
     ✔  is expected to be installed

Test Summary: 3 successful, 0 failures, 0 skipped
       Finished verifying <default-vbox-nginx64> (0m0.17s).
-----> Test Kitchen is finished. (0m0.81s)
```

* To clear out the kitchen test run 

```
bundle exec kitchen destroy
```
```
-----> Starting Test Kitchen (v2.3.4)
-----> Destroying <default-vbox-nginx64>...
       ==> default: Forcing shutdown of VM...
       ==> default: Destroying VM and associated drives...
       Vagrant instance <default-vbox-nginx64> destroyed.
       Finished destroying <default-vbox-nginx64> (0m3.75s).
-----> Test Kitchen is finished. (0m4.40s)
```

* To clear the vagrant box created during the test run

```
vagrant box remove -f nginx64 --provider virtualbox
```

