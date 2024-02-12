# Flutter Android System Font

Flutter plugin for getting the Android system font. Fully works on Android 14+ by using latest API, on earlier versions it usually returns the standard font - Roboto. Gets the path of the font file by parsing system files.
## Screenshot for proof
Example app on crDroid Android 14

<img src="screenshot-crDroid.png" alt="crDroid" width="256"/>

## Getting Started

```
static Future<ByteData> readFileBytes(String path) async {
    var bytes = await File(path).readAsBytes();
    return ByteData.view(bytes.buffer);
}

var fontLoader = FontLoader('SystemFont');
fontFilePath = await AndroidSystemFont().getFilePath();
fontLoader.addFont(readFileBytes(fontFilePath));
fontLoader.load();

return MaterialApp(
      theme: ThemeData(
        fontFamily: "SystemFont"
      ), ...
```
