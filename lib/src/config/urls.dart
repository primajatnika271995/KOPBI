class APIUrl {
  APIUrl._();

  static const String _baseURL = 'http://solusi.kopbi.or.id:8889';

  // API End Point Anggota
  static const String login_anggota = "$_baseURL/kopbi-agt/login";

  // API End Point Get Image Profile Anggota
  static const String img_profile = "$_baseURL/kobi-images/anggota/";

  // API End Point Pinjaman
  static const String pinjaman = "$_baseURL/kopbi-pinjaman";

  // API End Point Pengajuan
  static const String pengajuan = "$_baseURL/kopbi-pengajuan";

  // API End Point Barang
  static const String barang = "$_baseURL/kopbi-master";

  //API End Point Anggota
  static const String anggota = "$_baseURL/kopbi-agt";

  //PI End Point Images
  static const String images = "$_baseURL/kobi-images";

}