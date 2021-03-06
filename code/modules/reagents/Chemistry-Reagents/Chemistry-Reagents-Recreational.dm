/* TODO: post-psychic power update:
	ALZ-113 -     lethal virus in humans, triggers latencies in monkeys
	Ephemerol -   buffs to psychic powers, hallucinations.
	Nexus -       buffs metaconcerts, makes vulnerable to coercion
	Accela -      mental enhancer
	Booster -     may trigger latencies, causes hallucinations
	Soy sauce -   endgame drug (JDATE), permanent psychological effects and powers
*/

/* TODO: post-aspect update:
	Lethe -       amnesiac/calmative - removes a range of aspects
	Azrael -      Boosts aspects, causes neurological damage.
*/

/* TODO at some point:
	Pasceline D - treat bone damage
	Quietus -     suicide drug
	Allswell -    calmative
	Drive -       combat stim, lethal overdose
	Gravy -       'A nano-drug for acclimating to high-gravity environments.'
	Kamikaze -    designer amphetamine
	Powerball -   mania, feral strength
	Slab -        ammonium chloride and radium. Lethal to humans.
	Stimutacs -   99% kelp, 1% fugu tetrodotoxin
	Monocane -   'render the recipient invisible, side effect of inducing insanity.'
	Tripwire -    synthetic drugs (for robots)
	Ultrazone -   synthetic drugs (for robots)
*/

/datum/reagent/lsd
	name = "LSD"
	id = "lsd"
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#B31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lsd/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.hallucination = max(M.hallucination, 100)

/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	taste_description = "mushroom"
	color = "#E700E7"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5

/datum/reagent/psilocybin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.druggy = max(M.druggy, 30)

	if(dose < 1)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(dose < 2)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))

/datum/reagent/jumpstart
	name = "Jumpstart"
	id = "jumpstart"
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/jumpstart/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/glint
	name = "Glint"
	id = "glint"
	taste_description = "bitterness"
	taste_mult = 0.4
	reagent_state = LIQUID
	color = "#60A584"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE

/datum/reagent/glint/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.druggy = max(M.druggy, 15)
	if(prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/pax
	name = "Pax"
	id = "pax"
	taste_description = "nothing at all"
	taste_mult = 0.4
	reagent_state = LIQUID
	color = "#CCCCCC"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE

/datum/reagent/pax/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.a_intent != I_HELP && M.a_intent != I_DISARM)
		M.a_intent_change(I_HELP)
	M.add_chemical_effect(CE_PULSE, -1)
	M.add_chemical_effect(CE_PACIFIED, 1)

/datum/reagent/ladder
	name = "Ladder"
	id = "ladder"
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FFCC00"
	metabolism = REM * 0.5

/datum/reagent/ladder/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.a_intent != I_HURT && M.a_intent != I_GRAB)
		M.a_intent_change(I_HURT)
	M.add_chemical_effect(CE_PULSE, 2)
	M.add_chemical_effect(CE_BERSERK, 1)

/datum/reagent/threeeye
	name = "Three Eye"
	id = "threeeye"
	taste_description = "starlight"
	reagent_state = LIQUID
	color = "#CCCCFF"
	metabolism = REM * 0.15

/datum/reagent/threeeye/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_THIRDEYE, 1)

/datum/reagent/short
	name = "Short"
	id = "short"
	taste_description = "wax"
	reagent_state = LIQUID
	color = "#FFCCCC"
	metabolism = REM * 0.15

/datum/reagent/short/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_DRUG_SUPPRESSANT, 1)
