# 📚 Portal Akademik - Dokumentasi Lengkap

> **Sistem Informasi Akademik Terintegrasi**  
> Tech Stack: React 18 + Node.js + PostgreSQL + Prisma

---

## 📋 Daftar Isi

1. [Overview & Scope](#1-overview--scope)
2. [Arsitektur Sistem](#2-arsitektur-sistem)
3. [Tech Stack & Justifikasi](#3-tech-stack--justifikasi)
4. [Database Design](#4-database-design)
5. [API Documentation](#5-api-documentation)
6. [Frontend Architecture](#6-frontend-architecture)
7. [Business Logic & Validation](#7-business-logic--validation)
8. [Security Implementation](#8-security-implementation)
9. [File Management](#9-file-management)
10. [Notification System](#10-notification-system)
11. [Testing Strategy](#11-testing-strategy)
12. [Deployment Guide](#12-deployment-guide)
13. [Development Workflow](#13-development-workflow)
14. [Troubleshooting](#14-troubleshooting)

---

## 1. Overview & Scope

### 1.1 Tujuan Sistem

Portal Akademik adalah sistem informasi terintegrasi untuk mengelola seluruh aktivitas akademik di perguruan tinggi, mencakup mahasiswa, dosen, dan administrasi.

### 1.2 Fitur Utama

#### 🎓 **Mahasiswa**
- ✅ Dashboard akademik dengan visualisasi IP/IPK
- ✅ Pengisian KRS dengan validasi otomatis
- ✅ Lihat jadwal kuliah (calendar & list view)
- ✅ Cek nilai (KHS & Transkrip)
- ✅ Monitoring status pembayaran
- ✅ Download/print dokumen akademik
- ✅ Notifikasi real-time

#### 👨‍🏫 **Dosen**
- ✅ Dashboard kelas yang diampu
- ✅ Input & edit nilai mahasiswa
- ✅ Presensi mahasiswa
- ✅ Approval KRS mahasiswa perwalian
- ✅ Export data kelas

#### 👨‍💼 **Admin**
- ✅ Manajemen data mahasiswa & dosen
- ✅ Manajemen mata kuliah & jadwal
- ✅ Monitoring KRS & pembayaran
- ✅ Generate laporan & statistik
- ✅ Broadcast pengumuman
- ✅ Bulk import/export data

### 1.3 User Roles

| Role | Access Level | Primary Functions |
|------|--------------|-------------------|
| **Mahasiswa** | User | KRS, Jadwal, Nilai, Pembayaran |
| **Dosen** | Moderator | Input Nilai, Presensi, Approve KRS |
| **Admin** | Administrator | Full CRUD, Reports, Settings |
| **Super Admin** | Root | System Configuration |

### 1.4 Non-Functional Requirements

- **Performance**: Response time < 2s untuk 90% requests
- **Scalability**: Support 10,000 concurrent users
- **Availability**: 99.5% uptime
- **Security**: OWASP Top 10 compliance
- **Usability**: Mobile-responsive, WCAG 2.1 AA

---

## 2. Arsitektur Sistem

### 2.1 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Client Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Browser    │  │    Mobile    │  │   Desktop    │      │
│  │  (React 18)  │  │     (PWA)    │  │    (PWA)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTPS/REST API
┌────────────────────────▼────────────────────────────────────┐
│                   API Gateway Layer                          │
│  ┌────────────────────────────────────────────────────┐     │
│  │  - Rate Limiting                                    │     │
│  │  - Authentication/Authorization (JWT)               │     │
│  │  - Request Validation                               │     │
│  │  - Logging & Monitoring                             │     │
│  └────────────────────────────────────────────────────┘     │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                  Application Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Auth API   │  │  KRS API     │  │  Nilai API   │      │
│  │   Service    │  │  Service     │  │  Service     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Jadwal API   │  │ Payment API  │  │  Admin API   │      │
│  │   Service    │  │   Service    │  │  Service     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   Data Layer                                 │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │   PostgreSQL   │  │     Redis      │  │      S3      │  │
│  │   (Primary)    │  │    (Cache)     │  │  (Files)     │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   External Services                          │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │     SMTP       │  │   Payment      │  │   Analytics  │  │
│  │  (Email)       │  │   Gateway      │  │   (Sentry)   │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Data Flow Example - Pengisian KRS

```
Mahasiswa → Frontend → API Gateway → KRS Service → Validasi
                                          ↓
                                    ┌─────┴─────┐
                                    │ Validasi: │
                                    │ - Prasyarat
                                    │ - Jadwal
                                    │ - SKS
                                    │ - Kuota
                                    │ - Bayar
                                    └─────┬─────┘
                                          ↓
                            Database ← Save KRS ← Notification
                                          ↓
                            Email to Dosen Wali (Approval)
```

---

## 3. Tech Stack & Justifikasi

### 3.1 Frontend Stack

| Technology | Version | Purpose | Justifikasi |
|------------|---------|---------|-------------|
| **React** | 18+ | UI Library | Virtual DOM untuk performa optimal, ekosistem besar, reusable components |
| **TypeScript** | 5+ | Type Safety | Deteksi error saat development, autocomplete lebih baik, kode lebih maintainable |
| **Vite** | 5+ | Build Tool | Hot Module Replacement (HMR) sangat cepat, build time 10x lebih cepat dari CRA |
| **React Router** | 6+ | Routing | Declarative routing, code splitting otomatis, nested routes |
| **TanStack Query** | 5+ | Data Fetching | Auto caching, background refetch, optimistic updates, mengurangi boilerplate |
| **Zustand** | 4+ | State Management | API sederhana, tanpa boilerplate, bundle size kecil (1KB) |
| **React Hook Form** | 7+ | Form Handling | Performa tinggi (uncontrolled), validasi built-in, mudah diintegrasikan |
| **Zod** | 3+ | Validation | Type-safe schema, runtime validation, integrasi sempurna dengan TypeScript |
| **Tailwind CSS** | 3+ | Styling | Utility-first, responsive design mudah, customizable, production bundle kecil |
| **shadcn/ui** | Latest | UI Components | Accessible (ARIA), customizable, copy-paste (bukan dependency) |
| **Recharts** | 2+ | Charts | Komposable, responsive, terintegrasi React |
| **date-fns** | 3+ | Date Utils | Lightweight (bukan moment.js), tree-shakeable, immutable |
| **Axios** | 1+ | HTTP Client | Interceptors untuk token refresh, request cancellation, progress tracking |

### 3.2 Backend Stack

| Technology | Version | Purpose | Justifikasi |
|------------|---------|---------|-------------|
| **Node.js** | 20+ LTS | Runtime | Event-driven, non-blocking I/O, cocok untuk I/O intensive apps |
| **Express** | 4+ | Web Framework | Minimalis, flexible, middleware ecosystem lengkap |
| **TypeScript** | 5+ | Type Safety | Konsistensi dengan frontend, catch errors early |
| **Prisma** | 5+ | ORM | Type-safe queries, auto-generate types, migrations terintegrasi |
| **PostgreSQL** | 15+ | Database | ACID compliant, JSON support, complex queries, proven reliability |
| **Redis** | 7+ | Cache/Queue | In-memory speed untuk session & caching, pub/sub untuk real-time |
| **JWT** | 9+ | Authentication | Stateless, scalable, cocok untuk microservices |
| **bcrypt** | 5+ | Password Hash | Industry standard, salt rounds adjustable, secure |
| **Multer** | 1+ | File Upload | Stream-based (memory efficient), berbagai storage engines |
| **Nodemailer** | 6+ | Email Service | Support berbagai SMTP provider, template email |
| **pdf-lib** | 1+ | PDF Generation | Create/modify PDF, tidak perlu external dependency |
| **Winston** | 3+ | Logging | Multiple transports (file, console, external), log levels |
| **Joi** | 17+ | Validation | Schema-based validation, detailed error messages |
| **express-rate-limit** | 7+ | Rate Limiting | Protect dari brute force & DDoS |

### 3.3 DevOps & Tools

| Tool | Purpose | Benefit |
|------|---------|---------|
| **Docker** | Containerization | Konsistensi environment dev/prod |
| **Docker Compose** | Orchestration | Setup multi-container dengan mudah |
| **GitHub Actions** | CI/CD | Automated testing & deployment |
| **ESLint** | Code Linting | Enforce code standards |
| **Prettier** | Code Formatting | Consistent code style |
| **Husky** | Git Hooks | Pre-commit linting & testing |
| **Jest** | Unit Testing | Fast, snapshot testing, mocking |
| **Supertest** | API Testing | Test HTTP endpoints |
| **Playwright** | E2E Testing | Cross-browser testing |
| **Swagger** | API Documentation | Interactive API docs |
| **Sentry** | Error Tracking | Real-time error monitoring |

---

## 4. Database Design

### 4.1 Entity Relationship Diagram (ERD)

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│    users    │────────▶│  mahasiswa   │────────▶│ program_    │
│             │  1:1    │              │  N:1    │ studi       │
│ - id (PK)   │         │ - id (PK)    │         │             │
│ - email     │         │ - user_id FK │         │ - id (PK)   │
│ - password  │         │ - nim        │         │ - nama      │
│ - role      │         │ - ipk        │         │ - fakultas  │
└─────────────┘         └──────┬───────┘         └─────────────┘
                               │ 1:N
                               ▼
                        ┌──────────────┐         ┌─────────────┐
                        │     krs      │────────▶│   kelas     │
                        │              │  N:1    │             │
                        │ - id (PK)    │         │ - id (PK)   │
                        │ - mhs_id FK  │         │ - mk_id FK  │
                        │ - kelas_id FK│         │ - dosen_id  │
                        │ - status     │         │ - kuota     │
                        └──────┬───────┘         └─────────────┘
                               │ 1:1
                               ▼
                        ┌──────────────┐
                        │    nilai     │
                        │              │
                        │ - id (PK)    │
                        │ - krs_id FK  │
                        │ - nilai_akhir│
                        │ - huruf_mutu │
                        └──────────────┘
```

### 4.2 Database Schema (PostgreSQL)

```sql
-- ============================================
-- 1. USERS & AUTHENTICATION
-- ============================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('mahasiswa', 'dosen', 'admin', 'super_admin')),
    foto_profil VARCHAR(255),
    no_hp VARCHAR(20),
    tanggal_lahir DATE,
    is_active BOOLEAN DEFAULT true,
    email_verified_at TIMESTAMP,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_deleted_at ON users(deleted_at) WHERE deleted_at IS NOT NULL;

COMMENT ON TABLE users IS 'Tabel utama untuk autentikasi semua user';
COMMENT ON COLUMN users.role IS 'Role: mahasiswa, dosen, admin, super_admin';

-- Refresh tokens untuk JWT
CREATE TABLE refresh_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(500) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- Password reset tokens
CREATE TABLE password_resets (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_password_resets_email ON password_resets(email);
CREATE INDEX idx_password_resets_token ON password_resets(token);

-- ============================================
-- 2. ACADEMIC STRUCTURE
-- ============================================

CREATE TABLE fakultas (
    id SERIAL PRIMARY KEY,
    kode VARCHAR(10) UNIQUE NOT NULL,
    nama VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE fakultas IS 'Fakultas di perguruan tinggi';

CREATE TABLE program_studi (
    id SERIAL PRIMARY KEY,
    fakultas_id INTEGER REFERENCES fakultas(id) ON DELETE RESTRICT,
    kode VARCHAR(10) UNIQUE NOT NULL,
    nama VARCHAR(100) NOT NULL,
    jenjang VARCHAR(20) CHECK (jenjang IN ('D3', 'D4', 'S1', 'S2', 'S3')),
    akreditasi VARCHAR(2) CHECK (akreditasi IN ('A', 'B', 'C', 'UN')),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_program_studi_fakultas ON program_studi(fakultas_id);

COMMENT ON TABLE program_studi IS 'Program studi per fakultas';

CREATE TABLE periode_akademik (
    id SERIAL PRIMARY KEY,
    tahun_ajaran VARCHAR(10) NOT NULL,
    semester VARCHAR(10) NOT NULL CHECK (semester IN ('Ganjil', 'Genap', 'Pendek')),
    is_active BOOLEAN DEFAULT false,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    tanggal_mulai_krs DATE NOT NULL,
    tanggal_selesai_krs DATE NOT NULL,
    max_sks_normal INTEGER DEFAULT 24,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(tahun_ajaran, semester),
    CONSTRAINT check_dates CHECK (tanggal_selesai > tanggal_mulai),
    CONSTRAINT check_krs_dates CHECK (tanggal_selesai_krs > tanggal_mulai_krs)
);

CREATE INDEX idx_periode_is_active ON periode_akademik(is_active) WHERE is_active = true;

COMMENT ON TABLE periode_akademik IS 'Periode semester akademik';
COMMENT ON COLUMN periode_akademik.is_active IS 'Hanya 1 periode yang boleh aktif';

-- ============================================
-- 3. DOSEN
-- ============================================

CREATE TABLE dosen (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    nidn VARCHAR(20) UNIQUE NOT NULL,
    nip VARCHAR(30),
    program_studi_id INTEGER REFERENCES program_studi(id) ON DELETE SET NULL,
    jabatan_akademik VARCHAR(50),
    jabatan_struktural VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_dosen_user ON dosen(user_id);
CREATE INDEX idx_dosen_nidn ON dosen(nidn);
CREATE INDEX idx_dosen_prodi ON dosen(program_studi_id);

COMMENT ON TABLE dosen IS 'Data dosen';
COMMENT ON COLUMN dosen.nidn IS 'Nomor Induk Dosen Nasional';

-- ============================================
-- 4. MAHASISWA
-- ============================================

CREATE TABLE mahasiswa (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    nim VARCHAR(20) UNIQUE NOT NULL,
    program_studi_id INTEGER REFERENCES program_studi(id) ON DELETE RESTRICT,
    dosen_wali_id INTEGER REFERENCES dosen(id) ON DELETE SET NULL,
    angkatan INTEGER NOT NULL,
    semester_masuk INTEGER DEFAULT 1 CHECK (semester_masuk >= 1),
    semester_aktif INTEGER DEFAULT 1 CHECK (semester_aktif >= 1 AND semester_aktif <= 14),
    status VARCHAR(20) DEFAULT 'aktif' CHECK (status IN ('aktif', 'cuti', 'lulus', 'DO', 'keluar', 'meninggal')),
    ipk DECIMAL(3,2) DEFAULT 0.00 CHECK (ipk >= 0 AND ipk <= 4.00),
    total_sks INTEGER DEFAULT 0 CHECK (total_sks >= 0),
    tanggal_lulus DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT check_lulus CHECK (
        (status = 'lulus' AND tanggal_lulus IS NOT NULL) OR
        (status != 'lulus' AND tanggal_lulus IS NULL)
    )
);

CREATE INDEX idx_mahasiswa_user ON mahasiswa(user_id);
CREATE INDEX idx_mahasiswa_nim ON mahasiswa(nim);
CREATE INDEX idx_mahasiswa_prodi ON mahasiswa(program_studi_id);
CREATE INDEX idx_mahasiswa_status ON mahasiswa(status);
CREATE INDEX idx_mahasiswa_wali ON mahasiswa(dosen_wali_id);
CREATE INDEX idx_mahasiswa_angkatan ON mahasiswa(angkatan);

COMMENT ON TABLE mahasiswa IS 'Data mahasiswa';
COMMENT ON COLUMN mahasiswa.semester_aktif IS 'Semester saat ini (1-14)';

-- ============================================
-- 5. MATA KULIAH
-- ============================================

CREATE TABLE mata_kuliah (
    id SERIAL PRIMARY KEY,
    kode VARCHAR(20) UNIQUE NOT NULL,
    nama VARCHAR(150) NOT NULL,
    nama_en VARCHAR(150),
    sks INTEGER NOT NULL CHECK (sks > 0 AND sks <= 6),
    semester INTEGER CHECK (semester >= 1 AND semester <= 14),
    sifat VARCHAR(20) CHECK (sifat IN ('wajib', 'pilihan', 'wajib_prodi')),
    program_studi_id INTEGER REFERENCES program_studi(id) ON DELETE CASCADE,
    deskripsi TEXT,
    silabus TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_mata_kuliah_kode ON mata_kuliah(kode);
CREATE INDEX idx_mata_kuliah_prodi ON mata_kuliah(program_studi_id);
CREATE INDEX idx_mata_kuliah_semester ON mata_kuliah(semester);

COMMENT ON TABLE mata_kuliah IS 'Master mata kuliah';
COMMENT ON COLUMN mata_kuliah.sifat IS 'wajib: wajib universitas, wajib_prodi: wajib program studi, pilihan: mata kuliah pilihan';

-- Tabel prasyarat mata kuliah
CREATE TABLE prasyarat_mk (
    id SERIAL PRIMARY KEY,
    mata_kuliah_id INTEGER REFERENCES mata_kuliah(id) ON DELETE CASCADE,
    prasyarat_id INTEGER REFERENCES mata_kuliah(id) ON DELETE CASCADE,
    min_nilai VARCHAR(2) DEFAULT 'D' CHECK (min_nilai IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D', 'E')),
    UNIQUE(mata_kuliah_id, prasyarat_id),
    CONSTRAINT check_not_self CHECK (mata_kuliah_id != prasyarat_id)
);

CREATE INDEX idx_prasyarat_mk ON prasyarat_mk(mata_kuliah_id);
CREATE INDEX idx_prasyarat_prasyarat ON prasyarat_mk(prasyarat_id);

COMMENT ON TABLE prasyarat_mk IS 'Relasi prasyarat antar mata kuliah';

-- ============================================
-- 6. KELAS & JADWAL
-- ============================================

CREATE TABLE kelas (
    id SERIAL PRIMARY KEY,
    mata_kuliah_id INTEGER REFERENCES mata_kuliah(id) ON DELETE CASCADE,
    periode_akademik_id INTEGER REFERENCES periode_akademik(id) ON DELETE CASCADE,
    kode_kelas VARCHAR(10) NOT NULL,
    dosen_id INTEGER REFERENCES dosen(id) ON DELETE SET NULL,
    hari VARCHAR(10) CHECK (hari IN ('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu')),
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    ruangan VARCHAR(30),
    kuota INTEGER DEFAULT 40 CHECK (kuota > 0),
    terisi INTEGER DEFAULT 0 CHECK (terisi >= 0),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(mata_kuliah_id, periode_akademik_id, kode_kelas),
    CONSTRAINT check_jam CHECK (jam_selesai > jam_mulai),
    CONSTRAINT check_kuota_terisi CHECK (terisi <= kuota)
);

CREATE INDEX idx_kelas_mk ON kelas(mata_kuliah_id);
CREATE INDEX idx_kelas_periode ON kelas(periode_akademik_id);
CREATE INDEX idx_kelas_dosen ON kelas(dosen_id);
CREATE INDEX idx_kelas_active ON kelas(is_active) WHERE is_active = true;

COMMENT ON TABLE kelas IS 'Kelas per semester (mata kuliah + periode + dosen)';
COMMENT ON COLUMN kelas.terisi IS 'Jumlah mahasiswa yang sudah mengambil kelas ini';

-- ============================================
-- 7. KRS (Kartu Rencana Studi)
-- ============================================

CREATE TABLE krs (
    id SERIAL PRIMARY KEY,
    mahasiswa_id INTEGER REFERENCES mahasiswa(id) ON DELETE CASCADE,
    periode_akademik_id INTEGER REFERENCES periode_akademik(id) ON DELETE CASCADE,
    kelas_id INTEGER REFERENCES kelas(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'rejected', 'cancelled')),
    tanggal_pengisian TIMESTAMP DEFAULT NOW(),
    approved_by INTEGER REFERENCES dosen(id) ON DELETE SET NULL,
    approved_at TIMESTAMP,
    rejection_note TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL,
    UNIQUE(mahasiswa_id, kelas_id, periode_akademik_id)
);

CREATE INDEX idx_krs_mahasiswa ON krs(mahasiswa_id);
CREATE INDEX idx_krs_periode ON krs(periode_akademik_id);
CREATE INDEX idx_krs_kelas ON krs(kelas_id);
CREATE INDEX idx_krs_status ON krs(status);
CREATE INDEX idx_krs_mahasiswa_periode ON krs(mahasiswa_id, periode_akademik_id);
CREATE INDEX idx_krs_deleted ON krs(deleted_at) WHERE deleted_at IS NULL;

COMMENT ON TABLE krs IS 'Kartu Rencana Studi mahasiswa per semester';
COMMENT ON COLUMN krs.status IS 'draft: belum submit, submitted: menunggu approval, approved: disetujui, rejected: ditolak, cancelled: dibatalkan';

-- ============================================
-- 8. NILAI
-- ============================================

CREATE TABLE nilai (
    id SERIAL PRIMARY KEY,
    krs_id INTEGER UNIQUE REFERENCES krs(id) ON DELETE CASCADE,
    mahasiswa_id INTEGER REFERENCES mahasiswa(id) ON DELETE CASCADE,
    kelas_id INTEGER REFERENCES kelas(id) ON DELETE CASCADE,
    nilai_tugas DECIMAL(5,2) CHECK (nilai_tugas >= 0 AND nilai_tugas <= 100),
    nilai_uts DECIMAL(5,2) CHECK (nilai_uts >= 0 AND nilai_uts <= 100),
    nilai_uas DECIMAL(5,2) CHECK (nilai_uas >= 0 AND nilai_uas <= 100),
    nilai_akhir DECIMAL(5,2) CHECK (nilai_akhir >= 0 AND nilai_akhir <= 100),
    huruf_mutu VARCHAR(2) CHECK (huruf_mutu IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D', 'E')),
    angka_mutu DECIMAL(3,2) CHECK (angka_mutu >= 0 AND angka_mutu <= 4.00),
    is_published BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_nilai_mahasiswa ON nilai(mahasiswa_id);
CREATE INDEX idx_nilai_krs ON nilai(krs_id);
CREATE INDEX idx_nilai_kelas ON nilai(kelas_id);
CREATE INDEX idx_nilai_published ON nilai(is_published);

COMMENT ON TABLE nilai IS 'Nilai mahasiswa per mata kuliah';
COMMENT ON COLUMN nilai.is_published IS 'Nilai hanya bisa dilihat mahasiswa jika published = true';

-- ============================================
-- 9. PRESENSI
-- ============================================

CREATE TABLE presensi (
    id SERIAL PRIMARY KEY,
    kelas_id INTEGER REFERENCES kelas(id) ON DELETE CASCADE,
    mahasiswa_id INTEGER REFERENCES mahasiswa(id) ON DELETE CASCADE,
    pertemuan_ke INTEGER CHECK (pertemuan_ke >= 1 AND pertemuan_ke <= 16),
    tanggal DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'alpha' CHECK (status IN ('hadir', 'izin', 'sakit', 'alpha')),
    keterangan TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(kelas_id, mahasiswa_id, pertemuan_ke)
);

CREATE INDEX idx_presensi_kelas ON presensi(kelas_id);
CREATE INDEX idx_presensi_mahasiswa ON presensi(mahasiswa_id);
CREATE INDEX idx_presensi_tanggal ON presensi(tanggal);

COMMENT ON TABLE presensi IS 'Presensi mahasiswa per pertemuan';

-- ============================================
-- 10. PEMBAYARAN
-- ============================================

CREATE TABLE jenis_pembayaran (
    id SERIAL PRIMARY KEY,
    kode VARCHAR(20) UNIQUE NOT NULL,
    nama VARCHAR(100) NOT NULL,
    jumlah DECIMAL(12,2) NOT NULL CHECK (jumlah >= 0),
    is_recurring BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE jenis_pembayaran IS 'Master jenis pembayaran (SPP, UTS, UAS, Wisuda, dll)';
COMMENT ON COLUMN jenis_pembayaran.is_recurring IS 'true: tagihan per semester (SPP), false: tagihan sekali (wisuda)';

CREATE TABLE pembayaran (
    id SERIAL PRIMARY KEY,
    mahasiswa_id INTEGER REFERENCES mahasiswa(id) ON DELETE CASCADE,
    periode_akademik_id INTEGER REFERENCES periode_akademik(id) ON DELETE CASCADE,
    jenis_pembayaran_id INTEGER REFERENCES jenis_pembayaran(id) ON DELETE RESTRICT,
    jumlah DECIMAL(12,2) NOT NULL CHECK (jumlah >= 0),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'verified', 'overdue', 'cancelled')),
    tanggal_jatuh_tempo DATE,
    tanggal_bayar TIMESTAMP,
    metode VARCHAR(50),
    nomor_referensi VARCHAR(100),
    bukti_bayar VARCHAR(255),
    verified_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_pembayaran_mahasiswa ON pembayaran(mahasiswa_id);
CREATE INDEX idx_pembayaran_periode ON pembayaran(periode_akademik_id);
CREATE INDEX idx_pembayaran_status ON pembayaran(status);
CREATE INDEX idx_pembayaran_jatuh_tempo ON pembayaran(tanggal_jatuh_tempo);

COMMENT ON TABLE pembayaran IS 'Transaksi pembayaran mahasiswa';

-- ============================================
-- 11. PENGUMUMAN & NOTIFIKASI
-- ============================================

CREATE TABLE pengumuman (
    id SERIAL PRIMARY KEY,
    judul VARCHAR(200) NOT NULL,
    konten TEXT NOT NULL,
    kategori VARCHAR(50) CHECK (kategori IN ('akademik', 'kemahasiswaan', 'umum', 'urgent')),
    target VARCHAR(20) CHECK (target IN ('all', 'mahasiswa', 'dosen', 'prodi')),
    target_prodi_id INTEGER REFERENCES program_studi(id) ON DELETE CASCADE,
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMP,
    created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_pengumuman_published ON pengumuman(is_published) WHERE is_published = true;
CREATE INDEX idx_pengumuman_kategori ON pengumuman(kategori);
CREATE INDEX idx_pengumuman_target ON pengumuman(target);

COMMENT ON TABLE pengumuman IS 'Pengumuman untuk mahasiswa/dosen';

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) CHECK (type IN ('info', 'success', 'warning', 'error')),
    category VARCHAR(50),
    reference_id INTEGER,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_notif_user ON notifications(user_id);
CREATE INDEX idx_notif_read ON notifications(is_read);
CREATE INDEX idx_notif_created ON notifications(created_at DESC);

COMMENT ON TABLE notifications IS 'Notifikasi per user';

-- ============================================
-- 12. AUDIT LOG
-- ============================================

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(50) NOT NULL,
    table_name VARCHAR(50),
    record_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_table ON audit_logs(table_name, record_id);
CREATE INDEX idx_audit_created ON audit_logs(created_at DESC);
CREATE INDEX idx_audit_action ON audit_logs(action);

COMMENT ON TABLE audit_logs IS 'Log semua perubahan data penting';

-- ============================================
-- 13. FILE UPLOADS
-- ============================================

CREATE TABLE file_uploads (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100),
    size INTEGER CHECK (size > 0),
    path VARCHAR(500),
    category VARCHAR(50) CHECK (category IN ('profile', 'payment_proof', 'document', 'other')),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_file_user ON file_uploads(user_id);
CREATE INDEX idx_file_category ON file_uploads(category);

COMMENT ON TABLE file_uploads IS 'Metadata file yang diupload';

-- ============================================
-- 14. TRIGGERS & FUNCTIONS
-- ============================================

-- Function: Auto update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger ke tabel yang punya updated_at
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mahasiswa_updated_at 
    BEFORE UPDATE ON mahasiswa
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_nilai_updated_at 
    BEFORE UPDATE ON nilai
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pengumuman_updated_at 
    BEFORE UPDATE ON pengumuman
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function: Auto increment kelas.terisi saat KRS approved
CREATE OR REPLACE FUNCTION increment_kelas_terisi()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'approved' AND (OLD.status IS NULL OR OLD.status != 'approved') THEN
        UPDATE kelas 
        SET terisi = terisi + 1 
        WHERE id = NEW.kelas_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_krs_approved
AFTER INSERT OR UPDATE OF status ON krs
FOR EACH ROW
EXECUTE FUNCTION increment_kelas_terisi();

-- Function: Auto decrement kelas.terisi saat KRS cancelled/rejected/deleted
CREATE OR REPLACE FUNCTION decrement_kelas_terisi()
RETURNS TRIGGER AS $$
BEGIN
    -- Saat update status dari approved ke non-approved
    IF TG_OP = 'UPDATE' THEN
        IF OLD.status = 'approved' AND NEW.status != 'approved' THEN
            UPDATE kelas 
            SET terisi = terisi - 1 
            WHERE id = OLD.kelas_id;
        END IF;
        
        -- Saat soft delete (deleted_at diisi)
        IF OLD.status = 'approved' AND NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
            UPDATE kelas 
            SET terisi = terisi - 1 
            WHERE id = OLD.kelas_id;
        END IF;
    END IF;
    
    -- Saat hard delete
    IF TG_OP = 'DELETE' AND OLD.status = 'approved' THEN
        UPDATE kelas 
        SET terisi = terisi - 1 
        WHERE id = OLD.kelas_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_krs_cancelled
AFTER UPDATE OR DELETE ON krs
FOR EACH ROW
EXECUTE FUNCTION decrement_kelas_terisi();

-- Function: Auto calculate IPK setelah nilai diinput
CREATE OR REPLACE FUNCTION update_mahasiswa_ipk()
RETURNS TRIGGER AS $$
DECLARE
    v_total_mutu DECIMAL(10,2);
    v_total_sks INTEGER;
    v_new_ipk DECIMAL(3,2);
BEGIN
    -- Hitung IPK dari semua nilai yang sudah published
    SELECT 
        COALESCE(SUM(n.angka_mutu * mk.sks), 0),
        COALESCE(SUM(mk.sks), 0)
    INTO v_total_mutu, v_total_sks
    FROM nilai n
    JOIN krs k ON k.id = n.krs_id
    JOIN kelas kl ON kl.id = k.kelas_id
    JOIN mata_kuliah mk ON mk.id = kl.mata_kuliah_id
    WHERE n.mahasiswa_id = NEW.mahasiswa_id
      AND n.is_published = true
      AND k.status = 'approved'
      AND k.deleted_at IS NULL;
    
    -- Kalkulasi IPK
    IF v_total_sks > 0 THEN
        v_new_ipk := v_total_mutu / v_total_sks;
    ELSE
        v_new_ipk := 0.00;
    END IF;
    
    -- Update mahasiswa
    UPDATE mahasiswa
    SET ipk = v_new_ipk,
        total_sks = v_total_sks
    WHERE id = NEW.mahasiswa_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_nilai_changed
AFTER INSERT OR UPDATE ON nilai
FOR EACH ROW
WHEN (NEW.is_published = true)
EXECUTE FUNCTION update_mahasiswa_ipk();

-- Function: Audit log untuk perubahan data penting
CREATE OR REPLACE FUNCTION log_audit_trail()
RETURNS TRIGGER AS $$
DECLARE
    v_user_id INTEGER;
BEGIN
    -- Ambil user_id dari session (akan diset dari aplikasi)
    v_user_id := current_setting('app.user_id', true)::INTEGER;
    
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values)
        VALUES (v_user_id, 'DELETE', TG_TABLE_NAME, OLD.id, to_jsonb(OLD));
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
        VALUES (v_user_id, 'UPDATE', TG_TABLE_NAME, NEW.id, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values)
        VALUES (v_user_id, 'INSERT', TG_TABLE_NAME, NEW.id, to_jsonb(NEW));
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Apply audit log ke tabel penting
CREATE TRIGGER audit_mahasiswa
AFTER INSERT OR UPDATE OR DELETE ON mahasiswa
FOR EACH ROW EXECUTE FUNCTION log_audit_trail();

CREATE TRIGGER audit_krs
AFTER INSERT OR UPDATE OR DELETE ON krs
FOR EACH ROW EXECUTE FUNCTION log_audit_trail();

CREATE TRIGGER audit_nilai
AFTER INSERT OR UPDATE OR DELETE ON nilai
FOR EACH ROW EXECUTE FUNCTION log_audit_trail();

CREATE TRIGGER audit_pembayaran
AFTER INSERT OR UPDATE OR DELETE ON pembayaran
FOR EACH ROW EXECUTE FUNCTION log_audit_trail();

-- ============================================
-- 15. VIEWS FOR REPORTING
-- ============================================

-- View: Mahasiswa dengan detail lengkap
CREATE OR REPLACE VIEW v_mahasiswa_detail AS
SELECT 
    m.id,
    m.nim,
    u.nama_lengkap,
    u.email,
    u.no_hp,
    ps.nama as program_studi,
    ps.jenjang,
    f.nama as fakultas,
    m.angkatan,
    m.semester_aktif,
    m.status,
    m.ipk,
    m.total_sks,
    dw.nama_lengkap as dosen_wali,
    m.created_at
FROM mahasiswa m
JOIN users u ON u.id = m.user_id
JOIN program_studi ps ON ps.id = m.program_studi_id
JOIN fakultas f ON f.id = ps.fakultas_id
LEFT JOIN dosen d ON d.id = m.dosen_wali_id
LEFT JOIN users dw ON dw.id = d.user_id
WHERE m.deleted_at IS NULL;

-- View: KRS dengan detail mata kuliah
CREATE OR REPLACE VIEW v_krs_detail AS
SELECT 
    k.id as krs_id,
    m.nim,
    u.nama_lengkap as nama_mahasiswa,
    pa.tahun_ajaran,
    pa.semester,
    mk.kode as kode_mk,
    mk.nama as nama_mk,
    mk.sks,
    kl.kode_kelas,
    d.nidn,
    ud.nama_lengkap as nama_dosen,
    kl.hari,
    kl.jam_mulai,
    kl.jam_selesai,
    kl.ruangan,
    k.status,
    k.tanggal_pengisian
FROM krs k
JOIN mahasiswa m ON m.id = k.mahasiswa_id
JOIN users u ON u.id = m.user_id
JOIN periode_akademik pa ON pa.id = k.periode_akademik_id
JOIN kelas kl ON kl.id = k.kelas_id
JOIN mata_kuliah mk ON mk.id = kl.mata_kuliah_id
LEFT JOIN dosen d ON d.id = kl.dosen_id
LEFT JOIN users ud ON ud.id = d.user_id
WHERE k.deleted_at IS NULL;

-- View: Nilai dengan detail lengkap (untuk KHS)
CREATE OR REPLACE VIEW v_nilai_khs AS
SELECT 
    n.id,
    m.nim,
    u.nama_lengkap as nama_mahasiswa,
    pa.tahun_ajaran,
    pa.semester,
    mk.kode as kode_mk,
    mk.nama as nama_mk,
    mk.sks,
    n.nilai_tugas,
    n.nilai_uts,
    n.nilai_uas,
    n.nilai_akhir,
    n.huruf_mutu,
    n.angka_mutu,
    (n.angka_mutu * mk.sks) as mutu,
    n.is_published
FROM nilai n
JOIN krs k ON k.id = n.krs_id
JOIN mahasiswa m ON m.id = n.mahasiswa_id
JOIN users u ON u.id = m.user_id
JOIN kelas kl ON kl.id = k.kelas_id
JOIN mata_kuliah mk ON mk.id = kl.mata_kuliah_id
JOIN periode_akademik pa ON pa.id = k.periode_akademik_id
WHERE k.status = 'approved' AND k.deleted_at IS NULL;

-- ============================================
-- 16. SAMPLE DATA (SEED)
-- ============================================

-- Insert Fakultas
INSERT INTO fakultas (kode, nama) VALUES
('FTI', 'Fakultas Teknologi Informasi'),
('FEB', 'Fakultas Ekonomi dan Bisnis'),
('FK', 'Fakultas Kedokteran'),
('FHISIP', 'Fakultas Humaniora, Ilmu Sosial dan Ilmu Politik');

-- Insert Program Studi
INSERT INTO program_studi (fakultas_id, kode, nama, jenjang, akreditasi) VALUES
(1, 'IF', 'Teknik Informatika', 'S1', 'A'),
(1, 'SI', 'Sistem Informasi', 'S1', 'A'),
(1, 'TI', 'Teknologi Informasi', 'D3', 'B'),
(2, 'AK', 'Akuntansi', 'S1', 'B'),
(2, 'MJ', 'Manajemen', 'S1', 'A'),
(3, 'KD', 'Kedokteran', 'S1', 'A');

-- Insert Periode Akademik
INSERT INTO periode_akademik (
    tahun_ajaran, semester, is_active, 
    tanggal_mulai, tanggal_selesai, 
    tanggal_mulai_krs, tanggal_selesai_krs,
    max_sks_normal
) VALUES
('2024/2025', 'Ganjil', true, '2024-09-01', '2025-01-31', '2024-08-15', '2024-09-05', 24),
('2023/2024', 'Genap', false, '2024-02-01', '2024-07-31', '2024-01-15', '2024-02-05', 24);

-- Insert Jenis Pembayaran
INSERT INTO jenis_pembayaran (kode, nama, jumlah, is_recurring) VALUES
('SPP', 'SPP Semester', 3000000.00, true),
('UTS', 'Ujian Tengah Semester', 500000.00, true),
('UAS', 'Ujian Akhir Semester', 500000.00, true),
('WISUDA', 'Biaya Wisuda', 2000000.00, false),
('DAFTAR_ULANG', 'Daftar Ulang', 1500000.00, true),
('KKN', 'Kuliah Kerja Nyata', 1000000.00, false),
('SKRIPSI', 'Bimbingan Skripsi', 2500000.00, false);

-- Insert Sample Users (Password: "password123" hashed dengan bcrypt)
-- Note: Ganti dengan hash bcrypt yang sebenarnya saat implementasi
INSERT INTO users (email, password, nama_lengkap, role, is_active, email_verified_at) VALUES
-- Admin
('admin@university.ac.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin System', 'super_admin', true, NOW()),
-- Dosen
('ahmad.dosen@university.ac.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dr. Ahmad Hidayat, M.Kom', 'dosen', true, NOW()),
('siti.dosen@university.ac.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dr. Siti Nurhaliza, M.T', 'dosen', true, NOW()),
-- Mahasiswa
('john.doe@student.university.ac.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Doe', 'mahasiswa', true, NOW()),
('jane.smith@student.university.ac.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane Smith', 'mahasiswa', true, NOW());

-- Insert Dosen
INSERT INTO dosen (user_id, nidn, nip, program_studi_id, jabatan_akademik) VALUES
(2, '0812345678', '198512345678901234', 1, 'Lektor Kepala'),
(3, '0823456789', '198623456789012345', 1, 'Lektor');

-- Insert Mahasiswa
INSERT INTO mahasiswa (user_id, nim, program_studi_id, dosen_wali_id, angkatan, semester_aktif, status) VALUES
(4, '2024001', 1, 1, 2024, 1, 'aktif'),
(5, '2024002', 1, 1, 2024, 1, 'aktif');

-- Insert Sample Mata Kuliah (Semester 1 Teknik Informatika)
INSERT INTO mata_kuliah (kode, nama, sks, semester, sifat, program_studi_id) VALUES
('IF101', 'Pengantar Teknologi Informasi', 3, 1, 'wajib', 1),
('IF102', 'Algoritma dan Pemrograman', 4, 1, 'wajib', 1),
('IF103', 'Matematika Diskrit', 3, 1, 'wajib', 1),
('IF104', 'Logika Informatika', 3, 1, 'wajib', 1),
('IF105', 'Bahasa Inggris', 2, 1, 'wajib', 1),
('IF201', 'Struktur Data', 4, 2, 'wajib', 1),
('IF202', 'Basis Data', 3, 3, 'wajib', 1);

-- Insert Prasyarat (Basis Data memerlukan Struktur Data dengan min nilai C)
INSERT INTO prasyarat_mk (mata_kuliah_id, prasyarat_id, min_nilai) VALUES
(7, 6, 'C');

-- Insert Sample Kelas untuk periode aktif
INSERT INTO kelas (
    mata_kuliah_id, periode_akademik_id, kode_kelas, 
    dosen_id, hari, jam_mulai, jam_selesai, ruangan, kuota
) VALUES
(1, 1, 'A', 1, 'Senin', '08:00', '10:30', 'Lab 1', 40),
(1, 1, 'B', 2, 'Selasa', '08:00', '10:30', 'Lab 2', 40),
(2, 1, 'A', 1, 'Senin', '13:00', '16:20', 'Lab 1', 35),
(3, 1, 'A', 2, 'Rabu', '08:00', '10:30', 'Ruang 201', 40),
(4, 1, 'A', 1, 'Kamis', '08:00', '10:30', 'Ruang 202', 40),
(5, 1, 'A', 2, 'Jumat', '08:00', '09:40', 'Ruang 203', 40);
```

### 4.3 Database Migration Strategy

#### Setup Prisma Schema

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id                Int       @id @default(autoincrement())
  email             String    @unique @db.VarChar(100)
  password          String    @db.VarChar(255)
  namaLengkap       String    @map("nama_lengkap") @db.VarChar(100)
  role              String    @db.VarChar(20)
  fotoProfil        String?   @map("foto_profil") @db.VarChar(255)
  noHp              String?   @map("no_hp") @db.VarChar(20)
  tanggalLahir      DateTime? @map("tanggal_lahir") @db.Date
  isActive          Boolean   @default(true) @map("is_active")
  emailVerifiedAt   DateTime? @map("email_verified_at")
  lastLoginAt       DateTime? @map("last_login_at")
  createdAt         DateTime  @default(now()) @map("created_at")
  updatedAt         DateTime  @updatedAt @map("updated_at")
  deletedAt         DateTime? @map("deleted_at")

  mahasiswa         Mahasiswa?
  dosen             Dosen?
  refreshTokens     RefreshToken[]
  auditLogs         AuditLog[]
  fileUploads       FileUpload[]
  notifications     Notification[]

  @@index([email])
  @@index([role])
  @@map("users")
}

model Mahasiswa {
  id               Int      @id @default(autoincrement())
  userId           Int      @unique @map("user_id")
  nim              String   @unique @db.VarChar(20)
  programStudiId   Int      @map("program_studi_id")
  dosenWaliId      Int?     @map("dosen_wali_id")
  angkatan         Int
  semesterMasuk    Int      @default(1) @map("semester_masuk")
  semesterAktif    Int      @default(1) @map("semester_aktif")
  status           String   @default("aktif") @db.VarChar(20)
  ipk              Decimal  @default(0.00) @db.Decimal(3, 2)
  totalSks         Int      @default(0) @map("total_sks")
  tanggalLulus     DateTime? @map("tanggal_lulus") @db.Date
  createdAt        DateTime @default(now()) @map("created_at")
  updatedAt        DateTime @updatedAt @map("updated_at")

  user             User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  programStudi     ProgramStudi @relation(fields: [programStudiId], references: [id])
  dosenWali        Dosen?   @relation(fields: [dosenWaliId], references: [id])
  
  krs              Krs[]
  nilai            Nilai[]
  presensi         Presensi[]
  pembayaran       Pembayaran[]

  @@index([userId])
  @@index([nim])
  @@index([programStudiId])
  @@index([status])
  @@map("mahasiswa")
}

// ... (model lainnya mengikuti pola yang sama)
```

#### Migration Commands

```bash
# Install Prisma
npm install -D prisma
npm install @prisma/client

# Initialize Prisma
npx prisma init

# Create migration from schema
npx prisma migrate dev --name init

# Generate Prisma Client
npx prisma generate

# Seed database
npx prisma db seed

# Reset database (development only)
npx prisma migrate reset
```

---

## 5. API Documentation

### 5.1 API Standards & Conventions

#### Base URL Structure
```
Environment URLs:
- Production:  https://api.portal-akademik.ac.id/v1
- Staging:     https://staging-api.portal-akademik.ac.id/v1
- Development: http://localhost:3000/api/v1
```

#### Request/Response Format

**Success Response:**
```json
{
  "success": true,
  "data": {
    // response data
  },
  "message": "Operation successful",
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": [] // validation errors array
  }
}
```

#### Authentication Header
```http
Authorization: Bearer <access_token>
Content-Type: application/json
```

### 5.2 Authentication Endpoints

#### POST /api/v1/auth/login
Login user dan dapatkan access token.

**Request:**
```json
{
  "email": "john.doe@student.university.ac.id",
  "password": "password123"
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 4,
      "email": "john.doe@student.university.ac.id",
      "namaLengkap": "John Doe",
      "role": "mahasiswa",
      "fotoProfil": null
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 900
    }
  },
  "message": "Login berhasil"
}
```

**Error Responses:**
- `401 Unauthorized`: Credential salah
- `403 Forbidden`: Email belum diverifikasi
- `422 Unprocessable Entity`: Validation error

#### POST /api/v1/auth/refresh-token
Refresh access token yang expired.

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 900
  }
}
```

#### POST /api/v1/auth/logout
Logout dan invalidate refresh token.

**Headers:** `Authorization: Bearer {accessToken}`

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Logout berhasil"
}
```

#### POST /api/v1/auth/forgot-password
Request password reset link.

**Request:**
```json
{
  "email": "john.doe@student.university.ac.id"
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Link reset password telah dikirim ke email Anda"
}
```

#### POST /api/v1/auth/reset-password
Reset password dengan token dari email.

**Request:**
```json
{
  "token": "reset_token_from_email",
  "password": "newPassword123",
  "passwordConfirmation": "newPassword123"
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Password berhasil direset"
}
```

#### GET /api/v1/auth/me
Get current authenticated user info.

**Headers:** `Authorization: Bearer {accessToken}`

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "id": 4,
    "email": "john.doe@student.university.ac.id",
    "namaLengkap": "John Doe",
    "role": "mahasiswa",
    "mahasiswa": {
      "nim": "2024001",
      "programStudi": "Teknik Informatika",
      "semester": 1,
      "ipk": 0.00
    }
  }
}
```

### 5.3 Mahasiswa Endpoints

#### GET /api/v1/mahasiswa/dashboard
Dashboard data mahasiswa (hanya untuk role mahasiswa).

**Headers:** `Authorization: Bearer {accessToken}`

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "profile": {
      "nim": "2024001",
      "nama": "John Doe",
      "prodi": "Teknik Informatika",
      "semester": 1,
      "status": "aktif",
      "fotoProfil": null
    },
    "akademik": {
      "ipk": 0.00,
      "total_sks": 0,
      "ip_per_semester": [
        {
          "semester": 1,
          "tahun_ajaran": "2024/2025",
          "ip": 0.00,
          "sks": 0
        }
      ]
    },
    "pembayaran": {
      "status": "lunas",
      "total_tagihan": 0,
      "tagihan": []
    },
    "pengumuman": [
      {
        "id": 1,
        "judul": "Pengumuman Pembukaan KRS Semester Ganjil 2024/2025",
        "kategori": "akademik",
        "tanggal": "2024-08-10T10:00:00Z"
      }
    ],
    "notifikasi_unread": 5
  }
}
```

#### GET /api/v1/mahasiswa (Admin Only)
Get list mahasiswa dengan filter dan pagination.

**Headers:** `Authorization: Bearer {accessToken}`

**Query Parameters:**
- `page` (default: 1)
- `limit` (default: 20)
- `search` - search by nim/nama
- `prodi` - filter by program_studi_id
- `status` - filter by status (aktif, cuti, lulus, DO)
- `angkatan` - filter by angkatan

**Example:** `GET /api/v1/mahasiswa?page=1&limit=20&prodi=1&status=aktif`

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "nim": "2024001",
        "namaLengkap": "John Doe",
        "email": "john.doe@student.university.ac.id",
        "programStudi": "Teknik Informatika",
        "angkatan": 2024,
        "semester": 1,
        "status": "aktif",
        "ipk": 0.00
      }
    ],
    "meta": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "totalPages": 8
    }
  }
}
```

#### POST /api/v1/mahasiswa (Admin Only)
Create new mahasiswa.

**Request:**
```json
{
  "email": "new.student@student.university.ac.id",
  "password": "defaultPassword123",
  "namaLengkap": "New Student",
  "nim": "2024003",
  "programStudiId": 1,
  "dosenWaliId": 1,
  "angkatan": 2024,
  "noHp": "081234567890",
  "tanggalLahir": "2005-05-15"
}
```

**Response:** `201 Created`

#### PUT /api/v1/mahasiswa/:id (Admin Only)
Update mahasiswa data.

**Request:**
```json
{
  "namaLengkap": "Updated Name",
  "status": "cuti",
  "dosenWaliId": 2
}
```

**Response:** `200 OK`

#### DELETE /api/v1/mahasiswa/:id (Admin Only)
Soft delete mahasiswa.

**Response:** `200 OK`

### 5.4 KRS Endpoints

#### GET /api/v1/krs/mata-kuliah
Get available mata kuliah untuk pengisian KRS.

**Headers:** `Authorization: Bearer {accessToken}`

**Query Parameters:**
- `semester` - semester mahasiswa
- `periode_id` - periode akademik aktif

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "kode": "IF101",
      "nama": "Pengantar Teknologi Informasi",
      "sks": 3,
      "semester": 1,
      "sifat": "wajib",
      "deskripsi": "Mata kuliah pengenalan TI...",
      "prasyarat": [],
      "kelas": [
        {
          "id": 1,
          "kodeKelas": "A",
          "dosen": {
            "id": 1,
            "nama": "Dr. Ahmad Hidayat, M.Kom",
            "nidn": "0812345678"
          },
          "hari": "Senin",
          "jamMulai": "08:00",
          "jamSelesai": "10:30",
          "ruangan": "Lab 1",
          "kuota": 40,
          "terisi": 35,
          "isAvailable": true
        },
        {
          "id": 2,
          "kodeKelas": "B",
          "dosen": {
            "id": 2,
            "nama": "Dr. Siti Nurhaliza, M.T"
          },
          "hari": "Selasa",
          "jamMulai": "08:00",
          "jamSelesai": "10:30",
          "ruangan": "Lab 2",
          "kuota": 40,
          "terisi": 30,
          "isAvailable": true
        }
      ]
    }
  ]
}
```

#### POST /api/v1/krs/validate
Validasi KRS sebelum submit.

**Request:**
```json
{
  "periodeAkademikId": 1,
  "kelasIds": [1, 3, 4, 5, 6]
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "isValid": true,
    "totalSks": 18,
    "maxSks": 24,
    "validations": {
      "prasyarat": {
        "passed": true,
        "errors": []
      },
      "jadwalBentrok": {
        "passed": true,
        "conflicts": []
      },
      "kuota": {
        "passed": true,
        "fullClasses": []
      },
      "pembayaran": {
        "passed": true,
        "isLunas": true
      },
      "maxSks": {
        "passed": true,
        "message": "Total SKS dalam batas wajar"
      }
    }
  }
}
```

**Error Response (validation failed):**
```json
{
  "success": false,
  "data": {
    "isValid": false,
    "validations": {
      "prasyarat": {
        "passed": false,
        "errors": [
          {
            "mataKuliah": "IF202 - Basis Data",
            "prasyarat": "IF201 - Struktur Data",
            "message": "Anda belum lulus mata kuliah prasyarat dengan nilai minimal C"
          }
        ]
      },
      "jadwalBentrok": {
        "passed": false,
        "conflicts": [
          {
            "kelas1": "IF101-A (Senin 08:00-10:30)",
            "kelas2": "IF103-A (Senin 08:00-10:30)",
            "message": "Jadwal bentrok"
          }
        ]
      }
    }
  }
}
```

#### POST /api/v1/krs
Submit KRS.

**Request:**
```json
{
  "periodeAkademikId": 1,
  "kelasIds": [1, 3, 4, 5, 6]
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "data": {
    "krsIds": [1, 2, 3, 4, 5],
    "totalSks": 18,
    "status": "submitted",
    "message": "KRS berhasil disubmit. Menunggu approval dosen wali."
  }
}
```

#### GET /api/v1/krs
Get KRS mahasiswa per periode.

**Query Parameters:**
- `periode_id` - filter by periode akademik

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "periode": {
      "id": 1,
      "tahunAjaran": "2024/2025",
      "semester": "Ganjil"
    },
    "status": "approved",
    "totalSks": 18,
    "mataKuliah": [
      {
        "krsId": 1,
        "kode": "IF101",
        "nama": "Pengantar Teknologi Informasi",
        "sks": 3,
        "kelas": "A",
        "dosen": "Dr. Ahmad Hidayat, M.Kom",
        "jadwal": "Senin, 08:00-10:30",
        "ruangan": "Lab 1",
        "status": "approved"
      }
    ],
    "approvedBy": "Dr. Ahmad Hidayat, M.Kom",
    "approvedAt": "2024-08-25T10:30:00Z"
  }
}
```

#### DELETE /api/v1/krs/:id
Cancel/delete KRS item (hanya jika status masih draft).

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Mata kuliah berhasil dihapus dari KRS"
}
```

#### GET /api/v1/krs/export-pdf/:periode_id
Download KRS sebagai PDF.

**Response:** PDF File

### 5.5 Jadwal Endpoints

#### GET /api/v1/jadwal
Get jadwal kuliah mahasiswa.

**Query Parameters:**
- `periode_id` - periode akademik
- `view` - calendar atau list (default: list)

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "periode": {
      "tahunAjaran": "2024/2025",
      "semester": "Ganjil"
    },
    "jadwal": [
      {
        "id": 1,
        "hari": "Senin",
        "jamMulai": "08:00",
        "jamSelesai": "10:30",
        "mataKuliah": {
          "kode": "IF101",
          "nama": "Pengantar Teknologi Informasi",
          "sks": 3
        },
        "kelas": "A",
        "dosen": "Dr. Ahmad Hidayat, M.Kom",
        "ruangan": "Lab 1"
      }
    ]
  }
}
```

### 5.6 Nilai Endpoints

#### GET /api/v1/nilai/khs
Get Kartu Hasil Studi (KHS) per semester.

**Query Parameters:**
- `periode_id` - periode akademik

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "periode": {
      "tahunAjaran": "2024/2025",
      "semester": "Ganjil"
    },
    "mahasiswa": {
      "nim": "2024001",
      "nama": "John Doe",
      "prodi": "Teknik Informatika"
    },
    "nilai": [
      {
        "kodeMk": "IF101",
        "namaMk": "Pengantar Teknologi Informasi",
        "sks": 3,
        "nilaiTugas": 85.00,
        "nilaiUts": 80.00,
        "nilaiUas": 90.00,
        "nilaiAkhir": 85.50,
        "hurufMutu": "A",
        "angkaMutu": 4.00,
        "mutu": 12.00
      }
    ],
    "ringkasan": {
      "totalSks": 18,
      "totalMutu": 67.50,
      "ip": 3.75,
      "ipk": 3.75
    }
  }
}
```

#### GET /api/v1/nilai/transkrip
Get transkrip nilai lengkap semua semester.

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "mahasiswa": {
      "nim": "2024001",
      "nama": "John Doe",
      "prodi": "Teknik Informatika",
      "angkatan": 2024
    },
    "riwayatNilai": [
      {
        "semester": 1,
        "tahunAjaran": "2024/2025",
        "periode": "Ganjil",
        "mataKuliah": [
          {
            "kode": "IF101",
            "nama": "Pengantar Teknologi Informasi",
            "sks": 3,
            "nilaiAkhir": 85.50,
            "hurufMutu": "A",
            "angkaMutu": 4.00
          }
        ],
        "ip": 3.75,
        "totalSks": 18
      }
    ],
    "summary": {
      "totalSksLulus": 18,
      "ipk": 3.75,
      "predikat": "Cum Laude"
    }
  }
}
```

#### GET /api/v1/nilai/ipk
Get summary IP/IPK mahasiswa.

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "ipk": 3.75,
    "totalSks": 18,
    "ipPerSemester": [
      {
        "semester": 1,
        "tahunAjaran": "2024/2025",
        "ip": 3.75,
        "sks": 18
      }
    ]
  }
}
```

### 5.7 Pembayaran Endpoints

#### GET /api/v1/pembayaran
Get riwayat pembayaran mahasiswa.

**Query Parameters:**
- `page` - pagination
- `limit` - items per page
- `status` - filter by status

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "jenisPembayaran": "SPP Semester",
        "periode": "2024/2025 Ganjil",
        "jumlah": 3000000.00,
        "status": "paid",
        "tanggalBayar": "2024-08-20T10:00:00Z",
        "metode": "Transfer Bank",
        "nomorReferensi": "TRX202408200001"
      }
    ],
    "meta": {
      "page": 1,
      "limit": 10,
      "total": 5,
      "totalPages": 1
    }
  }
}
```

#### GET /api/v1/pembayaran/status
Get status pembayaran untuk periode aktif.

**Query Parameters:**
- `periode_id` - periode akademik

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "periode": "2024/2025 Ganjil",
    "tagihan": [
      {
        "id": 1,
        "jenis": "SPP Semester",
        "jumlah": 3000000.00,
        "status": "paid",
        "tanggalBayar": "2024-08-20"
      },
      {
        "id": 2,
        "jenis": "Ujian Tengah Semester",
        "jumlah": 500000.00,
        "status": "pending",
        "jatuhTempo": "2024-10-15"
      }
    ],
    "totalTagihan": 500000.00,
    "totalDibayar": 3000000.00,
    "isLunas": false
  }
}
```

