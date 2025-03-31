$; since the id doesnt need to be universal, we could use the node's position on the tree as its id
;
; (l i) : the id would be in the form of a list/tuple
; l -> level/depth of the node in the tree
; i -> index of the node in the level
;
; we perform a bfs on the tree, once we get all the nodes that are at the level l
; we traverse the output list and get the node at index i
; ---------------------------------------------------------------------------------------


; helper function to get the total length of a list
(= (len $list)
    (if (== $list ())
        0
        (+ 1 (len (cdr-atom $list)))
    )
)

; helper function to determine if a node is leaf or not
; if the node is of type Symbol (generally not of type Expression), then it is a leaf
(= (is-leaf? $node)
    (if (== (get-metatype $node) Symbol)
        True
        False
    )
)

; helper function
; traverses the level nodes and return the node at index i
; params: $level-nodes: the list of nodes at the level
;         $total-nodes: the total number of nodes at the level, function "len" is used to get this
;         $i: the index of the node to be returned
;         $j: the current index of the node being traversed
; returns: the node at index i
;          or an error if the index is out of bounds
(= (get-nth-node $level-nodes $total-nodes $i $j)
    (if (or (== $level-nodes ()) (>= $i $total-nodes))
        (Error: index out of bound)
        (if (== $i $j)
            (let $head (car-atom $level-nodes)
                (if (== (get-metatype $head) Expression)
                    (car-atom $head)
                    $head
                )
            )

            (if (== (get-metatype $level-nodes) Symbol)
                (get-nth-node ($level-nodes) $total-nodes $i (+ $j 1))
                (get-nth-node (cdr-atom $level-nodes) $total-nodes $i (+ $j 1))
            )
        )
    )
)

; helper function
; performs a bfs operation by treating the expression as a binary tree and returns the all nodes at the level l
; params: $expr: the expression to be traversed
;         $level: the level to be traversed
;         $curr-level: the current level / depth of the function is currently at
; returns: the nodes at the level l
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
                            
                            (if (== (get-metatype $right-side-return) Expression)
                                (cons-atom $left-side-return $right-side-return)
                                (cons-atom $left-side-return ($right-side-return))
                            )
                        )
                    )
                )
            )
        )
    )
)

; the main function that is meant to be called to retrieve a node with a specific id
; params: $expr: the expression to be traversed (AND (OR A B) (NOT A))
;         $id: the id of the node to be retrieved
; returns: the node at the id
;          or an error if the id is out of bounds
(= (get-node-by-id $expr $id)
    (let $level (car-atom $id)
    (let $nth (cdr-atom $id)
        (let $level-nodes (get-nodes-by-level $expr $level 0)
            (get-nth-node $level-nodes (len $level-nodes) (car-atom $nth) 0)
        )
    ))
)

; example usages
; (AND (OR A B) (NOT A))
; level 0:          AND
; level 1:      OR      NOT
; level 2:    A   B        A

; current issues with "get-nodes-by-level" function
; at line 86 - 87 i used cons-atom to concatenate the lists from the recursive output
; cons-atom left-side right-side
;
; issues with this is that, if left-side is of type Expression, it treats is as one entity
; for instance cons-atom (1) (2 3) outputs ((1) 2 3) instead of (1 2 3)
;
; the "get-nth-node" expects the input Expression to be flattend, not nested
; hence, doesn't particulary work with some instances -- still trying to get a work around with this
; other than this, everything works fine.

! (get-nodes-by-level (AND (OR A B) (NOT A)) 0 0) ; output -> AND
! (get-nodes-by-level (AND (OR A B) (NOT A)) 1 0) ; output -> (OR NOT)
! (get-nodes-by-level (AND (OR A B) (NOT A)) 2 0) ; output -> ((A B) A) instead of (A B A)

! (get-node-by-id (AND (OR A B) (NOT A)) (1 0))
