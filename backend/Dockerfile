# Tahap 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Salin file package dan instal dependensi
COPY package*.json ./
RUN npm install

# Salin file prisma
COPY prisma ./prisma/

# Salin kode sumber
COPY . .

# Hasilkan klien Prisma
RUN npx prisma generate

# Kompilasi TypeScript
RUN npm run build

# Tahap 2: Produksi
FROM node:20-alpine

WORKDIR /app

# Salin file package dan instal hanya dependensi produksi
COPY package*.json ./
RUN npm install --only=production

# Salin artefak build dari tahap builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src/generated ./src/generated

# Salin file .env.example (opsional, untuk referensi)
COPY .env.example .

# Expose port
EXPOSE 3000

# Jalankan aplikasi
CMD ["node", "dist/app.js"]
