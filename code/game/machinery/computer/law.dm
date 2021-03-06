//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_screen = "command"
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = 0


	verb/AccessInternals()
		set category = "Object"
		set name = "Access Computer's Internals"
		set src in oview(1)
		if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon))
			return

		opened = !opened
		if(opened)
			usr << "<span class='notice'>The access panel is now open.</span>"
		else
			usr << "<span class='notice'>The access panel is now closed.</span>"
		return


	attackby(var/obj/item/O, var/mob/user)
		if (user.z > 6)
			user << "<span class='danger'>Unable to establish a connection:</span> You're too far away from the ship!"
			return
		if(istype(O, /obj/item/aiModule))
			var/obj/item/aiModule/M = O
			M.install(src)
		else
			..()


	attack_hand(var/mob/user)
		if(src.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(src.stat & BROKEN)
			usr << "The upload computer is broken!"
			return

		src.current = select_active_ai(user)

		if (!src.current)
			usr << "No active AIs detected."
		else
			usr << "[src.current.name] selected for law changes."
		return

	attack_ghost(var/mob/user)
		return 1


/obj/machinery/computer/borgupload
	name = "robot upload console"
	desc = "Used to upload laws to robots."
	icon_screen = "command"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null


	attackby(var/obj/item/aiModule/module as obj, var/mob/user)
		if(istype(module, /obj/item/aiModule))
			module.install(src)
		else
			return ..()


	attack_hand(var/mob/user)
		if(src.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(src.stat & BROKEN)
			usr << "The upload computer is broken!"
			return

		src.current = freeborg()

		if (!src.current)
			usr << "No free robots detected."
		else
			usr << "[src.current.name] selected for law changes."
		return

	attack_ghost(var/mob/user)
		return 1