#### POST /api/v1/pembayaran/:id/upload-bukti
Upload bukti pembayaran.

**Content-Type:** `multipart/form-data`

**Request:**
```
file: <File>
tanggalBayar: "2024-08-20"
metode: "Transfer Bank"
nomorReferensi: "TRX202408200001"
```

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "pembayaranId": 1,
    "status": "paid",
    "buktiBayar": "uploads/payment/bukti_123.jpg",
    "message": "Bukti pembayaran berhasil diupload. Menunggu verifikasi admin."
  }
}
```

### 5.8 Dosen Endpoints

#### GET /api/v1/dosen/dashboard
Dashboard dosen.

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "profile": {
      "nidn": "0812345678",
      "nama": "Dr. Ahmad Hidayat, M.Kom",
      "prodi": "Teknik Informatika",
      "jabatan": "Lektor Kepala"
    },
    "kelasDiampu": [
      {
        "id": 1,
        "mataKuliah": "Pengantar Teknologi Informasi",
        "kodeKelas": "A",
        "jumlahMahasiswa": 35,
        "pertemuanSelesai": 5
      }
    ],
    "krsPending": 8,
    "nilaiPending": 12,
    "mahasiswaPerwalian": 25
  }
}
```

#### GET /api/v1/dosen/kelas
Get daftar kelas yang diampu.

