# Ứng Dụng Đặt Đồ Ăn Flutter + Firebase

## Thông tin sinh viên
- Họ và tên: **Nguyễn Văn Tiến**
- Mã sinh viên: **2351160558**
- Bài thực hành: **TH3 - Ứng dụng đặt đồ ăn**

## Giới thiệu
Đây là dự án ứng dụng đặt đồ ăn được xây dựng bằng Flutter, sử dụng Firebase để xử lý xác thực tài khoản và dữ liệu thực đơn. Ứng dụng hỗ trợ đăng nhập, xem danh sách món ăn, xem chi tiết, thêm vào giỏ hàng, thanh toán QR và theo dõi trạng thái đặt món.

## Tính năng chính
- Đăng ký, đăng nhập bằng email/mật khẩu với Firebase Authentication.
- Đăng nhập bằng Google (đã tích hợp trong màn hình đăng nhập).
- Hiển thị danh sách món ăn, mô tả, giá tiền theo định dạng VND.
- Tìm kiếm món ăn theo tên hoặc mô tả.
- Xem chi tiết món ăn và thêm vào giỏ hàng.
- Quản lý số lượng món trong giỏ hàng.
- Thanh toán bằng mã QR (theo cấu hình trong `constants/payment_qr.dart`).
- Hỗ trợ chạy đa nền tảng: Android, Web, Windows, iOS, macOS, Linux.

## Công nghệ sử dụng
- `Flutter` (UI đa nền tảng)
- `Provider` (quản lý state)
- `Firebase Core`
- `Firebase Authentication`
- `Cloud Firestore`
- `HTTP` (kiểm tra kết nối mạng)

## Cấu trúc thư mục chính
```text
lib/
  components/        # Widget dùng lại (tile, button, drawer...)
  constants/         # Hằng số giao diện, cấu hình QR
  models/            # Model dữ liệu (food, cart_item, restaurant...)
  pages/             # Các màn hình chính
  services/          # Service auth, data, firebase...
  themes/            # Theme sáng/tối
  utils/             # Hàm tiện ích (format tiền...)
```

## Yêu cầu môi trường
- Flutter SDK (khuyến nghị bản stable mới)
- Dart SDK đi kèm Flutter
- Android Studio hoặc VS Code
- Firebase project đã cấu hình cho app

## Cài đặt và chạy dự án
1. Cài dependencies:
```bash
flutter pub get
```

2. Chạy trên Chrome:
```bash
flutter run -d chrome
```

3. Chạy trên Android:
```bash
flutter run -d android
```

## Cấu hình Firebase
Đảm bảo các file sau đã tồn tại đúng vị trí:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Flutter options: `lib/firebase_options.dart`

Nếu thay đổi project Firebase, chạy lại lệnh cấu hình (nếu có dùng FlutterFire CLI) để cập nhật `firebase_options.dart`.

## Cấu hình đăng nhập Google
Để đăng nhập Google hoạt động ổn định:
1. Bật provider Google trong Firebase Console:
   `Authentication -> Sign-in method -> Google`.
2. Với Web, thêm domain vào `Authorized domains` (ví dụ `localhost`).
3. Chạy lại ứng dụng và thử nút `Tiếp tục với Google` ở màn hình đăng nhập.

## Lưu ý khi build Android trên Windows
Nếu gặp lỗi Gradle liên quan Java, đặt JDK theo Android Studio JBR:

```powershell
setx JAVA_HOME "C:\Program Files\Android\Android Studio\jbr"
```

Trong `android/gradle.properties`, nên có:

```properties
org.gradle.java.home=C:\\Program Files\\Android\\Android Studio\\jbr
```

Sau đó mở terminal mới và build lại.

## Kiểm tra mã nguồn
```bash
flutter analyze
```

## Ghi chú
- Dữ liệu món ăn hiện được xây dựng từ catalog nội bộ trong service.
- Một số ảnh món ăn dùng ảnh local để tránh lỗi chặn hotlink/CORS trên web.

---
**Tác giả:** Nguyễn Văn Tiến - 2351160558
