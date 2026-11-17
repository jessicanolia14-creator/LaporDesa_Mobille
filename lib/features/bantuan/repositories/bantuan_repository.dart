import '../models/bantuan_faq.dart';

/// Penyedia jawaban panduan lokal (belum memakai layanan AI online).
class BantuanRepository {
  const BantuanRepository();

  // Jawaban bantuan lokal untuk prototipe frontend.
  String answerQuestion(String question) {
    final String text = question.toLowerCase();

    if (text.contains('password') || text.contains('sandi')) {
      return 'Buka halaman Login, kemudian pilih '
          '“Lupa password?” untuk membuka halaman pemulihan.';
    }

    if (text.contains('foto') || text.contains('gambar')) {
      return 'Pada halaman Isi detail laporan, tekan '
          '“Tambah Foto”, lalu pilih foto masalah dari galeri.';
    }

    if (text.contains('lokasi') || text.contains('maps')) {
      return 'Pada halaman Tentukan Lokasi, tekan '
          '“Buka Google Maps”. Cari tempat laporan, lalu kembali '
          'ke LaporDesa dan masukkan alamat atau tautan lokasinya.';
    }

    if (text.contains('status') || text.contains('riwayat')) {
      return 'Buka menu Riwayat. Gunakan filter Semua, '
          'Diproses, atau Selesai untuk melihat daftar laporan.';
    }

    if (text.contains('kontak') || text.contains('admin')) {
      return 'Hubungi pengurus RT sesuai wilayahmu '
          'untuk bantuan terkait laporan.';
    }

    if (text.contains('rt')) {
      return 'Tekan bagian “Pilih RT”, kemudian pilih '
          'RT 01 atau RT 02 sesuai lokasi masalah.';
    }

    return 'Untuk membuat laporan, buka menu Lapor, pilih '
        'kategori masalah, isi judul dan deskripsi, tambahkan '
        'foto, lalu tentukan lokasi dan RT sebelum mengirim.';
  }

  BantuanFaq cariJawaban(String pertanyaan) =>
      BantuanFaq(pertanyaan: pertanyaan, jawaban: answerQuestion(pertanyaan));
}
