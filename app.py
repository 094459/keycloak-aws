#!/usr/bin/env python3
import os

import aws_cdk as cdk
import aws_cdk.aws_rds as rds 
import aws_cdk.aws_ecs as ecs
from cdk_keycloak import KeyCloak, KeycloakVersion
from aws_cdk import CfnOutput

app = cdk.App()
env = cdk.Environment(region="{replacewithyourawsregion}", account="{replacewithyourawsaccount}")

stack = cdk.Stack(app, "keycloak-demo", env=env)

mysso = KeyCloak(stack, "KeyCloak",
    certificate_arn="{replacewithyourcertificatearn}",
    keycloak_version=KeycloakVersion.V21_0_1,
    cluster_engine = rds.DatabaseClusterEngine.aurora_mysql(version=rds.AuroraMysqlEngineVersion.VER_2_11_2),
    hostname = "{replacewithyourcustomdns}",
    env = { "KEYCLOAK_FRONTEND_URL" : "{replacewithyourcustomdns}"},
    container_image = ecs.ContainerImage.from_registry("{replacewithyourecrcontainerimage}"),
    database_removal_policy=cdk.RemovalPolicy.DESTROY
)

CfnOutput(
            stack,
            id="KeyCloakSecret",
            value=mysso.keycloak_secret.secret_full_arn,
            description="Keycloak admin username and password"
        )
app.synth()