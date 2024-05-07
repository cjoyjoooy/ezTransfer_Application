class TransferFiles {
  final String filename;
  final String qrpassword;

  TransferFiles({
    required this.filename,
    required this.qrpassword,
  });

  static TransferFiles fromJson(Map<String, dynamic> json) => TransferFiles(
        filename: json['filename'],
        qrpassword: json['qrpassword'],
      );

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'qrPassword': qrpassword,
      };
}
