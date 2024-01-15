const fs = require('fs');
const export_bytes = fs.readFileSync('./table_export.wasm')
const test_bytes = fs.readFileSync('./table_test.wasm');

let i = 0;
let increment = () => {
  i++;
  return i;
}
let decrement = () => {
  i--;
  return i;
}

const importObject = {
  js: {
    tbl: null,
    increment: increment,
    decrement: decrement,
    wasm_increment: null, // 初期値はnullで、2つ目のモジュールが作成された関数が設定される
    wasm_decrement: null, // 初期値はnullで、2つ目のモジュールが作成された関数が設定される
  }
};

(async () => {
  let table_exp_obj = await WebAssembly.instantiate(new Uint8Array(export_bytes), importObject);

  // エクスポートされたテーブルをtblに割り当てる
  importObject.js.tbl = table_exp_obj.instance.exports.tbl;

  importObject.js.wasm_increment = table_exp_obj.instance.exports.increment;

  importObject.js.wasm_decrement = table_exp_obj.instance.exports.decrement;

  let obj = await WebAssembly.instantiate(new Uint8Array(test_bytes), importObject);

  // 分割代入構文を使って、exportsからJavaScript関数を作成
  ({ js_table_test, js_import_test, wasm_table_test, wasm_import_test } = obj.instance.exports);

  i = 0;
  let start = Date.now();
  // JavaScriptのテーブル呼び出しをテストする関数を実行
  js_table_test();
  let time = Date.now() - start; // 実行にかかった時間を計測
  console.log(`js_table_test: ${time}ms`);

  i = 0;
  start = Date.now();
  // JavaScriptの直接のimport呼び出しをテストする関数を実行
  js_import_test();
  time = Date.now() - start; // 実行にかかった時間を計測
  console.log(`js_import_test: ${time}ms`);

  i = 0;
  // WASMのテーブル呼び出しをテストする関数を実行
  wasm_table_test();
  time = Date.now() - start; // 実行にかかった時間を計測
  console.log(`wasm_table_test: ${time}ms`);

  i = 0;
  // WASMの直接のimport呼び出しをテストする関数を実行
  wasm_import_test();
  time = Date.now() - start; // 実行にかかった時間を計測
  console.log(`wasm_import_test: ${time}ms`);
})();