class Location {
  final double lat;
  final double lon;

  Location({required this.lat, required this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat']?.toDouble() ?? 0.0,
      lon: json['lon']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lon': lon};
  }
}

class TourInfo {
  final String contentid;
  final String contenttypeid;
  final String title;
  final String overview;
  final String addr1;
  final String addr2;
  final String zipcode;
  final String tel;
  final String homepage;
  final String firstimage;
  final String mapx;
  final String mapy;
  final String heritage1;
  final String heritage2;
  final String heritage3;
  final String infocenter;
  final String opendate;
  final String restdate;
  final String expguide;
  final String expagerange;
  final String accomcount;
  final String useseason;
  final String usetime;
  final String parking;
  final String chkbabycarriage;
  final String chkpet;
  final String chkcreditcard;
  final List<String> images;
  final String? error;

  TourInfo({
    required this.contentid,
    required this.contenttypeid,
    required this.title,
    required this.overview,
    required this.addr1,
    required this.addr2,
    required this.zipcode,
    required this.tel,
    required this.homepage,
    required this.firstimage,
    required this.mapx,
    required this.mapy,
    required this.heritage1,
    required this.heritage2,
    required this.heritage3,
    required this.infocenter,
    required this.opendate,
    required this.restdate,
    required this.expguide,
    required this.expagerange,
    required this.accomcount,
    required this.useseason,
    required this.usetime,
    required this.parking,
    required this.chkbabycarriage,
    required this.chkpet,
    required this.chkcreditcard,
    required this.images,
    this.error,
  });

  factory TourInfo.fromJson(Map<String, dynamic> json) {
    return TourInfo(
      contentid: json['contentid']?.toString() ?? '',
      contenttypeid: json['contenttypeid']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      overview: json['overview']?.toString() ?? '',
      addr1: json['addr1']?.toString() ?? '',
      addr2: json['addr2']?.toString() ?? '',
      zipcode: json['zipcode']?.toString() ?? '',
      tel: json['tel']?.toString() ?? '',
      homepage: json['homepage']?.toString() ?? '',
      firstimage: json['firstimage']?.toString() ?? '',
      mapx: json['mapx']?.toString() ?? '',
      mapy: json['mapy']?.toString() ?? '',
      heritage1: json['heritage1']?.toString() ?? '0',
      heritage2: json['heritage2']?.toString() ?? '0',
      heritage3: json['heritage3']?.toString() ?? '0',
      infocenter: json['infocenter']?.toString() ?? '',
      opendate: json['opendate']?.toString() ?? '',
      restdate: json['restdate']?.toString() ?? '',
      expguide: json['expguide']?.toString() ?? '',
      expagerange: json['expagerange']?.toString() ?? '',
      accomcount: json['accomcount']?.toString() ?? '',
      useseason: json['useseason']?.toString() ?? '',
      usetime: json['usetime']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      chkbabycarriage: json['chkbabycarriage']?.toString() ?? '',
      chkpet: json['chkpet']?.toString() ?? '',
      chkcreditcard: json['chkcreditcard']?.toString() ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      error: json['error']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentid': contentid,
      'contenttypeid': contenttypeid,
      'title': title,
      'overview': overview,
      'addr1': addr1,
      'addr2': addr2,
      'zipcode': zipcode,
      'tel': tel,
      'homepage': homepage,
      'firstimage': firstimage,
      'mapx': mapx,
      'mapy': mapy,
      'heritage1': heritage1,
      'heritage2': heritage2,
      'heritage3': heritage3,
      'infocenter': infocenter,
      'opendate': opendate,
      'restdate': restdate,
      'expguide': expguide,
      'expagerange': expagerange,
      'accomcount': accomcount,
      'useseason': useseason,
      'usetime': usetime,
      'parking': parking,
      'chkbabycarriage': chkbabycarriage,
      'chkpet': chkpet,
      'chkcreditcard': chkcreditcard,
      'images': images,
      if (error != null) 'error': error,
    };
  }

  // 편의 메서드들
  bool get hasImages => images.isNotEmpty;
  bool get hasOverview => overview.isNotEmpty && overview != '상세 정보가 없습니다.';
  bool get hasAddress => addr1.isNotEmpty;
  bool get hasParking => parking.isNotEmpty;
  bool get hasTel => tel.isNotEmpty || infocenter.isNotEmpty;
  String get displayAddress =>
      addr1.isNotEmpty ? addr1 : (addr2.isNotEmpty ? addr2 : '주소 정보 없음');
  String get displayTel =>
      infocenter.isNotEmpty ? infocenter : (tel.isNotEmpty ? tel : '연락처 정보 없음');
}

class Beach {
  final String id;
  final String name;
  final String city;
  final Location location;
  final String description;
  final TourInfo tourInfo;

  Beach({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
    required this.description,
    required this.tourInfo,
  });

  factory Beach.fromJson(Map<String, dynamic> json) {
    return Beach(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      description: json['description']?.toString() ?? '',
      tourInfo: TourInfo.fromJson(json['tourInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'location': location.toJson(),
      'description': description,
      'tourInfo': tourInfo.toJson(),
    };
  }

  // 편의 메서드들
  String get displayName => name.contains('해수욕장') ? name : '$name해수욕장';
  String get fullLocation => '$city $name';
  bool get hasDetailedInfo => tourInfo.hasOverview || tourInfo.hasImages;
  String get mainImage => tourInfo.hasImages ? tourInfo.images.first : '';
  String get displayOverview =>
      tourInfo.hasOverview ? tourInfo.overview : description;
}
