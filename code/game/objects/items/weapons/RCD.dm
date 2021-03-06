//Contains the rapid construction device.
/obj/item/rcd
	name = "rapid construction device"
	desc = "A device used to rapidly build walls and floors."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	flags = CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0

	matter = list(DEFAULT_WALL_MATERIAL = 50000)
	var/datum/effect/system/spark_spread/spark_system
	var/stored_matter = 0
	var/working = 0
	var/mode = 1
	var/list/modes = list("Floor & Walls","Airlock","Deconstruct")
	var/canRwall = 0
	var/disabled = 0

/obj/item/rcd/attack()
	return 0

/obj/item/rcd/proc/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && user.get_active_hand() == src && !user.stat && !user.restrained())

/obj/item/rcd/examine()
	..()
	if(src.type == /obj/item/rcd && loc == usr)
		usr << "It currently holds [stored_matter]/30 matter-units."

/obj/item/rcd/New()
	..()
	src.spark_system = new /datum/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/rcd/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/rcd/attackby(var/obj/item/W, mob/user)

	if(istype(W, /obj/item/rcd_ammo))
		if((stored_matter + 10) > 30)
			user << "<span class='notice'>The RCD can't hold any more matter-units.</span>"
			return
		user.drop_from_inventory(W)
		qdel(W)
		stored_matter += 10
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		user << "<span class='notice'>The RCD now holds [stored_matter]/30 matter-units.</span>"
		return
	..()

/obj/item/rcd/attack_self(mob/user)
	//Change the mode
	if(++mode > 3) mode = 1
	user << "<span class='notice'>Changed mode to '[modes[mode]]'</span>"
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	if(prob(20)) src.spark_system.start()

/obj/item/rcd/afterattack(atom/A, mob/user, proximity)
	if(!A.Adjacent(get_turf(user)))
		return 0
	if(disabled && !isrobot(user))
		return 0
	if(istype(get_area(A),/area/shuttle)||istype(get_area(A),/turf/space/transit))
		return 0
	return alter_turf(A,user,(mode == 3))

/obj/item/rcd/proc/useResource(var/amount, var/mob/user)
	if(stored_matter < amount)
		return 0
	stored_matter -= amount
	return 1

/obj/item/rcd/proc/alter_turf(var/turf/T,var/mob/user,var/deconstruct)

	var/build_cost = 0
	var/build_type
	var/build_turf
	var/build_delay
	var/build_other

	if(working == 1)
		return 0

	if(mode == 3 && istype(T,/obj/machinery/door/airlock))
		build_cost =  10
		build_delay = 50
		build_type = "airlock"
	else if(mode == 2 && !deconstruct && istype(T,/turf/simulated/floor))
		build_cost =  10
		build_delay = 50
		build_type = "airlock"
		build_other = /obj/machinery/door/airlock
	else if(!deconstruct && (istype(T,/turf/space) || istype(T,get_base_turf_by_area(T))))
		build_cost =  1
		build_type =  "floor"
		build_turf =  /turf/simulated/floor/airless
	else if(deconstruct && istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W = T
		build_delay = deconstruct ? 50 : 40
		build_cost =  5
		build_type =  (!canRwall && W.reinf_material) ? null : "wall"
		build_turf =  /turf/simulated/floor
	else if(istype(T,/turf/simulated/floor))
		build_delay = deconstruct ? 50 : 20
		build_cost =  deconstruct ? 10 : 3
		build_type =  deconstruct ? "floor" : "wall"
		build_turf =  deconstruct ? get_base_turf(T.z) : /turf/simulated/wall
	else
		return 0

	if(!build_type)
		working = 0
		return 0

	if(!useResource(build_cost, user))
		user << "Insufficient resources."
		return 0

	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

	working = 1
	user << "[(deconstruct ? "Deconstructing" : "Building")] [build_type]..."

	if(build_delay && !do_after(user, build_delay, src))
		working = 0
		return 0

	working = 0
	if(build_delay && !can_use(user,T))
		return 0

	if(build_turf)
		T.ChangeTurf(build_turf)
	else if(build_other)
		new build_other(T)
	else
		qdel(T)

	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return 1

/obj/item/rcd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	w_class = 2

	matter = list(DEFAULT_WALL_MATERIAL = 30000,"glass" = 15000)

/obj/item/rcd/borg
	canRwall = 1

/obj/item/rcd/borg/useResource(var/amount, var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			var/cost = amount*30
			if(R.cell.charge >= cost)
				R.cell.use(cost)
				return 1
	return 0

/obj/item/rcd/borg/attackby()
	return

/obj/item/rcd/borg/can_use(var/mob/user,var/turf/T)
	return(user.Adjacent(T) && !user.stat)

/obj/item/rcd/mounted/useResource(var/amount, var/mob/user)
	var/cost = amount*10
	var/obj/item/cell/cell
	if(istype(loc,/obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(module.holder && module.holder.cell)
			cell = module.holder.cell
	else if(istype(user, /mob/living/heavy_vehicle))
		var/mob/living/heavy_vehicle/mech = user
		if(mech.body && mech.body)
			cell = mech.body.cell
	if(cell && cell.charge >= cost)
		cell.use(cost)
		return 1
	return 0

/obj/item/rcd/mounted/attackby()
	return

/obj/item/rcd/mounted/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat && !user.restrained())
