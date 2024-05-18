import 'package:banner_carousel/banner_carousel.dart';

class BannerImages {
  final List<BannerModel> _listBannsers;

  BannerImages({required List<BannerModel> listBanners}) : _listBannsers = listBanners;

  List<BannerModel> get listBanners => _listBannsers;
}