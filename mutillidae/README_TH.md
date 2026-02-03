# OWASP Mutillidae II - Penetration Testing Lab

## ภาพรวม

Lab นี้ประกอบด้วย **Mutillidae** (เว็บแอปพลิเคชันที่มีช่องโหว่สำหรับฝึกฝน) และ **Kali Linux GUI** (เครื่องมือสำหรับการเจาะระบบ) ที่รันบน Docker และเชื่อมต่อกันได้ผ่าน Docker network

## องค์ประกอบของ Lab

### 1. Mutillidae (Target Application)
- **www**: Apache + PHP + Mutillidae source code (Port 80, 443)
- **database**: MySQL database (ไม่เปิด port ภายนอก)
- **database_admin**: PHPMyAdmin (Port 81)
- **directory**: OpenLDAP (Port 389)
- **directory_admin**: PHPLDAPAdmin (Port 82)

### 2. Kali Linux (Attacker Machine)
- **kali-gui**: Kali Linux Desktop พร้อม GUI (Browser Mode - Port 6901)

## ข้อกำหนดเบื้องต้น

- **Docker Desktop** ติดตั้งและรันอยู่บน Mac
- **Git** (สำหรับ clone repository)
- **เบราว์เซอร์** (Chrome, Safari, Firefox)

## การติดตั้งและเริ่มใช้งาน

### ขั้นตอนที่ 1: Clone Repository

```bash
cd /Users/kbbk/Secure
git clone https://github.com/webpwnized/mutillidae.git
cd mutillidae
```

### ขั้นตอนที่ 2: Build และรัน Containers

```bash
docker-compose up -d --build
```

คำสั่งนี้จะ:
- Build Docker images จาก source code
- สร้าง containers ทั้งหมด (Mutillidae + Kali Linux)
- เชื่อมต่อ containers เข้ากับ network เดียวกัน

**หมายเหตุ**: การ build ครั้งแรกอาจใช้เวลานาน (10-20 นาที) เนื่องจากต้องดาวน์โหลด base images และ compile PHP extensions

### ขั้นตอนที่ 3: ตั้งค่าฐานข้อมูล (ทำครั้งแรกครั้งเดียว)

1. รอให้ containers เริ่มทำงานเสร็จ (ประมาณ 1-2 นาที)
2. เปิดเบราว์เซอร์บน Mac ไปที่: `http://localhost/set-up-database.php`
3. ระบบจะสร้างตารางฐานข้อมูลอัตโนมัติ

### ขั้นตอนที่ 4: เข้าใช้งาน

#### เข้าใช้งาน Mutillidae (จาก Mac)

- **เว็บหลัก**: http://localhost
- **HTTPS**: https://localhost (อาจมี warning เรื่อง certificate)
- **PHPMyAdmin**: http://localhost:81
- **PHPLDAPAdmin**: http://localhost:82

#### เข้าใช้งาน Kali Linux GUI (Browser Mode)

1. เปิดเบราว์เซอร์บน Mac
2. ไปที่: **https://localhost:6901**
3. **คำเตือนความปลอดภัย**: จะมี warning เรื่อง self-signed certificate
   - กด **Advanced** → **Proceed to localhost (unsafe)**
4. **Login**:
   - Username: `kasm_user`
   - Password: `password`
5. คุณจะเห็นหน้าจอ Kali Linux Desktop ในเบราว์เซอร์

## การทดสอบการเชื่อมต่อ

### ทดสอบจาก Kali ไปหา Mutillidae

1. เปิด Terminal ใน Kali Linux GUI (ไอคอน Terminal สีดำ)
2. ทดสอบ ping:
   ```bash
   ping www
   ```
3. ทดสอบการเข้าถึงเว็บ:
   ```bash
   curl http://www
   ```

### ใช้งาน Mutillidae จาก Kali Linux

1. เปิด Firefox ใน Kali Linux GUI
2. ไปที่: `http://www` หรือ `http://www/mutillidae`
3. ตอนนี้คุณสามารถใช้ tools ใน Kali (เช่น Burp Suite, SQLMap, Nmap) เพื่อโจมตี Mutillidae ได้

## คำสั่งที่จำเป็น

### เริ่มระบบ
```bash
docker-compose up -d
```

### หยุดระบบ
```bash
docker-compose down
```

### หยุดและลบ volumes (ลบข้อมูลทั้งหมด)
```bash
docker-compose down -v
```

### ดู logs
```bash
# ดู logs ของทุก services
docker-compose logs

# ดู logs ของ service เฉพาะ
docker-compose logs www
docker-compose logs kali-gui
```

