# anki-cli from this checkout on Python 3.14, over the official `anki` wheel
# (abi3, pinned in release.json to the Anki Desktop and sync-server version).
{
  lib,
  python314Packages,
  fetchurl,
  autoPatchelfHook,
  stdenv,
}:
let
  py = python314Packages;
  release = lib.importJSON ./release.json;
  anki = py.buildPythonPackage {
    pname = "anki";
    inherit (release.anki) version;
    format = "wheel";
    src = fetchurl { inherit (release.anki) url hash; };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
    dependencies = with py; [
      decorator
      distro
      markdown
      orjson
      protobuf
      pysocks
      requests
      typing-extensions
    ];
    pythonImportsCheck = [ "anki.collection" ];
  };
in
py.buildPythonApplication {
  pname = "anki-cli";
  version = "0.1.0";
  pyproject = true;
  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../pyproject.toml
      ../README.md
      ../LICENSE
      ../src
      ../tests
    ];
  };
  build-system = [ py.setuptools ];
  dependencies = [ anki ];
  optional-dependencies.tui = [ py.textual ];
  nativeCheckInputs = with py; [
    pytestCheckHook
    jsonschema
    textual
  ];
  pythonImportsCheck = [ "ankicli" ];
  passthru = { inherit anki; };
  meta = {
    description = "Anki's engine as a headless AnkiConnect-compatible server and CLI";
    homepage = "https://github.com/Macro002/anki-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "anki-cli";
    platforms = [ "x86_64-linux" ];
  };
}
