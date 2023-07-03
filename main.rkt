#lang racket

(require metapict)
(require metapict/save-pdf)

(define PICT-DIR (box ""))
(define PICT-NAME (box ""))

(define (merge pict-list)
  (cond 
    [(eq? pict-list '()) (filled-rectangle 0 0)]
    [else
     (let* ([pict (bitmap (build-path (unbox PICT-DIR) (car pict-list)))]
            [line (filled-rectangle (pict-width pict) 10)])
       (vl-append pict line (merge (cdr pict-list))))]))

(module+ main
  (require racket/cmdline)  

  (command-line
   #:program "mdp"
   #:once-each
   [("-p" "--path") path "the input pictures directory path" (set-box! PICT-DIR path)]
   [("-n" "--name") name "the output picture name" (set-box! PICT-NAME name)]
   #:args ()
   (save-pict-as-pdf (merge (directory-list (unbox PICT-DIR)))
                     (string-append (unbox PICT-NAME) ".pdf"))))
