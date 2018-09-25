#lang racket
;;;;;;;;;;;;;;;;;;GUI;;;;;;;;;;;;;;;;;;;
(define (func)
  (define temp (send input get-value))
  (define ans (print-solution temp))
  (send output set-value ans)
  (define inc (incorrect-list temp))
  (send incorrect-words update-choices inc))
  

(define mainframe (new frame%
                       [label "CorRacketify"]
                       [width 800]
                       [height 800]
                       [enabled #t]
                       [border 5]))

(send mainframe show #t)

(define panel1 (new horizontal-panel%
                    [parent mainframe]))

(define input (new text-field%
                   [parent panel1]
                   [label "Enter Your Text Here"]
                   [min-height 100]
                   [style (list 'multiple)]

                   [vert-margin 0]))
(define correct-button(new button%
                           [label "Correct It!"]
                           [parent panel1]
                           [callback (lambda (x y) (func))]
                           ))
(define panel2 (new horizontal-panel%
                    [parent mainframe]))

(define output (new text-field%
                    [parent panel2]
                    [label "Parsed Text"]
                    [min-height 100]
                    [horiz-margin 60]
                    [vert-margin 0]))

(define panel3 (new horizontal-panel%
                    [parent mainframe]))

(define incorrect-words 
  (new (class combo-field%
         (super-new)
         
         (inherit get-menu append)
         
         (define/public (update-choices choice-list)
           ; remove all the old items
           (map
            (lambda (i)
              (send i delete))
            (send (get-menu) get-items))
           ; set up the menu with all new items
           (map
            (lambda (choice-label)
              (append choice-label))
            choice-list)
           (void)
           ))
       [parent panel3]
       [label "Incorrect-Words"] 
       [choices '()]
       [callback (lambda (x y) (send suggestions update-choices (smart-correction (send x get-value) 1)))]
       ))

(define suggestions
  (new (class combo-field%
         (super-new)
         
         (inherit get-menu append)
         
         (define/public (update-choices choice-list)
           ; remove all the old items
           (map
            (lambda (i)
              (send i delete))
            (send (get-menu) get-items))
           ; set up the menu with all new items
           (map
            (lambda (choice-label)
              (append choice-label))
            choice-list)
           (void)
           ))
       [parent panel3]
       [label "Suggestions"] 
       [choices '()]
       [callback (lambda (x y) (define word (send x get-value))
                   (set! sug word))]
       ))
(define add-button (new button%
                           [label "Add To Dictionary"]
                           [parent panel3]
                           [callback (lambda (x y) (map modify-vec (hasher sug))
                                       (set! dictree (add dictree sug)))]
                           ))

(define sug #f)