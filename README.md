# Portal Akademik

## Variabel Lingkungan

### Backend

| Variabel | Deskripsi | Contoh |
| --- | --- | --- |
| `NODE_ENV` | Lingkungan aplikasi | `development` |
| `PORT` | Port server | `3000` |
| `BASE_URL` | URL dasar aplikasi | `http://localhost:3000` |
| `DATABASE_URL` | URL koneksi database | `postgresql://user:password@localhost:5432/portal_akademik` |
| `REDIS_HOST` | Host Redis | `localhost` |
| `REDIS_PORT` | Port Redis | `6379` |
| `REDIS_PASSWORD` | Kata sandi Redis | `your_redis_password` |
| `JWT_SECRET` | Kunci rahasia JWT | `your_super_secret_jwt_key_change_this` |
| `JWT_EXPIRES_IN` | Waktu kedaluwarsa token JWT | `15m` |
| `JWT_REFRESH_EXPIRES_IN` | Waktu kedaluwarsa token refresh JWT | `7d` |
| `SMTP_HOST` | Host SMTP | `smtp.gmail.com` |
| `SMTP_PORT` | Port SMTP | `587` |
| `SMTP_USER` | Pengguna SMTP | `your-email@gmail.com` |
| `SMTP_PASS` | Kata sandi SMTP | `your-app-password` |
| `SMTP_FROM` | Alamat email pengirim | `"Portal Akademik <noreply@university.ac.id>"` |

### Frontend

| Variabel | Deskripsi | Contoh |
| --- | --- | --- |
| `VITE_API_URL` | URL API backend | `http://localhost:3000/api/v1` |
| `VITE_APP_NAME` | Nama aplikasi | `"Portal Akademik"` |
