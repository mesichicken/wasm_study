(module
  (func $even_check (param $n i32) (result i32)
    local.get $n
    i32.const 2
    i32.rem_u ;; 2で割った余り
    i32.const 0 ;; 偶数の余りは0になる
    i32.eq ;; $n % 2 == 0
  )

  (func $eq_2 (param $n i32) (result i32)
    local.get $n
    i32.const 2
    i32.eq ;; $n == 2
  )

  (func $multiple_check (param $n i32) (param $m i32) (result i32)
    local.get $n
    local.get $m
    i32.rem_u ;; $n % $mの余りを取得
    i32.const 0 ;; 余りが0かどうかを判定
    i32.eq ;; それにより $n が $m の倍数かどうかを判定
  )

  (func (export "is_prime") (param $n i32) (result i32)
    (local $i i32)
    (if (i32.eq (local.get $n) (i32.const 1))
      (then
        i32.const 0 ;; 1は素数ではない
        return
      )
    )

    ;; $n が 2 かどうかを判定
    (if (call $eq_2 (local.get $n))
      (then
        i32.const 1 ;; 2は素数
        return
      )
    )

    (block $not_prime
      (call $even_check (local.get $n))
      br_if $not_prime ;; $n が偶数ならば素数ではない

      (local.set $i (i32.const 1))

      (loop $prime_test_loop
        (local.tee $i
          (i32.add (local.get $i) (i32.const 2))) ;; $i += 2

        local.get $n ;; stack = [$n, $i]

        i32.ge_u ;; $i >= $n
        if ;; $i >= $n ならば $n は素数
          i32.const 1
          return
        end

        (call $multiple_check (local.get $n) (local.get $i))

        br_if $not_prime ;; $n が $i の倍数ならば素数ではない
        br $prime_test_loop ;; 素数ではないので次のループへ
      ) ;; $prime_test_loopの終わり
    ) ;; $not_primeの終わり
    i32.const 0 ;; falseを返す
  )
) ;; moduleの終わり
