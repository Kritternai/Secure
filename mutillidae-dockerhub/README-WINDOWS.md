# การรันบน Windows (mutillidae-dockerhub)

โฟลเดอร์นี้ใช้ **image จาก Docker Hub** (ไม่ต้อง build เอง) และ **ไม่ต้องสร้าง network เพิ่ม** — รันได้เลยบน Windows หลังติดตั้ง Docker Desktop

## ต้องรันที่ path ไหน

**ต้องรันที่โฟลเดอร์โปรเจกต์** — โฟลเดอร์ที่มีไฟล์ `docker-compose.yml` อยู่  
เช่น โฟลเดอร์ `mutillidae-dockerhub` หลัง clone โปรเจกต์

- เปิด Command Prompt / PowerShell แล้ว `cd` ไปที่ path นั้น แล้วรันสคริปต์  
- หรือเปิดโฟลเดอร์นั้นใน File Explorer แล้วดับเบิลคลิก `.bat`

## สิ่งที่ต้องมี

- [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) (แนะนำ WSL 2 backend)

## การรัน

| สคริปต์ | ใช้ทำอะไร |
|--------|------------|
| **start.bat** / **start.ps1** | `docker-compose up -d` |
| **stop.bat** / **stop.ps1** | `docker-compose down` |

หรือรันคำสั่งเอง:

```powershell
docker-compose up -d
```

## ความต่างจากโฟลเดอร์ mutillidae

| | mutillidae-dockerhub (โฟลเดอร์นี้) | mutillidae |
|--|-----------------------------------|------------|
| Image | ดึงจาก Docker Hub | build จาก Dockerfile ใน repo |
| Network | ไม่ต้องสร้างเพิ่ม | ต้องรัน `docker network create pentest-net` ก่อน |
| แก้ซอร์ส | ไม่ได้ (ใช้ image สำเร็จรูป) | ได้ (mount โฟลเดอร์ `src`) |
| Kali GUI | มี (port 6901) | ไม่มีใน compose หลัก |

ถ้าต้องการแค่รัน Mutillidae บน Windows โดยไม่แก้โค้ด แนะนำให้รันที่ **mutillidae-dockerhub** (โฟลเดอร์นี้) จะง่ายกว่า
