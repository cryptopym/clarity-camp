
;; dex

(use-trait sip-010-token .traits.ft-trait)

;; constants
;;
(define-constant CONTRACT_OWNER tx-sender)
(define-constant CONTRACT_ADDRESS (as-contract tx-sender))

;; errors
;;
(define-constant ERR_INVALID_TOKEN_VALUE (err u100))
(define-constant ERR_TOKEN_ALREADY_LISTED (err u101))

;; data maps and vars
;;
(define-data-var lastListingId uint u2000)

(define-map TokenListing uint {
    token: principal,
    seller: principal,
    tokenAmount: uint,
    price: uint,
    tokensLeft: uint
  }
)

(define-map UserTokens principal principal)

;; read-only functions
(define-read-only (get-token-listing (listingId uint))
  (map-get? TokenListing listingId)
)

;; public functions
;;
(define-public (list-sip10-token-for-sale (token <sip-010-token>) (tokenTotalAmount uint) (tokenPrice uint))
  (let
    (
      (newListingId (+ (var-get lastListingId) u1))
    )

    (asserts! (and (> tokenTotalAmount u0) (> tokenPrice u0)) ERR_INVALID_TOKEN_VALUE)
    (asserts! (is-none (map-get? UserTokens (contract-of token))) ERR_TOKEN_ALREADY_LISTED)

    ;; #[filter(tokenTotalAmount, tokenPrice, token)]
    (map-set TokenListing newListingId {
      token: (contract-of token),
      seller: tx-sender,
      tokenAmount: tokenTotalAmount,
      price: tokenPrice,
      tokensLeft: tokenTotalAmount
    })
    (map-set UserTokens (contract-of token) tx-sender)
    (var-set lastListingId newListingId)

    (try! (contract-call? token transfer tokenTotalAmount tx-sender CONTRACT_ADDRESS none))

    (ok newListingId)
  )
)