**Query Parameters:**
- `periode_id` - periode akademik

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "mataKuliah": {
        "kode": "IF101",
        "nama": "Pengantar Teknologi Informasi",
        "sks": 3
      },
      "kodeKelas": "A",
      "jadwal": "Senin, 08:00-10:30",
      "ruangan": "Lab 1",
      "jumlahMahasiswa": 35,
      "kuota": 40
    }
  ]
}
```

#### GET /api/v1/dosen/kelas/:id/mahasiswa
Get daftar mahasiswa di kelas tertentu.

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "kelas": {
      "mataKuliah": "Pengantar Teknologi Informasi",
      "kodeKelas": "A"
    },
    "mahasiswa": [
      {
        "id": 1,
        "nim": "2024001",
        "nama": "John Doe",
        "prodi": "Teknik Informatika",
        "semester": 1,
        "fotoProfil": null
      }
    ]
  }
}
```

#### POST /api/v1/dosen/nilai
Input nilai mahasiswa.

**Request:**
```json
{
  "kelasId": 1,
  "nilaiData": [
    {
      "krsId": 1,
      "mahasiswaId": 1,
      "nilaiTugas": 85.00,
      "nilaiUts": 80.00,
      "nilaiUas": 90.00
    },
    {
      "krsId": 2,
      "mahasiswaId": 2,
      "nilaiTugas": 75.00,
      "nilaiUts": 70.00,
      "nilaiUas": 80.00
    }
  ]
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Nilai berhasil disimpan",
  "data": {
    "inserted": 2,
    "updated": 0
  }
}
```

