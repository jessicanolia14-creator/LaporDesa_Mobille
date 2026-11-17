import 'package:lapordesa/features/bantuan/repositories/bantuan_repository.dart';

/// Jawaban simulasi lokal dari panduan Bantuan LaporDesa.
/// Belum terhubung ke layanan AI online.
class AiRepository {
  const AiRepository({BantuanRepository? bantuanRepository})
    : _bantuanRepository = bantuanRepository ?? const BantuanRepository();

  final BantuanRepository _bantuanRepository;

  String getResponse(String question) =>
      _bantuanRepository.answerQuestion(question);
}
