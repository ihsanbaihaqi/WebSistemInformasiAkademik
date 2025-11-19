-- Create database views for simplifying complex queries

-- v_mahasiswa_detail
-- This view provides a detailed look at a student, joining information
-- from the User, Mahasiswa, ProgramStudi, and Fakultas tables.
CREATE VIEW "v_mahasiswa_detail" AS
SELECT
    m.id AS "mahasiswaId",
    m.nim,
    m.nama AS "namaMahasiswa",
    m.angkatan,
    u.email,
    ps.nama AS "programStudi",
    f.nama AS "fakultas",
    d.nama AS "dosenWali"
FROM "Mahasiswa" m
LEFT JOIN "User" u ON m."userId" = u.id
LEFT JOIN "ProgramStudi" ps ON m."programStudiId" = ps.id
LEFT JOIN "Fakultas" f ON ps."fakultasId" = f.id
LEFT JOIN "Dosen" d ON m."dosenWaliId" = d.id;

-- v_krs_detail
-- This view shows detailed information about a student's course registration (KRS),
-- joining KRS, Mahasiswa, Kelas, MataKuliah, and Dosen.
CREATE VIEW "v_krs_detail" AS
SELECT
    krs.id AS "krsId",
    mhs.id AS "mahasiswaId",
    mhs.nim,
    mhs.nama AS "namaMahasiswa",
    mk.kode AS "kodeMataKuliah",
    mk.nama AS "namaMataKuliah",
    mk.sks,
    kls.nama AS "namaKelas",
    dsn.nama AS "namaDosen",
    kls.jadwal,
    kls.ruangan,
    krs.status AS "statusKRS"
FROM "KRS" krs
LEFT JOIN "Mahasiswa" mhs ON krs."mahasiswaId" = mhs.id
LEFT JOIN "Kelas" kls ON krs."kelasId" = kls.id
LEFT JOIN "MataKuliah" mk ON kls."mataKuliahId" = mk.id
LEFT JOIN "Dosen" dsn ON kls."dosenId" = dsn.id;

-- v_nilai_khs
-- This view is for the Kartu Hasil Studi (KHS). It joins Nilai, KRS,
-- Kelas, and MataKuliah to show the grades for each course a student has taken.
CREATE VIEW "v_nilai_khs" AS
SELECT
    mhs.id AS "mahasiswaId",
    mhs.nim,
    mhs.nama AS "namaMahasiswa",
    mk.kode AS "kodeMataKuliah",
    mk.nama AS "namaMataKuliah",
    mk.sks,
    n."nilaiAngka",
    n."nilaiHuruf",
    n.bobot
FROM "Nilai" n
LEFT JOIN "KRS" krs ON n."krsId" = krs.id
LEFT JOIN "Mahasiswa" mhs ON krs."mahasiswaId" = mhs.id
LEFT JOIN "Kelas" kls ON krs."kelasId" = kls.id
LEFT JOIN "MataKuliah" mk ON kls."mataKuliahId" = mk.id;

-- Database Triggers for maintaining data integrity

-- Function to update the 'terisi' count in the 'Kelas' table
-- This function is called when a record is inserted, deleted, or updated in the KRS table.
CREATE OR REPLACE FUNCTION update_kelas_terisi_on_change()
RETURNS TRIGGER AS $$
BEGIN
    -- On INSERT, increment the count for the new class
    IF (TG_OP = 'INSERT') THEN
        UPDATE "Kelas"
        SET terisi = terisi + 1
        WHERE id = NEW."kelasId";
    -- On DELETE, decrement the count for the old class
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE "Kelas"
        SET terisi = terisi - 1
        WHERE id = OLD."kelasId";
    -- On UPDATE, if the class has changed, decrement the old and increment the new
    ELSIF (TG_OP = 'UPDATE' AND NEW."kelasId" IS DISTINCT FROM OLD."kelasId") THEN
        -- Decrement the old class
        UPDATE "Kelas"
        SET terisi = terisi - 1
        WHERE id = OLD."kelasId";
        -- Increment the new class
        UPDATE "Kelas"
        SET terisi = terisi + 1
        WHERE id = NEW."kelasId";
    END IF;
    RETURN NULL; -- The result is ignored since this is an AFTER trigger
END;
$$ LANGUAGE plpgsql;

-- Trigger to execute the function after any change on the KRS table
CREATE TRIGGER trg_krs_change
AFTER INSERT OR DELETE OR UPDATE ON "KRS"
FOR EACH ROW
EXECUTE FUNCTION update_kelas_terisi_on_change();
