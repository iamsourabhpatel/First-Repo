#!/bin/bash

###########################################################################
# Author      : Sourabh Patel
# Date        : 29/09/2026
#
# Description : Tracks and reports key AWS resources (S3, EC2, Lambda, IAM)
# Version     : V1
###########################################################################

set -e
set -o pipefail

# Output log file
REPORT_FILE="aws_resource_report_$(date +%Y%m%d_%H%M%S).txt"

# Helper function to print section headers
print_header() {
    echo "==================================================" | tee -a "$REPORT_FILE"
    echo "  $1" | tee -a "$REPORT_FILE"
    echo "==================================================" | tee -a "$REPORT_FILE"
}

exec > >(tee -i "$REPORT_FILE") 2>&1

echo "AWS Resource Usage Report"
echo "Generated on: $(date)"
echo ""

# 1. Track S3 Buckets
print_header "S3 BUCKETS"
aws s3 ls || true
echo ""

# 2. Track EC2 Instances
print_header "EC2 INSTANCES (Instance ID | Type | State)"
aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].[InstanceId, InstanceType, State.Name]" \
    --output table || true
echo ""

# 3. Track Lambda Functions
print_header "LAMBDA FUNCTIONS (FunctionName | Runtime)"
aws lambda list-functions \
    --query "Functions[*].[FunctionName, Runtime]" \
    --output table || true
echo ""

# 4. Track IAM Users
print_header "IAM USERS (UserName | UserId | CreateDate)"
aws iam list-users \
    --query "Users[*].[UserName, UserId, CreateDate]" \
    --output table || true
echo ""

echo "Report generation complete! Output saved to: $REPORT_FILE"
