export EMCC_CFLAGS="-Wno-missing-field-initializers -Wno-deprecated-literal-operator -fPIC"

BASE_DIR=$(realpath $(dirname $0))
cd $BASE_DIR/web/build 
emmake make 
emcc -std=c++17 -g -s ALLOW_TABLE_GROWTH=1 \
-s EXPORT_NAME=libflutter_filament -sMODULARIZE -sMAIN_MODULE  \
-s ERROR_ON_UNDEFINED_SYMBOLS=0  -sEXPORTED_RUNTIME_METHODS=wasmExports,wasmTable \
-sFULL_ES3 -s ASSERTIONS -pthread -sPTHREAD_POOL_SIZE=1 -sALLOW_BLOCKING_ON_MAIN_THREAD -sPROXY_TO_PTHREAD \
./libflutter_filament_plugin.a  ./libdart_api.a -o ./libflutter_filament_web.js 
mv libflutter_filament_web.* $BASE_DIR/example/assets/web 
cd $BASE_DIR/example/ && flutter clean && flutter build web --wasm
cd $BASE_DIR/example/build/web_wasm
cp $BASE_DIR/web/src/js/main.dart.js ./
cp $BASE_DIR/web/src/js/libflutter_filament_web.worker.js ./assets/assets/web/
dart run ~/Documents/dhttpd/bin/dhttpd.dart
