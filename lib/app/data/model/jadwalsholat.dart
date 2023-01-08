class JadwalSholat {
  String? tanggal;
  String? imsak;
  String? subuh;
  String? terbit;
  String? dhuha;
  String? dzuhur;
  String? ashar;
  String? maghrib;
  String? isya;
  String? date;

  JadwalSholat(
      {this.tanggal,
      this.imsak,
      this.subuh,
      this.terbit,
      this.dhuha,
      this.dzuhur,
      this.ashar,
      this.maghrib,
      this.isya,
      this.date});

  JadwalSholat.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    imsak = json['imsak'];
    subuh = json['subuh'];
    terbit = json['terbit'];
    dhuha = json['dhuha'];
    dzuhur = json['dzuhur'];
    ashar = json['ashar'];
    maghrib = json['maghrib'];
    isya = json['isya'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tanggal'] = this.tanggal;
    data['imsak'] = this.imsak;
    data['subuh'] = this.subuh;
    data['terbit'] = this.terbit;
    data['dhuha'] = this.dhuha;
    data['dzuhur'] = this.dzuhur;
    data['ashar'] = this.ashar;
    data['maghrib'] = this.maghrib;
    data['isya'] = this.isya;
    data['date'] = this.date;
    return data;
  }
}
