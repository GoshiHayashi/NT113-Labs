import paramiko
import json
import subprocess
import sys

def get_terraform_outputs():
    print("Reading outputs from Terraform...")
    try:
        # Run 'terraform output -json' to get dynamic IPs
        output = subprocess.check_output(["terraform", "output", "-json"], text=True)
        data = json.loads(output)
        return {
            "vm_a_public_ip": data["vm_a_public_ip"]["value"],
            "vm_b_public_ip": data["vm_b_public_ip"]["value"],
            "vm_a_private_ip": data["vm_a_private_ip"]["value"],
            "vm_b_private_ip": data["vm_b_private_ip"]["value"],
        }
    except Exception as e:
        print(f"Error reading terraform outputs: {e}")
        print("Falling back to hardcoded IPs...")
        return {
            "vm_a_public_ip": "20.247.104.92",
            "vm_b_public_ip": "104.208.90.114",
            "vm_a_private_ip": "10.0.0.4",
            "vm_b_private_ip": "10.1.0.4",
        }

def test_connection():
    ips = get_terraform_outputs()
    
    username = "azureuser"
    password = "AzureP@ssw0rd123!" # Default password configured in variables.tf
    
    print("\n=== SYSTEM IP INFO ===")
    for k, v in ips.items():
        print(f"{k}: {v}")
    print("======================\n")

    # Connect to VM-A
    print(f"Connecting to VM-A ({ips['vm_a_public_ip']})...")
    client_a = paramiko.SSHClient()
    client_a.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    # Connect to VM-B
    print(f"Connecting to VM-B ({ips['vm_b_public_ip']})...")
    client_b = paramiko.SSHClient()
    client_b.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        client_a.connect(ips['vm_a_public_ip'], username=username, password=password, timeout=10)
        print("Connected to VM-A successfully!")
        
        client_b.connect(ips['vm_b_public_ip'], username=username, password=password, timeout=10)
        print("Connected to VM-B successfully!")
        
        # 1. Test ping VM-A -> VM-B
        print(f"\n--- 1. Testing Ping from VM-A to VM-B via Private IP ({ips['vm_b_private_ip']}) ---")
        stdin, stdout, stderr = client_a.exec_command(f"ping -c 4 {ips['vm_b_private_ip']}")
        print(stdout.read().decode())
        print(stderr.read().decode())
        
        # 2. Setup passwordless SSH from VM-A -> VM-B
        print("\n--- 2. Setting up SSH Key authorization between VMs ---")
        
        # Generate SSH key on VM-A if not exists
        print("Checking/Generating SSH Key on VM-A...")
        client_a.exec_command("mkdir -p ~/.ssh && chmod 700 ~/.ssh")
        stdin, stdout, stderr = client_a.exec_command("[ -f ~/.ssh/id_rsa ] || ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa")
        stdout.read(); stderr.read() # Wait for execution
        
        # Get VM-A public key
        stdin, stdout, stderr = client_a.exec_command("cat ~/.ssh/id_rsa.pub")
        vm_a_pub_key = stdout.read().decode().strip()
        
        # Append VM-A pub key to VM-B authorized_keys
        print("Adding VM-A public key to VM-B authorized keys...")
        client_b.exec_command("mkdir -p ~/.ssh && chmod 700 ~/.ssh")
        client_b.exec_command(f"echo '{vm_a_pub_key}' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys")
        
        # 3. Test SSH from VM-A -> VM-B using Private IP
        print(f"\n--- 3. Testing SSH from VM-A to VM-B via Private IP ({ips['vm_b_private_ip']}) ---")
        ssh_cmd = f"ssh -o StrictHostKeyChecking=no azureuser@{ips['vm_b_private_ip']} 'hostname && ip addr show dev eth0'"
        stdin, stdout, stderr = client_a.exec_command(ssh_cmd)
        
        print("Output of remote execution on VM-B from VM-A:")
        print(stdout.read().decode())
        print(stderr.read().decode())

    except Exception as e:
        print(f"Error occurred during testing: {e}")
    finally:
        client_a.close()
        client_b.close()

if __name__ == "__main__":
    test_connection()
