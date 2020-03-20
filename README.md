# CSC291-A2

# To run 
run your favorite CLISP complier, then type in (load "A2") \n
You will get repl testing for answer-whq, followed by answer-question, followed by answer-question-nicely \n

# Inputs you can try: 
Inputs for answer-whq and answer-question can follow from these following examples...\n
answer-question-nicely: \n

(ANSWER-QUESTION-NICELY (IS_A_ROBOT -)) => ((ROBBIE IS A ROBOT)) \n
(ANSWER-QUESTION-NICELY (IS_CONCIOUS -)) => ((ALICE IS CONCIOUS) (ROBBIE IS CONCIOUS)) \n
(ANSWER-QUESTION-NICELY (IS_CONCIOUS FREDDY)) => (It Is Not The Case That FREDDY IS CONCIOUS) \n
(ANSWER-QUESTION-NICELY (OWNS ROBBIE -)) => (It Is Not The Case That ROBBIE OWNS ANYTHING) \n
(ANSWER-QUESTION-NICELY (HATES ROBBIE -)) => (It Is Not The Case That ROBBIE HATES ANYTHING)  \n
(ANSWER-QUESTION-NICELY (HATES FREDDY -)) => UNKNOWN \n
(ANSWER-QUESTION-NICELY (LIKES - -)) => ((FREDDY LIKES SNOOPY) (SNOOPY LIKES FREDDY) (ALICE LIKES ROBBIE) (ALICE LIKES FREDDY) (ALICE LIKES SNOOPY) (ROBBIE LIKES ALICE) (ROBBIE LIKES SNOOPY)) \n
(ANSWER-QUESTION-NICELY (- - ROBBIE)) => ((ALICE LIKES ROBBIE)) \n
(ANSWER-QUESTION-NICELY (IS_CLEVER -)) => ((ALICE IS CLEVER) (ROBBIE IS CLEVER)) \n

You can also try several other queries, look at the knowledge base for more inspiration!

# Structure of Code
(store-fact wff) : takes a list, wff, generates all possible slot filling combinations, and adds to global knowledgebase. \n
-> uses (dash-binary keys), (dash-nary-keys) to generate the combos \n
-> uses (add-list-to-kb), (add-to-kb) to add the lists as specified to the KB \n
-> uses (store-pair-fact), (store-longer-fact) to begin process. \n

(answer-whq): simply just a query into KB \n
(answer-question): extends answer-whq by adding (not(...)) when neccesary. \n
-> uses (has-predicate), (check-negation) to make sure we do it right. \n
(answer-question-nicely): extends (answer-question) to print in nicer english \n
->uses split-str and corresponding helper to split Is_a_robot forms of predicates \n
->uses (print-nice-helper-2), (print-nice-helper-3) to format list. \n
->uses print affirmative and print negation to add respective forms. \n