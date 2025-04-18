(: Tree (-> $a Type))
(: mkTree (-> (Node $a) (List (Tree $a)) (Tree $a)))

(: Node (-> $a Type))
(: mkNode (-> $a (Node $a)))

(: NullVertex (Tree $a))
(: mkNullVex (-> (List (Tree $a)) (Tree $a)))

(: getChildren (-> Tree $a) (List (Tree $a)))
(= (getChildren (mkTree (mkNode $r) $children)) $children)
(= (getChildren (mkNullVex $children)) $children)

;---------------------------NOT QUITE SURE ON THIS ONE----------------------------------
(= (preOrder $tree (Cons $x $xs)))
     (let*
         (
           ($children (getChildren $tree))
           ($head (car-atom $tree))
           ($tail (cdr-atom $tree))
           ($lc  (List.map preOrder (Cons $head $tail)))
           ($lc' (List.filter (. not isUnit) $lc))
           ($lcE (List.listToExpr $lc'))
           ;; (()   (println! (Root: $r Children: $lc Children': $lc' Expression: $lcE)))
           ($exp (cons-atom $r $lcE))
         )
         $exp)

;---------------------------DONE----------------------------------
(: buildTree (-> $a (Tree $a)))
(= (buildTree $expr)
        (if (== (get-metatype $expr) Expression)
            (let ($head $tail) (decons-atom $expr)
                (mkTree (mkNode $head) (exprToList (map buildTree $tail))))
            (mkTree (mkNode $expr) Nil))
            )

;---------------------------DONE----------------------------------
;; Finds the NodeId of a subtree within the children of a target node.
;; Params:
;;   $tree: - The full tree to search.
;;   $targetId: - ID of the target node.
;;   $subtree: - The subtree to locate among the target node's children.
;;   $iter: - index to check children, increments recursively.
;; Returns:
;;   NodeId - The NodeId of the Subtree
(: getSubtreeId (-> (Tree $a) NodeId (Tree $a) Number NodeId))                      
(= (getSubtreeId $tree (mkNodeId $targetId) $subtree $iter)  
  (let* 
    (
      $targetNode (getNodeById $tree (mkNodeId $targetId))
      $childrenTgt (getChildren $targetNode)
      $currNode (List.getByIdx $childrenTgt $iter)
    )
    (if (== $currNode $subtree)
      (let $idOfSubtree (union-atom $targetId (+ $iter 1)))
        (mkNodeId $idOfSubtree))
      (getSubtreeId $tree (mkNodeId $targetId) $subtree (+ $iter 1))))


;---------------------------DONE----------------------------------
;; Retrieves the children list of a node identified by its NodeId.
;; Params:
;;   $tree: - The full tree to search.
;;   $id: - ID of the target node.
;; Returns:
;;   (List (Tree $a)) - The list of children of the target node.
(: getChildrenById (-> (Tree $a) NodeId (List (Tree $a))))
(= (getChildrenById $tree (mkNodeId $id))
   (let $targetNode (getNodeById $tree (mkNodeId $id))
     (getChildren $targetNode)))


;---------------------------DONE----------------------------------
;; Creates a new tree with a node inserted above the given tree as its parent.
;; Params:
;;   $tree: - The original tree to be placed as a child.
;;   $node: - The new node to become the root, wrapping $tree.
;; Returns:
;;   (Tree $a) - A new mkTree with $node as the root and $tree as its only child.
(: insertAbove (-> (Tree $a) (Node $n) (Tree $a)))
(= (insertAbove $tree $node)
   (mkTree $node (Cons $tree Nil))
)

;---------------------------NOT SURE----------------------------------
;; Replaces a subtree at a specific NodeId with a new subtree.
;; Params:
;;   $tree: - The tree to modify.
;;   $id: - ID of the node to be replace.
;;   $newSubtree: - The new subtree to insert.
;; Returns:
;;   (Tree $a) - The updated tree with $newSubtree at $id.
(: replaceNodeById (-> (Tree $a) NodeId (Tree $a) (Tree $a)))
(= (replaceNodeById $tree (mkNodeId $id) $newSubtree)
    (if (== $id ())  
       $newSubtree
       (let*
         (
           ($children (getChildren $tree))
           (let ($headId $tailId) (decons-atom $id))
           ($childToUpdate (List.getByIdx $children (- $headId 1)))
           ($updatedChild (if (== $tailId ())
                              $newSubtree
                              (replaceNodeById $childToUpdate (mkNodeId $tailId) $newSubtree)))
           ($newChildren 
             (if (== $headId 0)
               $children  
               (List.replaceAt $children (- $headId 1) $updatedChild)
             )
           )
         )
         (mkTree (mkNode $r) $newChildren))))


;---------------------------DONE----------------------------------
;; Appends a child to a target node's children and returns the updated tree and child's NodeId.
;; Parameters:
;;   $tree: - The tree to modify.
;;   $target: - ID of the target node
;;   $child: - The new child to append.
;; Returns:
;;   ((Tree $a) NodeId) - Tuple of updated tree and NodeId of the new child.    
(: appendChild (-> (Tree $a) NodeId (Tree $a) ((Tree $a) NodeId)))
(= (appendChild $tree (mkNodeId $target) $child)
   (let*
     (
       ($targetNode (getNodeById $tree (mkNodeId $target)))
       ($targetChildren (getChildren $targetNode))
       ($updatedChildrenTgt (List.append $child $childrenTgt))
       ($childIndex (List.length $updatedChildrenTgt))
       ($idOfChild (union-atom $target ($childIndex)))
       ($newTargetSubtree (mkNullVex $updatedChildrenTgt))
       ($updatedTree (replaceNodeById $tree (mkNodeId $target) $newTargetSubtree))
     )
      
      ($updatedTree (mkNodeId $idOfChild))))       