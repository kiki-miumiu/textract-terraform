# import boto3

# def analyze_expense(bucket, document):
#     client = boto3.client('textract')
    
#     response = client.analyze_expense(
#         Document={
#             'S3Object': {
#                 'Bucket': bucket,
#                 'Name': document
#             }
#         }
#     )
    
#     return response

def lambda_handler(event, context):
    result = 'Sucess'
    # bucket_name = 'terraform-state-061039763240'
    # document_name = 'hello.jpeg'
    # expense_response = analyze_expense(bucket_name, document_name)
    # print(expense_response)
    return {
        'statusCode' : 200,
        'body': result
    }
