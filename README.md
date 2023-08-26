# Terraform-Labs
Terraform Tutorials &amp; Training

 Updatinng this to configure aadb2c_directory and see if it shows the directory or if we need to update anything.
======= 
aadb2c_directory
1. We created a new directory in Azure AD B2C called exampleb2ctenatn.onmicrosoft.com
2. We created a resource group called example and attached to our newly created B2C Tenant
3. We destroyed the resources and utilized IaC throughout the whole process

Here's a short summary about what it means to use B2C Tenant in Azure AD B2C:
An Azure AD B2C tenant represents a collection of identities to be used with relying party applications. By adding New OpenID Connect provider under Azure AD B2C > Identity providers or with custom policies, Azure AD B2C can federate to Azure AD allowing authentication of employees in an organization.
