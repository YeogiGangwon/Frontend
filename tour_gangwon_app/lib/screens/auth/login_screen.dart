import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _dio.post(
          'http://10.0.2.2:8080/api/users/login', // API 엔드포인트
          data: {
            'email': _idController.text, // ID를 email로 전송
            'password': _pwController.text,
          },
        );

        if (response.statusCode == 200) {
          // 응답에서 토큰을 추출
          final String token = response.data['token'];
          // 기기에 안전하게 토큰 저장
          await _storage.write(key: 'jwt_token', value: token);
          
          print('로그인 성공, 토큰 저장 완료!');
          // 로그인 성공 후 홈 화면으로 이동
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } on DioException catch (e) {
        if (mounted) {
          // API 명세서에 따른 에러 처리
          if (e.response?.statusCode == 401) {
            // 401 에러 메시지 표시
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.response?.data['message'] ?? '아이디 또는 비밀번호가 틀립니다.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            // 기타 서버 에러
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('서버에 오류가 발생했습니다.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('네트워크 오류가 발생했습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          children: [
            Container(
              width: double.infinity,
              height: 884,
              padding: const EdgeInsets.only(top: 116, left: 72, right: 72, bottom: 100),
              decoration: const BoxDecoration(color: Color(0xFFF3F5F6)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로고
                  Container(
                    width: 157,
                    height: 157,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 입력폼 박스
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF3F5F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        // ID 라벨
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'ID',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1E1E1E),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ID 입력창
                        TextFormField(
                          controller: _idController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력해주세요';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '아이디를 입력하세요',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF002C50), width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // PW 라벨
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1E1E1E),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // PW 입력창
                        TextFormField(
                          controller: _pwController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '비밀번호를 입력하세요',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF002C50), width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 로그인 버튼
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF002C50),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 회원가입/비번찾기
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup'); // 회원가입 화면 이동
                              },
                              child: const Text(
                                '회원가입',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                            const SizedBox(width: 22),
                            TextButton(
                              onPressed: () {
                                // TODO: 비밀번호 찾기 화면 연결할 거면 여기에 추가
                                print('비밀번호 찾기 클릭됨');
                              },
                              child: const Text(
                                '비밀번호 찾기',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
