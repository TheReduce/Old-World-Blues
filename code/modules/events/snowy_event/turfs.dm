
/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "snow_turf"


/turf/simulated/floor/plating/snow/ex_act(severity)
	return


/turf/simulated/floor/plating/snow/attack_hand(var/mob/user as mob)
	if(user.a_intent == I_GRAB)
		var/obj/item/weapon/snow/S = new(src)
		user.put_in_hands(S)
		user << SPAN_NOTE("You grab some snow.")


/turf/simulated/floor/plating/snow/Entered(mob/living/user as mob)
	if(istype(user, /mob/living))
		if(prob(15))
			var/p = pick('sound/effects/snowy/snow_step1.ogg', 'sound/effects/snowy/snow_step2.ogg', 'sound/effects/snowy/snow_step3.ogg')
			playsound(src, p, 15, rand(-50, 50))
		var/image/I = image(icon, "footprint[1]", dir = user.dir)
		I.pixel_x = rand(-6, 6)
		I.pixel_y = rand(-6, 6)
		overlays += I
		spawn(1200) //Hm. Maybe that's a bad idea. Or not?..
			overlays -= I


/turf/simulated/floor/plating/snow/Exited(mob/living/user as mob)
	if(istype(user, /mob/living))
		var/image/I = image(icon, "footprint[2]", dir = user.dir)
		I.pixel_x = rand(-6, 6)
		I.pixel_y = rand(-6, 6)
		overlays += I
		spawn(1200)
			overlays -= I



/turf/simulated/floor/plating/snow/light_forest
	dynamic_lighting = 1
	var/bush_factor = 1 //helper. Dont change or use it please

	New()
		..()
		spawn(4)
			if(src)
				forest_gen(20, list(/obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 40,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush, /obj/structure/lootable/mushroom_hideout), 10, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable = 2, /obj/structure/butcherable = 1))



//I know, all of that and previous generation is shit and needed to coded separatly with masks. But i have't so much time to dig it up
//Sorry. Maybe i remake it to good version

//Another long shit. Hell!
/turf/simulated/floor/plating/snow/light_forest/proc/forest_gen(spawn_chance, trees, tree_chance, bushes, bush_chance, bush_density, stumps, stump_chance, additions)
	if(prob(spawn_chance))
		if(prob(tree_chance))
			var/obj/structure/S = pick(trees)
			new S(src)
			if(prob(8))
				var/obj/structure/lootable/mushroom_hideout/tree_mush/TM = new /obj/structure/lootable/mushroom_hideout/tree_mush(src)
				TM.layer = 10
			return
		if(prob(bush_chance))
			var/obj/structure/B = pick(bushes)
			new B(src)
			bush_gen(bush_density, B)
			return
		if(prob(stump_chance))
			var/obj/structure/L = pick(stumps)
			new L(src)
			return
		var/list/equal_chances = list()
		for(var/p in additions)
			if(prob(additions[p]))
				equal_chances.Add(p)
		if(equal_chances.len)
			var/to_spawn = pick(equal_chances)
			new to_spawn(src)


/turf/simulated/floor/plating/snow/light_forest/proc/bush_gen(var/chance, var/bush) //play with this carefully
	for(var/dir in alldirs)
		if(istype(get_step(src, dir), /turf/simulated/floor/plating/snow))
			var/turf/simulated/floor/plating/snow/light_forest/K = get_step(src, dir)
			var/obj/structure/B = locate(/obj/structure) in K
			if(!B)
				if(prob(chance/src.bush_factor))
					K.bush_factor = src.bush_factor + 1
					new bush(K)
					bush_gen()


/turf/simulated/floor/plating/snow/light_forest/pines

	New()
		spawn(4)
			if(src)
				forest_gen(30, list(/obj/structure/flora/snowytree/high), 35,
								list(/obj/structure/flora/snowybush/deadbush), 20, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable = 2, /obj/structure/butcherable = 1))


