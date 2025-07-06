abstract final class Routes {
  static const home = '/';
  static const editor = '/$editorRelative';
  static const editorRelative = 'editor';
  static String editorWithId(final int id) => '/$editorRelative/$id';
  static const memorizer = '/$memorizerRelative';
  static const memorizerRelative = 'memorizer';
  static String memorize(final int id) => '/$memorizerRelative/$id';
}
