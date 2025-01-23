#### **Description:**
This repository contains scripts for setting up and managing **Azure VPN client certificates** and configurations. The scripts automate the process of generating **root and client certificates**, modifying VPN configuration files, and ensuring a smooth setup process.

---

## **Repository Structure**
```
/azure-vpn-setup/
│── create_client_cert.sh     # Script to generate a client certificate
│── create_root_cert.sh       # Script to generate a root certificate
│── modify_vpnconfig.sh       # Script to modify the OpenVPN configuration file
│── README.md                 # Documentation & instructions
```

---

## **How to Use These Scripts**
These scripts help automate VPN setup, including creating certificates and modifying VPN configuration files.

### **1️⃣ Prerequisites**
- An **Azure VPN Gateway** configured with **point-to-site VPN**
- OpenSSL installed (`sudo dnf install openssl` on AlmaLinux)
- OpenVPN installed (`sudo dnf install openvpn` on AlmaLinux)
- Terraform (if deploying infrastructure via Terraform)

---

### **2️⃣ Generating Certificates**
#### **🔹 Step 1: Create the Root Certificate**
Run the following command to generate a root certificate:
```bash
./create_root_cert.sh
```
- This script generates a **root certificate** (`AzureRootCert.pem`).
- The root certificate should be uploaded to the **Azure VPN Gateway**.

#### **🔹 Step 2: Generate a Client Certificate**
After the root certificate is created, generate a client certificate:
```bash
./create_client_cert.sh
```
- This script generates a client certificate (`AzureClientCert.crt`).
- The client certificate must be installed on the client machine.

---

### **3️⃣ Modifying the VPN Configuration**
#### **🔹 Step 3: Modify the VPN Configuration**
If modifications to the `.ovpn` file are needed (e.g., adding certificate references), run:
```bash
./modify_vpnconfig.sh vpnconfig.ovpn
```
- This script updates the VPN configuration file as required.

---

### **4️⃣ Connecting to the VPN**
Once the VPN configuration is ready:
```bash
sudo openvpn --config vpnconfig.ovpn
```
If you want to run OpenVPN as a **systemd service**, follow these steps:
1. Move the configuration file:
   ```bash
   sudo cp vpnconfig.ovpn /etc/openvpn/client.conf
   ```
2. Start the OpenVPN service:
   ```bash
   sudo systemctl start openvpn@client
   ```
3. Enable the service at boot:
   ```bash
   sudo systemctl enable openvpn@client
   ```
4. Check VPN status:
   ```bash
   sudo systemctl status openvpn@client
   ```

---

### **Troubleshooting**
If you encounter issues:
- Check OpenVPN logs:
  ```bash
  sudo journalctl -u openvpn@client --no-pager -n 50
  ```
- Ensure the correct **root and client certificates** are used.
- Make sure the **Azure VPN Gateway** has the root certificate uploaded.

---

### **Contributing**
Feel free to fork the repo, open an issue, or submit a pull request for improvements.

---
