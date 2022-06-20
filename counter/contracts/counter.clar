;; contract that will increment the value of var

;; data maps and vars
(define-data-var count uint u0)

;; public functions
(define-read-only (get-count)
  (var-get count)
) 

(define-public (count-up)
  (ok (var-set count (+ (var-get count) u1)))
)

;; (define-public (send (amount uint) (receiver principal))
;;   (ft-transfer? mialgo amount tx-sender receiver)
;; )