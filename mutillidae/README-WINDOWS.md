# การติดตั้งและใช้งาน Mutillidae บน Windows

เอกสารนี้สรุปขั้นตอนให้โปรเจกต์ Docker Compose ใช้ได้บน Windows

## สิ่งที่ต้องเตรียม

### 1. Docker Desktop for Windows

- ติดตั้ง [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
- แนะนำให้ใช้ **WSL 2** เป็น backend (Settings → General → Use the WSL 2 based engine)
- หลังติดตั้ง ให้เปิด Docker Desktop แล้วรอจนสถานะเป็น Running

### 2. Network ภายนอก (pentest-net)

บริการ `www` ใช้ network ชื่อ `pentest-net` แบบ external จึงต้องสร้างก่อนรัน compose ครั้งแรก:

```powershell
docker network create pentest-net
```

หรือใช้สคริปต์ที่เตรียมไว้:

- **Command Prompt:** `create-network.bat`
- **PowerShell:** `.\create-network.ps1`

### 3. ไฟล์และโฟลเดอร์ที่ใช้

| รายการ | คำอธิบาย |
|--------|-----------|
| `docker-compose.yml` | ใช้ได้เหมือนบน Linux/macOS ไม่ต้องแก้สำหรับ Windows |
| `./src` | โฟลเดอร์ซอร์สถูก mount เข้า container — ใช้ path แบบเดียวกันได้กับ Docker Desktop |
| `.tools/*.sh` | สคริปต์ Bash ใช้ผ่าน **Git Bash** หรือ **WSL** ถ้าต้องการ; สำหรับแค่รัน Docker ไม่บังคับ |

## การรัน

**ต้องรันที่โฟลเดอร์โปรเจกต์** — โฟลเดอร์ที่มีไฟล์ `docker-compose.yml` อยู่ (เช่น `mutillidae` หลัง clone โปรเจกต์)

- เปิด Command Prompt หรือ PowerShell แล้ว `cd` ไปที่ path นั้น แล้วค่อยรันสคริปต์  
- หรือเปิดโฟลเดอร์นั้นใน File Explorer แล้วดับเบิลคลิก `.bat` / คลิกขวา → Run with PowerShell สำหรับ `.ps1`

### วิธีที่ 1: ใช้สคริปต์ (แนะนำบน Windows)

```cmd
create-network.bat   :: สร้าง pentest-net (รันครั้งเดียว)
start.bat           :: docker-compose up -d
stop.bat            :: docker-compose down
```

PowerShell:

```powershell
.\create-network.ps1   # สร้าง pentest-net (รันครั้งเดียว)
.\start.ps1            # docker-compose up -d
.\stop.ps1             # docker-compose down
```

### วิธีที่ 2: รันคำสั่งเอง

```powershell
docker network create pentest-net
docker-compose up -d
```

หยุดบริการ:

```powershell
docker-compose down
```

## การเข้าถึงแอป

หลัง `docker-compose up -d` สำเร็จ:

| บริการ | URL |
|--------|-----|
| Mutillidae (HTTP) | http://localhost |
| Mutillidae (HTTPS) | https://localhost |
| phpMyAdmin | http://localhost:81 |
| phpLDAPAdmin | http://localhost:82 |

## หมายเหตุสำหรับ Windows

- **Line endings:** ถ้าแก้ไฟล์ใน `src/` ด้วยเครื่องมือบน Windows ให้เก็บ line endings เป็น LF (หรือใช้ Git ด้วย `core.autocrlf=input`) เพื่อลดปัญหาใน container แบบ Linux
- **Antivirus:** บางตัวอาจสแกนโฟลเดอร์ที่ bind mount แล้วทำให้ช้า สามารถ exclude โฟลเดอร์โปรเจกต์ได้ถ้าต้องการ
- **สคริปต์ใน `.tools/`:** เป็น Bash ใช้ได้ผ่าน Git Bash หรือ WSL; ถ้าใช้แค่ Docker Compose ไม่จำเป็นต้องรันสคริปต์เหล่านี้
