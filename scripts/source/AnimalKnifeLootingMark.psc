Scriptname AnimalKnifeLootingMark extends activemagiceffect 

int HitCount
ObjectReference[] LootedItem
int ItemPointer

Event OnEffectStart(Actor akTarget, Actor akCaster)
	LootedItem = new ObjectReference[128]
	ItemPointer = 0
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	actor Animal = GetTargetActor()
	if Animal.IsDead() && (akSource as weapon).IsDagger()
		HitCount += 1
		if HitCount > 1
			int NumItems = Animal.GetNumItems()
			if NumItems > 0
				Sound LootFX = Game.GetFormFromFile(0x1F270, "Skyrim.esm") as Sound
				Form ItemtoLoot = Animal.getNthForm(0)
				int CountofLoot = Animal.GetItemCount(ItemtoLoot)
				Animal.RemoveItem(ItemtoLoot, 999, true)
				if ItemtoLoot.isPlayable()
					;LootedItem[ItemPointer] = akAggressor.PlaceAtMe(ItemtoLoot, CountofLoot)
					akAggressor.Additem(ItemtoLoot, CountofLoot)
					;LootedItem[ItemPointer].MoveTo(akAggressor, 50.0, 50.0, 100.0)
					Debug.Notification("Looted: " + ItemtoLoot.GetName())
				Else
					Debug.Notification("This was a wired thing nothing for me.")
				Endif
				ItemPointer += 1
				RegisterForSingleUpdate(5)
				int Loud = LootFX.Play(Animal)
				Sound.SetInstanceVolume(Loud, 3)
				HitCount = 0
				if NumItems == 1
					EffectShader LootedFX = Game.GetFormFromFile(0xABEFF, "Skyrim.esm") as EffectShader
					LootedFX.Play(Animal, 10.0)
					HitCount = 1
				Endif
			Else
				EffectShader LootedFX = Game.GetFormFromFile(0xABEFF, "Skyrim.esm") as EffectShader
				LootedFX.Play(Animal, 10.0)
				Debug.Notification("I can't get more!")
			EndIf
		Endif
	Endif
EndEvent

Event OnUpdate()
		if GetTargetActor().GetDistance(Game.GetPlayer()) > 1000 || GetTargetActor().GetDistance(Game.GetPlayer()) < -1
			int i = 0
			while i < 129
				LootedItem[i].Delete()
				LootedItem[i] = none
				i += 1
			EndWhile
		Else
			RegisterForSingleUpdate(5)
		EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int i = 0
	while i < 129
		LootedItem[i].Delete()
		i += 1
	EndWhile
EndEvent
