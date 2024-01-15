(module
  (import "js" "tbl" (table $tbl 4 anyfunc))
  ;; increment 関数をインポート
  (import "js" "increment" (func $increment (result i32)))
  ;; decrement 関数をインポート
  (import "js" "decrement" (func $decrement (result i32)))

  ;; wasm_increment 関数をインポート
  (import "js" "wasm_increment" (func $wasm_increment (result i32)))

  ;; wasm_decrement 関数をインポート
  (import "js" "wasm_decrement" (func $wasm_decrement (result i32)))

  ;; テーブル関数の型定義はすべて i32 であり、パラメータはない
  (type $returns_i32 (func (result i32)))

  ;; JavaScript の increment 関数のテーブルインデックス
  (global $inc_ptr i32 (i32.const 0))
  ;; JavaScript の decrement 関数のテーブルインデックス
  (global $dec_ptr i32 (i32.const 1))

  ;; WASM の increment 関数のテーブルインデックス
  (global $wasm_inc_ptr i32 (i32.const 2))
  ;; WASM の decrement 関数のテーブルインデックス
  (global $wasm_dec_ptr i32 (i32.const 3))

  ;; JavaScript 関数の間接的な呼び出しのパフォーマンスをテスト
  (func (export "js_table_test")
    (loop $inc_cycle
      ;; JavaScript の increment 関数を間接的に呼び出す
      (call_indirect (type $returns_i32) (global.get $inc_ptr))
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $inc_cycle ;; 4_000_000 以上の場合はループを終了
    )

    (loop $dec_cycle
      ;; JavaScript の decrement 関数を間接的に呼び出す
      (call_indirect (type $returns_i32) (global.get $dec_ptr))
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $dec_cycle ;; 4_000_000 以上の場合はループを終了
    )
  )

  ;; JavaScript関数の直接の呼び出しのパフォーマンスをテスト
  (func (export "js_import_test")
    (loop $inc_cycle
      ;; JavaScript の increment 関数を直接呼び出す
      call $increment
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $inc_cycle ;; 4_000_000 以上の場合はループを終了
    )

    (loop $dec_cycle
      ;; JavaScript の decrement 関数を直接呼び出す
      call $decrement
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $dec_cycle ;; 4_000_000 以上の場合はループを終了
    )
  )

  ;; WASM 関数の間接的な呼び出しのパフォーマンスをテスト
  (func (export "wasm_table_test")
    (loop $inc_cycle
      ;; WASM の increment 関数を間接的に呼び出す
      (call_indirect (type $returns_i32) (global.get $wasm_inc_ptr))
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $inc_cycle ;; 4_000_000 以上の場合はループを終了
    )

    (loop $dec_cycle
      ;; WASM の decrement 関数を間接的に呼び出す
      (call_indirect (type $returns_i32) (global.get $wasm_dec_ptr))
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $dec_cycle ;; 4_000_000 以上の場合はループを終了
    )
  )

  ;; WASM 関数の直後の呼び出しのパフォーマンスをテスト
  (func (export "wasm_import_test")
    (loop $inc_cycle
      ;; WASM の increment 関数を直接呼び出す
      call $wasm_increment
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $inc_cycle ;; 4_000_000 以上の場合はループを終了
    )

    (loop $dec_cycle
      ;; WASM の decrement 関数を直接呼び出す
      call $wasm_decrement
      i32.const 4_000_000
      i32.le_u ;; 4_000_000 以下の場合はループを継続
      br_if $dec_cycle ;; 4_000_000 以上の場合はループを終了
    )
  )
)