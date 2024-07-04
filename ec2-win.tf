locals {
    # Get configuration data from the JSON file
    config_data = jsondecode(file("${path.module}/config.json"))

    # Extract parameters from the configuration data
    hostname = local.config_data.hostname
    users = local.config_data.users
    features = local.config_data.features
}

# Define the AWS EC2 Windows instance
resource "aws_instance" "exercise_ec2_win" {
  ami           = data.aws_ami.windows_2022.id
  instance_type = var.instance_type

  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.win_sg.security_group_id]
  key_name               = module.key_pair.key_pair_name

  # Construct user_data script to configure the instance
  user_data = <<-EOF
    <powershell>
    # Rename the computer using the hostname from the configuration data
    Rename-Computer -NewName "${local.hostname}" -Force -PassThru

    # Define the list of features to be installed dynamically
    $allFeatures = @("${join("\", \"", local.features)}")

    # Iterate through each feature and install it
    foreach ($feat in $allFeatures) {
        Install-WindowsFeature -Name $feat -IncludeManagementTools
    }

    # Define the list of users to be created dynamically
    $allUsers = @("${join("\", \"", local.users)}")

    # Iterate through each user and create a local user with a predefined password
    foreach ($user in $allUsers) {
        $password = ConvertTo-SecureString "P@ssDgH53Hdw0DgHdErd123" -AsPlainText -Force
        New-LocalUser "azure_agent_user" -Password $password
    }

    # Get a list of disks that need initialization and formatting
    $disks = Get-Disk | Where-Object PartitionStyle -Eq 'RAW'

    # Iterate through each disk, initialize, partition, and format it
    foreach ($disk in $disks) {
        Initialize-Disk -Number $disk.Number -PartitionStyle GPT
        
        # Create a new partition on the disk using the maximum available size and assign a drive letter automatically
        $partition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter
        
        # Format the new partition with the NTFS file system and assign a new file system label
        Format-Volume -DriveLetter $partition.DriveLetter -FileSystem NTFS -NewFileSystemLabel "External Volume $($disk.Number)"
    }
    Start-Sleep -Seconds 60
    Restart-Computer -Force

    </powershell>
    EOF

  # Configure root disk parameters
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  # Configure extra disk parameters
  ebs_block_device {
    device_name           = "/dev/xvdf"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-windows-server"
    Environment = var.app_environment
  }
}