#### POST /api/v1/dosen/nilai/publish/:kelas_id
Publish nilai ke mahasiswa (make visible).

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Nilai berhasil dipublish dan dapat dilihat mahasiswa",
  "data": {
    "kelasId": 1,
    "totalMahasiswa": 35
  }
}
```

#### POST /api/v1/dosen/presensi
Input presensi mahasiswa.

**Request:**
```json
{
  "kelasId": 1,
  "pertemuanKe": 5,
  "tanggal": "2024-09-15",
  "presensiData": [
    {
      "mahasiswaId": 1,
      "status": "hadir"
    },
    {
      "mahasiswaId": 2,
      "status": "izin",
      "keterangan": "Sakit"
    },
    {
      "mahasiswaId": 3,
      "status": "alpha"
    }
  ]
}
```

**Response:** `200 OK`

#### GET /api/v1/dosen/krs-approval
Get daftar KRS yang perlu di-approve (dosen wali).

**Query Parameters:**
- `status` - pending, approved, rejected

**Response:** `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "krsId": 123,
      "mahasiswa": {
        "id": 1,
        "nim": "2024001",
        "nama": "John Doe",
        "semester": 1,
        "ipk": 0.00
      },
      "periode": "2024/2025 Ganjil",
      "mataKuliah": [
        {
          "kode": "IF101",
          "nama": "Pengantar Teknologi Informasi",
          "sks": 3,
          "kelas": "A"
        }
      ],
      "totalSks": 18,
      "tanggalSubmit": "2024-08-20T10:00:00Z"
    }
  ]
}
```

#### POST /api/v1/dosen/krs-approval/:mahasiswa_id
Approve atau reject KRS mahasiswa.

**Request:**
```json
{
  "periodeAkademikId": 1,
  "status": "approved",
  "note": "Disetujui"
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "KRS berhasil disetujui",
  "data": {
    "mahasiswa": "John Doe",
    "totalSks": 18,
    "status": "approved"
  }
}
```

### 5.9 Admin Endpoints

#### GET /api/v1/admin/dashboard
Admin dashboard dengan statistics.

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "statistics": {
      "totalMahasiswa": 1500,
      "mahasiswaAktif": 1350,
      "totalDosen": 80,
      "totalMataKuliah": 200,
      "totalKelas": 150
    },
    "krsStats": {
      "submitted": 800,
      "approved": 650,
      "pending": 150,
      "rejected": 0
    },
    "pembayaranStats": {
      "lunas": 1200,
      "pending": 300,
      "overdue": 50
    },
    "charts": {
      "mahasiswaPerProdi": [
        { "prodi": "Teknik Informatika", "jumlah": 600 },
        { "prodi": "Sistem Informasi", "jumlah": 450 }
      ],
      "ipkDistribution": [
        { "range": "3.50-4.00", "jumlah": 300 },
        { "range": "3.00-3.49", "jumlah": 500 }
      ]
    }
  }
}
```

#### POST /api/v1/admin/mata-kuliah
Create new mata kuliah.

**Request:**
```json
{
  "kode": "IF301",
  "nama": "Basis Data Lanjut",
  "namaEn": "Advanced Database",
  "sks": 3,
  "semester": 3,
  "sifat": "wajib",
  "programStudiId": 1,
  "deskripsi": "Mata kuliah lanjutan basis data...",
  "prasyarat": [
    {
      "prasyaratId": 7,
      "minNilai": "C"
    }
  ]
}
```

**Response:** `201 Created`

#### POST /api/v1/admin/kelas
Create new kelas untuk periode tertentu.

**Request:**
```json
{
  "mataKuliahId": 1,
  "periodeAkademikId": 1,
  "kodeKelas": "C",
  "dosenId": 1,
  "hari": "Rabu",
  "jamMulai": "13:00",
  "jamSelesai": "15:30",
  "ruangan": "Lab 3",
  "kuota": 40
}
```

**Response:** `201 Created`

#### POST /api/v1/admin/periode-akademik
Create new periode akademik.

**Request:**
```json
{
  "tahunAjaran": "2025/2026",
  "semester": "Ganjil",
  "tanggalMulai": "2025-09-01",
  "tanggalSelesai": "2026-01-31",
  "tanggalMulaiKrs": "2025-08-15",
  "tanggalSelesaiKrs": "2025-09-05",
  "maxSksNormal": 24
}
```

**Response:** `201 Created`

