
(defparameter *KB* (make-hash-table :test #'equal)) ;;definition of the knowledge base we shall use



;given fom professor
(defun dash-keys (wff)
   ;````````````````
   ; wff: a list such as '(A B C D), containing no '-'
   ; Result: e.g., ((- B C D) (A - C D) (A B - D) (A B C -))
       (cond ((atom wff) wff)
             (t (cons (cons '- (cdr wff))
                      (mapcar #'(lambda (x) (cons (car wff) x))
                          (-keys (cdr wff)))))))



;lets store all our facts as described in our *KB*
(defun store-fact (wff) 
    (if (< (list-length wff) 3)
        (store-pair-fact wff)
         (store-longer-fact wff)
    )
   
)

(defun add-list-to-kb (l value)
    (setq index (gethash l *KB*))
    (cond
        ((eq index nil));if we do not hve a value in place for this list
        (
            (setq myset '()) ;;create new set and add valueu
            (adjoin l myset)
            (setf (gethash l *KB*) myset)
        )
        ((not (eq index nil))) 
        (
            (if (not (member index value))
                (setf (gethash l *KB*) (adjoin index value))
            )
        )
    )
)

(defun add-to-kb (all-combos value)
    (if (eq all-combos nil)
        nil
        (add-list-to-kb (car all-combos) value)
    )
    (add-to-kb (cdr all-combos) value)
)

(defun store-longer-fact (wff)
    (format t "Got to store-longer-fact~%")
)

(defun store-pair-fact (wff)
    (setf (gethash wff *KB*) T) ;set the actual list to true
    (add-to-kb (dash-keys wff) wff)
)

;(store-fact '(A B C))
(store-fact '(Robot Robbie))
(loop for k being each hash-key of *KB*
	 do (print k)
)
