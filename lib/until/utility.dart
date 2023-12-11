/// kotlin equivalent to .let{}
/// see https://stackoverflow.com/a/58762538
extension ObjectExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}
