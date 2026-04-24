# The region where you want to host the app
aws_region = "us-east-1"

# The EC2 instance type (e.g., t2.micro for free tier)
instance_type = "t2.micro"

# Replace with the EXACT name of your .pem key in AWS
key_name = "dmi-cohort2-keypair"

# Replace with your actual public IP (visit whatismyip.com)
# This fulfills the "SSH restricted to your IP" requirement in Phase 7
my_ip = "65.34.64.90"

project_name = "theepicbook"