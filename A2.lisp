
(defparameter *KB* (make-hash-table :test #'equal)) ;;definition of the knowledge base we shall use



;given fom professor
(defun dash-binary-keys (wff)
   ;````````````````
   ; wff: a list such as '(A B C D), containing no '-'
   ; Result: e.g., ((- B C D) (A - C D) (A B - D) (A B C -))
       (cond ((atom wff) wff)
             (t (cons (cons '- (cdr wff))
                      (mapcar #'(lambda (x) (cons (car wff) x))
                          (dash-binary-keys (cdr wff)))))))

(defun dash-nary-keys (wff)
    (setq n (- (list-length wff) 1))
    (setq toreturn '())
    (loop for i from 0 to n doing
        (setq temp (copy-list wff))
        (setf (nth i temp) '-)
        (setq toreturn (adjoin temp toreturn :test 'equal)  )
        (loop for j from 0 to n doing
            (setq temp2 (copy-list temp))
            (setf (nth j temp2) '-)
            (setq toreturn (adjoin temp2 toreturn :test 'equal) ) 
            (print temp2)
                
        )
    )
    toreturn
)

;lets store all our facts as described in our *KB*
(defun store-fact (wff) 
    (if (< (list-length wff) 3)
        (store-pair-fact wff)
         (store-longer-fact wff)
    )
   
)

(defun add-list-to-kb (list. value)
    (setq l (car list.)) ;; set l to the first element of the list
    (setq val (gethash l *KB*)) ;set val to be the gethas value of l from *kB*
    ;(print l)
    ;(print value)
    (setq myset '()) ;;create new set and add valueu
    (setq myset (adjoin value myset))
    (cond
        ((eq val nil);if we do not hve a value in place for this list
        
            (setf (gethash l *KB*) myset)
        )
        ( (not (eq val nil)) ;;else if we do have a value
        
            (setf (gethash l *KB*) (adjoin value val))
           ; (print val)
            
        
        
        )
       
    )
    (add-to-kb (cdr list.) value) ;calls rest of list
)

(defun add-to-kb (all-combos value)
  ;  (print all-combos)
    (if (eq all-combos nil)
        nil
        (add-list-to-kb all-combos value)
    )
)

(defun store-longer-fact (wff)
    (setf (gethash wff *KB*) T)
    (add-to-kb (dash-nary-keys wff) wff)
    (format t "Got to store-longer-fact~%")
)

(defun store-pair-fact (wff)
    (setf (gethash wff *KB*) T) ;set the actual list to true
    (add-to-kb (dash-binary-keys wff) wff)
)

(defun answer-whq (wff)
    (setq result (gethash wff *KB* ))
    (if (eq result nil)
        (print nil)
        (print result)
    )
)

(defun check-for-negation (wff)
   ;;check if query is length 2, thus we preform predicate testing
   (if (eq (list-length wff) 2)
        (has-predicate wff)
        (and (not (eq '- (car wff)))(member 'Robbie wff)) ;;else, we check if Robbie is included, as if he is, Robbie should theoretically
                            ;; know everything about himself. 
   )
)
(defun answer-question (wff)
    (setq result (gethash wff *KB*))
     (cond 
		((not (eq nil result)) (format nil "~a" result))
        ((and (eq nil result) (check-for-negation wff)) (format nil "(not (~a))" wff))
        ((eq result nil) (format nil "UNKNOWN"))
		(t (format nil "UNKNOWN"))
	)
)

(store-fact '(Owns Alice Snoopy))
(store-fact '(Is_a_robot Robbie))
(print "-------")
(answer-whq '(- Fucker))

; creating interactive repl 

(defun print-fun (f a) ;evaluate and print function "E, P"
	(format t "(~a ~a) => ~a ~%" f a (funcall f a))
)
(defun repl1(f) ;repl for part two. Enter elements in a list. Ex: (Robot Robbie)
	(format t "Enter arguments for ~a (q to stop): " f)
	(finish-output nil)
	(setq arg1 (read))
	(if (equalp (format nil "~a" arg1) "q") ;check for q
		nil
		(if (print-fun f arg1)
			nil
			(repl1 f)
		)		
	)

)
(repl1 'answer-question)

;(setq init (dash-nary-keys '(Owns Alice Snoopy)))
;print init)
;(setq test (dash-binary-keys (reverse (cdr (dash-binary-keys '(Owns Alice Snoopy))))))
;(print test)
;(store-fact '(Robot Robbie))
;(store-fact '(Robot Billy))
;(loop for k being each hash-key of *KB*
;	 do (format t "~%~a ~a~%" k (gethash k *KB*))
;)
