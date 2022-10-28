import 'package:get/get.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ReportBugController extends GetxController {
  var listImages = [].obs;
  var emailText = "";
  var subject = "";
  var content = "";

  updateEmail(String value) {
    emailText = value;
  }

  updateSubject(String value) {
    subject = value;
  }

  updateContent(String value) {
    content = value;
  }

  addImage(String path) {
    listImages.add(path);
  }

  removeImage(String path) {
    listImages.remove(path);
  }

  sendFeedback() async {
    if (content == "") {
      return "Conteudo não pode ser vazio";
    }
    final Email email = Email(
      body: content,
      subject: subject,
      recipients: ["tudoemcasareceitas@gmail.com"],
      attachmentPaths: List<String>.from(listImages),
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
    return "";
  }
}
