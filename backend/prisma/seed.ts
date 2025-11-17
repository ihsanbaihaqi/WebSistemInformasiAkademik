// prisma/seed.ts

import { PrismaClient } from '../src/generated/prisma';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
    console.log('Start seeding...');

    // Hash a password for all users
    const password = await bcrypt.hash('password123', 10);

    // Create Admin User
    const admin = await prisma.user.create({
        data: {
            email: 'admin@example.com',
            password: password,
            role: 'ADMIN',
        },
    });

    // Create Fakultas
    const fst = await prisma.fakultas.create({
        data: {
            nama: 'Sains dan Teknologi',
        },
    });

    // Create Program Studi
    const si = await prisma.programStudi.create({
        data: {
            nama: 'Sistem Informasi',
            fakultasId: fst.id,
        },
    });

    // Create Dosen
    const dosenUser = await prisma.user.create({
        data: {
            email: 'dosen@example.com',
            password: password,
            role: 'DOSEN',
        },
    });
    const dosen = await prisma.dosen.create({
        data: {
            userId: dosenUser.id,
            nidn: '1234567890',
            nama: 'Dr. Budi Santoso',
            programStudiId: si.id,
        },
    });

    // Create Mahasiswa
    const mahasiswaUser = await prisma.user.create({
        data: {
            email: 'mahasiswa@example.com',
            password: password,
            role: 'MAHASISWA',
        },
    });
    const mahasiswa = await prisma.mahasiswa.create({
        data: {
            userId: mahasiswaUser.id,
            nim: '1122334455',
            nama: 'Ani Yudhoyono',
            angkatan: 2022,
            programStudiId: si.id,
            dosenWaliId: dosen.id,
        },
    });

    // Create Mata Kuliah
    const mk1 = await prisma.mataKuliah.create({
        data: {
            kode: 'SI101',
            nama: 'Dasar-Dasar Pemrograman',
            sks: 3,
            programStudiId: si.id,
        },
    });
    const mk2 = await prisma.mataKuliah.create({
        data: {
            kode: 'SI102',
            nama: 'Struktur Data',
            sks: 3,
            programStudiId: si.id,
        },
    });

    console.log('Seeding finished.');
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
