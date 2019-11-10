class APIUrl {
  APIUrl._();

  static const String _baseURL = 'http://solusi.kopbi.or.id/api';

  // API End Point Anggota
  static const String login_anggota = "$_baseURL/kopbi-agt/login/";

  // API End Point Get Image Profile Anggota
  static const String img_profile = "$_baseURL/kobi-images/anggota/";

  // API End Point Pinjaman
  static const String pinjaman = "$_baseURL/kopbi-pinjaman";
}