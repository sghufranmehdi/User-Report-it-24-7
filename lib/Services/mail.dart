// Future sendMail(
//   List<File> attachment,
//   String name,
//   String location,
//   String description,
// ) async {
//   final user = await Auth().signin();
//   if (user == null) return;
//
//   final email = user.email;
//   final auth = await user.authentication;
//   final token = auth.accessToken!;
//   final smtpServer = gmailSaslXoauth2(email, token);
//   final message = Message()
//     ..from = Address(email, 'name')
//     ..recipients = ['faisal.4692814@gmail.com']
//     ..subject = 'ReportIt'
//     ..text =
//         'Name : $name \n Description : $description \n Location : $location '
//     ..attachments = attachment.cast<Attachment>();
//   //  ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
//
//   try {
//     await send(message, smtpServer);
//     showToast('Send email successfully!');
//   } on MailerException catch (e) {
//     print(e);
//   } catch (e) {
//     print(e);
//   }
// }

// Future sendMail1(
//   List<File> attachment,
//   String name,
//   String location,
//   String description,
// ) async {
//   final user = await Auth().signin();
//   if (user == null) return;
//
//   final email = user.email;
//   final auth = await user.authentication;
//   final token = auth.accessToken!;
//   final smtpServer = gmailSaslXoauth2(email, token);
//   final message = Message()
//     ..from = Address(email, 'Your name')
//     ..recipients = ['faisal.4692814@gmail.com']
//     ..subject = 'ReportIt'
//     ..text =
//         'Name : $name \n Description : $description \n Location : $location '
//     ..attachments = attachment.cast<Attachment>();
//   //  ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
//
//   try {
//     await send(message, smtpServer);
//     showToast('Send email successfully!');
//   } on MailerException catch (e) {
//     print(e);
//   } catch (e) {
//     print(e);
//   }
// }
//
// Future sendMail2(
//   List<File> attachment,
//   String name,
//   String location,
//   String description,
// ) async {
//   final user = await Auth().signin();
//   if (user == null) return;
//
//   final email = user.email;
//   final auth = await user.authentication;
//   final token = auth.accessToken!;
//   final smtpServer = gmailSaslXoauth2(email, token);
//   final message = Message()
//     ..from = Address(email, 'Your name')
//     ..recipients = ['malikdanishali125@gmail']
//     ..subject = 'ReportIt'
//     ..text =
//         'Name : $name \n Description : $description \n Location : $location '
//     ..attachments = attachment.cast<Attachment>();
//   //  ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
//
//   try {
//     await send(message, smtpServer);
//     showToast('Send email successfully!');
//   } on MailerException catch (e) {
//     print(e);
//   } catch (e) {
//     print(e);
//   }
// }
