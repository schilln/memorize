abstract final class Routes {
  static const home = '/';
  static const editor = '/$editorRelative';
  static const editorRelative = 'editor';
  static String editorWithId(int id) => '/$editorRelative/$id';
}
