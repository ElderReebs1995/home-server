import os
import sys
import subprocess

def test_node_connectivity(ip_address):
    print(f"[*] Proactive Check: Verifying network route to target node: {ip_address}...")
    
    # Run a single ping packet sweep to verify the route is open
    param = '-n' if os.name == 'nt' else '-c'
    command = ['ping', param, '1', ip_address]
    
    # Execute the system command quietly
    result = subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    if result.returncode == 0:
        print(f"[+] Success: Target node {ip_address} is responsive and reachable!")
        return True
    else:
        print(f"[-] Critical Error: Cannot establish a network route to {ip_address}.")
        print("[*] Triage Action: Verify host power state, physical ethernet, or local IP allocation.")
        return False

if __name__ == "__main__":
    target_pi_ip = "192.168.4.68"
    
    if not test_node_connectivity(target_pi_ip):
        # Exit with a non-zero status code if the network route is dead.
        # This tells Terraform to halt deployment and flag an error immediately.
        sys.exit(1)
        
    print("[+] Automation Suite Pre-checks Complete. Standing by for infrastructure confirmation.")