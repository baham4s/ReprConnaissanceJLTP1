; DUBIN Baptiste
(deffacts faits-initiaux
	; Les enfants de Eugenie 
	(relation parent 11 10)
	(relation parent 12 10)
	(relation parent 2 10)
	(relation parent 11 1)
	(relation parent 12 1)
	(relation parent 2 1)

	; Les enfants de Martine
	(relation parent 3 11)
	(relation parent 4 11)
	(relation parent 5 11)

	; Les enfants de Christiane
	(relation parent 13 12)
	(relation parent 6 12)
	(relation parent 7 12)

	; Les enfants de Daniel
	(relation parent 8 2)
	(relation parent 9 2)

	(string parent homme "le pere")
	(string parent femme "la mere")

	(string soeur_frr homme "le frere")
	(string soeur_frr femme "la soeur")

	(string oncle_tante homme "l'oncle")
	(string oncle_tante femme "la tante")

	(string cousin homme "le cousin")
	(string cousin femme "la cousine")

	(string grand_parent homme "le grand pere")
	(string grand_parent femme "la grand mere")


	; Definition du sexe de tout ces personnage
	(sexe homme 1)
	(sexe homme 2)
	(sexe homme 3)
	(sexe homme 4)
	(sexe homme 5)
	(sexe homme 6)
	(sexe homme 7)
	(sexe homme 8)
	(sexe homme 9)
	(sexe femme 10)
	(sexe femme 11)
	(sexe femme 12)
	(sexe femme 13)

	(id "Albert" 1)
	(id "Daniel" 2)
	(id "Herve" 3)
	(id "Laurent" 4)
	(id "Nicolas" 5)
	(id "Thierry" 6)
	(id "Sylvain" 7)
	(id "Philipe" 8)
	(id "Eric" 9)
	(id "Eugenie" 10)
	(id "Martine" 11)
	(id "Christiane" 12)
	(id "Stephanie" 13)

	; initalisation des liste
	(all soeur_frr)
	(all parent)
	(all cousin)
	(all grand_parent)
	(all oncle_tante)
)	

(defrule affListe
	(declare (salience -1))
	(all ?relation $?ids)
	=>
	(printout t ?relation ": " $?ids crlf)
)

; Affiche tous les types de relation
(defrule disp_relation
	(relation ?relation ?personne1 ?personne2)
	(sexe ?sexe ?personne2)
	(string ?relation ?sexe ?texte)
	(id ?prenom1 ?personne1)
	(id ?prenom2 ?personne2)
	=>
	(printout t ?prenom2 " est " ?texte " de " ?prenom1 crlf)
)

; Création de nouvelle relation (frère/soeur, oncle/tante, neveu/nièce, cousin/cousine, mari/femme)
(defrule rule_soeur_frr
	(relation parent ?enfant1 ?parent)
	(relation parent ?enfant2 ?parent)
	(test (neq ?enfant1 ?enfant2))
	(not (relation soeur_frr ?enfant1 ?enfant2))
	=>
	(assert (relation soeur_frr ?enfant1 ?enfant2))
)

(defrule oncle_tante
	(relation soeur_frr ?fraterie_parent ?parent)
	(relation parent ?fieul ?parent)
	=>
	(assert (relation oncle_tante ?fieul ?fraterie_parent))
)

(defrule cousin
	(relation oncle_tante ?cousin1 ?oncle)
	(relation parent ?cousin2 ?oncle)
	=>
	(assert (relation cousin ?cousin1 ?cousin2))
)

(defrule grand_parent
	(relation parent ?parent ?grandparent)
	(relation parent ?petitenfant ?parent)
	=>
	(assert (relation grand_parent ?petitenfant ?grandparent))
)


(defrule liste
	(relation ?relation ? ?personne2)
	(not (all ?relation $? ?personne2 $?))
	?liste2 <- (all ?relation $?liste)
	=>
	(retract ?liste2)
	(assert (all ?relation $?liste ?personne2))
)
