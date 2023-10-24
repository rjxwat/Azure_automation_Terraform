# IAAS_tf_az


src-->contains code for all operations
img-->contains output image of those operations

src====================
What I have done -
  config-->file containing basic azure to terraform config
  RGrp-->config file to create resource group wec1
  Aset1-->config file for creating availability set
  VNet1-->config file to create Virtual network and subnets for each virtual machine
  VM-->config file to create virtual machine and its network interface
  Wpage-->config file to create webserver and webpage for each virtual machine , i have used windows os on both so installed IIS as web server , if using linux use ngix as it is more resource efficient than                 apache..., this file also contains network security(not necessary).
  final-->config file to create all the above resources along with load balancing.
  
  
  
Visualising load balancer 
  1.open the same url in multiple tabs
  2.refresh the page multiple times
  I have uploaded the output results in img file naming it as LoadBalancerop1 and LoadBalancerop2;
  where u can see the ip address is same for both but webpage is diiferent

As a additional feature I have also included a public ip address for each webpage so we can access them independently too.



Initial steps-
Create a Azure student account
Download Azure Cli
Install terraform and add it path variables
Do a principal authetication using az login

Basic Commands-
terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan
(replace main with respective file names)






________the problem listed below are not inorder of completion of task i just metioned them randomly...
problems and errors encountered throughout the journey-->
1..Priority order of resource creation need to be correct
2.SKU in public ip address of load balancer also should be Standared
3.while using the depends on --> cycling of resource creation.
4.Load Balancer the SKU on default is set on basic need to change it to Standard 
5.need of destroying resources- as some slight changes didn't reflect in terraform plan
6.Can't destroy and change resource which are in use by other components 
7.Some wierd vm extension creation issue+ the time it takes ....ahh
8.for setup of webserver provision config issues
9.naming of user in vm (naming conventions-how can i miss this just like other languages even HCL have keywords reserved ..)
10.installing wrong web server on wrong operating system ngix and apache
11.subnet overlapping errors

12.weird storage issue in blob and storage account had to create to different containers and storage account for each.
13.resource grp creation and deletion
14.basically i counldn't access the vm as it was not in subscription(jit plan out of bound), i wanted to check if the webpage file was in place in vm.

15.public address not found - then realised to put up web server 
16.duplicate ip address found on virtual network
17.back end address pool address error(had assigned wrong network interface)


