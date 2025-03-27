; type and data structure definition
(: List Type)

; the structure may or may not be empty
(= List (or Nil (Cons Number List)))

; constructors
(: Nil List) ;empty list                          
(: Cons (-> Number List List)) ; cons takes a num and a list, returns a list

; --------------------------------------------------------------------------

; append method definition
; the append method accepts two lists as its parameter, and returns the list at the end
(: append (-> List List List))

; base case when the list is empty
(= (append Nil $ys) 
    $ys)

(= (append (Cons $x $xs) $ys) 
    (Cons $x (append $xs $ys)))

; examples usage
(= list1 (Cons 1 (Cons 2 Nil)))     
(= list2 (Cons 3 (Cons 4 Nil)))     

(= combined (append (eval list1) (eval list2))) 
! (eval combined)                   ; (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil))))

; in cases where we may want to append a single value to the data structure
; we have to do it in this way by using the cons to define a single valued list
(= append_result (append (eval list1) (Cons 4 Nil)))
! (eval append_result)              ; (Cons 1 (Cons 2 (Cons 4 Nil)))

; --------------------------------------------------------------------------

; get_by_index method definition
; the method accepts a list and a number (value) as its parameter and returns a number (value)
(: get_by_index (-> List Number Number))

; recursive approach for non zero index
; we continously decrement the index value and continue operating on the tail
(= (get_by_index (Cons $x $xs) $idx)
    (if (== $idx 0) 
        $x
        (get_by_index $xs (- $idx 1))
    )
)

; error definition for an empty list
(= (get_by_index Nil $n) (error "index out of bounds"))

; --- example usage ---
(= first_num (get_by_index (eval list1) 0))             ; 1
(= second_num (get_by_index (eval list1) 1))            ; 2
(= index_out_bound (get_by_index (eval list1) 2))       ; error "index out of bounds"
! (eval first_num)
! (eval second_num)
! (eval index_out_bound)