### Rebuild containers (เมื่อแก้ไข Dockerfiles)
```bash
docker-compose up -d --build
```

### ดูสถานะ containers
```bash
docker-compose ps
```

## โครงสร้างไฟล์

```
mutillidae/
├── docker-compose.yml          # ไฟล์หลักสำหรับ Docker Compose
├── Dockerfile.www              # Dockerfile สำหรับ Apache/PHP
├── Dockerfile.database         # Dockerfile สำหรับ MySQL
├── Dockerfile.database_admin   # Dockerfile สำหรับ PHPMyAdmin
├── Dockerfile.directory        # Dockerfile สำหรับ OpenLDAP
├── Dockerfile.directory_admin  # Dockerfile สำหรับ PHPLDAPAdmin
├── src/                        # Source code ของ Mutillidae
│   ├── includes/
│   │   ├── database-config.inc
│   │   └── ldap-config.inc
│   └── ...
└── README_TH.md               # ไฟล์นี้
```

## Network Configuration

Lab นี้ใช้ 2 networks:

- **datanet**: เชื่อมต่อ www, database, database_admin, kali-gui
- **ldapnet**: เชื่อมต่อ www, directory, directory_admin, kali-gui

Kali Linux เชื่อมต่อกับทั้ง 2 networks เพื่อให้เข้าถึงทุก services ได้

## การแก้ไข Source Code

Source code ของ Mutillidae อยู่ในโฟลเดอร์ `src/` และถูก mount เป็น volume ใน container `www` ดังนั้น:

- **การแก้ไขไฟล์ใน `src/` จะมีผลทันที** (ไม่ต้อง rebuild)
- **การแก้ไข Dockerfiles ต้อง rebuild**: `docker-compose up -d --build`

## ข้อควรระวังสำหรับ Mac M2/M3

1. **Platform Compatibility**: 
   - Mutillidae services ใช้ `platform: linux/amd64` เพื่อรองรับ Mac M2/M3
   - Kali Linux (Kasm) รองรับ ARM64 native จึงไม่ต้องใช้ platform

2. **Performance**:
   - การรัน AMD64 images บน Mac M2/M3 จะใช้ Rosetta 2 emulation
   - อาจรู้สึกหน่วงเล็กน้อย แต่ใช้งานได้ปกติ

3. **Memory**:
   - Lab นี้ใช้ RAM ประมาณ 2-4 GB
   - ตรวจสอบว่า Docker Desktop มี RAM เพียงพอ

## Troubleshooting

### ปัญหา: Containers ไม่ start

```bash
# ตรวจสอบ logs
docker-compose logs

# ตรวจสอบว่า ports ไม่ถูกใช้งาน
lsof -i :80
lsof -i :6901
```

### ปัญหา: Database ไม่เชื่อมต่อ

1. ตรวจสอบว่า database container รันอยู่:
   ```bash
   docker-compose ps database
   ```

2. ตรวจสอบ logs:
   ```bash
   docker-compose logs database
   ```

3. รอให้ database พร้อมก่อน (ประมาณ 30 วินาที) แล้วลอง setup database อีกครั้ง

### ปัญหา: Kali GUI ไม่เปิด

1. ตรวจสอบว่า container รันอยู่:
   ```bash
   docker-compose ps kali-gui
   ```

2. ลองใช้ HTTP แทน HTTPS:
   - http://localhost:6901 (บางครั้ง HTTPS อาจมีปัญหา)

3. ตรวจสอบ logs:
   ```bash
   docker-compose logs kali-gui
   ```

### ปัญหา: ไม่สามารถ ping จาก Kali ไปหา www ได้

**หมายเหตุ**: Kali container อาจไม่มี `ping` ติดตั้ง และการติดตั้งอาจมีปัญหา dependency conflict

**วิธีแก้**: ใช้วิธีอื่นทดสอบการเชื่อมต่อแทน:

1. **ใช้ curl (แนะนำ)**:
   ```bash
   curl http://www
   # ถ้าเห็น HTML code แสดงว่าเชื่อมต่อได้
   ```

2. **ใช้ wget**:
   ```bash
   wget -O- http://www
   ```

3. **ใช้ getent (ตรวจสอบ DNS resolution)**:
   ```bash
   getent hosts www
   # ควรเห็น IP address ของ www container
   ```

4. **เปิด Firefox และทดสอบโดยตรง**:
   - เปิด Firefox ใน Kali Linux
   - ไปที่: `http://www` หรือ `http://www/index.php`
   - ถ้าเห็นหน้า Mutillidae แสดงว่าเชื่อมต่อได้

