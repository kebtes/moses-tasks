(= (is-leaf? $node)
    (if (== (get-metatype $node) Symbol)
        True
        False
    )
)

(= (get-nodes-by-level $expr $level $curr-level)
    (if (== $expr ())
        ()
        (if (== $level $curr-level)
            (if (== (is-leaf? $expr) True)
                $expr
                (car-atom $expr)
            ) 
            
            (let* (
                    ($children (cdr-atom $expr))
                    ($left-side (if (== $children ()) () (car-atom $children)))
                    ($right-side (if (== $children ()) () (cdr-atom $children)))
                
                )
                
                (if (== $children ())
                    ()
                    (let $left-side-return (get-nodes-by-level $left-side $level (+ $curr-level 1))
                        (let $right-side-return 
                            (if (== $right-side ())
                                ()
                                (get-nodes-by-level (car-atom $right-side) $level (+ $curr-level 1))
                            )
                            
                            (cons-atom $left-side-return ($right-side-return))
                        )
                    )
                )
            )
        )
    )
)


(= (get-nth-node $nodes $i)
    (let*
        (
            ($j (trunc-math (/ $i 2)))
            ($jth (index-atom $nodes $j))

        )

        (if (== (% $i 2) 0)
            (index-atom $jth 0)
            (index-atom $jth 1)
        )
    )

    
)

(= (get-node-by-id $expr $id)
    (let $level (car-atom $id)
    (let $nth (cdr-atom $id)
        (let $level-nodes (get-nodes-by-level $expr $level 0)
            (get-nth-node $level-nodes $nth)
        )
    ))
)

! (get-node-by-id (AND (OR A B) (NOT A)) (1 0))
; 
; ! (get-nth-node ((A B) (A ())) 3)
