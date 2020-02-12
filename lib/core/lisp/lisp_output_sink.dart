// A simple substitute for stdout by SendPort
class LispOutputSink extends StringSink {
  LispOutputSink(this.handler);

  Function(Object) handler;

  @override void write(x) { handler(x); }
  @override void writeln([x=""]) { handler("${x}\n"); }
  @override void writeAll(x, [sep=""]) { throw new UnimplementedError(); }
  @override void writeCharCode(int code) { throw new UnimplementedError(); }
}