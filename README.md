# IAAS_tf_az
==============================wait i still need to organise readme properly==========================

Visualising load balancer 
  1.open the same url in multiple tabs
  2.refresh the page multiple times
  I have uploaded the output results in img file naming it as LoadBalancerop1 and LoadBalancerop2;
  where u can see the ip address is same for both but webpage is diiferent

I have also included a public ip address for each webpage so we can access them independently too


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






problems and errors encountered

basic sku in load balancer -
public ip address of load balancer also should be standared
cycling of resource creation
priority of resource creation need of destroying resources- as some slight changes didnt reflect
a wierd vm extension creation issue
provision config issues
naming of user in vm (naming conventions)
installing wrong web server on wrong operating system ngix and apache
subnet errors
weird storage issue in blob and storage account 
resource grp creation and deletion
jit plan out of bound
public address not found - then realised to put up web server 
duplicate ip address found on virtual netwoirk , back end addresspool address error
