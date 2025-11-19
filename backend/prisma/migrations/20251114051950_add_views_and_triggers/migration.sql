-- View: Mahasiswa dengan detail lengkap
CREATE OR REPLACE VIEW v_mahasiswa_detail AS
SELECT
    m.id,
    m.nim,
    m.nama as nama_lengkap,
    u.email,
    ' ' AS no_hp, -- Placeholder, as it does not exist in the User table
    ps.nama as program_studi,
    'S1' AS jenjang, -- Placeholder, as it does not exist in the ProgramStudi table
    f.nama as fakultas,
    m.angkatan,
    1 AS semester_aktif, -- Placeholder, logic to be implemented in application layer
    'aktif' AS status, -- Placeholder, logic to be implemented in application layer
    0.00 AS ipk, -- Placeholder, logic to be implemented in application layer
    0 AS total_sks, -- Placeholder, logic to be implemented in application layer
    d.nama as dosen_wali,
    m."createdAt"
FROM "Mahasiswa" m
JOIN "User" u ON u.id = m."userId"
JOIN "ProgramStudi" ps ON ps.id = m."programStudiId"
JOIN "Fakultas" f ON f.id = ps."fakultasId"
LEFT JOIN "Dosen" d ON d.id = m."dosenWaliId";

-- View: KRS dengan detail mata kuliah
CREATE OR REPLACE VIEW v_krs_detail AS
SELECT
    k.id as krs_id,
    m.nim,
    m.nama as nama_mahasiswa,
    '2024/2025' AS tahun_ajaran, -- Placeholder, to be sourced from a new 'PeriodeAkademik' table
    'Ganjil' AS semester, -- Placeholder, to be sourced from a new 'PeriodeAkademik' table
    mk.kode as kode_mk,
    mk.nama as nama_mk,
    mk.sks,
    kl.nama as kode_kelas,
    d.nidn,
    d.nama as nama_dosen,
    kl.jadwal AS hari, -- This is a string, assuming format is 'Day HH:MM-HH:MM'
    kl.jadwal AS jam_mulai, -- Placeholder, parsing needed
    kl.jadwal AS jam_selesai, -- Placeholder, parsing needed
    kl.ruangan,
    k.status::text,
    k."createdAt" AS tanggal_pengisian
FROM "KRS" k
JOIN "Mahasiswa" m ON m.id = k."mahasiswaId"
JOIN "Kelas" kl ON kl.id = k."kelasId"
JOIN "MataKuliah" mk ON mk.id = kl."mataKuliahId"
LEFT JOIN "Dosen" d ON d.id = kl."dosenId";

-- View: Nilai dengan detail lengkap (untuk KHS)
CREATE OR REPLACE VIEW v_nilai_khs AS
SELECT
    n.id,
    m.nim,
    m.nama as nama_mahasiswa,
    '2024/2025' AS tahun_ajaran, -- Placeholder, to be sourced from a new 'PeriodeAkademik' table
    'Ganjil' AS semester, -- Placeholder, to be sourced from a new 'PeriodeAkademik' table
    mk.kode as kode_mk,
    mk.nama as nama_mk,
    mk.sks,
    0.0 AS nilai_tugas, -- Placeholder, as it does not exist in the Nilai table
    0.0 AS nilai_uts, -- Placeholder, as it does not exist in the Nilai table
    0.0 AS nilai_uas, -- Placeholder, as it does not exist in the Nilai table
    n."nilaiAngka" as nilai_akhir,
    n."nilaiHuruf" as huruf_mutu,
    n.bobot as angka_mutu,
    (n.bobot * mk.sks) as mutu,
    true AS is_published -- Placeholder, logic to be implemented in application layer
FROM "Nilai" n
JOIN "KRS" k ON k.id = n."krsId"
JOIN "Mahasiswa" m ON m.id = k."mahasiswaId"
JOIN "Kelas" kl ON kl.id = k."kelasId"
JOIN "MataKuliah" mk ON mk.id = kl."mataKuliahId"
WHERE k.status = 'APPROVED';

-- Function: Auto update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS '
BEGIN
    NEW."updatedAt" = NOW();
    RETURN NEW;
END;
' LANGUAGE plpgsql;

-- Apply trigger to tables with updatedAt
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON "User"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mahasiswa_updated_at
    BEFORE UPDATE ON "Mahasiswa"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dosen_updated_at
    BEFORE UPDATE ON "Dosen"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_kelas_updated_at
    BEFORE UPDATE ON "Kelas"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_krs_updated_at
    BEFORE UPDATE ON "KRS"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_nilai_updated_at
    BEFORE UPDATE ON "Nilai"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function: Auto increment kelas.terisi saat KRS approved
CREATE OR REPLACE FUNCTION increment_kelas_terisi()
RETURNS TRIGGER AS '
BEGIN
    IF NEW.status = ''APPROVED'' AND (OLD.status IS NULL OR OLD.status != ''APPROVED'') THEN
        UPDATE "Kelas"
        SET terisi = terisi + 1
        WHERE id = NEW."kelasId";
    END IF;
    RETURN NEW;
END;
' LANGUAGE plpgsql;

CREATE TRIGGER after_krs_approved
AFTER INSERT OR UPDATE OF status ON "KRS"
FOR EACH ROW
EXECUTE FUNCTION increment_kelas_terisi();

-- Function: Auto decrement kelas.terisi saat KRS cancelled/rejected/deleted
CREATE OR REPLACE FUNCTION decrement_kelas_terisi()
RETURNS TRIGGER AS '
BEGIN
    -- Saat update status dari approved ke non-approved
    IF TG_OP = ''UPDATE'' THEN
        IF OLD.status = ''APPROVED'' AND NEW.status != ''APPROVED'' THEN
            UPDATE "Kelas"
            SET terisi = terisi - 1
            WHERE id = OLD."kelasId";
        END IF;
    END IF;

    -- Saat hard delete
    IF TG_OP = ''DELETE'' AND OLD.status = ''APPROVED'' THEN
        UPDATE "Kelas"
            SET terisi = terisi - 1
            WHERE id = OLD."kelasId";
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
' LANGUAGE plpgsql;

CREATE TRIGGER after_krs_cancelled
AFTER UPDATE OR DELETE ON "KRS"
FOR EACH ROW
EXECUTE FUNCTION decrement_kelas_terisi();
