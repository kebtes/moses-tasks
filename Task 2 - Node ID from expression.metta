$; since the id doesnt need to be universal, we could use the node's position on the tree as its id
;
; (l i) : the id would be in the form of a list/tuple
; l -> level/depth of the node in the tree
; i -> index of the node in the level
;
; we perform a bfs on the tree, once we get all the nodes that are at the level l
; we traverse the output list and get the node at index i
; ---------------------------------------------------------------------------------------


; ; helper function to get the total length of a list
; (= (len $list)
;     (if (== $list ())
;         0
;         (+ 1 (len (cdr-atom $list)))
;     )
; )

; helper function to determine if a node is leaf or not
; if the node is of type Symbol (generally not of type Expression), then it is a leaf
(= (is-leaf? $node)
    (if (== (get-metatype $node) Symbol)
        True
        False
    )
)
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
            ($jth (if (== (get-metatype $nodes) Symbol) (index-atom ($nodes) $i) (index-atom $nodes $i)))
        )

        (if (== (get-metatype $jth) Symbol)
            $jth
            (if (== (% $i 2) 0)
                (index-atom $jth 0)
                (index-atom $jth 1)
            )
        )
    )
)

(= (get-node-by-id $expr $id)
    (let $level (car-atom $id)
    (let $nth (cdr-atom $id)
        (let $level-nodes (get-nodes-by-level $expr $level 0)
            (get-nth-node $level-nodes (car-atom $nth))
        )
    ))
)

! (get-node-by-id (AND (OR A B) (NOT A)) (1 0)) ; or