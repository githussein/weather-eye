import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:matar_weather/widgets/VideoTile.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_player/video_player.dart';
import '../providers/data.dart';
import '../screens/settings.dart';
import '../providers/posts.dart';
import '../models/media.dart';
import 'notifications_screen.dart';
import 'send_photo_screen.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  String theUrl = '';

  var _isInit = true;
  var _isLoading = false;
  int _snappedPageIndex = 0;

  // void _loadInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: AdHelper.interstitialAdUnitId,
  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         this._interstitialAd = ad;
  //
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //           },
  //         );
  //
  //         _isInterstitialAdReady = true;
  //       },
  //       onAdFailedToLoad: (err) {
  //         print('Failed to load an interstitial ad: ${err.message}');
  //         _isInterstitialAdReady = false;
  //       },
  //     ),
  //   );
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // NativeAd? nativeAd;
  // bool _isAdLoaded = false;
  // static const _kAdIndex = 4;
  // int _getDestinationItemIndex(int rawIndex) {
  //   if (rawIndex >= _kAdIndex && _isAdLoaded) {
  //     return rawIndex - 1;
  //   }
  //   return rawIndex;
  // }

  // late BannerAd _bannerAd;
  // bool _isBannerAdReady = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _bannerAd = BannerAd(
  //     adUnitId: AdHelper.bannerAdUnitId,
  //     request: const AdRequest(),
  //     size: AdSize.leaderboard,
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isBannerAdReady = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, err) {
  //         print('Failed to load a banner ad: ${err.message}');
  //         _isBannerAdReady = false;
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //
  //   _bannerAd.load();
  // }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   nativeAd = NativeAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/1044960115',
  //     factoryId: 'listTile',
  //     request: const AdRequest(),
  //     listener: NativeAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         // Releases an ad resource when it fails to load
  //         ad.dispose();
  //
  //         print('Ad load failed (code=${error.code} message=${error.message})');
  //       },
  //     ),
  //   );
  //
  //   nativeAd!.load();
  // }
  //
  // @override
  // void dispose() {
  //   nativeAd!.dispose();
  //   super.dispose();
  // }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() => _isLoading = true);
      Provider.of<Posts>(context, listen: false)
          .getAllMedia()
          .then((_) => setState(() => _isLoading = false));
    }
    _isInit = false;
  }

  // Future<void> changeVideo(String newUrl) async {
  //   await _controller.pause();
  //   await Future.delayed(const Duration(milliseconds: 3000));
  //   _controller = VideoPlayerController.network(newUrl)
  //     ..addListener(() => setState(() {}))
  //     ..setLooping(true)
  //     ..initialize().then((_) => _controller.play());
  //   await Future.delayed(const Duration(milliseconds: 3000));
  //
  //   print('https://app.rain-app.com/storage/weather-shots/$newUrl');
  // }

  @override
  Widget build(BuildContext context) {
    var mediaList = Provider.of<Posts>(context, listen: false).media;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.black87,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: mediaList.length,
        onPageChanged: (int page) => setState(() => _snappedPageIndex = page),
        itemBuilder: (context, index) {
          return (index == 1 || (index > 2 && (index - 1) % 4 == 0))
              ? Column(
                  children: [
                    const Text(
                      'x إيقاف الإعلانات',
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Image.asset('assets/img/ad.png', fit: BoxFit.fill),
                    ),
                  ],
                )
              : Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      mediaList[index].media.contains('.mp4')
                          ? Center(
                              child: VideoTile(
                                videoUrl:
                                    'https://app.app-backend.com/storage/weather-shots/${mediaList[index].media}',
                                currentIndex: index,
                                snappedPage: _snappedPageIndex,
                              ),
                            )
                          : Center(
                              child: CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  imageUrl:
                                      'https://app.app-backend.com/storage/weather-shots/${mediaList[index].media}'),
                            ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 16, right: 8),
                          child: IconButton(
                            icon: const Icon(Icons.info_outline,
                                color: Colors.white38, size: 36),
                            onPressed: () {
                              showBottomSheet(
                                  context: context,
                                  builder: (context) => ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    'assets/icon/close.png',
                                                    height: 24,
                                                    color:
                                                        Colors.purple.shade800,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text('إغلاق'),
                                                  const SizedBox(width: 16),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.camera_alt),
                                              const SizedBox(width: 10),
                                              Text(mediaList[index]
                                                  .photographer),
                                            ],
                                          ),
                                          const Divider(thickness: 1),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_pin),
                                              const SizedBox(width: 10),
                                              Text(mediaList[index].location),
                                            ],
                                          ),
                                          const Divider(thickness: 1),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time),
                                              const SizedBox(width: 10),
                                              Text(mediaList[index].date),
                                            ],
                                          ),
                                        ],
                                      ));
                            },
                          ),
                        ),
                      )
                    ],
                  ));
        },
      ),
    );
  }
}
