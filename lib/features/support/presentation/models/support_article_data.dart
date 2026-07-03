import 'package:oneship_customer/core/base/base_import_components.dart';

class SupportArticleData {
  const SupportArticleData({required this.content});

  final String content;
}

const _pendingContent = 'support_help.answer_placeholder';

const supportArticleDataByQuestionKey = {
  'support_help.categories.account.questions.login_failed': SupportArticleData(
    content:
        "Nếu không thể đăng nhập, hãy kiểm tra lại tên đăng nhập và mật khẩu đã nhập. Đồng thời, đảm bảo bạn đang sử dụng đúng tài khoản đã được đăng ký và có đúng quyền (vai trò) để truy cập ứng dụng. Nếu vẫn không đăng nhập được, vui lòng liên hệ bộ phận hỗ trợ hoặc quản trị viên để được kiểm tra.",
  ),
  'support_help.categories.account.questions.forgot_password': SupportArticleData(
    content:
        "Nếu quên mật khẩu, hãy chọn \"Quên mật khẩu\" trên màn hình đăng nhập và nhập địa chỉ email đã đăng ký. Hệ thống sẽ gửi email hướng dẫn đặt lại mật khẩu. Vui lòng kiểm tra hộp thư đến (bao gồm cả thư rác/Spam nếu cần) và làm theo hướng dẫn trong email để tạo mật khẩu mới.",
  ),
  'support_help.categories.account.questions.change_phone': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.account.questions.kyc': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.account.questions.locked': SupportArticleData(
    content:
        "Nếu tài khoản của bạn bị khóa và không thể đăng nhập, vui lòng liên hệ quản trị viên hoặc bộ phận hỗ trợ để được kiểm tra nguyên nhân và mở khóa tài khoản. Việc mở khóa chỉ được thực hiện sau khi xác minh thông tin tài khoản.",
  ),
  'support_help.categories.income.questions.receive_money_time':
      SupportArticleData(content: _pendingContent),
  'support_help.categories.income.questions.withdraw': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.income.questions.wrong_income': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.income.questions.transaction_history':
      SupportArticleData(content: _pendingContent),
  'support_help.categories.income.questions.service_fee': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.package.questions.missing_or_error': SupportArticleData(
    content:
        "Nếu phát hiện túi hàng bị lỗi, thiếu hàng hoặc thông tin không chính xác, vui lòng liên hệ quản trị viên hoặc bộ phận hỗ trợ để được kiểm tra và xử lý. Hãy cung cấp mã túi hàng hoặc mã đơn hàng để việc xác minh được thực hiện nhanh chóng.",
  ),
  'support_help.categories.package.questions.how_to_use': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.package.questions.delivery_failed': SupportArticleData(
    content:
        "Nếu đơn hàng giao không thành công, vui lòng liên hệ trực tiếp với tài xế để tìm hiểu nguyên nhân. Trong trường hợp cần thêm hỗ trợ hoặc không thể liên hệ với tài xế, bạn có thể liên hệ bộ phận hỗ trợ để được hướng dẫn xử lý.",
  ),
  'support_help.categories.package.questions.change_address': SupportArticleData(
    content:
        "Trước khi đơn hàng được giao đến người nhận, bạn có thể cập nhật thông tin đơn hàng như người nhận, số điện thoại, địa chỉ giao hàng hoặc các thông tin liên quan khác. Vui lòng thực hiện thay đổi sớm hoặc liên hệ bộ phận hỗ trợ để được hỗ trợ cập nhật trước khi đơn hàng được giao.",
  ),
  'support_help.categories.package.questions.delivery_time': SupportArticleData(
    content:
        "Thời gian giao hàng có thể thay đổi tùy theo khu vực, loại dịch vụ và tình trạng vận chuyển. Để biết thời gian dự kiến hoàn thành đơn hàng, vui lòng liên hệ bộ phận cung cấp dịch vụ hoặc bộ phận hỗ trợ để được cung cấp thông tin chính xác nhất.",
  ),
  'support_help.categories.app_feature.questions.app_error': SupportArticleData(
    content:
        "Ứng dụng bị treo, tự thoát hoặc không phản hồi? Hãy thử khởi động lại ứng dụng. Nếu vẫn chưa khắc phục được, vui lòng liên hệ bộ phận hỗ trợ.",
  ),
  'support_help.categories.app_feature.questions.update_app': SupportArticleData(
    content:
        "Luôn sử dụng phiên bản mới nhất để đảm bảo ứng dụng hoạt động ổn định, được bổ sung tính năng mới và khắc phục các lỗi đã biết. Hãy cập nhật ứng dụng từ App Store hoặc Google Play khi có phiên bản mới.",
  ),
  'support_help.categories.app_feature.questions.scan_failed': SupportArticleData(
    content:
        "Nếu không thể quét mã, hãy kiểm tra ứng dụng đã được cấp quyền truy cập camera trong phần Cài đặt của thiết bị. Đồng thời, đảm bảo camera sạch, hình ảnh rõ nét, đủ ánh sáng và giữ thiết bị ổn định khi đưa mã vào khung quét. Nếu sự cố vẫn tiếp diễn, vui lòng liên hệ bộ phận hỗ trợ.",
  ),
  'support_help.categories.app_feature.questions.notification_missing':
      SupportArticleData(
        content:
            "Nếu không nhận được thông báo từ ứng dụng, hãy kiểm tra và đảm bảo ứng dụng đã được cấp quyền gửi thông báo trong phần Cài đặt của thiết bị. Đồng thời, hãy bật thông báo, âm thanh và các tùy chọn hiển thị thông báo để không bỏ lỡ các cập nhật quan trọng. Nếu sự cố vẫn tiếp diễn, vui lòng liên hệ bộ phận hỗ trợ.",
      ),
  'support_help.categories.app_feature.questions.suggestion': SupportArticleData(
    content:
        "Chúng tôi luôn lắng nghe ý kiến từ người dùng để cải thiện chất lượng ứng dụng. Nếu bạn có góp ý về tính năng, trải nghiệm sử dụng hoặc đề xuất cải tiến, vui lòng gửi qua email: ${Constants.oneshipGmail}, "
        "\nhoặc liên hệ trực tiếp với bộ phận hỗ trợ: ${Constants.hotline}. Mọi ý kiến đóng góp đều được ghi nhận và xem xét.",
  ),
  'support_help.categories.complaint.questions.create': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.complaint.questions.tracking': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.complaint.questions.order': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.complaint.questions.payment': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.complaint.questions.general': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.other.questions.feedback': SupportArticleData(
    content: '''📩 Lắng Nghe Để Bứt Phá Công Nghệ
OzoShip luôn trân trọng mọi ý kiến đóng góp từ Quý chủ shop để liên tục nâng cấp hệ thống điều vận, tối ưu hóa giao diện ứng dụng và cải thiện thái độ phục vụ của đội ngũ bưu tá. Sự hài lòng của bạn chính là kim chỉ nam cho mọi bước đi của chúng tôi.

🛠️ Quy Trình Tiếp Nhận & Xử Lý Phản Hồi:
Bước 1: Quý khách nhấn vào nút [Tạo Yêu Cầu Hỗ Trợ] (biểu tượng dấu cộng màu cam phía dưới màn hình) hoặc gửi trực tiếp nội dung phản hồi qua hòm thư điện tử: support@ozoship.vn

Bước 2: Bộ phận Vận hành Trung tâm sẽ tiếp nhận, phân loại ý kiến (Vấn đề kỹ thuật trên ứng dụng, Thái độ bưu tá, Quy trình lấy hàng/đối soát).

Bước 3: Phản hồi tiến trình xử lý hoặc giải pháp khắc phục cho Chủ shop trong vòng 24 giờ làm việc.

🎁 Vinh Danh Đóng Góp Vàng:
Hằng tháng, bộ phận Tiếp thị (Marketing) của OzoShip sẽ sàng lọc ra 05 ý kiến đóng góp xuất sắc nhất (giúp phát hiện lỗi hệ thống hoặc đề xuất tính năng mới hữu ích) để gửi tặng Mã giảm giá cước vận chuyển trị giá 500.000đ vào ví ứng dụng của chủ shop.

⚠️ Trường hợp khẩn cấp: Nếu cần xử lý ngay các sự cố thực địa (Bưu tá không đến lấy hàng, chậm trễ lấy/giao đơn hỏa tốc), Quý khách vui lòng gọi thẳng đến đường dây nóng vận hành 0981 280 176 hoặc nhấn Chat trực tiếp với Điều phối viên tại mục Hỗ trợ trực tuyến để được giải quyết trong vòng 5 phút.''',
  ),
  'support_help.categories.other.questions.promotion': SupportArticleData(
    content: '''⚡ Bùng Nổ Đơn Hàng – Ship Thả Ga Không Lo Về Giá
OzoShip Seller liên tục triển khai các chiến dịch ưu đãi độc quyền nhằm đồng hành cùng các chủ shop tối ưu hóa chi phí vận hành, gia tăng tỷ lệ chốt đơn thành công.

🚀 Các Chương Trình Khuyến Mãi Đình Đám Đang Diễn Ra (Năm 2026):
Đồng Giá Siêu Tốc 15K: Áp dụng cho toàn bộ các đơn hàng giao hỏa tốc trong ngày chặng nội thành TP.HCM cũ (Trọng lượng dưới 1kg).

Chào Mừng Bạn Mới: Tặng ngay gói giải pháp [Thử Nghiệm OzoShip] gồm 10 mã miễn phí 100% cước giao chặng đầu cho các tài khoản mới đăng ký trong tháng.

Hoàn Tiền Theo Sản Lượng (Bậc Thang Vàng): Chủ shop đạt sản lượng trên 500 đơn/tháng sẽ được hệ thống tự động hoàn tiền chiết khấu từ 5% - 15% tổng cước phí vào Ví điện tử trên ứng dụng vào ngày mùng 05 hằng tháng.

📝 Hướng Dẫn Sử Dụng Mã Khuyến Mãi:
Cách 1: Hệ thống tự động áp dụng mã ưu đãi tốt nhất phù hợp với đơn hàng của bạn khi tiến hành tạo đơn.

Cách 2: Tại màn hình "Tạo Đơn Hàng", Quý khách nhập tay mã khuyến mãi vào ô [Mã Giảm Giá/Ưu Đãi] trước khi bấm Xác nhận điều phối bưu tá.

📌 Lưu ý vận hành: Mỗi mã khuyến mãi đều có quy định cụ thể về thời hạn sử dụng, khu vực áp dụng và trọng lượng quy đổi. Tiền khuyến mãi không có giá trị quy đổi thành tiền mặt hoặc rút về tài khoản ngân hàng.''',
  ),
  'support_help.categories.other.questions.partner': SupportArticleData(
    content:
        '''OzoShip không chỉ là một ứng dụng giao hàng, chúng tôi định vị mình là người bạn đồng hành chiến lược, cánh tay nối dài giúp các doanh nghiệp, chuỗi cửa hàng và các tổng kho thương mại điện tử chuẩn hóa quy trình phân phối sản phẩm.

🌐 Các Giải Pháp Hợp Tác Toàn Diện B2B:
Tích Hợp API Hệ Thống Siêu Tốc: Giải pháp kết nối cổng công nghệ trực tiếp dành cho các đơn vị sử dụng phần mềm quản lý bán hàng lớn (Haravan, Pancake, KiotViet, Nhanh.vn) hoặc các sàn thương mại điện tử TikTok Shop, Shopee. Giúp tự động đẩy hàng nghìn đơn sang hệ thống OzoShip chỉ bằng 1 cú nhấp chuột.

Gói Giải Pháp Cho Khách Hàng Doanh Nghiệp (VIP Account): Thiết lập chính sách giá đặc quyền, hỗ trợ hạ tầng bưu cục di động lấy bưu kiện tận kho riêng biệt, đối soát dòng tiền thu hộ (COD) linh hoạt theo yêu cầu (Hằng ngày hoặc định kỳ Thứ 2 - 4 - 6).

Hợp Tác Nhượng Quyền Bưu Cục Nhận Hàng: Cơ hội kinh doanh bền vững cho các đối tác muốn sở hữu điểm nhận hàng mang thương hiệu OzoShip tại các tỉnh thành, chia sẻ nguồn doanh thu ổn định từ mạng lưới điều phối quốc gia.

📩 Phương Thức Kết Nối:
Nếu Quý đối tác có sản lượng đơn lớn (từ 100 đơn/ngày trở lên) hoặc muốn liên kết truyền thông, quảng cáo chéo (Cross-marketing) giữa các hệ sinh thái, xin vui lòng liên hệ:

Bộ phận Phát triển Thị trường Doanh nghiệp (BD Team): b2b@ozoship.vn

Đường dây nóng kết nối đối tác: 0901.866689 (Mr. Dũng Huỳnh)''',
  ),
  'support_help.categories.other.questions.policy': SupportArticleData(
    content: _pendingContent,
  ),
  'support_help.categories.other.questions.general_complaint':
      SupportArticleData(content: _pendingContent),
};
