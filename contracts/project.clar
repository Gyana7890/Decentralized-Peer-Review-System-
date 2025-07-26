;; Decentralized Peer Review System
;; Two main functions: submit-review and get-review

;; Map to store review data by submission ID
(define-map reviews (buff 32) (tuple (reviewer principal) (rating uint) (comment (buff 256))))

;; Constants
(define-constant err-empty-comment (err u201))
(define-constant err-invalid-rating (err u202))
(define-constant err-review-not-found (err u203))

;; Submit a review for a submission
(define-public (submit-review (submission-id (buff 32)) (rating uint) (comment (buff 256)))
  (begin
    (asserts! (<= rating u10) err-invalid-rating)
    (asserts! (> rating u0) err-invalid-rating)
    (asserts! (> (len comment) u0) err-empty-comment)
    (map-set reviews submission-id {
      reviewer: tx-sender,
      rating: rating,
      comment: comment
    })
    (ok true)))

;; Retrieve review for a submission
(define-read-only (get-review (submission-id (buff 32)))
  (let ((maybe-review (map-get? reviews submission-id)))
    (match maybe-review review
      (ok review)
      err-review-not-found)))
