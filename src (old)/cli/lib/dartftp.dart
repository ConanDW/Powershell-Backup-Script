import 'dart:developer';
import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';
UploadFilesFromPwshScript() async{
    FTPConnect ftpConnect = FTPConnect('192.168.2.1',user:'user', pass:'pass');
    try {
      File fileToUpload = File('fileToUpload.txt');
      await ftpConnect.connect();
      await ftpConnect.uploadFileWithRetry(fileToUpload, pRetryCount: 2);
      await ftpConnect.disconnect();
      stdout.write("Backup transferred successfully");
    } catch (e) {
      stderr.write("Something went wrong, please try again");
      log("Something went wrong, please try again.");
    }
}
DownloadFilesFromPwshScript() async{
  FTPConnect ftpConnect = FTPConnect('192.168.2.1',user:'user', pass:'pass');
  var Date = DateTime.timestamp();
  var BackupFileName = "BackupFromFTP.zip";
  try {
    String fileName = 'toDownload.txt';
    await ftpConnect.connect();
    await ftpConnect.downloadFile(fileName, File('$Date$BackupFileName'));
    await ftpConnect.disconnect();
    stdout.write("Backup downloaded successfully.");
  } catch (e) {
    stderr.write(("Something went wrong, please try again."));
    log("Something went wrong, please try again.");
  }
}