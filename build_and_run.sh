#! /bin/sh

set -euo pipefail 

export EMCC_CFLAGS="-Wno-missing-field-initializers -Wno-deprecated-literal-operator -fPIC"

BASE_DIR=$(realpath $(dirname $0))
cd $BASE_DIR/web/build 

emmake make 
emcc --bind -std=c++17 -g -s ALLOW_TABLE_GROWTH=1 \
-s EXPORT_NAME=libflutter_filament -sMAIN_MODULE -sMODULARIZE -sTOTAL_MEMORY=1024MB \
-s ERROR_ON_UNDEFINED_SYMBOLS=0  -sEXPORTED_RUNTIME_METHODS=wasmExports,wasmTable \
-sFULL_ES3 -s ASSERTIONS -pthread -sPTHREAD_POOL_SIZE=1 \
-sALLOW_BLOCKING_ON_MAIN_THREAD=1 -sOFFSCREEN_FRAMEBUFFER  -sNO_DISABLE_EXCEPTION_CATCHING -sFETCH=1  \
-sUSE_WEBGL2=1 -sMIN_WEBGL_VERSION=2  \
./libflutter_filament_plugin.a ./libfilament_shaders.a ../lib/lib*.a -o ./libflutter_filament_web.js 
cp libflutter_filament_web.* $BASE_DIR/example/assets/web 
cd $BASE_DIR/example/ 
flutter build web --wasm --wasm-opt=none
cd $BASE_DIR/example/build/web_wasm
cp $BASE_DIR/web/src/js/main.dart.js ./
cp $BASE_DIR/web/src/js/libflutter_filament_web.worker.js ./assets/assets/web/

dart run ~/Documents/dhttpd/bin/dhttpd.dart
