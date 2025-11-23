import 'package:flutter/material.dart';

/// 메인 페이지에서 사용하는 큰 버튼 위젯
///
/// 재사용 가능한 커스텀 버튼으로, 메인 페이지의 네비게이션 버튼으로 사용됩니다.
///
/// 특징:
/// - Expanded를 사용하여 부모 위젯의 가용 공간을 채웁니다
/// - InkWell을 사용하여 터치 시 물결 효과를 제공합니다
/// - 둥근 모서리와 파란색 배경을 가진 일관된 디자인
///
/// 주의사항:
/// - 반드시 Row, Column, Flex 등의 부모 위젯 내부에서 사용해야 합니다
/// - Expanded를 사용하므로 단독으로는 사용할 수 없습니다
///
/// 사용 예:
/// ```dart
/// Column(
///   children: [
///     BigButton(
///       label: '연습하기',
///       onPressed: () => Navigator.push(...),
///     ),
///     BigButton(label: '다시 배우기'),
///   ],
/// )
/// ```
class BigButton extends StatelessWidget {
  const BigButton({super.key, required this.label, this.onPressed});

  /// 버튼에 표시될 텍스트
  final String label;

  /// 버튼 클릭 시 실행될 콜백 함수
  /// null인 경우 버튼은 표시되지만 동작하지 않습니다 (미구현 기능용)
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // 부모의 가용 공간을 균등하게 차지
      child: InkWell(
        // 터치 이벤트 처리 및 물결 효과
        onTap: onPressed ?? () {}, // onPressed가 null이면 빈 함수 실행
        splashColor: Colors.black26, // 클릭 시 물결 효과 색상
        child: Ink(
          // InkWell의 배경 설정 (Material 효과를 위해 Ink 사용)
          decoration: BoxDecoration(
            color: Colors.blue[100], // 연한 파란색 배경
            borderRadius: BorderRadius.circular(12), // 둥근 모서리 (반지름 12)
          ),
          child: Container(
            padding: const EdgeInsets.all(16), // 내부 여백
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬
              children: [
                const SizedBox(width: 12), // 좌측 여백 (향후 아이콘 추가를 위한 공간)
                Text(label, style: const TextStyle(fontSize: 18)), // 버튼 텍스트
              ],
            ),
          ),
        ),
      ),
    );
  }
}
