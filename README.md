## Installing KeyCloak on AWS

This repo contains code to help you use the AWS CDK cdk-keycloak construct to deploy newer/later versions KeyCloak (v17 onwards) on AWS. 

To use this repo you will need to create a certificate in Amazon Certificate Manager. You will need to have the Arn for this certificate so make sure you complete this before proceeding. You will also need the ability to update the DNS record for that certificate later on once the KeyCloak ECS cluster has deployed, so make sure you are able to do that to.

To deploy follow these steps:

1. The first thing you need to do is build your custom KeyCloak container image. To help you there is a script in the docker directory called build.sh. BEFORE you run this however, you need to download and copy into the "providers" folder a bunch of jar files. The README file in the providers folder has helpful links.

2. Once you have downloaded the jar files into the providers folder, you should review the Docker file and make sure it fits your needs (for example, the version of KeyCloak you want to use)

3. You are now ready to run the build script. Review and update the script to include the info about your AWS environment. Once you have updated this, run the build script which will build, tag and then push a container image to your Amazon ECR repo. This  might take a while depending on the speed of your internet.

4. Once this has completed, make sure you grab the URI for the image you just uploaded (for example, 123456789012.dkr.ecr.eu-west-1.amazonaws.com/keycloak:21.1.1-amd64) as you will need that when configuring your CDK app

5. Review the app.py in the root folder and update as follows:

* update {replacewithyourawsregion} and {replacewithyourawsaccount} to reflect your AWS Account
* update {replacewithyourcertificatearn} with the Certificate Arn you created at the beginning
* update {replacewithyourcustomdns} with the domain name you used for your certificate (for example, my-keycloak.demo.com)
* update {replacewithyourecrcontainerimage} with the URI for your custom KeyCloak container image you creatd in step 4

Once you have updated, save the file.

6. Deploy the stack using the following command: cdk deploy keycloak-demo

You will be asked to confirm security details. Review and if happy, proceed to deploy by answering Y. The stack will take around 20-25 minutes to complete, and once finished you will be presented with some details of the resources that were created.

```
keycloak-demo: creating CloudFormation changeset...

 ✅  keycloak-demo

✨  Deployment time: 1012.98s

Outputs:
keycloak-demo.KeyCloakDatabaseDBSecretArn28BEB641 = arn:aws:secretsmanager:eu-west-1:xxxxx:secret:keycloakdemoKeyCloakDatabas-xxxxxx-1TosEJ
keycloak-demo.KeyCloakDatabaseclusterEndpointHostname38FB0D1E = keycloak-demo-keycloakdatabasedbcluster06e9c0e1-hzjlnplxzu6i.cluster-ceinb9vexcbc.eu-west-1.rds.amazonaws.com
keycloak-demo.KeyCloakDatabaseclusterIdentifierF00C290B = keycloak-demo-keycloakdatabasedbcluster06e9c0e1-hzjlnplxzu6i
keycloak-demo.KeyCloakKeyCloakContainerSerivceEndpointURL9C81E19A = https://keycl-KeyCl-7Y47664RLHT5-2141835688.eu-west-1.elb.amazonaws.com
Stack ARN:
arn:aws:cloudformation:eu-west-1:xxxxxx:stack/keycloak-demo/9a6e8260-045c-11ee-bb15-062703c4f3a7

✨  Total time: 1025.66s
```

7. Use the info from the output above (keycloak-demo.KeyCloakKeyCloakContainerSerivceEndpointxxxxxx) to update the DNS record for the certificate you created. Create a CNAME record pointing the ELB to the domain record. This will allow you to access KeyCloak via a simple link like  "https://my-keycloak.demo.com"

8. Congratulations, with a bit of luck you should now have a KeyCloak service up and running.