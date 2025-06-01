"""
Create a docker service form a JSON file which can be exported using 'docker service inspect'.
"""

import json
import subprocess
import sys

# Check if the JSON file name is provided as a command line argument
if len(sys.argv) < 2:
    print("Please provide the JSON file name as a command line argument.")
    sys.exit(1)

# Get the JSON file name from the command line argument
json_file = sys.argv[1]

# Load the JSON output from the inspect command
with open(json_file, 'r') as file:
    service_info = json.load(file)

# Extract relevant service configuration
service_spec = service_info[0]['Spec']

# Check if the service already exists
service_name = service_info[0]['Spec']['Name']
existing_service_check = subprocess.run(['docker', 'service', 'ls', '--format', '{{.Name}}'], capture_output=True, text=True)
service_exists = service_name in existing_service_check.stdout

# Construct the docker service command
command = ['docker', 'service']

# Determine whether to create or update the service
if service_exists:
    command.append('update')
    print(f"UPDATING existing service: '{service_name}' ")
    env_param = '--env-add'

else:
    command.append('create')
    command.extend(['--name', service_name])
    env_param = '--env'
    print(f"CREATING new service: '{service_name}' ")

# Construct the docker service create command by iterating over the service spec
for key, value in service_spec.items():
    # Skip properties which are not recognized
    if key in ['Name', 'Labels', 'Mode', 'Constraints', 'TaskTemplate', 'Env']:
        # Convert boolean options to appropriate flags
        if isinstance(value, bool):
            if value:
                command.append('--' + key.lower())
        # Process replicas as a separate flag
        elif key == 'Mode':
            replicas = value['Replicated']['Replicas']
            command.extend(['--replicas', str(replicas)])
        # Process Labels as separate key-value pairs
        elif key == 'Labels':
            for label_key, label_value in value.items():
                command.extend(['--label', f'{label_key}={label_value}'])
        # Process Constraints as separate constraints
        elif key == 'Constraints':
            for constraint in value:
                command.extend(['--constraint', constraint])
        # Process Volumes as separate volumes
        elif key == 'TaskTemplate' and 'ContainerSpec' in value:
            container_spec = value['ContainerSpec']
            if 'Mounts' in container_spec:
                for mount in container_spec['Mounts']:
                    command.extend(['--mount', mount['Type'] + '=' + mount['Source'] + ':' + mount['Target']])
            # Add environment variables using --env flag
            if 'Env' in container_spec:
                env_list = container_spec['Env']
                for env_var in env_list:
                    command.extend([env_param, env_var])
    else:
        print("JSON key ignored:", key)

image_name = service_spec['TaskTemplate']['ContainerSpec']['Image']

if service_exists:
    command.extend(['--image', image_name])
    command.append(service_name)

else:
    command.append(image_name)

# Specify the image and tag as the last parameter for the service


# Print the final command
print("\nRunning command:", " ".join(command))

# Create the new service
subprocess.run(command)
