
import { PrismaClient, UserRole } from '../src/generated/prisma';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('Start seeding ...');

  const saltRounds = 10;
  const password = await bcrypt.hash('password123', saltRounds);

  // Create Users
  const adminUser = await prisma.user.create({
    data: {
      email: 'admin@university.ac.id',
      password: password,
      role: UserRole.ADMIN,
    },
  });

  const dosenUser1 = await prisma.user.create({
    data: {
      email: 'ahmad.dosen@university.ac.id',
      password: password,
      role: UserRole.DOSEN,
    },
  });

    const dosenUser2 = await prisma.user.create({
    data: {
      email: 'siti.dosen@university.ac.id',
      password: password,
      role: UserRole.DOSEN,
    },
  });

  const mahasiswaUser1 = await prisma.user.create({
    data: {
      email: 'john.doe@student.university.ac.id',
      password: password,
      role: UserRole.MAHASISWA,
    },
  });

    const mahasiswaUser2 = await prisma.user.create({
    data: {
      email: 'jane.smith@student.university.ac.id',
      password: password,
      role: UserRole.MAHASISWA,
    },
  });

  // Create Fakultas
  const fti = await prisma.fakultas.create({
    data: {
      nama: 'Fakultas Teknologi Informasi',
    },
  });

  const feb = await prisma.fakultas.create({
    data: {
        nama: 'Fakultas Ekonomi dan Bisnis'
    },
  });

    const fk = await prisma.fakultas.create({
    data: {
        nama: 'Fakultas Kedokteran'
    },
  });

  // Create ProgramStudi
  const ifps = await prisma.programStudi.create({
    data: {
      nama: 'Teknik Informatika',
      fakultasId: fti.id,
    },
  });

    const sips = await prisma.programStudi.create({
    data: {
      nama: 'Sistem Informasi',
      fakultasId: fti.id,
    },
  });

  // Create Dosen
  const dosen1 = await prisma.dosen.create({
    data: {
      userId: dosenUser1.id,
      nidn: '0812345678',
      nama: 'Dr. Ahmad Hidayat, M.Kom',
      programStudiId: ifps.id,
    },
  });

    const dosen2 = await prisma.dosen.create({
    data: {
      userId: dosenUser2.id,
      nidn: '0823456789',
      nama: 'Dr. Siti Nurhaliza, M.T',
      programStudiId: sips.id,
    },
  });

  // Create Mahasiswa
  await prisma.mahasiswa.create({
    data: {
      userId: mahasiswaUser1.id,
      nim: '2024001',
      nama: 'John Doe',
      angkatan: 2024,
      programStudiId: ifps.id,
      dosenWaliId: dosen1.id,
    },
  });

    await prisma.mahasiswa.create({
    data: {
      userId: mahasiswaUser2.id,
      nim: '2024002',
      nama: 'Jane Smith',
      angkatan: 2024,
      programStudiId: sips.id,
      dosenWaliId: dosen2.id,
    },
  });

  // Create MataKuliah
  const mk1 = await prisma.mataKuliah.create({
    data: {
        kode: 'IF101',
        nama: 'Pengantar Teknologi Informasi',
        sks: 3,
        programStudiId: ifps.id
    },
  });

  const mk2 = await prisma.mataKuliah.create({
    data: {
        kode: 'IF102',
        nama: 'Algoritma dan Pemrograman',
        sks: 4,
        programStudiId: ifps.id
    },
  });

    const mk3 = await prisma.mataKuliah.create({
    data: {
        kode: 'SI101',
        nama: 'Pengantar Sistem Informasi',
        sks: 3,
        programStudiId: sips.id
    },
  });

  // Create Kelas
  await prisma.kelas.create({
    data: {
        mataKuliahId: mk1.id,
        dosenId: dosen1.id,
        nama: 'A',
        ruangan: 'Lab 1',
        jadwal: 'Senin 08:00-10:30',
        kapasitas: 40
    },
  });

    await prisma.kelas.create({
    data: {
        mataKuliahId: mk2.id,
        dosenId: dosen1.id,
        nama: 'A',
        ruangan: 'Lab 2',
        jadwal: 'Selasa 13:00-15:30',
        kapasitas: 35
    },
  });

    await prisma.kelas.create({
    data: {
        mataKuliahId: mk3.id,
        dosenId: dosen2.id,
        nama: 'B',
        ruangan: 'Ruang 201',
        jadwal: 'Rabu 10:00-12:30',
        kapasitas: 40
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
