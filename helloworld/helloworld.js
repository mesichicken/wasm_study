const fs = require('fs');
const bytes = fs.readFileSync('./helloworld.wasm');

let hello_world = null; // 関数は後で設定
let start_string_index = 100; // 線形メモリでの文字列の位置
let memory = new WebAssembly.Memory({ initial: 1 }); // メモリを1ページ(64KB)確保

let importOject = {
  env: {
    buffer: memory,
    start_string: start_string_index,
    print_string: function (str_len) {
      const bytes = new Uint8Array(memory.buffer, start_string_index, str_len); // メモリから文字列を取得
      const log_string = new TextDecoder('utf8').decode(bytes); // バイト列を文字列に変換
      console.log(log_string);
    }
  }
};

(async () => {
  let obj = await WebAssembly.instantiate(new Uint8Array(bytes), importOject);
  ({ helloworld: hello_world } = obj.instance.exports);
  hello_world();
})();