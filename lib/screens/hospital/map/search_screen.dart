import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hanwha/constants/theme.dart';
import 'insurance_claim_screen.dart'; // 방금 만든 파일 임포트

class MainSearchScreen extends StatefulWidget {
  const MainSearchScreen({super.key});

  @override
  State<MainSearchScreen> createState() => _MainSearchScreenState();
}

class _MainSearchScreenState extends State<MainSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _symptomController = TextEditingController();
  String _recommendedDept = "";
  NaverMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _symptomController.dispose();
    super.dispose();
  }

  // 내 위치로 이동 함수
  Future<void> _moveToCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition();
      final cameraUpdate = NCameraUpdate.withParams(
        target: NLatLng(position.latitude, position.longitude),
        zoom: 15,
      );
      _mapController?.updateCamera(cameraUpdate);
    } catch (e) {
      print("위치를 가져오는데 실패했습니다: $e");
    }
  }

  // 증상 분석 및 마커 표시 (추후 백엔드 연결 지점)
  void _analyzeSymptom() async {
    setState(() {
      _recommendedDept = "이비인후과"; // 예시 결과
    });

    if (_mapController != null) {
      // 기존 마커 삭제
      await _mapController!.clearOverlays();

      // 실제로는 백엔드에서 받은 위경도 리스트를 반복문으로 돌려야 함
      // 지금은 샘플 마커 하나를 현재 위치 주변에 찍어봅니다.
      Position pos = await Geolocator.getCurrentPosition();

      final marker = NMarker(
        id: 'hospital_1',
        position: NLatLng(pos.latitude + 0.002, pos.longitude + 0.002),
        caption: NOverlayCaption(
          text: "한화이비인후과",
          color: Colors.black,
          textSize: 12,
          haloColor: Colors.white,
        ),
      );

      // 마커 클릭 시 정보창 띄우기 설정 가능
      marker.setOnTapListener((marker) {
        print("병원 클릭됨: ${marker.info.id}");
      });

      _mapController!.addOverlay(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '주변 병원',
          style: TextStyle(fontFamily: 'Pretendard-Bold', fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.hanwhaOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.hanwhaOrange,
          labelStyle: TextStyle(
            fontFamily: 'Pretendard-SemiBold',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: "병원 검색"),
            Tab(text: "보험금 청구"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildHospitalSearchTab(), // 1번 탭: 지도 화면
          const InsuranceClaimScreen(), // 2번 탭: 빈 화면
        ],
      ),
    );
  }

  // 병원 검색 탭 레이아웃
  Widget _buildHospitalSearchTab() {
    return Column(
      children: [
        _buildInputSection(),
        Expanded(
          child: Stack(
            children: [
              NaverMap(
                options: const NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(37.5666, 126.9784),
                    zoom: 15,
                  ),
                  locationButtonEnable: true,
                ),
                onMapReady: (controller) {
                  _mapController = controller;
                  _moveToCurrentLocation();
                },
              ),
              if (_recommendedDept.isNotEmpty)
                Positioned(top: 16, left: 16, child: _buildResultChip()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _symptomController,
              decoration: InputDecoration(
                hintText: "어디가 아프신가요?",
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard-Regular',
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.hanwhaOrange),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _analyzeSymptom,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orangeLight,
              minimumSize: const Size(60, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildResultChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.hanwhaOrange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            "추천 진료과: $_recommendedDept",
            style: const TextStyle(
              fontFamily: 'Pretendard-Regular',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