#### POST /api/v1/admin/periode-akademik/:id/activate
Activate periode akademik (hanya 1 periode yang bisa aktif).

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Periode 2024/2025 Ganjil berhasil diaktifkan"
}
```

#### POST /api/v1/admin/pengumuman
Create pengumuman.

**Request:**
```json
{
  "judul": "Pengumuman Penting",
  "konten": "Isi pengumuman...",
  "kategori": "akademik",
  "target": "all",
  "isPublished": true
}
```

**Response:** `201 Created`

#### GET /api/v1/admin/reports/mahasiswa-per-prodi
Generate report mahasiswa per program studi.

**Query Parameters:**
- `angkatan` - filter by angkatan
- `status` - filter by status

**Response:** `200 OK` (JSON or Excel download)

### 5.10 File Upload Endpoints

#### POST /api/v1/upload/profile-photo
Upload profile photo.

**Content-Type:** `multipart/form-data`

**Request:**
```
file: <Image File> (max 2MB, jpg/png)
```

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "url": "https://cdn.portal-akademik.ac.id/uploads/profile/user_4.jpg",
    "filename": "user_4.jpg"
  }
}
```

#### POST /api/v1/upload/document
Upload document (PDF).

**Request:**
```
file: <PDF File> (max 5MB)
category: "document"
```

**Response:** `200 OK`

### 5.11 Notification Endpoints

#### GET /api/v1/notifications
Get user notifications.

**Query Parameters:**
- `is_read` - filter by read status
- `limit` - items per page

**Response:** `200 OK`
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "title": "KRS Disetujui",
        "message": "KRS Anda untuk semester Ganjil 2024/2025 telah disetujui oleh dosen wali",
        "type": "success",
        "category": "krs",
        "isRead": false,
        "createdAt": "2024-08-25T10:30:00Z"
      }
    ],
    "unreadCount": 5
  }
}
```

#### PUT /api/v1/notifications/:id/read
Mark notification as read.

**Response:** `200 OK`

#### POST /api/v1/notifications/mark-all-read
Mark all notifications as read.

**Response:** `200 OK`

---

## 7. Business Logic & Validation

### 7.1 KRS Validation Rules

```typescript
// services/krsValidation.service.ts

class KRSValidationService {
  /**
   * Validasi lengkap KRS sebelum submit
   */
  async validateKRS(mahasiswaId: number, kelasIds: number[], periodeId: number) {
    const validations = {
      prasyarat: await this.checkPrasyarat(mahasiswaId, kelasIds),
      jadwalBentrok: await this.checkJadwalBentrok(kelasIds),
      kuota: await this.checkKuotaKelas(kelasIds),
      maxSks: await this.checkMaxSKS(mahasiswaId, kelasIds, periodeId),
      pembayaran: await this.checkPembayaran(mahasiswaId, periodeId),
      periodeAktif: await this.checkPeriodeKRS(periodeId)
    };

    const isValid = Object.values(validations).every(v => v.passed);
    
    return {
      isValid,
      validations
    };
  }

  /**
   * Check prasyarat mata kuliah
   */
  private async checkPrasyarat(mahasiswaId: number, kelasIds: number[]) {
    const errors = [];
    
    for (const kelasId of kelasIds) {
      const kelas = await prisma.kelas.findUnique({
        where: { id: kelasId },
        include: {
          mataKuliah: {
            include: {
              prasyarat: {
                include: {
                  prasyarat: true
                }
              }
            }
          }
        }
      });

      if (kelas.mataKuliah.prasyarat.length > 0) {
        for (const prasyarat of kelas.mataKuliah.prasyarat) {
          // Cek apakah mahasiswa sudah lulus prasyarat
          const nilaiPrasyarat = await prisma.nilai.findFirst({
            where: {
              mahasiswaId,
              krs: {
                kelas: {
                  mataKuliahId: prasyarat.prasyaratId
                },
                status: 'approved'
              },
              isPublished: true
            }
          });

          const hurufMutuOrder = ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D', 'E'];
          const minNilaiIndex = hurufMutuOrder.indexOf(prasyarat.minNilai);
          const nilaiIndex = nilaiPrasyarat ? hurufMutuOrder.indexOf(nilaiPrasyarat.hurufMutu) : -1;

          if (!nilaiPrasyarat || nilaiIndex > minNilaiIndex) {
            errors.push({
              mataKuliah: `${kelas.mataKuliah.kode} - ${kelas.mataKuliah.nama}`,
              prasyarat: `${prasyarat.prasyarat.kode} - ${prasyarat.prasyarat.nama}`,
              minNilai: prasyarat.minNilai,
              nilaiAnda: nilaiPrasyarat?.hurufMutu || 'Belum lulus',
              message: `Prasyarat tidak terpenuhi. Minimal nilai ${prasyarat.minNilai}`
            });
          }
        }
      }
    }

    return {
      passed: errors.length === 0,
      errors
    };
  }

  /**
   * Check jadwal bentrok
   */
  private async checkJadwalBentrok(kelasIds: number[]) {
    const conflicts = [];
    const kelas = await prisma.kelas.findMany({
      where: { id: { in: kelasIds } },
      include: { mataKuliah: true }
    });

    for (let i = 0; i < kelas.length; i++) {
      for (let j = i + 1; j < kelas.length; j++) {
        const k1 = kelas[i];
        const k2 = kelas[j];

        // Check apakah hari sama
        if (k1.hari === k2.hari) {
          // Check apakah jam bentrok
          const bentrok = this.isTimeBentrok(
            k1.jamMulai, k1.jamSelesai,
            k2.jamMulai, k2.jamSelesai
          );

          if (bentrok) {
            conflicts.push({
              kelas1: `${k1.mataKuliah.kode}-${k1.kodeKelas} (${k1.hari} ${k1.jamMulai}-${k1.jamSelesai})`,
              kelas2: `${k2.mataKuliah.kode}-${k2.kodeKelas} (${k2.hari} ${k2.jamMulai}-${k2.jamSelesai})`,
              message: 'Jadwal kuliah bentrok'
            });
          }
        }
      }
    }

    return {
      passed: conflicts.length === 0,
      conflicts
    };
  }

  /**
   * Helper: Check time overlap
   */
  private isTimeBentrok(start1: string, end1: string, start2: string, end2: string): boolean {
    const s1 = this.timeToMinutes(start1);
    const e1 = this.timeToMinutes(end1);
    const s2 = this.timeToMinutes(start2);
    const e2 = this.timeToMinutes(end2);

    return (s1 < e2 && e1 > s2);
  }

  private timeToMinutes(time: string): number {
    const [hours, minutes] = time.split(':').map(Number);
    return hours * 60 + minutes;
  }

  /**
   * Check kuota kelas
   */
  private async checkKuotaKelas(kelasIds: number[]) {
    const fullClasses = [];
    
    for (const kelasId of kelasIds) {
      const kelas = await prisma.kelas.findUnique({
        where: { id: kelasId },
        include: { mataKuliah: true }
      });

      if (kelas.terisi >= kelas.kuota) {
        fullClasses.push({
          kelas: `${kelas.mataKuliah.kode}-${kelas.kodeKelas}`,
          kuota: kelas.kuota,
          terisi: kelas.terisi,
          message: 'Kuota kelas penuh'
        });
      }
    }

    return {
      passed: fullClasses.length === 0,
      fullClasses
    };
  }

  /**
   * Check max SKS yang boleh diambil
   */
  private async checkMaxSKS(mahasiswaId: number, kelasIds: number[], periodeId: number) {
    const mahasiswa = await prisma.mahasiswa.findUnique({
      where: { id: mahasiswaId }
    });

    const periode = await prisma.periodeAkademik.findUnique({
      where: { id: periodeId }
    });

    // Hitung total SKS yang akan diambil
    const kelas = await prisma.kelas.findMany({
      where: { id: { in: kelasIds } },
      include: { mataKuliah: true }
    });

    const totalSks = kelas.reduce((sum, k) => sum + k.mataKuliah.sks, 0);

    // Tentukan max SKS berdasarkan IPK
    let maxSks = periode.maxSksNormal;
    
    if (mahasiswa.ipk >= 3.00) {
      maxSks = 24;
    } else if (mahasiswa.ipk >= 2.50) {
      maxSks = 21;
    } else {
      maxSks = 18;
    }

    const passed = totalSks <= maxSks;

    return {
      passed,
      totalSks,
      maxSks,
      ipk: mahasiswa.ipk,
      message: passed 
        ? `Total SKS ${totalSks} dalam batas (max: ${maxSks})` 
        : `Total SKS ${totalSks} melebihi batas (max: ${maxSks} untuk IPK ${mahasiswa.ipk})`
    };
  }

  /**
   * Check status pembayaran
   */
  private async checkPembayaran(mahasiswaId: number, periodeId: number) {
    const tagihan = await prisma.pembayaran.findMany({
      where: {
        mahasiswaId,
        periodeAkademikId: periodeId,
        status: { in: ['pending', 'overdue'] }
      }
    });

    const isLunas = tagihan.length === 0;

    return {
      passed: isLunas,
      isLunas,
      totalTagihan: tagihan.reduce((sum, t) => sum + Number(t.jumlah), 0),
      message: isLunas 
        ? 'Pembayaran lunas' 
        : `Masih ada tagihan yang belum dibayar (${tagihan.length} tagihan)`
    };
  }

  /**
   * Check periode KRS aktif
   */
  private async checkPeriodeKRS(periodeId: number) {
    const periode = await prisma.periodeAkademik.findUnique({
      where: { id: periodeId }
    });

    if (!periode) {
      return {
        passed: false,
        message: 'Periode akademik tidak ditemukan'
      };
    }

    const now = new Date();
    const mulai = new Date(periode.tanggalMulaiKrs);
    const selesai = new Date(periode.tanggalSelesaiKrs);

    const isOpen = now >= mulai && now <= selesai;

    return {
      passed: isOpen,
      tanggalMulai: periode.tanggalMulaiKrs,
      tanggalSelesai: periode.tanggalSelesaiKrs,
      message: isOpen 
        ? 'Periode KRS sedang dibuka' 
        : `Periode KRS ${now < mulai ? 'belum dibuka' : 'sudah ditutup'}`
    };
  }
}
```

### 7.2 Nilai Calculation Logic

```typescript
// services/nilaiCalculation.service.ts

class NilaiCalculationService {
  /**
   * Calculate nilai akhir dari komponen nilai
   */
  calculateNilaiAkhir(nilaiTugas: number, nilaiUts: number, nilaiUas: number): number {
    // Bobot: Tugas 30%, UTS 30%, UAS 40%
    const nilaiAkhir = (nilaiTugas * 0.3) + (nilaiUts * 0.3) + (nilaiUas * 0.4);
    return Math.round(nilaiAkhir * 100) / 100; // Round to 2 decimals
  }

  /**
   * Convert nilai angka ke huruf mutu
   */
  getHurufMutu(nilaiAkhir: number): string {
    if (nilaiAkhir >= 85) return 'A';
    if (nilaiAkhir >= 80) return 'A-';
    if (nilaiAkhir >= 75) return 'B+';
    if (nilaiAkhir >= 70) return 'B';
    if (nilaiAkhir >= 65) return 'B-';
    if (nilaiAkhir >= 60) return 'C+';
    if (nilaiAkhir >= 55) return 'C';
    if (nilaiAkhir >= 50) return 'D';
    return 'E';
  }

  /**
   * Convert huruf mutu ke angka mutu
   */
  getAngkaMutu(hurufMutu: string): number {
    const mapping: Record<string, number> = {
      'A': 4.00,
      'A-': 3.75,
      'B+': 3.50,
      'B': 3.00,
      'B-': 2.75,
      'C+': 2.50,
      'C': 2.00,
      'D': 1.00,
      'E': 0.00
    };
    return mapping[hurufMutu] || 0.00;
  }

  /**
   * Calculate IP (Indeks Prestasi) untuk 1 semester
   */
  calculateIP(nilaiList: Array<{ angkaMutu: number; sks: number }>): number {
    const totalMutu = nilaiList.reduce((sum, n) => sum + (n.angkaMutu * n.sks), 0);
    const totalSks = nilaiList.reduce((sum, n) => sum + n.sks, 0);
    
    if (totalSks === 0) return 0.00;
    
    const ip = totalMutu / totalSks;
    return Math.round(ip * 100) / 100; // Round to 2 decimals
  }

  /**
   * Calculate IPK (Indeks Prestasi Kumulatif)
   */
  calculateIPK(allNilai: Array<{ angkaMutu: number; sks: number }>): number {
    return this.calculateIP(allNilai); // Same formula as IP but for all semesters
  }

  /**
   * Determine predikat kelulusan
   */
  getPredikat(ipk: number): string {
    if (ipk >= 3.51) return 'Cum Laude';
    if (ipk >= 3.00) return 'Sangat Memuaskan';
    if (ipk >= 2.75) return 'Memuaskan';
    return 'Lulus';
  }

  /**
   * Save nilai dan auto-calculate
   */
  async saveNilai(data: {
    krsId: number;
    mahasiswaId: number;
    kelasId: number;
    nilaiTugas: number;
    nilaiUts: number;
    nilaiUas: number;
  }) {
    const nilaiAkhir = this.calculateNilaiAkhir(data.nilaiTugas, data.nilaiUts, data.nilaiUas);
    const hurufMutu = this.getHurufMutu(nilaiAkhir);
    const angkaMutu = this.getAngkaMutu(hurufMutu);

    const nilai = await prisma.nilai.upsert({
      where: { krsId: data.krsId },
      create: {
        ...data,
        nilaiAkhir,
        hurufMutu,
        angkaMutu,
        isPublished: false
      },
      update: {
        nilaiTugas: data.nilaiTugas,
        nilaiUts: data.nilaiUts,
        nilaiUas: data.nilaiUas,
        nilaiAkhir,
        hurufMutu,
        angkaMutu
      }
    });

    return nilai;
  }
}
```

### 7.3 Pembayaran Logic

```typescript
// services/pembayaran.service.ts

class PembayaranService {
  /**
   * Generate tagihan untuk mahasiswa per periode
   */
  async generateTagihan(mahasiswaId: number, periodeId: number) {
    const jenisPembayaran = await prisma.jenisPembayaran.findMany({
      where: { isRecurring: true }
    });

    const tagihan = [];
    const now = new Date();

    for (const jenis of jenisPembayaran) {
      // Check if already exists
      const existing = await prisma.pembayaran.findFirst({
        where: {
          mahasiswaId,
          periodeAkademikId: periodeId,
          jenisPembayaranId: jenis.id
        }
      });

      if (!existing) {
        const jatuhTempo = this.calculateJatuhTempo(jenis.kode, periodeId);
        
        tagihan.push({
          mahasiswaId,
          periodeAkademikId: periodeId,
          jenisPembayaranId: jenis.id,
          jumlah: jenis.jumlah,
          status: 'pending',
          tanggalJatuhTempo: jatuhTempo
        });
      }
    }

    if (tagihan.length > 0) {
      await prisma.pembayaran.createMany({
        data: tagihan
      });
    }

    return tagihan;
  }

  /**
   * Calculate tanggal jatuh tempo
   */
  private calculateJatuhTempo(kodeJenis: string, periodeId: number): Date {
    const periode = await prisma.periodeAkademik.findUnique({
      where: { id: periodeId }
    });

    const tanggalMulai = new Date(periode.tanggalMulai);

    switch (kodeJenis) {
      case 'SPP':
        return new Date(tanggalMulai.setDate(tanggalMulai.getDate() + 14)); // 14 hari dari mulai
      case 'UTS':
        return new Date(tanggalMulai.setMonth(tanggalMulai.getMonth() + 2)); // 2 bulan dari mulai
      case 'UAS':
        return new Date(tanggalMulai.setMonth(tanggalMulai.getMonth() + 4)); // 4 bulan dari mulai
      default:
        return new Date(tanggalMulai.setDate(tanggalMulai.getDate() + 30));
    }
  }

  /**
   * Verify pembayaran (admin)
   */
  async verifyPembayaran(pembayaranId: number, adminId: number) {
    const pembayaran = await prisma.pembayaran.update({
      where: { id: pembayaranId },
      data: {
        status: 'verified',
        verifiedBy: adminId,
        verifiedAt: new Date()
      }
    });

    // Send notification to mahasiswa
    await this.sendNotification(pembayaran.mahasiswaId, {
      title: 'Pembayaran Terverifikasi',
      message: `Pembayaran Anda telah diverifikasi oleh admin`,
      type: 'success',
      category: 'pembayaran',
      referenceId: pembayaranId
    });

    return pembayaran;
  }

