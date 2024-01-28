import 'package:cli/dartftp.dart' as DartFTP;
void main() {
  var ChoiceOfUporDown = 0;
  if (ChoiceOfUporDown == 1) {
    DartFTP.DownloadFilesFromPwshScript();
  } else {
    DartFTP.UploadFilesFromPwshScript();
  }
}