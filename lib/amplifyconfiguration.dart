const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "6d277033f79a4cde90476c6ee64a0e79",
                    "region": "us-east-1"
                },
                "pinpointTargeting": {
                    "region": "us-east-1"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "6d277033f79a4cde90476c6ee64a0e79",
                        "Region": "us-east-1"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "us-east-1"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:f659096d-88de-4af4-931b-98aae4d40dde",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_OWJolgLKu",
                        "AppClientId": "7hj8avao3kjrvppbg3oi0hqna1",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "DynamoDBObjectMapper": {
                    "Default": {
                        "Region": "us-east-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsDynamoDbStoragePlugin": {
                "partitionKeyName": "id",
                "sortKeyName": "trailId",
                "sortKeyType": "S",
                "region": "us-east-1",
                "arn": "arn:aws:dynamodb:us-east-1:654654343438:table/trailReviews-dev",
                "streamArn": "arn:aws:dynamodb:us-east-1:654654343438:table/trailReviews-dev/stream/2024-04-27T18:15:12.697",
                "partitionKeyType": "S",
                "name": "trailReviews-dev"
            }
        }
    }
}''';