  /**
   * Check status pembayaran untuk KRS
   */
  async checkStatusLunas(mahasiswaId: number, periodeId: number): Promise<boolean> {
    const tagihan = await prisma.pembayaran.findMany({
      where: {
        mahasiswaId,
        periodeAkademikId: periodeId,
        jenisPembayaran: {
          kode: 'SPP' // Only check SPP for KRS
        },
        status: { in: ['pending', 'overdue'] }
      }
    });

    return tagihan.length === 0;
  }

  /**
   * Auto update overdue status
   */
  async updateOverdueStatus() {
    const now = new Date();
    
    await prisma.pembayaran.updateMany({
      where: {
        status: 'pending',
        tanggalJatuhTempo: {
          lt: now
        }
      },
      data: {
        status: 'overdue'
      }
    });
  }
}
```

---

## 8. Security Implementation

### 8.1 Authentication Flow

```typescript
// middleware/auth.middleware.ts

import jwt from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';

interface JWTPayload {
  userId: number;
  email: string;
  role: string;
}

export const authMiddleware = async (
  req: Request, 
  res: Response, 
  next: NextFunction
) => {
  try {
    // Extract token from header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'Token tidak ditemukan'
        }
      });
    }

    const token = authHeader.split(' ')[1];

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload;

    // Check if user still exists and active
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId }
    });

    if (!user || !user.isActive) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'User tidak ditemukan atau tidak aktif'
        }
      });
    }

    // Attach user to request
    req.user = {
      id: user.id,
      email: user.email,
      role: user.role
    };

    next();
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'TOKEN_EXPIRED',
          message: 'Token sudah expired'
        }
      });
    }

    return res.status(401).json({
      success: false,
      error: {
        code: 'INVALID_TOKEN',
        message: 'Token tidak valid'
      }
    });
  }
};
```

### 8.2 Role-Based Access Control

```typescript
// middleware/rbac.middleware.ts

export const roleMiddleware = (...allowedRoles: string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'Unauthorized'
        }
      });
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        error: {
          code: 'FORBIDDEN',
          message: 'Anda tidak memiliki akses ke resource ini'
        }
      });
    }

    next();
  };
};

// Usage in routes:
// router.get('/admin/dashboard', authMiddleware, roleMiddleware('admin', 'super_admin'), getDashboard);
```

### 8.3 Password Hashing

```typescript
// utils/password.util.ts

import bcrypt from 'bcrypt';

export class PasswordUtil {
  private static SALT_ROUNDS = 10;

  /**
   * Hash password
   */
  static async hash(password: string): Promise<string> {
    return bcrypt.hash(password, this.SALT_ROUNDS);
  }

  /**
   * Compare password with hash
   */
  static async compare(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }

  /**
   * Validate password strength
   */
  static validateStrength(password: string): { isValid: boolean; errors: string[] } {
    const errors: string[] = [];

    if (password.length < 8) {
      errors.push('Password minimal 8 karakter');
    }

    if (!/[A-Z]/.test(password)) {
      errors.push('Password harus mengandung huruf besar');
    }

    if (!/[a-z]/.test(password)) {
      errors.push('Password harus mengandung huruf kecil');
    }

    if (!/[0-9]/.test(password)) {
      errors.push('Password harus mengandung angka');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }
}
```

### 8.4 Rate Limiting

```typescript
// middleware/rateLimiter.middleware.ts

import rateLimit from 'express-rate-limit';

// General API rate limiter
export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Max 100 requests per window
  message: {
    success: false,
    error: {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Terlalu banyak request, coba lagi nanti'
    }
  },
  standardHeaders: true,
  legacyHeaders: false
});

// Strict limiter for authentication
export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // Max 5 login attempts
  skipSuccessfulRequests: true,
  message: {
    success: false,
    error: {
      code: 'AUTH_RATE_LIMIT',
      message: 'Terlalu banyak percobaan login, coba lagi dalam 15 menit'
    }
  }
});

// Apply in app.ts:
// app.use('/api', apiLimiter);
// app.use('/api/auth/login', authLimiter);
```

### 8.5 Input Validation & Sanitization

```typescript
// validators/krs.validator.ts

import Joi from 'joi';

export const krsSubmitSchema = Joi.object({
  periodeAkademikId: Joi.number().integer().positive().required(),
  kelasIds: Joi.array()
    .items(Joi.number().integer().positive())
    .min(1)
    .max(12)
    .unique()
    .required()
    .messages({
      'array.min': 'Minimal pilih 1 mata kuliah',
      'array.max': 'Maksimal 12 mata kuliah',
      'array.unique': 'Tidak boleh ada kelas duplikat'
    })
});

export const validateRequest = (schema: Joi.Schema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const { error, value } = schema.validate(req.body, {
      abortEarly: false,
      stripUnknown: true
    });

    if (error) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Data tidak valid',
          details: error.details.map(d => ({
            field: d.path.join('.'),
            message: d.message
          }))
        }
      });
    }

    req.body = value;
    next();
  };
};

// Usage:
// router.post('/krs', authMiddleware, validateRequest(krsSubmitSchema), submitKRS);
```

### 8.6 SQL Injection Prevention

Prisma ORM automatically prevents SQL injection by using parameterized queries. Always use Prisma query builder instead of raw SQL:

```typescript
// ✅ GOOD - Using Prisma (safe)
const mahasiswa = await prisma.mahasiswa.findMany({
  where: {
    nim: { contains: searchQuery }
  }
});

// ❌ BAD - Raw SQL without parameterization
const mahasiswa = await prisma.$queryRawUnsafe(
  `SELECT * FROM mahasiswa WHERE nim LIKE '%${searchQuery}%'`
);

// ✅ GOOD - If must use raw SQL, use parameterized
const mahasiswa = await prisma.$queryRaw`
  SELECT * FROM mahasiswa WHERE nim LIKE ${'%' + searchQuery + '%'}
`;
```

### 8.7 XSS Prevention

```typescript
// utils/sanitize.util.ts

import DOMPurify from 'isomorphic-dompurify';

export class SanitizeUtil {
  /**
   * Sanitize HTML content
   */
  static html(dirty: string): string {
    return DOMPurify.sanitize(dirty, {
      ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a', 'p', 'br'],
      ALLOWED_ATTR: ['href']
    });
  }

  /**
   * Escape special characters
   */
  static escape(text: string): string {
    const map: Record<string, string> = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#x27;',
      '/': '&#x2F;'
    };
    return text.replace(/[&<>"'/]/g, char => map[char]);
  }
}
```

### 8.8 CORS Configuration

```typescript
// config/cors.config.ts

import cors from 'cors';

export const corsOptions: cors.CorsOptions = {
  origin: (origin, callback) => {
    const allowedOrigins = [
      'https://portal-akademik.ac.id',
      'https://www.portal-akademik.ac.id',
      'http://localhost:5173', // Development
      'http://localhost:3000'
    ];

    if (!origin || allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization']
};

// Usage in app.ts:
// app.use(cors(corsOptions));
```

---

## 9. File Management

### 9.1 File Upload Configuration

```typescript
// config/multer.config.ts

import multer from 'multer';
import path from 'path';
import { Request } from 'express';

// Storage configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const category = req.body.category || 'general';
    const uploadPath = path.join(__dirname, '../uploads', category);
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const ext = path.extname(file.originalname);
    cb(null, `${file.fieldname}-${uniqueSuffix}${ext}`);
  }
});

// File filter
const fileFilter = (req: Request, file: Express.Multer.File, cb: multer.FileFilterCallback) => {
  const allowedMimes = {
    image: ['image/jpeg', 'image/png', 'image/jpg'],
    document: ['application/pdf'],
    excel: ['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
  };

  const category = req.body.category || 'image';
  const allowed = allowedMimes[category as keyof typeof allowedMimes] || allowedMimes.image;

  if (allowed.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error(`File type not allowed. Allowed types: ${allowed.join(', ')}`));
  }
};

// Export configurations
export const uploadImage = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 2 * 1024 * 1024 // 2MB
  }
});

export const uploadDocument = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB
  }
});
```

### 9.2 File Service

```typescript
// services/file.service.ts

import fs from 'fs/promises';
import path from 'path';

export class FileService {
  /**
   * Save file metadata to database
   */
  async saveFileMetadata(data: {
    userId: number;
    filename: string;
    originalName: string;
    mimeType: string;
    size: number;
    path: string;
    category: string;
  }) {
    return prisma.fileUpload.create({
      data
    });
  }

  /**
   * Delete file from filesystem and database
   */
  async deleteFile(fileId: number) {
    const file = await prisma.fileUpload.findUnique({
      where: { id: fileId }
    });

    if (!file) {
      throw new Error('File not found');
    }

    // Delete from filesystem
    const filePath = path.join(__dirname, '../', file.path);
    try {
      await fs.unlink(filePath);
    } catch (error) {
      console.error('Error deleting file from filesystem:', error);
    }

    // Delete from database
    await prisma.fileUpload.delete({
      where: { id: fileId }
    });

    return { success: true };
  }

  /**
   * Get file URL
   */
  getFileUrl(filename: string, category: string = 'general'): string {
    const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
    return `${baseUrl}/uploads/${category}/${filename}`;
  }
}
```

### 9.3 PDF Generation

```typescript
// services/pdf.service.ts

import { PDFDocument, rgb, StandardFonts } from 'pdf-lib';

export class PDFService {
  /**
   * Generate KRS PDF
   */
  async generateKRSPdf(krsData: any) {
    const pdfDoc = await PDFDocument.create();
    const page = pdfDoc.addPage([595, 842]); // A4 size
    const { width, height } = page.getSize();
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const fontBold = await pdfDoc.embedFont(StandardFonts.HelveticaBold);

    // Header
    page.drawText('KARTU RENCANA STUDI (KRS)', {
      x: 50,
      y: height - 50,
      size: 16,
      font: fontBold,
      color: rgb(0, 0, 0)
    });

    // Student Info
    let yPos = height - 100;
    page.drawText(`NIM: ${krsData.mahasiswa.nim}`, { x: 50, y: yPos, size: 10, font });
    yPos -= 20;
    page.drawText(`Nama: ${krsData.mahasiswa.nama}`, { x: 50, y: yPos, size: 10, font });
    yPos -= 20;
    page.drawText(`Program Studi: ${krsData.mahasiswa.prodi}`, { x: 50, y: yPos, size: 10, font });
    yPos -= 20;
    page.drawText(`Semester: ${krsData.mahasiswa.semester}`, { x: 50, y: yPos, size: 10, font });

    // Table Header
    yPos -= 40;
    const tableHeaders = ['No', 'Kode MK', 'Nama Mata Kuliah', 'SKS', 'Kelas', 'Dosen'];
    const colWidths = [30, 70, 200, 40, 50, 155];
    let xPos = 50;

    tableHeaders.forEach((header, i) => {
      page.drawText(header, {
        x: xPos,
        y: yPos,
        size: 9,
        font: fontBold
      });
      xPos += colWidths[i];
    });

    // Table Content
    yPos -= 20;
    krsData.mataKuliah.forEach((mk: any, index: number) => {
      xPos = 50;
      const row = [
        (index + 1).toString(),
        mk.kode,
        mk.nama,
        mk.sks.toString(),
        mk.kelas,
        mk.dosen
      ];

      row.forEach((cell, i) => {
        page.drawText(cell, {
          x: xPos,
          y: yPos,
          size: 8,
          font
        });
        xPos += colWidths[i];
      });
      yPos -= 18;
    });

    // Total SKS
    yPos -= 20;
    page.drawText(`Total SKS: ${krsData.totalSks}`, {
      x: 50,
      y: yPos,
      size: 10,
      font: fontBold
    });

    // Signature
    yPos -= 60;
    page.drawText('Mahasiswa,', { x: 50, y: yPos, size: 9, font });
    page.drawText('Dosen Wali,', { x: 400, y: yPos, size: 9, font });

    yPos -= 60;
    page.drawText(krsData.mahasiswa.nama, { x: 50, y: yPos, size: 9, font });
    page.drawText(krsData.dosenWali || '_______________', { x: 400, y: yPos, size: 9, font });

    const pdfBytes = await pdfDoc.save();
    return Buffer.from(pdfBytes);
  }

  /**
   * Generate KHS PDF
   */
  async generateKHSPdf(khsData: any) {
    const pdfDoc = await PDFDocument.create();
    const page = pdfDoc.addPage([595, 842]);
    const { width, height } = page.getSize();
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const fontBold = await pdfDoc.embedFont(StandardFonts.HelveticaBold);

    // Header
    page.drawText('KARTU HASIL STUDI (KHS)', {
      x: 50,
      y: height - 50,
      size: 16,
      font: fontBold
    });

    // Student and Period Info
    let yPos = height - 100;
    page.drawText(`NIM: ${khsData.mahasiswa.nim}`, { x: 50, y: yPos, size: 10, font });
    yPos -= 20;
    page.drawText(`Nama: ${khsData.mahasiswa.nama}`, { x: 50, y: yPos, size: 10, font });
    yPos -= 20;
    page.drawText(`Periode: ${khsData.periode.tahunAjaran} ${khsData.periode.semester}`, { x: 50, y: yPos, size: 10, font });

    // Table
    yPos -= 40;
    const headers = ['No', 'Kode', 'Mata Kuliah', 'SKS', 'Nilai', 'Mutu'];
    const colWidths = [30, 70, 220, 40, 50, 50];
    let xPos = 50;

    headers.forEach((header, i) => {
      page.drawText(header, { x: xPos, y: yPos, size: 9, font: fontBold });
      xPos += colWidths[i];
    });

    yPos -= 20;
    khsData.nilai.forEach((n: any, index: number) => {
      xPos = 50;
      const row = [
        (index + 1).toString(),
        n.kodeMk,
        n.namaMk.substring(0, 30),
        n.sks.toString(),
        n.hurufMutu,
        (n.angkaMutu * n.sks).toFixed(2)
      ];

      row.forEach((cell, i) => {
        page.drawText(cell, { x: xPos, y: yPos, size: 8, font });
        xPos += colWidths[i];
      });
      yPos -= 18;
    });

    // Summary
    yPos -= 30;
    page.drawText(`Total SKS: ${khsData.ringkasan.totalSks}`, { x: 50, y: yPos, size: 10, font: fontBold });
    yPos -= 20;
    page.drawText(`IP Semester: ${khsData.ringkasan.ip}`, { x: 50, y: yPos, size: 10, font: fontBold });
    yPos -= 20;
    page.drawText(`IPK: ${khsData.ringkasan.ipk}`, { x: 50, y: yPos, size: 10, font: fontBold });

    const pdfBytes = await pdfDoc.save();
    return Buffer.from(pdfBytes);
  }

  /**
   * Generate Transkrip PDF
   */
  async generateTranskripPdf(transkripData: any) {
    const pdfDoc = await PDFDocument.create();
    const page = pdfDoc.addPage([595, 842]);
    const { width, height } = page.getSize();
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const fontBold = await pdfDoc.embedFont(StandardFonts.HelveticaBold);

    // Header
    page.drawText('TRANSKRIP NILAI', {
      x: 50,
      y: height - 50,
      size: 16,
      font: fontBold
    });

    // Implementation similar to KHS but with all semesters
    // ... (detailed implementation)

    const pdfBytes = await pdfDoc.save();
    return Buffer.from(pdfBytes);
  }
}
```

---

## 10. Notification System

### 10.1 Notification Service

```typescript
// services/notification.service.ts

export class NotificationService {
  /**
   * Create notification for user
   */
  async create(data: {
    userId: number;
    title: string;
    message: string;
    type: 'info' | 'success' | 'warning' | 'error';
    category?: string;
    referenceId?: number;
  }) {
    return prisma.notification.create({
      data: {
        ...data,
        isRead: false
      }
    });
  }

  /**
   * Create bulk notifications
   */
  async createBulk(notifications: Array<{
    userId: number;
    title: string;
    message: string;
    type: string;
    category?: string;
  }>) {
    return prisma.notification.createMany({
      data: notifications
    });
  }

