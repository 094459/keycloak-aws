import aws_cdk as core
import aws_cdk.assertions as assertions

from keycloak_cdk.keycloak_cdk_stack import KeycloakCdkStack

# example tests. To run these tests, uncomment this file along with the example
# resource in keycloak_cdk/keycloak_cdk_stack.py
def test_sqs_queue_created():
    app = core.App()
    stack = KeycloakCdkStack(app, "keycloak-cdk")
    template = assertions.Template.from_stack(stack)

#     template.has_resource_properties("AWS::SQS::Queue", {
#         "VisibilityTimeout": 300
#     })