5. **ติดตั้ง inetutils-ping (alternative)**:
   ```bash
   # ใน Kali terminal (เป็น root)
   apt-get update
   apt-get install -y inetutils-ping
   # หรือ
   apt-get install -y iputils-ping --fix-broken
   ```

## การตั้งค่ารหัสผ่านสำหรับ sudo ใน Kali

**หมายเหตุ**: Kasm image อาจมีปัญหา PAM configuration ที่ทำให้ `chpasswd` ไม่ทำงาน

### วิธีที่ 1: ใช้ root user โดยตรง (แนะนำ - ไม่ต้องตั้งรหัสผ่าน)

```bash
# เข้าไปใน container เป็น root (ไม่ต้องใช้ sudo)
docker exec -it --user root attacker-kali bash

# ตอนนี้คุณเป็น root แล้ว ไม่ต้องใช้ sudo
apt-get update
apt-get install -y <package-name>
```

### วิธีที่ 2: ตั้งรหัสผ่านด้วย usermod (ถ้าต้องการใช้ sudo)

```bash
# ตั้งรหัสผ่านให้ kasm_user ใช้ usermod
docker exec -it --user root attacker-kali bash -c "usermod -p \$(openssl passwd -1 password) kasm_user"

# ตั้งรหัสผ่านให้ root
docker exec -it --user root attacker-kali bash -c "usermod -p \$(openssl passwd -1 password) root"
```

### วิธีที่ 3: ตั้งรหัสผ่านแบบ Interactive (แนะนำ)

```bash
# เข้าไปใน container เป็น root
docker exec -it --user root attacker-kali bash

# ตั้งรหัสผ่านแบบ interactive
passwd kasm_user
# Enter new password: password
# Retype new password: password

# หรือตั้งรหัสผ่านให้ root
passwd root
# Enter new password: password
# Retype new password: password
```

### ตั้งรหัสผ่านแบบกำหนดเอง

```bash
# เปลี่ยนรหัสผ่านเป็นที่คุณต้องการ (เช่น: mypassword123)
docker exec -it attacker-kali bash -c "echo 'kasm_user:mypassword123' | chpasswd"
```

### ใช้ root user โดยตรง (ไม่ต้องใช้ sudo)

```bash
# เข้าไปใน container เป็น root
docker exec -it --user root attacker-kali bash

# ตอนนี้คุณเป็น root แล้ว ไม่ต้องใช้ sudo
# หมายเหตุ: การติดตั้ง iputils-ping อาจมีปัญหา dependency conflict
# แนะนำให้ใช้ curl หรือ wget แทน
```

### วิธีที่ง่ายที่สุด: ใช้ Script อัตโนมัติ

รัน script ที่เตรียมไว้ให้:

```bash
cd /Users/kbbk/Secure/mutillidae
./setup-kali-sudo.sh
```

Script นี้จะตั้งรหัสผ่านให้ `kasm_user` และ `root` เป็น `password` อัตโนมัติ

### หลังจากตั้งรหัสผ่านแล้ว

กลับไปที่ Kali Linux GUI Terminal และลองใช้:

```bash
# ใช้ sudo ด้วยรหัสผ่าน: password
sudo apt-get update
sudo apt-get install -y <package-name>

# หรือใช้ su - เพื่อเปลี่ยนเป็น root
su -
# Password: password
```

## การใช้งาน Tools ใน Kali

### Burp Suite
1. เปิด Burp Suite ใน Kali
2. ตั้งค่า proxy ใน Firefox: `127.0.0.1:8080`
3. เริ่ม intercept และโจมตี Mutillidae

### SQLMap
```bash
sqlmap -u "http://www/mutillidae/index.php?page=user-info.php" --forms --batch
```

### Nmap
```bash
nmap -sV www
```

## ข้อมูลเพิ่มเติม

- **Official Repository**: https://github.com/webpwnized/mutillidae
- **OWASP Mutillidae**: https://owasp.org/www-project-mutillidae-ii/
- **Video Tutorials**: https://www.youtube.com/user/webpwnized

## License

GPL-3.0 License - ดูไฟล์ LICENSE สำหรับรายละเอียด

---

**หมายเหตุ**: Lab นี้สร้างขึ้นเพื่อการศึกษาและฝึกฝนการเจาะระบบเท่านั้น ห้ามใช้เพื่อโจมตีระบบจริงโดยไม่ได้รับอนุญาต

