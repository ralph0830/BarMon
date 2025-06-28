import 'dart:io';

void main() {
  final dir = Directory('assets/images/portrait');
  if (!dir.existsSync()) {
    stderr.writeln('assets/images/portrait 폴더가 존재하지 않습니다.');
    exit(1);
  }
  final buffer = StringBuffer();
  for (var entity in dir.listSync()..sort((a, b) => a.path.compareTo(b.path))) {
    if (entity is Directory) {
      buffer.writeln('    - ${entity.path.replaceAll('\\', '/')}/');
    }
  }
  stdout.write(buffer.toString());
} 