(define-trait locked-wallet-trait
    (
        (lock (principal uint uint) (response bool uint))
        (bestow (principal) (response bool uint))
        (claim () (response bool uint))
    )
)
