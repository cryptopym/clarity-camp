(use-trait locked-wallet-trait 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.locked-wallet-trait.locked-wallet-trait)

(define-public (claim-wallet (wallet-contract <locked-wallet-trait>))
  (ok (try! (as-contract (contract-call? wallet-contract claim))))
)

;; (contract-call? .example-contract claim-wallet .timelocked-wallet)