  /**
   * Send notification untuk KRS approved
   */
  async notifyKRSApproved(mahasiswaId: number, totalSks: number, periode: string) {
    const mahasiswa = await prisma.mahasiswa.findUnique({
      where: { id: mahasiswaId },
      include: { user: true }
    });

    if (!mahasiswa) return;

    await this.create({
      userId: mahasiswa.userId,
      title: 'KRS Disetujui',
      message: `KRS Anda untuk periode ${periode} dengan total ${totalSks} SKS telah disetujui oleh dosen wali`,
      type: 'success',
      category: 'krs'
    });

    // Send email
    await this.sendEmail(
      mahasiswa.user.email,
      'KRS Disetujui',
      `KRS Anda telah disetujui. Total SKS: ${totalSks}`
    );
  }

  /**
   * Send notification untuk nilai published
   */
  async notifyNilaiPublished(kelasId: number) {
    const krs = await prisma.krs.findMany({
      where: { 
        kelasId,
        status: 'approved'
      },
      include: {
        mahasiswa: {
          include: { user: true }
        },
        kelas: {
          include: { mataKuliah: true }
        }
      }
    });

    const notifications = krs.map(k => ({
      userId: k.mahasiswa.userId,
      title: 'Nilai Tersedia',
      message: `Nilai untuk mata kuliah ${k.kelas.mataKuliah.nama} sudah dapat dilihat`,
      type: 'info' as const,
      category: 'nilai'
    }));

    await this.createBulk(notifications);
  }

  /**
   * Send notification untuk pembayaran jatuh tempo
   */
  async notifyPembayaranJatuhTempo() {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 7); // 7 days before due

    const pembayaran = await prisma.pembayaran.findMany({
      where: {
        status: 'pending',
        tanggalJatuhTempo: {
          lte: tomorrow,
          gte: new Date()
        }
      },
      include: {
        mahasiswa: {
          include: { user: true }
        },
        jenisPembayaran: true
      }
    });

    for (const p of pembayaran) {
      await this.create({
        userId: p.mahasiswa.userId,
        title: 'Pengingat Pembayaran',
        message: `Pembayaran ${p.jenisPembayaran.nama} akan jatuh tempo pada ${p.tanggalJatuhTempo.toLocaleDateString()}`,
        type: 'warning',
        category: 'pembayaran',
        referenceId: p.id
      });
    }
  }

  /**
   * Send email notification
   */
  private async sendEmail(to: string, subject: string, body: string) {
    // Implementation using nodemailer
    const transporter = nodemailer.createTransporter({
      host: process.env.SMTP_HOST,
      port: parseInt(process.env.SMTP_PORT || '587'),
      secure: false,
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS
      }
    });

    await transporter.sendMail({
      from: process.env.SMTP_FROM,
      to,
      subject,
      html: body
    });
  }

  /**
   * Mark notification as read
   */
  async markAsRead(notificationId: number) {
    return prisma.notification.update({
      where: { id: notificationId },
      data: {
        isRead: true,
        readAt: new Date()
      }
    });
  }

  /**
   * Get unread count
   */
  async getUnreadCount(userId: number): Promise<number> {
    return prisma.notification.count({
      where: {
        userId,
        isRead: false
      }
    });
  }
}
```

### 10.2 Email Templates

```typescript
// templates/email.templates.ts

export class EmailTemplates {
  static krsApproved(data: { nama: string; periode: string; totalSks: number }) {
    return `
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: #4CAF50; color: white; padding: 20px; text-align: center; }
          .content { padding: 20px; background: #f5f5f5; }
          .footer { padding: 20px; text-align: center; color: #666; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>KRS Disetujui</h1>
          </div>
          <div class="content">
            <p>Yth. ${data.nama},</p>
            <p>KRS Anda untuk periode <strong>${data.periode}</strong> dengan total <strong>${data.totalSks} SKS</strong> telah disetujui oleh dosen wali.</p>
            <p>Silakan login ke portal akademik untuk melihat detail KRS Anda.</p>
          </div>
          <div class="footer">
            <p>Portal Akademik - Universitas</p>
          </div>
        </div>
      </body>
      </html>
    `;
  }

  static passwordReset(data: { nama: string; resetLink: string }) {
    return `
      <!DOCTYPE html>
      <html>
      <body>
        <div class="container">
          <h2>Reset Password</h2>
          <p>Yth. ${data.nama},</p>
          <p>Anda telah meminta reset password. Klik link berikut untuk reset password:</p>
          <p><a href="${data.resetLink}">${data.resetLink}</a></p>
          <p>Link ini berlaku selama 1 jam.</p>
          <p>Jika Anda tidak meminta reset password, abaikan email ini.</p>
        </div>
      </body>
      </html>
    `;
  }
}
```

---

## 11. Testing Strategy

### 11.1 Unit Testing

```typescript
// tests/unit/nilaiCalculation.test.ts

import { NilaiCalculationService } from '../../services/nilaiCalculation.service';

describe('NilaiCalculationService', () => {
  let service: NilaiCalculationService;

  beforeEach(() => {
    service = new NilaiCalculationService();
  });

  describe('calculateNilaiAkhir', () => {
    it('should calculate correctly with weights 30-30-40', () => {
      const result = service.calculateNilaiAkhir(80, 75, 85);
      expect(result).toBe(80); // (80*0.3 + 75*0.3 + 85*0.4)
    });

    it('should round to 2 decimals', () => {
      const result = service.calculateNilaiAkhir(83.33, 76.67, 88.88);
      expect(result.toString()).toMatch(/^\d+\.\d{2}$/);
    });
  });

  describe('getHurufMutu', () => {
    it('should return A for nilai >= 85', () => {
      expect(service.getHurufMutu(85)).toBe('A');
      expect(service.getHurufMutu(90)).toBe('A');
    });

    it('should return E for nilai < 50', () => {
      expect(service.getHurufMutu(40)).toBe('E');
    });
  });

  describe('calculateIP', () => {
    it('should calculate IP correctly', () => {
      const nilai = [
        { angkaMutu: 4.0, sks: 3 },
        { angkaMutu: 3.5, sks: 4 },
        { angkaMutu: 3.0, sks: 3 }
      ];
      const ip = service.calculateIP(nilai);
      // (4.0*3 + 3.5*4 + 3.0*3) / (3+4+3) = 3.5
      expect(ip).toBe(3.5);
    });

    it('should return 0 for empty nilai', () => {
      expect(service.calculateIP([])).toBe(0);
    });
  });
});
```

### 11.2 Integration Testing

```typescript
// tests/integration/krs.test.ts

import request from 'supertest';
import app from '../../app';
import { prisma } from '../../lib/prisma';

describe('KRS API', () => {
  let authToken: string;
  let mahasiswaId: number;

  beforeAll(async () => {
    // Setup test data
    const loginRes = await request(app)
      .post('/api/v1/auth/login')
      .send({
        email: 'test@student.university.ac.id',
        password: 'password123'
      });
    
    authToken = loginRes.body.data.tokens.accessToken;
    mahasiswaId = loginRes.body.data.user.mahasiswa.id;
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  describe('POST /api/v1/krs/validate', () => {
    it('should validate KRS successfully', async () => {
      const res = await request(app)
        .post('/api/v1/krs/validate')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          periodeAkademikId: 1,
          kelasIds: [1, 3, 4]
        });

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data).toHaveProperty('isValid');
      expect(res.body.data).toHaveProperty('validations');
    });

    it('should reject invalid KRS with bentrok jadwal', async () => {
      const res = await request(app)
        .post('/api/v1/krs/validate')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          periodeAkademikId: 1,
          kelasIds: [1, 2] // Assume these have conflicting schedules
        });

      expect(res.body.data.isValid).toBe(false);
      expect(res.body.data.validations.jadwalBentrok.passed).toBe(false);
    });
  });

  describe('POST /api/v1/krs', () => {
    it('should submit KRS successfully', async () => {
      const res = await request(app)
        .post('/api/v1/krs')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          periodeAkademikId: 1,
          kelasIds: [1, 3, 4, 5]
        });

      expect(res.status).toBe(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data).toHaveProperty('krsIds');
    });

    it('should reject KRS without authentication', async () => {
      const res = await request(app)
        .post('/api/v1/krs')
        .send({
          periodeAkademikId: 1,
          kelasIds: [1]
        });

      expect(res.status).toBe(401);
    });
  });
});
```

### 11.3 E2E Testing with Playwright

```typescript
// tests/e2e/krs-flow.spec.ts

import { test, expect } from '@playwright/test';

test.describe('KRS Flow', () => {
  test.beforeEach(async ({ page }) => {
    // Login
    await page.goto('http://localhost:5173/login');
    await page.fill('input[name="email"]', 'john.doe@student.university.ac.id');
    await page.fill('input[name="password"]', 'password123');
    await page.click('button[type="submit"]');
    await page.waitForURL('**/dashboard');
  });

  test('should complete KRS submission flow', async ({ page }) => {
    // Navigate to KRS page
    await page.click('text=KRS');
    await page.waitForURL('**/krs');

    // Select mata kuliah
    await page.click('[data-testid="mk-card-1"] button');
    await page.click('[data-testid="mk-card-3"] button');
    await page.click('[data-testid="mk-card-4"] button');

    // Check selected count
    const selectedCount = await page.textContent('[data-testid="selected-count"]');
    expect(selectedCount).toContain('3');

    // Validate KRS
    await page.click('button:has-text("Validasi KRS")');
    await page.waitForSelector('[data-testid="validation-result"]');

    // Submit KRS
    await page.click('button:has-text("Submit KRS")');
    await page.waitForSelector('text=KRS berhasil disubmit');

    // Verify success message
    const successMessage = await page.textContent('[data-testid="success-message"]');
    expect(successMessage).toContain('berhasil');
  });

  test('should show error for jadwal bentrok', async ({ page }) => {
    await page.goto('http://localhost:5173/krs');

    // Select conflicting classes
    await page.click('[data-testid="mk-card-1"] button'); // Senin 08:00
    await page.click('[data-testid="mk-card-2"] button'); // Senin 08:00 (bentrok)

    await page.click('button:has-text("Validasi KRS")');

    // Should show error
    await expect(page.locator('text=Jadwal bentrok')).toBeVisible();
  });
});
```

---

## 12. Deployment Guide

### 12.1 Environment Variables

```bash
# .env.production

# Application
NODE_ENV=production
PORT=3000
BASE_URL=https://api.portal-akademik.ac.id

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/portal_akademik?schema=public

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password

# JWT
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# SMTP Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=noreply@university.ac.id
SMTP_PASS=your_smtp_password
SMTP_FROM=Portal Akademik <noreply@university.ac.id>

# File Storage
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=5242880

# Sentry (Error Tracking)
SENTRY_DSN=https://your-sentry-dsn

# CORS
ALLOWED_ORIGINS=https://portal-akademik.ac.id,https://www.portal-akademik.ac.id
```

### 12.2 Docker Configuration

```dockerfile
# Dockerfile

FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# Build TypeScript
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Copy built files
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/package*.json ./

# Create uploads directory
RUN mkdir -p uploads

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD node healthcheck.js

# Start application
CMD ["npm", "start"]
```

```yaml
# docker-compose.yml

version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: portal_akademik_db
    environment:
      POSTGRES_USER: portal_user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: portal_akademik
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - portal_network

  redis:
    image: redis:7-alpine
    container_name: portal_akademik_redis
    command: redis-server --requirepass ${REDIS_PASSWORD}
    ports:
      - "6379:6379"
    networks:
      - portal_network

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: portal_akademik_backend
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://portal_user:${DB_PASSWORD}@postgres:5432/portal_akademik
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - REDIS_PASSWORD=${REDIS_PASSWORD}
    ports:
      - "3000:3000"
    depends_on:
      - postgres
      - redis
    volumes:
      - ./uploads:/app/uploads
    networks:
      - portal_network

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: portal_akademik_frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - portal_network

volumes:
  postgres_data:

networks:
  portal_network:
    driver: bridge
```

### 12.3 CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/deploy.yml

name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Run linter
        run: npm run lint

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Docker image
        run: docker build -t portal-akademik-backend ./backend
      
      - name: Push to Docker Registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker tag portal-akademik-backend ${{ secrets.DOCKER_REGISTRY }}/portal-akademik-backend:latest
          docker push ${{ secrets.DOCKER_REGISTRY }}/portal-akademik-backend:latest

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /var/www/portal-akademik
            docker-compose pull
            docker-compose up -d
            docker-compose exec backend npx prisma migrate deploy
```

### 12.4 Nginx Configuration

```nginx
# /etc/nginx/sites-available/portal-akademik

upstream backend {
    server localhost:3000;
}

server {
    listen 80;
    listen [::]:80;
    server_name portal-akademik.ac.id www.portal-akademik.ac.id;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name portal-akademik.ac.id www.portal-akademik.ac.id;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/portal-akademik.ac.id/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/portal-akademik.ac.id/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # API Proxy
    location /api {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Static files
    location /uploads {
        alias /var/www/portal-akademik/uploads;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Frontend
    location / {
        root /var/www/portal-akademik/frontend/dist;
        try_files $uri $uri/ /index.html;
    }

    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;

    # Rate Limiting
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
    limit_req zone=api_limit burst=20 nodelay;

    # Logs
    access_log /var/log/nginx/portal-akademik-access.log;
    error_log /var/log/nginx/portal-akademik-error.log;
}
```

### 12.5 Database Backup Strategy

```bash
#!/bin/bash
# scripts/backup-database.sh

# Configuration
DB_NAME="portal_akademik"
DB_USER="portal_user"
BACKUP_DIR="/var/backups/postgresql"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"
RETENTION_DAYS=30

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

# Perform backup
echo "Starting database backup..."
pg_dump -U $DB_USER -h localhost $DB_NAME | gzip > $BACKUP_FILE

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
    
    # Remove old backups
    find $BACKUP_DIR -name "${DB_NAME}_*.sql.gz" -mtime +$RETENTION_DAYS -delete
    echo "Old backups cleaned up (older than $RETENTION_DAYS days)"
else
    echo "Backup failed!"
    exit 1
fi

# Upload to S3 (optional)
# aws s3 cp $BACKUP_FILE s3://your-bucket/backups/
```

```bash
# Add to crontab for daily backup at 2 AM
# crontab -e
0 2 * * * /var/www/portal-akademik/scripts/backup-database.sh
```

---

## 13. Development Workflow

### 13.1 Git Workflow

```bash
# Branch naming conventions
feature/nama-fitur      # New feature
bugfix/nama-bug         # Bug fix
hotfix/critical-bug     # Critical production bug
refactor/nama-refactor  # Code refactoring
docs/update-readme      # Documentation

# Example workflow
git checkout -b feature/krs-validation
# ... make changes ...
git add .
git commit -m "feat: add KRS validation logic"
git push origin feature/krs-validation
# Create Pull Request on GitHub
```

### 13.2 Commit Message Convention

```bash
# Format: <type>(<scope>): <subject>

# Types:
feat:     # New feature
fix:      # Bug fix
docs:     # Documentation only
style:    # Code style (formatting, semicolons, etc)
refactor: # Code refactoring
test:     # Adding tests
chore:    # Maintenance tasks

# Examples:
feat(krs): add prasyarat validation
fix(nilai): correct IP calculation formula
docs(api): update authentication endpoints
refactor(auth): simplify token refresh logic
test(krs): add unit tests for validation service
chore(deps): update prisma to v5.8.0
```

### 13.3 Code Review Checklist

```markdown
## Code Review Checklist

### Functionality
- [ ] Code meets the requirements
- [ ] Edge cases are handled
- [ ] Error handling is implemented
- [ ] No hardcoded values

### Code Quality
- [ ] Code follows project conventions
- [ ] No code duplication
- [ ] Functions are small and focused
- [ ] Meaningful variable/function names
- [ ] No commented-out code

### Security
- [ ] No SQL injection vulnerabilities
- [ ] Input validation is implemented
- [ ] Sensitive data is not logged
- [ ] Authentication/authorization checks are in place

### Testing
- [ ] Unit tests are added/updated
- [ ] Integration tests pass
- [ ] Manual testing performed

### Documentation
- [ ] Code comments for complex logic
- [ ] API documentation updated
- [ ] README updated if needed
```

### 13.4 Local Development Setup

