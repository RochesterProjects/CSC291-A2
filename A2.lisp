
(defparameter *KB* (make-hash-table :test #'equal)) ;;definition of the knowledge base we shall use



;given fom professor
(defun dash-keys (wff)
   ;````````````````
   ; wff: a list such as '(A B C D), containing no '-'
   ; Result: e.g., ((- B C D) (A - C D) (A B - D) (A B C -))
       (cond ((atom wff) wff)
             (t (cons (cons '- (cdr wff))
                      (mapcar #'(lambda (x) (cons (car wff) x))
                          (dash-keys (cdr wff)))))))



;lets store all our facts as described in our *KB*
(defun store-fact (wff) 
    (if (< (list-length wff) 3)
        (store-pair-fact wff)
         (store-longer-fact wff)
    )
   
)

(defun add-list-to-kb (list. value)
    (setq l (car list.))
    (setq index (gethash l *KB*))
    ;(print l)
    ;(print value)
    (setq myset '()) ;;create new set and add valueu
    (setq myset (adjoin l myset))
    (cond
        ((eq index nil);if we do not hve a value in place for this list
        
            (format t "No index")
            (setf (gethash l *KB*) value)
        )
        ((not (eq index nil)) 
        (
            ;(if (not (member index value))
            ;    (setf (gethash l *KB*) (adjoin index value))
            ;    nil
            ;)
            (format t "Got here")
        )
        )
        (t (format t "Fuclk"))
    )
    (add-to-kb (cdr list.) value)
)

(defun add-to-kb (all-combos value)
  ;  (print all-combos)
    (if (eq all-combos nil)
        nil
        (add-list-to-kb all-combos value)
    )
)

(defun store-longer-fact (wff)
    (format t "Got to store-longer-fact~%")
)

(defun store-pair-fact (wff)
    (setf (gethash wff *KB*) T) ;set the actual list to true
    (add-to-kb (dash-keys wff) wff)
)

;(store-fact '(A B C))
;(print(dash-keys '(Robot Robbie)))
(store-fact '(Robot Robbie))
(loop for k being each hash-key of *KB*
	 do (format t "~%~a ~a~%" k (gethash k *KB*))
)
