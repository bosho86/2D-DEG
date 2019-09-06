
(define Lc @Lchannel@);
(define Ld @Ldrain@);
(define W @Wbottom@);
(define tox @Thfo2@);
(define r @ref@);
(define thintop (+ W tox))
(define thinbot (+ tox))
(define toptox (+ W tox));
(define mtc @Metalcontact@);
(define topcon (+ mtc W tox ));
(define botcon (+ mtc tox ));
(define Ldrain (+ Lc Ld));
(define R1 (+ Lc r))
(define R2 (- Lc r))
(define R3 (+ W r))
(define R4 (- W r))



(sdegeo:create-rectangle (position 0.0 thintop  0.0) (position Lc topcon  0.0)	"Tungsten"  "metal1")

(sdegeo:create-rectangle (position 0.0 0.0 0.0)	(position Lc W 0.0)	"InGaAs" "semi1")
(sdegeo:create-rectangle (position  Lc 0.0 0.0)	(position Ldrain W 0.0)	"InGaAs" "drain")
(sdegeo:create-rectangle (position (- Ld) 0.0 0.0)	(position 0.0 W 0.0)	"InGaAs" "source")

(sdegeo:create-rectangle (position (- Ld) (- tox) 0.0) (position Ldrain 0.0 0.0) "HfO2" "oxide6")
(sdegeo:create-rectangle (position (- Ld) W 0.0) (position Ldrain toptox 0.0)	"HfO2" "oxide7")


(sdegeo:create-rectangle (position 0.0 (- botcon) 0.0) (position Lc (- tox) 0.0) "Tungsten"  "metal2")


(define topcontact (find-edge-id (position 0.005 thintop 0.0)))
(sdegeo:define-contact-set "top")
(sdegeo:set-current-contact-set "top")
(sdegeo:set-contact-edges topcontact)
(define bottomcontact (find-edge-id (position 0.005 (- tox) 0.0)))
(sdegeo:define-contact-set "bottom")
(sdegeo:set-current-contact-set "bottom")
(sdegeo:set-contact-edges bottomcontact)


(define draincontact (find-edge-id  (position Ldrain tox 0.0)))
(sdegeo:define-contact-set "drain")
(sdegeo:set-current-contact-set "drain")
(sdegeo:set-contact-edges draincontact)

(define sourcecontact (find-edge-id (position (- Ld) tox 0.0)))
(sdegeo:define-contact-set "source")
(sdegeo:set-current-contact-set "source")
(sdegeo:set-contact-edges sourcecontact)


(sdegeo:delete-region (list (car (find-body-id (position 0.0075 -0.0038 0)))))
(sdegeo:delete-region (list (car (find-body-id (position 0.0075 0.0108 0)))))



(sdeio:save-tdr-bnd (get-body-list) "n@node@_bnd.tdr")


(sdedr:define-constant-profile "substratedoping" "BoronActiveConcentration" @Channeldoping@)
(sdedr:define-constant-profile "contactdoping" "ArsenicActiveConcentration" @ContactDoping@)
(sdedr:define-constant-profile "pato" "BoronActiveConcentration" 1e6)
(sdedr:define-constant-profile "substratemolefraction" "xMoleFraction" 0.47)

(sdedr:define-constant-profile-region "substratedoping11" "substratedoping" "semi1")
(sdedr:define-constant-profile-region "contactdoping11" "contactdoping" "drain")
(sdedr:define-constant-profile-region "contactdoping1" "contactdoping" "source")
(sdedr:define-constant-profile-region "contapato" "pato" "drain")
(sdedr:define-constant-profile-region "contapato2" "pato" "source")
(sdedr:define-constant-profile-region "substratemolefraction11" "substratemolefraction" "semi1")
(sdedr:define-constant-profile-region "substratemolefraction1" "substratemolefraction" "source")
(sdedr:define-constant-profile-region "substratemolefraction2" "substratemolefraction" "drain")


(sdedr:define-refinement-size "Ref.global" 0.001 0.001 0.0006 0.0006)
(sdedr:define-refinement-size "Ref.isolator" 0.0009 0.0009 0.0006 0.0006)
(sdedr:define-refinement-size "Ref.channel" 0.0009 0.0009 0.0006 0.0006)

(sdedr:define-refinement-region "ref.semi1" "Ref.channel" "semi1")
(sdedr:define-refinement-region "ref.drain" "Ref.isolator" "drain")
(sdedr:define-refinement-region "ref.source" "Ref.isolator" "source")
(sdedr:define-refinement-material "ref.oxide" "Ref.isolator" "HfO2")
(sdedr:define-refinement-material "ref.metal1" "Ref.isolator" "Tungsten")

(sdedr:define-refeval-window "RefWin1" "Rectangle" (position R2 (- r) 0.0)	(position R1 R3 0.0))
(sdedr:define-refinement-size "Ref.interface" 0.0005 0.0005 0.0004 0.0004)
(sdedr:define-refinement-placement "Place.int1" "Ref.interface" "RefWin1")

(sdedr:define-refeval-window "RefWin2" "Rectangle" (position (- r) 0.0 0.0)	(position r R3 0.0))
(sdedr:define-refinement-placement "Place.int2" "Ref.interface" "RefWin2")


(sdedr:define-refeval-window "RefWin3" "Rectangle" (position (- r) R4 0.0)	(position R1 R3 0.0))
(sdedr:define-refinement-placement "Place.int3" "Ref.interface" "RefWin3")

(sdedr:define-refeval-window "RefWin4" "Rectangle" (position (- r) (- r) 0.0)	(position R1 r 0.0))
(sdedr:define-refinement-placement "Place.int4" "Ref.interface" "RefWin4")

(sde:save-model "n@node@")

(sde:build-mesh "snmesh" "-offset" "n@node@_msh")