```bash
# 1. Clone repository
git clone https://github.com/university/portal-akademik.git
cd portal-akademik

# 2. Install dependencies - Backend
cd backend
npm install

# 3. Setup environment variables
cp .env.example .env
# Edit .env with your local configuration

# 4. Setup database
docker-compose up -d postgres redis
npx prisma migrate dev
npx prisma db seed

# 5. Start backend
npm run dev

# 6. Install dependencies - Frontend
cd ../frontend
npm install

# 7. Start frontend
npm run dev

# Access application:
# Frontend: http://localhost:5173
# Backend: http://localhost:3000
# API Docs: http://localhost:3000/api-docs
```

### 13.5 Database Migration Workflow

```bash
# Create new migration
npx prisma migrate dev --name add_presensi_table

# Apply migrations to production
npx prisma migrate deploy

# Reset database (development only)
npx prisma migrate reset

# Generate Prisma Client after schema changes
npx prisma generate

# View current migration status
npx prisma migrate status

# Resolve migration issues
npx prisma migrate resolve --rolled-back "20240101000000_migration_name"
```

---

## 14. Troubleshooting

### 14.1 Common Issues & Solutions

#### Issue 1: Database Connection Error

**Error:**
```
Error: Can't reach database server at `localhost:5432`
```

**Solution:**
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start PostgreSQL
sudo systemctl start postgresql

# Check connection
psql -U portal_user -d portal_akademik -h localhost

# Verify DATABASE_URL in .env
DATABASE_URL="postgresql://user:password@localhost:5432/portal_akademik"
```

#### Issue 2: JWT Token Expired

**Error:**
```json
{
  "error": {
    "code": "TOKEN_EXPIRED",
    "message": "Token sudah expired"
  }
}
```

**Solution:**
```typescript
// Frontend: Implement automatic token refresh
import axios from 'axios';

const api = axios.create({
  baseURL: process.env.VITE_API_URL
});

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = localStorage.getItem('refreshToken');
        const { data } = await axios.post('/api/v1/auth/refresh-token', {
          refreshToken
        });

        localStorage.setItem('accessToken', data.data.accessToken);
        originalRequest.headers['Authorization'] = `Bearer ${data.data.accessToken}`;

        return api(originalRequest);
      } catch (refreshError) {
        // Redirect to login
        window.location.href = '/login';
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);
```

#### Issue 3: File Upload Fails

**Error:**
```
Error: File too large
```

**Solution:**
```typescript
// Backend: Increase max file size in multer config
export const uploadImage = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB
  }
});

// Also check nginx configuration
client_max_body_size 10M;
```

#### Issue 4: CORS Error

**Error:**
```
Access to XMLHttpRequest has been blocked by CORS policy
```

**Solution:**
```typescript
// Backend: Update CORS configuration
import cors from 'cors';

app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:5173',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
```

#### Issue 5: Prisma Migration Failed

**Error:**
```
Error: Migration failed to apply cleanly to a temporary database
```

**Solution:**
```bash
# 1. Mark migration as rolled back
npx prisma migrate resolve --rolled-back "20240101000000_migration_name"

# 2. Fix the migration SQL
# Edit the migration file in prisma/migrations/

# 3. Apply migration again
npx prisma migrate deploy

# If all else fails (development only):
npx prisma migrate reset
```

### 14.2 Performance Optimization Tips

#### Database Query Optimization

```typescript
// ❌ BAD: N+1 Query Problem
const mahasiswa = await prisma.mahasiswa.findMany();
for (const m of mahasiswa) {
  const krs = await prisma.krs.findMany({
    where: { mahasiswaId: m.id }
  });
}

// ✅ GOOD: Use include to fetch related data
const mahasiswa = await prisma.mahasiswa.findMany({
  include: {
    krs: {
      include: {
        kelas: {
          include: {
            mataKuliah: true
          }
        }
      }
    }
  }
});
```

#### Redis Caching

```typescript
// services/cache.service.ts

export class CacheService {
  private redis: Redis;
  private DEFAULT_TTL = 3600; // 1 hour

  constructor() {
    this.redis = new Redis({
      host: process.env.REDIS_HOST,
      port: parseInt(process.env.REDIS_PORT || '6379'),
      password: process.env.REDIS_PASSWORD
    });
  }

  async get<T>(key: string): Promise<T | null> {
    const cached = await this.redis.get(key);
    return cached ? JSON.parse(cached) : null;
  }

  async set(key: string, value: any, ttl: number = this.DEFAULT_TTL): Promise<void> {
    await this.redis.setex(key, ttl, JSON.stringify(value));
  }

  async delete(key: string): Promise<void> {
    await this.redis.del(key);
  }

  async deletePattern(pattern: string): Promise<void> {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(...keys);
    }
  }
}

// Usage in service
async getMahasiswaById(id: number) {
  const cacheKey = `mahasiswa:${id}`;
  
  // Try cache first
  const cached = await cacheService.get(cacheKey);
  if (cached) return cached;

  // Fetch from database
  const mahasiswa = await prisma.mahasiswa.findUnique({
    where: { id },
    include: { user: true, programStudi: true }
  });

  // Store in cache
  await cacheService.set(cacheKey, mahasiswa);

  return mahasiswa;
}
```

#### Database Indexing

```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_krs_mahasiswa_periode ON krs(mahasiswa_id, periode_akademik_id);
CREATE INDEX idx_nilai_mahasiswa ON nilai(mahasiswa_id);
CREATE INDEX idx_pembayaran_status ON pembayaran(status) WHERE status IN ('pending', 'overdue');

-- Partial index for active records
CREATE INDEX idx_mahasiswa_active ON mahasiswa(id) WHERE status = 'aktif';

-- Composite index for common queries
CREATE INDEX idx_kelas_periode_mk ON kelas(periode_akademik_id, mata_kuliah_id);
```

### 14.3 Monitoring & Logging

#### Winston Logger Configuration

```typescript
// config/logger.config.ts

import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'portal-akademik' },
  transports: [
    // Write all logs to console
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    }),
    // Write all logs error (and below) to error.log
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error'
    }),
    // Write all logs to combined.log
    new winston.transports.File({
      filename: 'logs/combined.log'
    })
  ]
});

// In production, log to external service
if (process.env.NODE_ENV === 'production') {
  logger.add(new winston.transports.Http({
    host: process.env.LOG_HOST,
    port: process.env.LOG_PORT,
    path: '/logs'
  }));
}

export default logger;
```

#### Request Logging Middleware

```typescript
// middleware/logging.middleware.ts

import logger from '../config/logger.config';

export const requestLogger = (req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    
    logger.info({
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration: `${duration}ms`,
      ip: req.ip,
      userAgent: req.get('user-agent'),
      userId: req.user?.id
    });
  });

  next();
};
```

#### Error Tracking with Sentry

```typescript
// config/sentry.config.ts

import * as Sentry from '@sentry/node';

export const initSentry = (app: Express) => {
  if (process.env.SENTRY_DSN) {
    Sentry.init({
      dsn: process.env.SENTRY_DSN,
      environment: process.env.NODE_ENV,
      tracesSampleRate: 1.0
    });

    app.use(Sentry.Handlers.requestHandler());
    app.use(Sentry.Handlers.tracingHandler());

    // Add after all routes
    app.use(Sentry.Handlers.errorHandler());
  }
};
```

### 14.4 Health Check Endpoint

```typescript
// routes/health.routes.ts

import { Router } from 'express';
import { prisma } from '../lib/prisma';
import redis from '../lib/redis';

const router = Router();

router.get('/health', async (req, res) => {
  const health = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    services: {
      database: 'unknown',
      redis: 'unknown'
    }
  };

  // Check database
  try {
    await prisma.$queryRaw`SELECT 1`;
    health.services.database = 'ok';
  } catch (error) {
    health.services.database = 'error';
    health.status = 'degraded';
  }

  // Check Redis
  try {
    await redis.ping();
    health.services.redis = 'ok';
  } catch (error) {
    health.services.redis = 'error';
    health.status = 'degraded';
  }

  const statusCode = health.status === 'ok' ? 200 : 503;
  res.status(statusCode).json(health);
});

export default router;
```

---

## 15. API Error Codes Reference

### Complete Error Code List

| Code | HTTP Status | Description | Solution |
|------|-------------|-------------|----------|
| **AUTH001** | 401 | Invalid credentials | Check email and password |
| **AUTH002** | 401 | Token expired | Refresh token or login again |
| **AUTH003** | 401 | Invalid token | Login again |
| **AUTH004** | 403 | Email not verified | Check email for verification link |
| **AUTH005** | 403 | Account inactive | Contact admin |
| **KRS001** | 422 | Kuota kelas penuh | Choose different class |
| **KRS002** | 422 | Jadwal bentrok | Check schedule conflicts |
| **KRS003** | 422 | Prasyarat tidak terpenuhi | Complete prerequisite courses |
| **KRS004** | 422 | Melebihi batas SKS | Reduce number of credits |
| **KRS005** | 422 | Periode KRS belum dibuka | Wait for KRS period |
| **KRS006** | 422 | Periode KRS sudah ditutup | Contact academic admin |
| **PAY001** | 422 | Pembayaran belum lunas | Complete payment first |
| **PAY002** | 404 | Tagihan tidak ditemukan | Contact finance admin |
| **STUDENT001** | 422 | Status mahasiswa tidak aktif | Contact academic admin |
| **VALIDATION_ERROR** | 400 | Data tidak valid | Check input fields |
| **NOT_FOUND** | 404 | Resource tidak ditemukan | Check resource ID |
| **FORBIDDEN** | 403 | Akses ditolak | Check user permissions |
| **RATE_LIMIT** | 429 | Too many requests | Wait and try again |

---

## 16. Frontend Component Examples

### 16.1 KRS Component (Complete Example)

```typescript
// features/krs/components/KRSForm.tsx

import React, { useState, useEffect } from 'react';
import { useQuery, useMutation } from '@tanstack/react-query';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { MataKuliahCard } from './MataKuliahCard';
import { KRSValidation } from './KRSValidation';
import { krsApi } from '../services/krsApi';
import { useToast } from '@/hooks/useToast';

export const KRSForm: React.FC = () => {
  const { toast } = useToast();
  const [selectedKelas, setSelectedKelas] = useState<number[]>([]);
  const [showValidation, setShowValidation] = useState(false);

  // Fetch available mata kuliah
  const { data: mataKuliahList, isLoading } = useQuery({
    queryKey: ['mata-kuliah'],
    queryFn: () => krsApi.getAvailableMataKuliah()
  });

  // Validate KRS mutation
  const validateMutation = useMutation({
    mutationFn: (kelasIds: number[]) => krsApi.validateKRS(kelasIds),
    onSuccess: (data) => {
      if (data.data.isValid) {
        toast({
          title: 'Validasi Berhasil',
          description: 'KRS Anda valid dan siap disubmit',
          variant: 'success'
        });
        setShowValidation(true);
      } else {
        toast({
          title: 'Validasi Gagal',
          description: 'Ada kesalahan dalam pemilihan KRS Anda',
          variant: 'error'
        });
      }
    }
  });

  // Submit KRS mutation
  const submitMutation = useMutation({
    mutationFn: (kelasIds: number[]) => krsApi.submitKRS(kelasIds),
    onSuccess: () => {
      toast({
        title: 'KRS Berhasil Disubmit',
        description: 'Menunggu approval dosen wali',
        variant: 'success'
      });
      setSelectedKelas([]);
      setShowValidation(false);
    }
  });

  const handleSelectKelas = (kelasId: number) => {
    setSelectedKelas(prev => 
      prev.includes(kelasId) 
        ? prev.filter(id => id !== kelasId)
        : [...prev, kelasId]
    );
  };

  const handleValidate = () => {
    validateMutation.mutate(selectedKelas);
  };

  const handleSubmit = () => {
    submitMutation.mutate(selectedKelas);
  };

  const totalSks = mataKuliahList?.data
    .filter(mk => selectedKelas.some(kelasId => 
      mk.kelas.some(k => k.id === kelasId)
    ))
    .reduce((sum, mk) => sum + mk.sks, 0) || 0;

  if (isLoading) {
    return <div>Loading...</div>;
  }

  return (
    <div className="space-y-6">
      {/* Summary Card */}
      <Card>
        <CardHeader>
          <CardTitle>Ringkasan KRS</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex justify-between items-center">
            <div>
              <p className="text-sm text-muted-foreground">Total Mata Kuliah</p>
              <p className="text-2xl font-bold">{selectedKelas.length}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Total SKS</p>
              <p className="text-2xl font-bold">{totalSks}</p>
            </div>
            <div>
              <Badge variant={totalSks <= 24 ? 'default' : 'destructive'}>
                Max: 24 SKS
              </Badge>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Mata Kuliah List */}
      <div className="grid gap-4 md:grid-cols-2">
        {mataKuliahList?.data.map(mk => (
          <MataKuliahCard
            key={mk.id}
            mataKuliah={mk}
            selectedKelasIds={selectedKelas}
            onSelectKelas={handleSelectKelas}
          />
        ))}
      </div>

      {/* Validation Result */}
      {showValidation && validateMutation.data && (
        <KRSValidation
          validationResult={validateMutation.data.data}
        />
      )}

      {/* Action Buttons */}
      <div className="flex gap-4 justify-end">
        <Button
          variant="outline"
          onClick={() => setSelectedKelas([])}
          disabled={selectedKelas.length === 0}
        >
          Reset
        </Button>
        <Button
          onClick={handleValidate}
          disabled={selectedKelas.length === 0 || validateMutation.isPending}
        >
          {validateMutation.isPending ? 'Validating...' : 'Validasi KRS'}
        </Button>
        <Button
          onClick={handleSubmit}
          disabled={!showValidation || !validateMutation.data?.data.isValid || submitMutation.isPending}
        >
          {submitMutation.isPending ? 'Submitting...' : 'Submit KRS'}
        </Button>
      </div>
    </div>
  );
};
```

---

## 17. Best Practices Summary

### Code Quality
- ✅ Use TypeScript for type safety
- ✅ Follow consistent naming conventions
- ✅ Write self-documenting code
- ✅ Keep functions small and focused
- ✅ Use async/await instead of callbacks
- ✅ Handle errors properly

### Security
- ✅ Never commit secrets to git
- ✅ Validate all user inputs
- ✅ Use parameterized queries
- ✅ Implement rate limiting
- ✅ Use HTTPS in production
- ✅ Keep dependencies updated

### Performance
- ✅ Use database indexes
- ✅ Implement caching (Redis)
- ✅ Optimize database queries
- ✅ Use pagination for large datasets
- ✅ Compress responses (gzip)
- ✅ Lazy load components

### Testing
- ✅ Write unit tests for business logic
- ✅ Write integration tests for APIs
- ✅ Test edge cases
- ✅ Aim for >80% code coverage
- ✅ Use E2E tests for critical flows

### Documentation
- ✅ Keep README updated
- ✅ Document API endpoints
- ✅ Write inline comments for complex logic
- ✅ Use JSDoc for functions
- ✅ Maintain changelog

---

## 18. Resources & References

### Official Documentation
- [React Documentation](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Node.js Documentation](https://nodejs.org/docs/)
- [Prisma Documentation](https://www.prisma.io/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

### Learning Resources
- [System Design Primer](https://github.com/donnemartin/system-design-primer)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [REST API Design](https://restfulapi.net/)
- [Database Optimization](https://use-the-index-luke.com/)

### Tools
- [Postman](https://www.postman.com/) - API Testing
- [DBeaver](https://dbeaver.io/) - Database Management
- [VS Code](https://code.visualstudio.com/) - Code Editor
- [GitHub](https://github.com/) - Version Control

---

## 19. Changelog

### Version 1.0.0 (2024-11-11)
- ✨ Initial release
- ✨ Complete authentication system
- ✨ KRS management
- ✨ Nilai management
- ✨ Pembayaran system
- ✨ Admin dashboard
- ✨ Notification system
- ✨ PDF generation
- ✨ File upload system

---

## 20. Contributors & Support

### Development Team
- **Backend Lead**: [Name]
- **Frontend Lead**: [Name]
- **Database Admin**: [Name]
- **DevOps**: [Name]

### Support
- **Email**: support@university.ac.id
- **Documentation**: https://docs.portal-akademik.ac.id
- **Issue Tracker**: https://github.com/university/portal-akademik/issues

---

**© 2024 Portal Akademik - Universitas. All rights reserved.**