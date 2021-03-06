//All of the scissor stuff <-- TGameCo
/obj/item/weapon/scissors
	name = "Scissors"
	desc = "Those are scissors. Don't run with them!"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "scissor"
	item_state = "scissor"
	force = 5
	matter = list("metal" = 35)
	sharp = 1
	edge = 1
	w_class = 2
	urist_only = 1
	attack_verb = list("slices", "cuts", "stabs", "jabs")

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/obj/item/weapon/scissors/attackby(var/obj/item/I, mob/user as mob) //Seperation of the scissors
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/improvised/scissorknife/N = new /obj/item/weapon/improvised/scissorknife
		var/obj/item/weapon/improvised/scissorknife/N2 = new /obj/item/weapon/improvised/scissorknife

		user.before_take_item(src)

		user.put_in_hands(N)
		user.put_in_hands(N2)
		user << "<span class='notice'>You seperate the parts of the [src]</span>"

		del(src)
	..()

/obj/item/weapon/improvised/scissorsassembly //So you can put it together!
	name = "Scissor Assembly"
	desc = "Two parts of a scissor loosely combined"
	force = 3

/obj/item/weapon/improvised/scissorsassembly/attackby(var/obj/item/I, mob/user as mob) //Putting it together
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/scissors/N = new /obj/item/weapon/scissors

		user.before_take_item(src)

		user.put_in_hands(N)
		user << "<span class='notice'>You tighten the screw on the screwdriver assembley</span>"

		del(src)
	..()

//Makes scissors cut hair, special thanks to Miauw and Xerux -Nien
/obj/item/weapon/scissors/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(user.a_intent != "help")
		..()
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.
		//handle facial hair (if necessary)
		var/list/species_facial_hair = list()
		if(H.gender == MALE)
			if(H.species)
				for(var/i in facial_hair_styles_list)
					var/datum/sprite_accessory/facial_hair/tmp_facial = facial_hair_styles_list[i]
					if(H.species.name in tmp_facial.species_allowed)
						species_facial_hair += i
			else
				species_facial_hair = facial_hair_styles_list
		var/f_new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in species_facial_hair
		//handle normal hair
		var/list/species_hair = list()
		if(H.species)
			for(var/i in hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = hair_styles_list[i]
				if(H.species.name in tmp_hair.species_allowed)
					species_hair += i
		else
			species_hair = hair_styles_list
		var/h_new_style = input(user, "Select a hair style", "Grooming")  as null|anything in species_hair
		user.visible_message("[user] start's cutting [M]'s hair!", "You start cutting [M]'s hair!", "You hear the sound of scissors.") //arguments for this are: 1. what others see 2. what the user sees 3. what blind people hear.
		if(do_after(user, 10)) //this is the part that adds a delay. delay is in deciseconds.
			if(f_new_style)
				H.f_style = f_new_style
			if(h_new_style)
				H.h_style = h_new_style

		H.update_hair()
		user.visible_message("[user] finishes cutting [M]'s hair!")