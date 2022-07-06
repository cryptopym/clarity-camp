
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
(define-constant ERR_LISTING_NOT_FOUND (err u102))
(define-constant ERR_UNAUTHORIZED (err u103))
(define-constant ERR_INVALID_TOKEN (err u104))

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

(define-public (add-tokens (listingId uint) (token <sip-010-token>) (amount uint))
  (let
    (
      (listing (unwrap! (map-get? TokenListing listingId) ERR_LISTING_NOT_FOUND))
    )

    (asserts! (> amount u0) ERR_INVALID_TOKEN_VALUE)
    (asserts! (is-eq (get seller listing) tx-sender) ERR_UNAUTHORIZED)
    (asserts! (is-eq (get token listing) (contract-of token)) ERR_INVALID_TOKEN)

    (map-set TokenListing listingId 
      (merge listing {
        tokenAmount: (+ (get tokenAmount listing) amount), 
        tokensLeft: (+ (get tokensLeft listing) amount)
      })
    )

    (try! (contract-call? token transfer amount tx-sender CONTRACT_ADDRESS none))

    (ok true)
  )
)

