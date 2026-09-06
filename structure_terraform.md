# Cấu trúc cơ bản của một project Terraform

## 1. Cấu trúc thư mục đề xuất

```
project-root/
├── main.tf              # Tài nguyên chính (resources)
├── variables.tf         # Khai báo input variables
├── outputs.tf           # Khai báo output values
├── providers.tf         # Cấu hình provider (aws, azurerm, ...)
├── versions.tf          # Ràng buộc version Terraform & providers
├── backend.tf           # Cấu hình remote state backend
├── terraform.tfvars     # Giá trị thực tế cho variables (không commit nếu chứa secret)
├── .gitignore
└── modules/
    └── <module-name>/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

Với dự án nhiều môi trường (dev/staging/prod), có thể tách thêm:

```
project-root/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   └── prod/
└── modules/
    ├── vpc/
    ├── ec2/
    └── rds/
```

## 2. Nội dung mẫu từng file

### versions.tf
```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

### providers.tf
```hcl
provider "aws" {
  region = var.aws_region
}
```

### backend.tf
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "project-name/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### variables.tf
```hcl
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}
```

### main.tf — chi tiết các thành phần thường gặp

Lưu ý: việc chia file `main.tf`, `variables.tf`, `providers.tf`... chỉ là **quy ước**, Terraform đọc tất cả file `.tf` trong cùng thư mục như một khối duy nhất. Với project nhỏ/mới học, bạn có thể gộp hết vào `main.tf` cũng chạy được. Dưới đây là các loại "block" thường xuất hiện trong `main.tf`:

**1. `resource` — khai báo tài nguyên cần tạo (thành phần quan trọng nhất)**
```hcl
resource "<PROVIDER>_<LOẠI_TÀI_NGUYÊN>" "<tên_local>" {
  argument_1 = giá_trị
  argument_2 = giá_trị
}
```
Ví dụ:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name        = "web-server"
    Environment = var.environment
  }
}
```
- `aws_instance` = loại tài nguyên (do provider định nghĩa).
- `web` = tên định danh trong code (dùng để tham chiếu: `aws_instance.web.id`), không phải tên hiển thị trên AWS.

**2. `data` — đọc thông tin tài nguyên đã tồn tại (không tạo mới)**
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/*22.04*"]
  }
}
```
Dùng khi cần lấy AMI ID, VPC ID, v.v. có sẵn thay vì hard-code.

**3. `locals` — biến nội bộ, tính toán lại giá trị để dùng nhiều lần**
```hcl
locals {
  name_prefix = "${var.project}-${var.environment}"
}
```
Khác `variable`: `locals` không nhận input từ ngoài, chỉ để đặt tên/rút gọn biểu thức trong file.

**4. `module` — gọi lại code Terraform đã đóng gói (tái sử dụng)**
```hcl
module "vpc" {
  source = "./modules/vpc"

  cidr_block  = "10.0.0.0/16"
  environment = var.environment
}
```

**5. Meta-arguments hay dùng trong `resource`/`module`**
| Argument | Ý nghĩa |
|---|---|
| `count` | Tạo N bản sao giống nhau (dùng index `count.index`) |
| `for_each` | Tạo nhiều bản sao khác nhau dựa trên map/set |
| `depends_on` | Ép thứ tự tạo tài nguyên khi Terraform không tự suy ra được |
| `lifecycle` | Kiểm soát hành vi khi update/destroy (`create_before_destroy`, `prevent_destroy`...) |

Ví dụ `for_each`:
```hcl
resource "aws_instance" "web" {
  for_each      = toset(["dev", "staging"])
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "web-${each.key}"
  }
}
```

**Tóm tắt thứ tự đọc hiểu khi mới học:**
1. `terraform {}` — khai báo version (thường ở `versions.tf`)
2. `provider {}` — kết nối tới đâu (AWS/Azure/GCP...)
3. `variable {}` — input đầu vào
4. `resource {}` / `data {}` — phần chính, thứ bạn thực sự muốn tạo/đọc
5. `locals {}` — biến phụ trợ (tùy chọn)
6. `module {}` — tái sử dụng code (khi project lớn hơn)
7. `output {}` — giá trị trả ra sau khi apply

### outputs.tf
```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}
```

### terraform.tfvars
```hcl
aws_region  = "ap-southeast-1"
environment = "dev"
```

### .gitignore
```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
!example.tfvars
.terraform.lock.hcl
```

## 3. Quy ước đặt tên & best practices

- Dùng `snake_case` cho tên resource, variable, output.
- Mỗi module nên có `README.md` mô tả input/output.
- Không commit `terraform.tfvars` nếu chứa secret; dùng `*.tfvars.example` làm mẫu.
- Luôn commit file `.terraform.lock.hcl` để khóa version provider.
- Tách state theo môi trường (mỗi env một `key` riêng trong backend).

## 4. Các bước chạy Terraform

Chạy các lệnh sau tại thư mục chứa file `.tf` (theo đúng thứ tự):

**1. `terraform init`** — khởi tạo project
```
terraform init
```
- Tải provider (aws, azurerm...) về thư mục `.terraform/`.
- Cấu hình backend (nếu có khai báo trong `backend.tf`).
- Chỉ cần chạy lại khi: mới clone code về, thêm/đổi provider, hoặc đổi backend.

**2. `terraform fmt`** — format code cho đúng chuẩn (tùy chọn nhưng nên làm)
```
terraform fmt -recursive
```

**3. `terraform validate`** — kiểm tra cú pháp hợp lệ (tùy chọn)
```
terraform validate
```

**4. `terraform plan`** — xem trước những gì sẽ thay đổi (bắt buộc nên làm trước khi apply)
```
terraform plan
```
- Không tạo/sửa/xóa gì cả, chỉ hiển thị: cái gì sẽ được tạo mới (`+`), sửa (`~`), xóa (`-`).
- Có thể lưu lại plan để dùng chính xác cho bước apply:
```
terraform plan -out=tfplan
```

**5. `terraform apply`** — thực thi thay đổi lên hạ tầng thật
```
terraform apply
```
- Terraform sẽ hỏi xác nhận `yes` trước khi chạy (trừ khi dùng `-auto-approve`).
- Nếu đã có file plan từ bước trước:
```
terraform apply tfplan
```

**6. `terraform destroy`** — xóa toàn bộ tài nguyên đã tạo (cẩn thận, không hoàn tác được)
```
terraform destroy
```

**Lệnh hỗ trợ khác thường dùng:**
| Lệnh | Công dụng |
|---|---|
| `terraform show` | Xem state hiện tại đang quản lý gì |
| `terraform state list` | Liệt kê tất cả resource đang có trong state |
| `terraform output` | Xem giá trị các `output` sau khi apply |
| `terraform destroy -target=<resource>` | Chỉ xóa 1 resource cụ thể |
| `terraform apply -target=<resource>` | Chỉ apply 1 resource cụ thể |

**Quy trình chuẩn khi làm việc:**
```
terraform init      (chỉ lần đầu / khi đổi provider-backend)
      │
terraform fmt + validate   (kiểm tra nhanh)
      │
terraform plan       (xem trước thay đổi)
      │
terraform apply      (thực thi, gõ "yes" để xác nhận)
```