/turf/simulated/floor/plating/snow/light_forest/mixed

	New()
		spawn(4)
			if(src)
				forest_gen(50, list(/obj/structure/flora/snowytree/high, /obj/structure/flora/snowytree/big/another, /obj/structure/flora/snowytree/big, /obj/structure/flora/snowytree), 35,
								list(/obj/structure/flora/snowybush/deadbush, /obj/structure/flora/snowybush), 20, 40,
								list(/obj/structure/flora/stump/fallen, /obj/structure/flora/stump, /obj/structure/lootable/mushroom_hideout), 20,
								list(/obj/item/weapon/branches = 10, /obj/structure/rock = 3, /obj/structure/lootable = 2, /obj/structure/butcherable = 1))




/turf/simulated/floor/plating/chasm
	name = "chasm"
	desc = "Dark bottomless abyss."
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "chasm"
	dynamic_lighting = 1

	New()
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
						var/turf/simulated/floor/plating/chasm/FF = get_step(src,direction)
						FF.update_icon()


/turf/simulated/floor/plating/chasm/update_icon()
	overlays.Cut()
	var/nums = 0
	var/list/our_dirs = list()
	for(var/direction in list(1, 4, 2, 8))
		if(istype(get_step(src,direction),/turf/simulated/floor/plating/chasm))
			nums += direction
			our_dirs.Add(direction)
	if(nums && nums != 15)
		icon_state = "chasm-[nums]"
	if(our_dirs.len > 1)
		for(var/i = 1, i<=our_dirs.len, i++)
			var/next_dir = i+1
			if(i == our_dirs.len)
				next_dir = 1
			var/sum_dir = our_dirs[i] + our_dirs[next_dir]
			if(!istype(get_step(src, sum_dir), /turf/simulated/floor/plating/chasm))
				overlays += "corner-[sum_dir]"


/turf/simulated/floor/plating/chasm/proc/eat(atom/movable/M as mob|obj)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.stat != DEAD)
			var/can_clutch = 0
			for(var/direction in list(1,2,4,8))
				if(!istype(get_step(src,direction), /turf/simulated/floor/plating/chasm))
					can_clutch = 1
					break
			if(can_clutch)
				var/obj/structure/fallingman/F = new(src)
				F.pull_in_colonist(M)
			else
				H.ghostize()
				qdel(M)
				src.visible_message(SPAN_WARN("[M.name] falling in the abyss!"))
		else
			src.visible_message(SPAN_WARN("[M.name] falling in the abyss!")) //meh, these three... I fix it later maybe
			if(H.ckey)
				H.ghostize()
			qdel(M)
	else if(!istype(M, /mob/observer))
		src.visible_message(SPAN_WARN("[M.name] falling in the abyss!"))
		qdel(M)


/turf/simulated/floor/plating/chasm/Entered(atom/movable/M as mob|obj)
	if(M.throwing)
		spawn(5) //Hm. Can't find need proc and hitby not working. Dont know why nobody puts Entered() under else at impact
			if(M.loc == src)
				eat(M)
	else
		eat(M)


/turf/simulated/floor/plating/ice
	name = "ice"
	icon = 'icons/obj/snowy_event/snowy_turfs.dmi'
	icon_state = "ice1"

	New()
		..()
		icon_state = "ice[rand(1, 5)]"


//need to add effects and sound here
/turf/simulated/floor/plating/ice/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp && !istype(W, /obj/item/weapon/wirecutters) && !istype(W, /obj/item/weapon/material/shard))
		var/obj/structure/ice_hole/I = locate(/obj/structure/ice_hole) in src
		if(I)
			user << SPAN_WARN("Ice is already are cracked here.")
		else
			user << SPAN_NOTE("You cracks trough ice with your [W.name]...")
			if(do_after(user, 30))
				I = locate(/obj/structure/ice_hole) in src
				if(I)
					user << SPAN_WARN("Ice is already are cracked here.")
				else
					new /obj/structure/ice_hole(src)
				user << SPAN_NOTE("A few time ago you can see water under thin layer of ice.")
			else
				user << SPAN_WARN("You need to stay still.")


//I rework it to something better later
/turf/simulated/floor/plating/ice/Entered(var/mob/living/A)
	if(A.last_move && prob(10))
		if(istype(A, /mob/living/carbon/human))
			if(A.intent == "walk")
				return
		if(prob(30) && istype(A, /mob/living/carbon/human))
			A << SPAN_WARN("You slips away!")
			A.Weaken(2)
			var/direction = pick(alldirs)
			step(A, direction)
