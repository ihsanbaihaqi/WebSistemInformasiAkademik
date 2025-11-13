# Tahap 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Salin file package dan instal dependensi
COPY package*.json ./
RUN npm install

# Salin kode sumber
COPY . .

# Build aplikasi
RUN npm run build

# Tahap 2: Produksi
FROM nginx:stable-alpine

# Salin file build dari tahap builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Salin file konfigurasi Nginx kustom
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Jalankan Nginx
CMD ["nginx", "-g", "daemon off;"]
