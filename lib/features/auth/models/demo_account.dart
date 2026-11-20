
class DemoAccount {
  static String name = 'Budi Santoso';
  static String phone = '0812356654';
  static String password = 'Budi123';
  static String address = 'Jl. Melati, RT 02/RW 01';
  static String rt = 'RT 02';

  static bool isDeleted = false;

  static void register({
    required String name,
    required String phone,
    required String password,
    required String address,
    required String rt,
  }) {
    DemoAccount.name = name;
    DemoAccount.phone = phone;
    DemoAccount.password = password;
    DemoAccount.address = address;
    DemoAccount.rt = rt;
    DemoAccount.isDeleted = false;
  }

  static bool authenticate(String phone, String password) {
    if (isDeleted || DemoAccount.phone.isEmpty) {
      return false;
    }

    return phone.trim() == DemoAccount.phone &&
        password == DemoAccount.password;
  }

  // Menghapus seluruh data akun demo yang sedang tersimpan.
  static void deleteAccount() {
    name = '';
    phone = '';
    password = '';
    address = '';
    rt = '';
    isDeleted = true;
  }
}
