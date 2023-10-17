<h1 align="center"> AWS </h1>
<h2 align="center"> Create AWS-EKS (Elastic Kubernetes Service) Using Terraform </h2>

### This repository contains Terraform code to provision an Amazon Elastic Kubernetes Service (EKS) cluster on custom AWS VPC. EKS is a managed Kubernetes service that makes it easy to deploy, manage, and scale containerized applications using Kubernetes.

![imagegit](https://github.com/shankar439/Images/assets/70714976/0ae43c4f-9bf2-4e08-8beb-9e6334cee426)


<br>


## Table of Contents
- <a href="#prerequisites"> Prerequisites </a>
- <a href="#what-is-aws-eks-and-its-advantages"> AWS-EKS Advantages </a>
- <a href="#terraform"> Terraform </a>
- <a href="#explanation"> Explanation </a>
- <a href="#resources"> Resources </a>
- <a href="#conclusion"> Conclusion </a>


<br>
<br>


## Prerequisites

Before you begin, ensure that you have the following prerequisites set up:
1. AWS Account: You need an AWS account with appropriate permissions for EKS, IAM, and other required services.
2. Terraform: Install Terraform by following the official [Terraform Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
3. AWS CLI: Configure the AWS CLI with your AWS credentials. You can follow the instructions in the [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html).
4. kubectl: Install kubectl for interacting with the Kubernetes cluster. You can install it by following the [Kubectl Installation Guide](https://kubernetes.io/docs/tasks/tools/).


<br>
<br>


## What is AWS EKS and it's advantages ?. 

  - [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/) `is a managed Kubernetes service that offers several advantages for deploying and managing containerized applications. Here are some key benefits of using EKS:`
  - ### Advantages:
    - `Managed Kubernetes Control Plane` - EKS provides a fully managed Kubernetes control plane, which means AWS takes care of the underlying infrastructure, including patching, scaling, and updates.

    - `High Availability and Scalability` - EKS is designed for high availability and scalability. It runs Kubernetes control plane components across multiple Availability Zones to ensure fault tolerance.

    - `Integrations with AWS Services` - EKS seamlessly integrates with various AWS services, including Elastic Load Balancing, Amazon RDS, Amazon EBS, and more by leveraging IAM.

    - `Serverless option` - EKS supports AWS Fargate to provide serverless compute for containers.
    

<br>
<br>


<h1 align="center">Lets Begin </h1>

<img align="right" src="https://github.com/shankar439/Images/assets/70714976/e5fa9512-1398-4f26-9b0d-87133f415133" height="200" alt="Kubernetes"> 


- Commands Used for this Demo.

    - aws configure
    - terraform init
    - terraform plan
    - terraform apply
    - terraform desstroy
    - aws eks update-kubeconfig --region ap-south-1 --name PG-EKS
    - aws eks update-kubeconfig --region ap-south-1 --name PG-EKS --dry-run


<br>
<br>


## Terraform

- In this AWS-EKS Terraform code I have used [EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest).


<br>


## Explanation

- I have created a AWS-EKS with Terraform EKS Module.
- In this architecture I have used EKS version 1.28 and i have granted access to EKS cluster both from public and private range.
```yaml
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
```

- As the Control Plan is taken care by AWS lets focus on Worker nodes.
- The worker Nodes are grouped using Node groups there are two types. And both support autoscaling using ASG if we leverage with AutoScaler or Karpenter.
  - EKS managed node group - In this group EKS will take care or worker node patches and connectivity.
  - Self managed node group - As it is self we need to take care of these.
```yaml
    spot = {
      desired_size = 3
      min_size     = 1
      max_size     = 5

      labels = {
        role = "spot"
      }

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
```

- Enable_irsa `(IAM role for Service Account)` this is the part where we connect from EKS pod to other AWS services 
by leverage the use of IAM to attach role to kubernetes Service Account. 
This will create an OpenID Connect Provider for EKS.
```yaml
enable_irsa = true
```

- I too installed Nginx-ingress controller, so i allocates a Classic Load Balancer
```yaml
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress --create-namespace
```

<br>
<br>


## Resources

- [AWS-EKS Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [AWS-EKS Examples](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/eks_managed_node_group/main.tf)


<br>
<br>


## Conclusion

- By this setup I am able to save lot of time, where I only use `terraform apply` to provision the entire VPC and AWS EKS.
- In summary, Amazon Elastic Kubernetes Service (EKS) combined with Terraform provides a powerful solution for deploying and managing containerized applications in a scalable, resilient, and cost-effective manner.
- EKS offers a managed Kubernetes environment, taking care of the underlying infrastructure and making it easier to focus on your applications. Terraform, on the other hand, enables you to define your infrastructure as code, making it repeatable and maintainable.


<br>
<br>

<h1 align="center" id="END"> END </h1>
