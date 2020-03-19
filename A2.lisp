(setq ext:*warn-on-redefinition*)



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

(defun dash-nary-keys (wff) ;; for n length'd keys
    (setq n (- (list-length wff) 1))
    (setq toreturn '()) ;create a set
    (loop for i from 0 to n doing ;;add all combinations of slot filled forms of wff
        (setq temp (copy-list wff))
        (setf (nth i temp) '-)
        (setq toreturn (adjoin temp toreturn :test 'equal)  ) ;;adjoin them to toreturn as to not get duplicates
        (loop for j from 0 to n doing
            (setq temp2 (copy-list temp))
            (setf (nth j temp2) '-)
            (setq toreturn (adjoin temp2 toreturn :test 'equal) ) 
                
        )
    )
    toreturn
)

(defun append(l1 l2) ;my append, two lists, l2 being appended to l1 .
	(append-aux (reverse l1) l2) ;reversing the list so conforms with -aux
)
(defun append-aux(l a)
	(if (eq l nil)
		a
		(append-aux (cdr l) (cons (car l) a)  ) ;building a reversed appended list

	)

)

(defun addtoend(n l) ;add value to end of list
	(setq l1 (reverse(cons n (reverse l) ) )) ;building a new list that first adds the element to the front of the reversed list, then reverses it
    l1

)

;lets store all our facts as described in our *KB*
(defun store-fact (wff) 
    (if (< (list-length wff) 3)
        (store-pair-fact wff) ;For predicated facts
         (store-longer-fact wff) ;For longer formed facts
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

(defun add-to-kb (all-combos value) ;; take a list of slot filled combinations and the value
  ;  (print all-combos)
    (if (eq all-combos nil)
        nil
        (add-list-to-kb all-combos value)
    )
)

(defun store-longer-fact (wff)
    (setf (gethash wff *KB*) T) ; set the actual list to true
    (add-to-kb (dash-nary-keys wff) wff) ;;add every slot-filled combination to knowledgebase 
)

(defun store-pair-fact (wff)
    (setf (gethash wff *KB*) T) ;set the actual list to true
    (add-to-kb (dash-binary-keys wff) wff) ;;add every slot-filled combination to knowledgebase 
)

(defun answer-whq (wff)
    (setq result (gethash wff *KB* ))
    (if (eq result nil)
        (format nil "NIL")
        (format nil "~a" result)
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

;;answer question as specified 
(defun answer-question (wff)
    (setq result (gethash wff *KB*))
     (cond 
		((not (eq nil result)) (format nil "~a" result))
        ((and (eq nil result) (check-for-negation wff)) (format nil "(not (~a))" wff))
        ((eq result nil) (format nil "UNKNOWN"))
		(t (format nil "UNKNOWN"))
	)
)

(defun split-str (string separator ) ;; recursive defintion of split string and a seperator
  (split-helper string separator))

(defun split-helper (string separator &optional(r nil)) ;;set 
  (let ((n (position separator string
		     :from-end t ;;work backwords and seperate string 
		     :test #'(lambda (x y)
			       (find y x :test #'string=))))) ;;testing seperator from the end...
    (if n
	(split-helper (subseq string 0 n) separator (cons (subseq string (1+ n)) r)) ;;rebuild string bottom up
      (cons string r))))


;for lists of 3 terms, use this helper funtion...
(defun print-nice-helper-3 (term)
    (setq templist '(temp))
    (setq splitted (split-str (write-to-string (car term)) "_"))
    (setq templist (append templist splitted))
    (setf (nth 0 templist) (car (cdr term)))
    (setq templist (append templist (list (car (cdr (cdr term)))) )) ;; takes (Owns Robbie Snoopy) converts to (Robbie Owns Snoopy)
    templist
)

(defun print-nice-helper-2 (term)
    (setq templist '(temp))
    (setq splitted  (split-str (write-to-string (car term)) "_")) ;delimits _... st that IS_a_robot => is a robot
    (setq templist (append templist splitted ))
    (setf (nth 0 templist) (car (cdr term))) 
    
    templist
)

(defun print-nice-affirmative (wff result)
    (setq toreturn '())
    (if (eq result T) ;;if we are querying a full list 
        (if (eq 2 (list-length wff)) ;know that there is only one vlaue to print nicely, not a list. 
            (setq toreturn (print-nice-helper-2 wff))
            (setq toreturn (print-nice-helper-3 wff))
        )
        (progn ;;else, covnert every list in value to a nicer one. 
        (loop for term in result doing
            (setq templist '())
            (if (eq (list-length term) 2)
                (setq templist (print-nice-helper-2 term))
                (setq templist (print-nice-helper-3 term))
            )
            (setq toreturn (addtoend templist toreturn))
        )
        )
    )
    toreturn
)

(defun print-nice-negation (wff result)
    (setq toreturn '())
    (if (eq result nil)
        (if (eq 2 (list-length wff))
            (setq toreturn (print-nice-helper-2 wff))
            (setq toreturn (print-nice-helper-3 wff))
        )
        nil
    )       ;;negation formatting
            (setq toreturn (cons "That" toreturn))
            (setq toreturn (cons "Case" toreturn))
            (setq toreturn (cons "The" toreturn))
            (setq toreturn (cons "Not" toreturn))
            (setq toreturn (cons "Is" toreturn))
            (setq toreturn (cons "It" toreturn))
    (if (equalp (last toreturn) '(-))
        (setf (nth (- (list-length toreturn) 1) toreturn) "NOTHING") ;;checks for the last dash
        nil
    )       
        
    
    toreturn

)

;;;main functiom
(defun answer-question-nicely (wff)
     (setq result (gethash wff *KB*))
     (cond 
		((not (eq nil result)) (print-nice-affirmative wff result))
        ((and (eq nil result) (check-for-negation wff)) (print-nice-negation wff result))
        ((eq result nil) (format nil "UNKNOWN"))
		(t (format nil "UNKNOWN"))
	)

)

;; storing facts!!!
(store-fact '(Owns Alice Snoopy))
(store-fact '(Owns Alice Freddy))
(store-fact '(Is_a_dog Snoopy))
(store-fact '(Is_a_dog Freddy))
(store-fact '(Is_concious Robbie))
(store-fact '(Is_concious Alice))
(store-fact '(Is_a_robot Robbie))
(store-fact '(Is_clever Robbie))
(store-fact '(Likes Robbie Snoopy))
(store-fact '(Likes Robbie Alice))
(store-fact '(Likes Alice Snoopy))
(store-fact '(Likes Alice Freddy))
(store-fact '(Likes Alice Robbie))
(print "-------")
;(answer-whq '(- Robbie))
(print (answer-question-nicely '(Owns Alice Snoopy)))
(print (answer-question-nicely '(- Robbie)))
(print (answer-question-nicely '(Hates Robbie -)))
(print (answer-question-nicely '(- Robbie BrooklynBridge)))
(print (answer-question-nicely '(Likes Robbie Freddy)))



; creating interactive repl 
(defun print-fun (f a) ;evaluate and print function "E, P"
	(format t "(~a ~a) => ~a ~%" f a (funcall f a))
)
(defun repl1(f) ;repl . Enter elements in a list. Ex: (Robot Robbie)
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

