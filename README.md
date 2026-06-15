# NT1113-Labs

Dự án này tập trung vào việc triển khai cơ sở hạ tầng mạng trên Azure bằng Terraform và kiểm thử kết nối giữa các máy ảo (VM).

## Cấu trúc thư mục dự án

- lab1-peering: Triển khai mô hình kết nối hai mạng ảo (VNet Peering) trên Azure với 2 Virtual Machines (VM-A và VM-B).
- lab2-virtual-wan: Triển khai mô hình kết nối sử dụng Azure Virtual WAN và Virtual Hub để liên kết 3 mạng ảo khác nhau với 3 Virtual Machines (VM-A, VM-B và VM-C).
- modules: Chứa các module Terraform dùng chung được tái sử dụng trong các bài thực hành.
  - modules/network: Module khởi tạo mạng ảo (Virtual Network), subnet, Network Security Group (NSG) và Route Table.
  - modules/vm: Module khởi tạo máy ảo Linux, kèm Network Interface (NIC) và Public IP.

## Các bước chuẩn bị trước khi chạy kiểm thử

Để chạy được các tập tin kiểm thử (Python test scripts), bạn cần chuẩn bị các yêu cầu sau:

1. Cài đặt Python 3 trên máy tính của bạn.
2. Cài đặt thư viện Paramiko để hỗ trợ kết nối SSH và thực thi lệnh trên các máy ảo. Chạy lệnh sau trong terminal:
   ```bash
   pip install paramiko
   ```
3. Đảm bảo rằng bạn đã triển khai thành công tài nguyên bằng Terraform (`terraform apply`) trong các thư mục lab tương ứng (vì kiểm thử sẽ tự động lấy các giá trị IP từ Terraform outputs).

## Cách chạy test kiểm thử kết nối

Các file test script sẽ tự động thực hiện các nhiệm vụ:
- Đọc thông tin IP public và IP private từ output của Terraform.
- Kiểm tra kết nối SSH từ máy bạn đến các VM qua Public IP.
- Kiểm tra tính kết nối thông qua giao thức Ping giữa các VM bằng IP private.
- Cấu hình xác thực khóa SSH (SSH Key authorization) giữa các VM và kiểm tra kết nối SSH giữa các VM qua mạng nội bộ (Private IP).

### Chạy test cho Lab 1 (VNet Peering)

1. Di chuyển vào thư mục lab1-peering:
   ```bash
   cd lab1-peering
   ```
2. Chạy file test:
   ```bash
   python test_ping.py
   ```

### Chạy test cho Lab 2 (Virtual WAN)

1. Di chuyển vào thư mục lab2-virtual-wan:
   ```bash
   cd lab2-virtual-wan
   ```
2. Chạy file test:
   ```bash
   python test_ping_vwan.py
   ```
