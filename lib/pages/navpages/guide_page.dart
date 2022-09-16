import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showPopup(_performList, context){
  showDialog(
      context: context,
      builder: (context){
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: _performList.length,
              itemBuilder: (context, index){
                return Card(
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Center(
                        child: Text(_performList[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color(0xff60584C),
                          ),
                        ),
                      ),
                    )
                );
              },
            ),
          ),
        );
      },
  );
}

class GuidePage extends StatelessWidget {
  List<String> _schoolList = [
    '먹을 만큼만 배식 받기',
    '안 쓸땐 컴퓨터 끄기',
    '교복, 교재는 깨끗하게 물려주기', 
    '걸레를 빨 때 물을 받아서 사용하기', 
    '분리수거해서 쓰레기 버리기', 
    '4층 이내는 계단 이용하기',
    '빈 교실 조명 소등하기',
    '물 절약하기',
    '등하교시 대중교통 및 도보 이용하기',
    '핸드 드라이어 대신 개인 손수건 사용하기',
    '다회용 컵 사용하기',
    '나무 심고 가꾸기'
  ];
  List<String> _companyList = [
    '컴퓨터 사용하지 않을 때는 전원 끄기', 
    '엘리베이터 대신 계단 이용하기', 
    '이면지 다시 사용하기', 
    '출퇴근 시 대중교통 이용하기',
    '친환경 운전 실천하기',
    '분리수거 하기',
    '핸드 드라이어 대신 개인 손수건 사용하기',
    '인쇄 시 종이 사용 줄이기',
    '고효율 전자기기 사용하기',
    '전자기기 대기 전력 차단하기',
    '절수 설비 또는 기기 설치하기',
    '1회 용품 줄이기'
  ];
  List<String> _performList = [
    '안 쓰는 플러그 뽑아 두기',
    '걷기 > 자전거 타기 > 대중교통 이용하기',
    '장바구니 사용하기',
    '친환경 상품 구매하기',
    '샤워시간 줄이기',
    '빨래 모아서 하기',
    '일회용컵 대신 텀블러 사용하기',
    '휴대폰 절전모드로 사용하기',
    '안 쓰는 방의 불 끄기',
    '난방온도 2도 낮추기',
    '냉방 온도 2도 높이기',
    '창틀, 문틈 사이 바람막이 설치하기',
    'LED 조명으로 교체하기'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        child: Text('오늘은 뭘 할까?',
                          style: const TextStyle(
                            fontSize: 30,
                            color: const Color(0xff60584C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ),
                  Padding(padding: const EdgeInsets.all(15),
                    child: TextButton(
                      onPressed: (){
                        showPopup(_performList, context);
                      },
                      child: Text("일상에서"),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 30),
                        backgroundColor: const Color(0xffffcc00),
                        primary: Colors.white,
                        padding: EdgeInsets.all(30),
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: TextButton(
                      onPressed: (){
                        showPopup(_schoolList, context);
                      },
                      child: Text("학교에서"),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 30),
                        backgroundColor: const Color(0xff60584C),
                        primary: Colors.white,
                        padding: EdgeInsets.all(30),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showPopup(_companyList, context);
                    },
                    child: Text("회사에서"),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 30),
                      backgroundColor: const Color(0xfff2a900),
                      primary: Colors.white,
                      padding: EdgeInsets.all(30),
                    ),
                  ),
                ]
            ),
          ),
    );
  }
}