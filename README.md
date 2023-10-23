# IAAS_tf_az
==============================wait i still need to organise readme properly==========================

src-->contains code for all operations
img-->contains output image of those operations

src====================
  config-->file containing basic azure to terraform config
  RGrp-->config file to create resource group wec1
  Aset1-->config file for creating availability set
  VNet1-->config file to create Virtual network and subnets for each virtual machine
  VM-->config file to create virtual machine and its network interface
  Wpage-->config file to create webserver and webpage for each virtual machine , i have used              windows os on both so installed IIS as web server , if using linux use ngix as it is            more resource efficient than apache..., this file also contains network security(not            necessary).
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


What I have done -




problems and errors encountered

basic sku in load balancer -
public ip address of load balancer also should be standared
cycling of resource creation
priority of resource creation need of destroying resources- as some slight changes didnt reflect
a wierd vm extension creation issue
provision config issues
naming of user in vm (naming conventions-how can i miss this just like other languages even HCL have keywords reserved ..)
installing wrong web server on wrong operating system ngix and apache
subnet errors
weird storage issue in blob and storage account 
resource grp creation and deletion
jit plan out of bound
public address not found - then realised to put up web server 
duplicate ip address found on virtual netwoirk , back end addresspool address error
