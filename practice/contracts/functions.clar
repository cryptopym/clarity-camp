
(define-constant contract-owner tx-sender)

(define-data-var odd-values uint u0)

(define-public (count-odd (number uint))
    (begin
        ;; increment the "event-values" variable by one.
        (var-set odd-values (+ (var-get odd-values) u1))
        
        ;; check if the input number is odd
        (if (not (is-eq (mod number u2) u0))
            (ok "the number is odd")
            (err "the number is even")
        )
    )
)

(define-read-only (get-odd-values)
  (var-get odd-values)
)

;; (contract-call? .functions count-odd u21)
;; (contract-call? .functions get-odd-values)

(define-private (is-valid-caller)
    (is-eq tx-sender)
)
