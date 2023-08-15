
![alt text](https://github.com/kernelv5/crypexam/blob/main/DevOpsQ1/Deployment_mode.png)

Here Deployment Model ( https://github.com/kernelv5/crypexam/blob/main/DevOpsQ1/Deployment_mode.png ) 
-	It is a concept of how we can manage deployment if we go with ec2. 
-	Aws crypto-base-image is the image in which hardening is completed an pushed to aws ami. 
-	Hashicrop packer will use that image as the base image. 
-	Application installation will be done using the Ansible playbook, Packer will execute Ansible.  
-	Once the image build is done, it will push to aws ami with a new serial number like timestamp. 
-	Next part is , terraform trigger, once terraform will trigger it will detect a new image available, so terraform will redeploy the instance with new image. 



####



![alt text](https://github.com/kernelv5/crypexam/blob/main/DevOpsQ1/infra.png ) 



-	Infra Architecture ( https://github.com/kernelv5/crypexam/blob/main/DevOpsQ1/infra.png )
-	2 ec2 instance deployment. 
-	One bastion, another crypto node with attached ebs , encryption enabled. 
-	Bastion server accept 22 connection from anywhere ( temporary ) 
-	Crypto-node only accepts ssh connection from the bastion server. In security group source from bastion server sg. 
-	Crypto node also listens to 2 custom ports only for a specific CIDR block , this CIRD block needs to be adjusted as per the incoming connection. 
-	Private subnets has NAT enabled. This option is available on IAC as boolean value. 




### Terraform

Note :
1. Terraform will use local state file
2. Version : Terraform v1.5.2

Pre-requisits :
1. Create a key pair : crypto-demo-key
2. Please adjust provider.tf profile value. 
3. if required please adjust the ip range for public and private main.tf
4. terraform init
5. terraform apply



