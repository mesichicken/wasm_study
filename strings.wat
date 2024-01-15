(module
  ;; インポートするJavaScript関数のは位置と長さを受け取る
  (import "env" "str_pos_len" (func $str_pos_len (param i32 i32)))
  (import "env" "null_str" (func $null_str (param i32)))
  (import "env" "len_prefix" (func $len_prefix (param i32)))
  (import "env" "buffer" (memory 1))
  (data (i32.const 0) "null-terminating string\00")
  (data (i32.const 128) "another null-terminating string\00")
  ;; 30文字の文字列
  (data (i32.const 256) "Know the length of this string")
  ;; 35文字の文字列
  (data (i32.const 288) "Also know the length of this string")
  ;; 長さは10進数で22, 16進数で16
  (data (i32.const 512) "\16length-prefix string")
  ;; 長さは10進数で30, 16進数で1e
  (data (i32.const 640) "\1eanother length-prefix string")

  (func (export "main")
    ;; $null_str関数ではパラメータは1つだけ
    (call $null_str (i32.const 0))
    (call $null_str (i32.const 128))
    ;; 1つ目の文字列の長さは30文字
    (call $str_pos_len (i32.const 256) (i32.const 30))
    ;; 2つ目の文字列の長さは35文字
    (call $str_pos_len (i32.const 288) (i32.const 35))

    (call $len_prefix (i32.const 512))
    (call $len_prefix (i32.const 640))
  )
)
