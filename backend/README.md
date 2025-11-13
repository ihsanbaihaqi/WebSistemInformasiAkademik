# Backend

Dokumentasi untuk aplikasi backend Portal Akademik.

## Variabel Lingkungan

Variabel lingkungan berikut diperlukan untuk menjalankan aplikasi. Salin file `.env.example` ke `.env` dan isi nilainya.

| Variabel                  | Deskripsi                                                                 | Contoh                                                               |
| ------------------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `NODE_ENV`                | Lingkungan aplikasi (misalnya, `development`, `production`).                | `development`                                                        |
| `PORT`                    | Port tempat server akan berjalan.                                          | `3000`                                                                       |
| `BASE_URL`                | URL dasar aplikasi.                                                     | `http://localhost:3000`                                              |
| `DATABASE_URL`            | URL koneksi untuk database PostgreSQL.                                    | `postgresql://user:password@localhost:5433/portal_akademik`          |
| `REDIS_HOST`              | Hostname dari server Redis.                                               | `localhost`                                                          |
| `REDIS_PORT`              | Port dari server Redis.                                                   | `6379`                                                               |
| `REDIS_PASSWORD`          | Kata sandi untuk server Redis.                                              | `your_redis_password`                                                |
| `JWT_SECRET`              | Kunci rahasia untuk menandatangani token JWT.                                      | `your_super_secret_jwt_key_change_this`                              |
| `JWT_EXPIRES_IN`          | Waktu kedaluwarsa untuk token akses JWT.                                       | `15m`                                                                |
| `JWT_REFRESH_EXPIRES_IN`  | Waktu kedaluwarsa untuk token penyegaran JWT.                                | `7d`                                                                 |
| `SMTP_HOST`               | Hostname dari server SMTP untuk mengirim email.                             | `smtp.gmail.com`                                                     |
| `SMTP_PORT`               | Port dari server SMTP.                                                    | `587`                                                                |
| `SMTP_USER`               | Nama pengguna untuk server SMTP.                                                | `your-email@gmail.com`                                               |
| `SMTP_PASS`               | Kata sandi untuk server SMTP.                                               | `your-app-password`                                                  |
| `SMTP_FROM`               | Alamat email "dari" yang digunakan saat mengirim email.                         | `"Portal Akademik <noreply@university.ac.id>"`                       |
