const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:102fdced-bf6d-45db-b89e-c17a46e91f2f",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_2rLqPCemm",
                        "AppClientId": "4ple56rpailjbqehqgj4vg30mi",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "pandacustomersmastera0be86b0-a0be86b0-dev.auth.us-east-1.amazoncognito.com",
                            "AppClientId": "4ple56rpailjbqehqgj4vg30mi",
                            "SignInRedirectURI": "myapp://callback/",
                            "SignOutRedirectURI": "myapp://signout/",
                            "Scopes": [
                                "phone",
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [
                            "GOOGLE"
                        ],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    },
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "pandacustomersmaster": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://fvdfhzv5snhn7eo62xzyz6ytgi.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-tvp27jdvtnbr7avnnzfrvfcxe4"
                }
            }
        }
    }
}''';


/*
  '''{ "API":{
  "aws_appsync_region": "us-east-1",
  "aws_appsync_graphqlEndpoint": "https://fvdfhzv5snhn7eo62xzyz6ytgi.appsync-api.us-east-1.amazonaws.com/graphql",
  "aws_appsync_authenticationType": "API_KEY", 
  "aws_appsync_apiKey": "da2-tvp27jdvtnbr7avnnzfrvfcxe4"
  }
}''';

*/

/*{
  aws_appsync_region: 'us-east-1', // (optional) - AWS AppSync region
  aws_appsync_graphqlEndpoint:
    'https://<app-id>.appsync-api.<region>.amazonaws.com/graphql', // (optional) - AWS AppSync endpoint
  aws_appsync_authenticationType: 'AMAZON_COGNITO_USER_POOLS', // (optional) - Primary AWS AppSync authentication type
  graphql_endpoint: 'https://www.yourdomain.com/graphql', // (optional) - Custom GraphQL endpoint
  aws_appsync_apiKey: 'da2-xxxxxxxxxxxxxxxxxxxxxxxxxx', // (optional) - AWS AppSync API Key
  graphql_endpoint_iam_region: 'us-east-1' // (optional) - Custom IAM region
}*/