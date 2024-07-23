import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


 final smtpServer = gmail("tehila6564@gmail.com", "bfya kivk hpam uujt");

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
    final message = Message()
      ..from = Address("tehila6564@gmail.com", 'Coffee App')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> sendVerificationEmail(email, code) async {
    
    String subject = "Your Verification Code";
    String body = "Your verification code is: $code";

    await sendEmail(email, subject, body);
  }
 Future<void> orderDatail(String email, double total ) async {
    String subject = "your order detail";
    String body = "orderDetail";

    await sendEmail(email, subject, body);
  }