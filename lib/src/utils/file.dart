import 'package:get_smart/get_smart.dart';
import 'package:path/path.dart' as path;

class GetFile {
  GetFile({
    required this.path,
    String? name,
    int? size,
  })  : _name = name,
        _size = size;

  final String path;
  final String? _name;
  final int? _size;

  String get name => _name ?? path.fileName;

  int get size => _size ?? 0;

  String get type => name.fileType;

  MediaType? get mediaType => path.mediaType;

  Future<GetMultipartFile> get multipart => GetMultipartFile.fromFile(
        path,
        filename: name,
        contentType: mediaType,
      );

  bool get isImage => name.isImage;

  bool get isVideo => name.isVideo;

  bool get isAudio => name.isAudio;

  bool get isDocument => name.isDocument;

  bool get isMediaOrDocs => name.isMediaOrDocs;

  @override
  String toString() => "$typeName: ${{
        "path": path,
        "name": name,
        "size": size,
      }}";

  static Future<List<GetMultipartFile>> toMultipart(List<GetFile> files) async {
    List<GetMultipartFile> multipartFiles = [];
    await Future.forEach(
      files,
      (GetFile file) async => multipartFiles.add(await file.multipart),
    );
    return multipartFiles;
  }

  static const List<String> videoTypes = [
    "mp4",
    "wmv",
    "mov",
    "mpg",
    "mpeg",
  ];

  static const List<String> imageTypes = [
    "jpg",
    "jpeg",
    "png",
    "gif",
    "bmp",
    "tif"
  ];

  static const List<String> audioTypes = [
    "mp3",
    "wav",
    "wma",
    "m4a",
  ];

  static const List<String> docTypes = [
    "pdf",
    "doc",
    "docx",
  ];

  static const List<String> mediaAndDocTypes = [
    ...videoTypes,
    ...imageTypes,
    ...audioTypes,
    ...docTypes,
  ];
}

extension GetFileX on String {
  String get svg => "$this.svg";

  String get png => "$this.png";

  String get gif => "$this.gif";

  String get jpg => "$this.jpg";

  String get jpeg => "$this.jpeg";

  String get pdf => "$this.pdf";

  bool get isSVG => lowercase.endsWith("svg");

  bool get isPNG => lowercase.endsWith("png");

  bool get isGIF => lowercase.endsWith("gif");

  bool get isJPG => lowercase.endsWith("jpg") || lowercase.endsWith("jpeg");

  bool get isPDF => lowercase.endsWith("pdf");

  /// return the file name of file path.
  String get fileName => path.basename(this);

  /// return the file name without type.
  String get fileNameWithoutType => path.basenameWithoutExtension(this);

  /// return the file type without dot i.e. pdf.
  String get fileType => afterDot.lowercase;

  /// return the mime type description i.e. Image.
  String? get mimeDescription => mediaType?.type.capitalized;

  /// return the mime type description with type i.e. Image.jpg.
  String? fileDescription([String? append]) =>
      mimeDescription?.post(append, between: "-").post(fileType, between: ".");

  /// Parses a string to mime type.
  String? get mimeType => mime(this);

  /// Parses a string to media type.
  MediaType? get mediaType => mimeType?.mapIt((it) => MediaType.parse(it));

  /// Checks if string is a wmv file name.
  bool get isWMVFile => lowercase.endsWith("wmv");

  /// Checks if string is a video file name.
  bool get isVideo => GetFile.videoTypes.any(lowercase.endsWith);

  /// Checks if string is an image file name.
  bool get isImage => GetFile.imageTypes.any(lowercase.endsWith);

  /// Checks if string is an audio file name.
  bool get isAudio => GetFile.audioTypes.any(lowercase.endsWith);

  /// Checks if string is a document file name.
  bool get isDocument => GetFile.docTypes.any(lowercase.endsWith);

  /// Checks if string is an image, video, audio or document file name.
  bool get isMediaOrDocs => GetFile.mediaAndDocTypes.any(lowercase.endsWith);
}
