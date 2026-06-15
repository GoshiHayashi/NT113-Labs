# NT1113-Labs

Du an nay chua cac bai thuc hanh (labs) cho mon hoc NT1113, tap trung vao viec trien khai co so ha tang mang tren Azure bang Terraform va kiem thu ket noi giua cac may ao (VM).

## Cau truc thu muc du an

- lab1-peering: Trien khai mo hinh ket noi hai mang ao (VNet Peering) tren Azure voi 2 Virtual Machines (VM-A va VM-B).
- lab2-virtual-wan: Trien khai mo hinh ket noi su dung Azure Virtual WAN va Virtual Hub de lien ket 3 mang ao khac nhau voi 3 Virtual Machines (VM-A, VM-B va VM-C).
- modules: Chua cac module Terraform dung chung duoc tai su dung trong cac bai thuc hanh.
  - modules/network: Module khoi tao mang ao (Virtual Network), subnet, Network Security Group (NSG) va Route Table.
  - modules/vm: Module khoi tao may ao Linux, kem Network Interface (NIC) va Public IP.

## Cac buoc chuan bi truoc khi chay kiem thu

De chay duoc cac tap tin kiem thu (Python test scripts), ban can chuan bi cac yeu cau sau:

1. Cai dat Python 3 tren may tinh cua ban.
2. Cai dat thu vien Paramiko de ho tro ket noi SSH va thuc thi lenh tren cac may ao. Chay lenh sau trong terminal:
   ```bash
   pip install paramiko
   ```
3. Dam bao rang ban da trien khai thanh cong tai nguyen bang Terraform (`terraform apply`) trong cac thu muc lab tuong ung (vi kiem thu se tu dong lay cac gia tri IP tu Terraform outputs).

## Cach chay test kiem thu ket noi

Cac file test script se tu dong thuc hien cac nhiem vu:
- Doc thong tin IP public va IP private tu output cua Terraform.
- Kiem tra ket noi SSH tu may ban den cac VM qua Public IP.
- Kiem tra tinh ket noi thong qua giao thuc Ping giua cac VM bang IP private.
- Cau hinh xac thuc khoa SSH (SSH Key authorization) giua cac VM va kiem tra ket noi SSH giua cac VM qua mang noi bo (Private IP).

### Chay test cho Lab 1 (VNet Peering)

1. Di chuyen vao thu muc lab1-peering:
   ```bash
   cd lab1-peering
   ```
2. Chay file test:
   ```bash
   python test_ping.py
   ```

### Chay test cho Lab 2 (Virtual WAN)

1. Di chuyen vao thu muc lab2-virtual-wan:
   ```bash
   cd lab2-virtual-wan
   ```
2. Chay file test:
   ```bash
   python test_ping_vwan.py
   ```
