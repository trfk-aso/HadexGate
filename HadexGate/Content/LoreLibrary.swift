//
//  LoreLibrary.swift
//  HadexGate
//
//  The curated body of underworld lore. Every entry carries a unique sigil and
//  seed so no two cards share artwork.
//

import Foundation

enum LoreLibrary {

    static let all: [LoreEntry] = {
        var result: [LoreEntry] = []
        result += realms
        result += rivers
        result += guardians
        result += monsters
        result += heroes
        result += torments
        result += rulers
        return result
    }()

    // MARK: - Realms

    static let realms: [LoreEntry] = [
        LoreEntry(
            id: "elysium",
            name: "Elysium",
            epithet: "Paradise of Heroes",
            category: .realm,
            summary: "The blessed fields where the virtuous and the heroic dwell in eternal light, feasting and contending among golden meadows.",
            facts: [
                Fact(icon: "person.fill.checkmark", label: "Who dwells here", value: "Heroes & the virtuous"),
                Fact(icon: "sun.max.fill", label: "Climate", value: "Endless soft daylight"),
                Fact(icon: "arrow.triangle.2.circlepath", label: "Fate", value: "Possible rebirth"),
            ],
            sections: [
                LoreSection(title: "A reward, not a grave", body: "Unlike the grey majority of the dead, those admitted to Elysium keep their vigor and joy. Homer places it at the world's western edge; later poets set it deep within Hades' realm, a walled garden of the afterlife."),
                LoreSection(title: "The path to rebirth", body: "In Orphic and Pythagorean belief a soul could choose to be reborn. Live three virtuous lives in a row and you earned passage to the Isles of the Blessed — the deepest peace the Greeks imagined."),
            ],
            tags: ["paradise", "heroes", "reward", "light"],
            artwork: ArtworkStyle(symbol: "laurel.leading", tint: .gold, seed: 101, imageName: "art_elysium"),
            hook: "Where heroes feast forever"
        ),
        LoreEntry(
            id: "asphodel",
            name: "Asphodel Meadows",
            epithet: "The Grey Plain of the Many",
            category: .realm,
            summary: "A vast, twilit field of pale flowers where ordinary souls drift as shades — neither punished nor blessed, only remembering.",
            facts: [
                Fact(icon: "person.3.fill", label: "Who dwells here", value: "Ordinary souls"),
                Fact(icon: "aqi.medium", label: "Mood", value: "Grey, dim, endless"),
                Fact(icon: "drop.fill", label: "Nearby", value: "The waters of Lethe"),
            ],
            sections: [
                LoreSection(title: "The fate of most", body: "The overwhelming majority of the dead came here — people who were neither great sinners nor great heroes. They wandered the misty plain as insubstantial shades, faint echoes of who they had been."),
                LoreSection(title: "Named for a flower", body: "Asphodel is a real, ghostly-pale Mediterranean bloom that grows in poor soil and near graves. To the Greeks it was the food and flower of the dead."),
            ],
            tags: ["ordinary", "shades", "grey", "flowers"],
            artwork: ArtworkStyle(symbol: "aqi.medium", tint: .spirit, seed: 102, imageName: "art_asphodel"),
            hook: "The destiny of the ordinary dead"
        ),
        LoreEntry(
            id: "tartarus",
            name: "Tartarus",
            epithet: "The Abyss Beneath the Abyss",
            category: .realm,
            summary: "A dungeon of torment as far below Hades as the sky is above the earth, ringed by bronze walls and triple night. Prison of the great sinners and the defeated Titans.",
            facts: [
                Fact(icon: "flame.fill", label: "Purpose", value: "Eternal punishment"),
                Fact(icon: "shield.fill", label: "Sealed by", value: "Bronze gates & walls"),
                Fact(icon: "person.fill.xmark", label: "Inmates", value: "Titans & god-defiers"),
            ],
            sections: [
                LoreSection(title: "A pit, not a plain", body: "Hesiod says a bronze anvil would fall for nine days and nights from heaven to earth, and nine more from earth to Tartarus. It is the deepest place that exists."),
                LoreSection(title: "The great prisoners", body: "Zeus cast the defeated Titans here after the Titanomachy. Later it held mortals who insulted the gods: Sisyphus, Tantalus, Ixion and the rest, each bound to a torment fitted to their crime."),
            ],
            tags: ["abyss", "punishment", "titans", "prison"],
            artwork: ArtworkStyle(symbol: "flame.fill", tint: .blood, seed: 103, imageName: "art_tartarus"),
            hook: "The deepest prison in all creation"
        ),
        LoreEntry(
            id: "mourning-fields",
            name: "The Mourning Fields",
            epithet: "Lugentes Campi",
            category: .realm,
            summary: "Hidden paths where those consumed by unrequited or destructive love wander still, unable to leave their grief behind even in death.",
            facts: [
                Fact(icon: "heart.slash.fill", label: "Who dwells here", value: "The heartbroken"),
                Fact(icon: "eye.slash.fill", label: "Nature", value: "Hidden byways"),
                Fact(icon: "leaf.fill", label: "Setting", value: "A myrtle wood"),
            ],
            sections: [
                LoreSection(title: "Love beyond death", body: "In Virgil's vision of the underworld, those who died for love follow secret trails through a myrtle grove. Here Aeneas meets Dido, who turns from him in silence — grief made eternal."),
            ],
            tags: ["love", "grief", "myrtle", "sorrow"],
            artwork: ArtworkStyle(symbol: "heart.slash.fill", tint: .spirit, seed: 104, imageName: "art_mourning"),
            hook: "Where broken hearts never heal"
        ),
        LoreEntry(
            id: "erebus",
            name: "Erebus",
            epithet: "The Threshold Dark",
            category: .realm,
            summary: "The primordial darkness a soul first passes through on entering the underworld — the deep gloom between the world of the living and the realm of the dead.",
            facts: [
                Fact(icon: "moon.stars.fill", label: "Meaning", value: "Deep shadow"),
                Fact(icon: "arrow.down.forward", label: "Role", value: "The entrance region"),
                Fact(icon: "sparkles", label: "Origin", value: "A primordial god"),
            ],
            sections: [
                LoreSection(title: "Darkness given a name", body: "Erebus was both a place and one of the first beings to exist, born of Chaos. Souls crossing into Hades first traveled through his shadow before reaching the rivers and the fields beyond."),
            ],
            tags: ["darkness", "threshold", "primordial", "shadow"],
            artwork: ArtworkStyle(symbol: "moon.stars.fill", tint: .shadow, seed: 105, imageName: "art_erebus"),
            hook: "The first darkness of the dead"
        ),
        LoreEntry(
            id: "isles-blessed",
            name: "Isles of the Blessed",
            epithet: "The Final Reward",
            category: .realm,
            summary: "Islands of perfect peace at the edge of the world, granted to the rare souls pure enough to be reborn into virtue three times over.",
            facts: [
                Fact(icon: "sun.max.fill", label: "Who dwells here", value: "The thrice-worthy"),
                Fact(icon: "location.fill", label: "Location", value: "The world's western edge"),
                Fact(icon: "infinity", label: "Fate", value: "Rest without end"),
            ],
            sections: [
                LoreSection(title: "Beyond even paradise", body: "The Isles were the highest afterlife a Greek could hope for. Pindar sang of a place where ocean breezes blow and flowers of gold blaze — reserved for the very few who had lived, died, and lived again in goodness."),
            ],
            tags: ["paradise", "islands", "rebirth", "peace"],
            artwork: ArtworkStyle(symbol: "sun.max.fill", tint: .gold, seed: 106, imageName: "art_isles"),
            hook: "The highest peace the Greeks imagined"
        ),
    ]

    // MARK: - Rivers

    static let rivers: [LoreEntry] = [
        LoreEntry(
            id: "styx",
            name: "The Styx",
            epithet: "River of Unbreakable Oaths",
            category: .river,
            summary: "The great black river winding seven times around the underworld. So sacred that even the gods swore their most binding oaths upon it.",
            facts: [
                Fact(icon: "hand.raised.fill", label: "Meaning", value: "Hatred / shuddering"),
                Fact(icon: "crown.fill", label: "Feared by", value: "Even the gods"),
                Fact(icon: "drop.fill", label: "Legend", value: "Made Achilles near-invincible"),
            ],
            sections: [
                LoreSection(title: "The oath of the gods", body: "When a god swore by the Styx, the oath could not be broken. Any who lied were struck senseless for a year and exiled from the councils of Olympus for nine more."),
                LoreSection(title: "The ferry crossing", body: "In popular imagination the Styx became the river Charon ferried souls across — though older sources give that role to the Acheron. Its waters marked the true border of the dead."),
            ],
            tags: ["oath", "border", "achilles", "sacred"],
            artwork: ArtworkStyle(symbol: "hand.raised.fill", tint: .river, seed: 201, imageName: "art_styx"),
            hook: "The river even gods dared not betray"
        ),
        LoreEntry(
            id: "lethe",
            name: "The Lethe",
            epithet: "River of Forgetting",
            category: .river,
            summary: "Its still waters erased memory. Souls who drank from it forgot their former lives entirely — a mercy, or an erasure, depending on who you ask.",
            facts: [
                Fact(icon: "wind", label: "Meaning", value: "Oblivion"),
                Fact(icon: "brain.head.profile", label: "Effect", value: "Total loss of memory"),
                Fact(icon: "arrow.triangle.2.circlepath", label: "Role", value: "Prepared souls for rebirth"),
            ],
            sections: [
                LoreSection(title: "Drink and forget", body: "Shades who drank from Lethe lost all recollection of their lives. In reincarnation myths, this was necessary — a soul had to forget before it could be born anew."),
                LoreSection(title: "The other choice", body: "Some mystery cults taught initiates to avoid Lethe and drink instead from the pool of Mnemosyne (Memory), keeping their awareness intact in the afterlife."),
            ],
            tags: ["memory", "oblivion", "rebirth", "forgetting"],
            artwork: ArtworkStyle(symbol: "wind", tint: .spirit, seed: 202, imageName: "art_lethe"),
            hook: "Drink, and forget you ever lived"
        ),
        LoreEntry(
            id: "acheron",
            name: "The Acheron",
            epithet: "River of Woe",
            category: .river,
            summary: "The river of pain and sorrow, and in the oldest tellings the true crossing-place where Charon met the newly dead.",
            facts: [
                Fact(icon: "cloud.rain.fill", label: "Meaning", value: "Woe / distress"),
                Fact(icon: "sailboat.fill", label: "Role", value: "Charon's original ferry"),
                Fact(icon: "mappin", label: "Echo on earth", value: "A real river in Epirus"),
            ],
            sections: [
                LoreSection(title: "The river of pain", body: "Homer names the Acheron as the chief river of the underworld, into which the others flow. Its very name became a byword for the land of the dead."),
                LoreSection(title: "A real place", body: "There is an actual Acheron river in Greece, whose gorges and a famous Necromanteion (oracle of the dead) let the living feel they stood at the border of Hades itself."),
            ],
            tags: ["woe", "ferry", "sorrow", "border"],
            artwork: ArtworkStyle(symbol: "water.waves", tint: .river, seed: 203, imageName: "art_acheron"),
            hook: "The waters of pain and sorrow"
        ),
        LoreEntry(
            id: "cocytus",
            name: "The Cocytus",
            epithet: "River of Wailing",
            category: .river,
            summary: "A frozen river of lamentation whose banks echoed with the cries of the unburied dead, doomed to wander a hundred years.",
            facts: [
                Fact(icon: "snowflake", label: "Meaning", value: "Lamentation"),
                Fact(icon: "person.fill.questionmark", label: "Its dead", value: "The unburied"),
                Fact(icon: "hourglass", label: "Their wait", value: "One hundred years"),
            ],
            sections: [
                LoreSection(title: "The cries of the wronged", body: "Cocytus ran cold with the tears and wailing of souls denied proper funeral rites. Without burial and a coin for Charon, they could not cross — and so lingered on the near shore, weeping."),
            ],
            tags: ["wailing", "frozen", "unburied", "grief"],
            artwork: ArtworkStyle(symbol: "snowflake", tint: .river, seed: 204, imageName: "art_cocytus"),
            hook: "Where the unburied wail for a century"
        ),
        LoreEntry(
            id: "phlegethon",
            name: "The Phlegethon",
            epithet: "River of Fire",
            category: .river,
            summary: "A river of flame that did not consume but burned eternally, coiling down toward the depths of Tartarus itself.",
            facts: [
                Fact(icon: "flame.fill", label: "Meaning", value: "Blazing / fiery"),
                Fact(icon: "arrow.down.to.line", label: "Flows toward", value: "Tartarus"),
                Fact(icon: "sparkles", label: "Nature", value: "Fire that never dies"),
            ],
            sections: [
                LoreSection(title: "A current of flame", body: "Where other rivers ran with water, the Phlegethon ran with fire. Plato describes it winding through the earth and pouring into the abyss, its molten stream feeding the punishments below."),
            ],
            tags: ["fire", "tartarus", "flame", "burning"],
            artwork: ArtworkStyle(symbol: "flame", tint: .ember, seed: 205, imageName: "art_phlegethon"),
            hook: "A river that burns without end"
        ),
    ]

    // MARK: - Guardians

    static let guardians: [LoreEntry] = [
        LoreEntry(
            id: "charon",
            name: "Charon",
            epithet: "The Ferryman of the Dead",
            category: .guardian,
            summary: "The grim boatman who ferries souls across the river — but only those who are buried and can pay. The rest are turned away to wander the shore.",
            facts: [
                Fact(icon: "centsign.circle.fill", label: "His fee", value: "One obol (a coin)"),
                Fact(icon: "person.fill.xmark", label: "Turned away", value: "The unburied & unpaid"),
                Fact(icon: "sailboat.fill", label: "His craft", value: "A skiff across the Styx"),
            ],
            sections: [
                LoreSection(title: "The coin for the ferryman", body: "The Greeks placed a coin — an obol — in or on the mouth of the dead so they could pay Charon. Without it, a soul was stranded on the wrong bank for a hundred years."),
                LoreSection(title: "A miserable god", body: "Charon is depicted as a squalid, ill-tempered old man with blazing eyes. He served Hades and answered to no bribe of the living — Heracles is said to have forced a crossing by sheer intimidation, and Charon was punished for allowing it."),
            ],
            tags: ["ferryman", "coin", "styx", "crossing"],
            artwork: ArtworkStyle(symbol: "sailboat.fill", tint: .ember, seed: 301, imageName: "art_charon"),
            hook: "No coin, no crossing"
        ),
        LoreEntry(
            id: "cerberus",
            name: "Cerberus",
            epithet: "The Three-Headed Hound",
            category: .guardian,
            summary: "The monstrous dog of Hades, with three heads and a serpent's tail, who let the dead enter but savaged any who tried to leave.",
            facts: [
                Fact(icon: "pawprint.fill", label: "Heads", value: "Three (sometimes more)"),
                Fact(icon: "shield.lefthalf.filled", label: "Duty", value: "Guard the gate"),
                Fact(icon: "figure.strengthtraining.traditional", label: "Subdued by", value: "Heracles, bare-handed"),
            ],
            sections: [
                LoreSection(title: "The gate that only opens inward", body: "Cerberus welcomed souls into the underworld with a wagging tail — but tore apart any who attempted to escape back to the living. He was born of the monsters Typhon and Echidna."),
                LoreSection(title: "How he was tamed", body: "For his twelfth and final labour, Heracles wrestled Cerberus into submission without weapons and dragged him to the surface. Orpheus lulled him with music; the Sibyl drugged him with a honey-cake. The gate had its weaknesses."),
            ],
            tags: ["dog", "gate", "guardian", "heracles"],
            artwork: ArtworkStyle(symbol: "pawprint.fill", tint: .blood, seed: 302, imageName: "art_cerberus"),
            hook: "Three heads, one gate, no escape"
        ),
        LoreEntry(
            id: "judges",
            name: "The Three Judges",
            epithet: "Minos, Rhadamanthus & Aeacus",
            category: .guardian,
            summary: "Three former kings who judge every soul at the crossroads of the dead, sending each to reward, oblivion or torment.",
            facts: [
                Fact(icon: "scalemass.fill", label: "Their task", value: "Judge every soul"),
                Fact(icon: "arrow.triangle.branch", label: "The verdict", value: "Elysium, Asphodel or Tartarus"),
                Fact(icon: "crown.fill", label: "In life", value: "Righteous kings"),
            ],
            sections: [
                LoreSection(title: "A court at the crossroads", body: "Plato describes a meadow where three roads meet. Rhadamanthus judged the souls of the East, Aeacus those of the West, and Minos held the final vote in disputed cases."),
                LoreSection(title: "Judged by their lives", body: "There was no bribing this court and no lawyer to plead. Each soul was weighed by the deeds of its life alone — the virtuous sent right toward the Isles, the wicked left toward the pit."),
            ],
            tags: ["judgment", "kings", "verdict", "law"],
            artwork: ArtworkStyle(symbol: "scalemass.fill", tint: .gold, seed: 303, imageName: "art_judges"),
            hook: "Three kings weigh every life"
        ),
        LoreEntry(
            id: "furies",
            name: "The Furies",
            epithet: "The Erinyes, Hounds of Vengeance",
            category: .guardian,
            summary: "Three winged goddesses of retribution who hunted oath-breakers and kin-slayers without mercy, and tormented the guilty among the dead.",
            facts: [
                Fact(icon: "eye.fill", label: "Number", value: "Three: Alecto, Megaera, Tisiphone"),
                Fact(icon: "drop.fill", label: "Born from", value: "The blood of Uranus"),
                Fact(icon: "flame.fill", label: "They punish", value: "Murder & broken oaths"),
            ],
            sections: [
                LoreSection(title: "The unresting avengers", body: "With snakes for hair and eyes that wept blood, the Erinyes pursued the guilty across the world and beyond death. They answered the curses of the wronged, especially crimes against family."),
                LoreSection(title: "The Kindly Ones", body: "So terrible were they that the Greeks dared not speak their name, calling them instead the 'Eumenides' — the Kindly Ones — hoping flattery might turn their wrath aside."),
            ],
            tags: ["vengeance", "erinyes", "retribution", "snakes"],
            artwork: ArtworkStyle(symbol: "eye.fill", tint: .blood, seed: 304, imageName: "art_furies"),
            hook: "They never tire, and never forgive"
        ),
        LoreEntry(
            id: "thanatos",
            name: "Thanatos",
            epithet: "The Gentle Hand of Death",
            category: .guardian,
            summary: "The winged god of peaceful death, who carried souls from life's end — twin brother to Sleep, and once outwitted and chained by a clever mortal.",
            facts: [
                Fact(icon: "moon.fill", label: "Domain", value: "Peaceful death"),
                Fact(icon: "person.2.fill", label: "Twin", value: "Hypnos, god of Sleep"),
                Fact(icon: "link", label: "Once", value: "Chained by Sisyphus"),
            ],
            sections: [
                LoreSection(title: "Death without violence", body: "Where the Keres brought bloody, violent ends, Thanatos brought the quiet death of age and peace. He was merciless but not cruel — simply inevitable."),
                LoreSection(title: "The day death was caught", body: "The trickster Sisyphus once trapped Thanatos in chains, and while Death lay bound no mortal could die. Only when Ares freed him did the natural order — and Sisyphus's doom — resume."),
            ],
            tags: ["death", "sleep", "gentle", "sisyphus"],
            artwork: ArtworkStyle(symbol: "moon.fill", tint: .spirit, seed: 305, imageName: "art_thanatos"),
            hook: "Even Death was once put in chains"
        ),
        LoreEntry(
            id: "hecate",
            name: "Hecate",
            epithet: "Mistress of the Crossroads",
            category: .guardian,
            summary: "Goddess of magic, ghosts and boundaries who moved freely between worlds, holding the keys to the gates of the dead.",
            facts: [
                Fact(icon: "key.fill", label: "She holds", value: "The keys to Hades"),
                Fact(icon: "moon.stars.fill", label: "Domain", value: "Magic, ghosts, crossroads"),
                Fact(icon: "flashlight.on.fill", label: "Bears", value: "Twin torches"),
            ],
            sections: [
                LoreSection(title: "Between the worlds", body: "Hecate walked freely among the living, the dead and the gods. At crossroads and thresholds — places that belonged to no realm — offerings were left to win her favor and ward off restless spirits."),
                LoreSection(title: "Guide of Persephone", body: "When Persephone was taken, Hecate helped Demeter search with her torches, and afterward became the maiden's attendant and companion between the worlds above and below."),
            ],
            tags: ["magic", "ghosts", "crossroads", "keys"],
            artwork: ArtworkStyle(symbol: "key.fill", tint: .spirit, seed: 306, imageName: "art_hecate"),
            hook: "She holds the keys to the dead"
        ),
    ]

    // MARK: - Monsters

    static let monsters: [LoreEntry] = [
        LoreEntry(
            id: "medusa",
            name: "Medusa",
            epithet: "The Gorgon Whose Gaze Turns Stone",
            category: .monster,
            summary: "A serpent-haired Gorgon whose stare petrified any living thing. Once a mortal woman, cursed into a monster — and slain by Perseus.",
            facts: [
                Fact(icon: "eye.trianglebadge.exclamationmark.fill", label: "Her power", value: "Turns the living to stone"),
                Fact(icon: "figure.fencing", label: "Slain by", value: "Perseus"),
                Fact(icon: "shield.fill", label: "His trick", value: "A mirror-bright shield"),
            ],
            sections: [
                LoreSection(title: "Woman into monster", body: "In Ovid's telling Medusa was once beautiful, transformed into a snake-haired horror as punishment after being violated in Athena's temple — a story later readers reclaim as a tale of injustice, not evil."),
                LoreSection(title: "The mirrored death", body: "Perseus never looked at her directly. Guided by her reflection in his polished shield, he struck off her head — and from her blood sprang the winged horse Pegasus. Her severed head kept its power as a weapon."),
            ],
            tags: ["gorgon", "stone", "perseus", "snakes"],
            artwork: ArtworkStyle(symbol: "eye.trianglebadge.exclamationmark.fill", tint: .blood, seed: 401, imageName: "art_medusa"),
            hook: "Meet her eyes and turn to stone"
        ),
        LoreEntry(
            id: "minotaur",
            name: "The Minotaur",
            epithet: "The Bull of the Labyrinth",
            category: .monster,
            summary: "A man with the head of a bull, penned in a vast maze beneath Crete and fed on tribute of youths — until Theseus followed a thread to its heart.",
            facts: [
                Fact(icon: "arrow.triangle.branch", label: "Prison", value: "The Labyrinth of Knossos"),
                Fact(icon: "figure.fencing", label: "Slain by", value: "Theseus"),
                Fact(icon: "point.topleft.down.to.point.bottomright.curvepath.fill", label: "Escape by", value: "Ariadne's thread"),
            ],
            sections: [
                LoreSection(title: "The maze and the tribute", body: "King Minos hid the beast in a labyrinth built by Daedalus, and demanded Athens send youths and maidens to be devoured. The maze was so cunning none who entered could find the way out."),
                LoreSection(title: "The thread of Ariadne", body: "Princess Ariadne gave Theseus a ball of thread to unwind as he went. He slew the Minotaur in the maze's heart and followed the line back to daylight — the first to ever leave the labyrinth alive."),
            ],
            tags: ["bull", "labyrinth", "theseus", "crete"],
            artwork: ArtworkStyle(symbol: "arrow.triangle.branch", tint: .blood, seed: 402, imageName: "art_minotaur"),
            hook: "A maze with a monster at its heart"
        ),
        LoreEntry(
            id: "hydra",
            name: "The Lernaean Hydra",
            epithet: "The Serpent of Many Heads",
            category: .monster,
            summary: "A venomous water-serpent that grew two heads for every one cut away. Heracles could only kill it by burning each stump before it regrew.",
            facts: [
                Fact(icon: "allergens", label: "Its trick", value: "Two heads for each one lost"),
                Fact(icon: "flame.fill", label: "Weakness", value: "Fire to sear the stumps"),
                Fact(icon: "figure.strengthtraining.traditional", label: "Slain by", value: "Heracles & Iolaus"),
            ],
            sections: [
                LoreSection(title: "The problem of many heads", body: "The Hydra lurked in the swamps of Lerna. Cutting a head only doubled the threat, and one head was immortal. Its blood and breath were lethal poison."),
                LoreSection(title: "Fire and cunning", body: "Heracles' nephew Iolaus seared each neck-stump with a torch the moment a head was cut, stopping the regrowth. The immortal head Heracles buried under a great rock. He later dipped his arrows in the Hydra's venom."),
            ],
            tags: ["serpent", "regrow", "heracles", "poison"],
            artwork: ArtworkStyle(symbol: "allergens", tint: .river, seed: 403, imageName: "art_hydra"),
            hook: "Cut one head, grow two more"
        ),
        LoreEntry(
            id: "chimera",
            name: "The Chimera",
            epithet: "The Fire-Breathing Hybrid",
            category: .monster,
            summary: "A single beast of three creatures — lion, goat and serpent — that breathed fire and ravaged Lycia, until slain from the air by Bellerophon.",
            facts: [
                Fact(icon: "flame.circle.fill", label: "Its breath", value: "Living fire"),
                Fact(icon: "pawprint.fill", label: "Its form", value: "Lion, goat & serpent"),
                Fact(icon: "bird.fill", label: "Slain by", value: "Bellerophon on Pegasus"),
            ],
            sections: [
                LoreSection(title: "Three beasts in one", body: "The Chimera had the body and head of a lion, a goat's head rising from its back, and a serpent for a tail. From its jaws poured flame. Merely to see it was thought an omen of disaster."),
                LoreSection(title: "Death from above", body: "Bellerophon, riding the winged Pegasus, stayed beyond reach of the flames. He fixed a lump of lead to his spear and drove it into the Chimera's mouth; its fiery breath melted the lead, which choked the beast from within."),
            ],
            tags: ["hybrid", "fire", "bellerophon", "pegasus"],
            artwork: ArtworkStyle(symbol: "flame.circle.fill", tint: .ember, seed: 404, imageName: "art_chimera"),
            hook: "Three beasts, one breath of fire"
        ),
        LoreEntry(
            id: "sirens",
            name: "The Sirens",
            epithet: "Voices That Lure to Death",
            category: .monster,
            summary: "Winged singers whose song was so beautiful that sailors steered onto the rocks to reach them, wrecking ship after ship.",
            facts: [
                Fact(icon: "waveform.path", label: "Their weapon", value: "An irresistible song"),
                Fact(icon: "sailboat.fill", label: "Their victims", value: "Passing sailors"),
                Fact(icon: "ear.fill", label: "Odysseus's trick", value: "Wax in the ears, bound to the mast"),
            ],
            sections: [
                LoreSection(title: "The fatal song", body: "The Sirens promised knowledge of all things to any who listened. But no ship that turned toward their island ever sailed on — the shore was heaped with the bones of the men they had charmed."),
                LoreSection(title: "How Odysseus survived", body: "Warned by Circe, Odysseus plugged his crew's ears with beeswax and had himself lashed to the mast, so he alone could hear the song and live. Orpheus, on the Argo, simply out-sang them."),
            ],
            tags: ["song", "sailors", "odysseus", "rocks"],
            artwork: ArtworkStyle(symbol: "waveform.path", tint: .spirit, seed: 405, imageName: "art_sirens"),
            hook: "A song worth dying for"
        ),
        LoreEntry(
            id: "scylla-charybdis",
            name: "Scylla & Charybdis",
            epithet: "The Strait of No Safe Passage",
            category: .monster,
            summary: "Two horrors guarding a narrow strait — a six-headed cliff-monster and a ship-swallowing whirlpool. To dodge one was to risk the other.",
            facts: [
                Fact(icon: "pawprint.fill", label: "Scylla", value: "Six heads on a cliff"),
                Fact(icon: "tornado", label: "Charybdis", value: "A devouring whirlpool"),
                Fact(icon: "arrow.left.arrow.right", label: "The dilemma", value: "No path avoids both"),
            ],
            sections: [
                LoreSection(title: "Between the two", body: "Scylla snatched six sailors from every ship that passed within reach of her cliff. Opposite her, Charybdis thrice daily swallowed the sea and belched it back, dragging whole vessels down."),
                LoreSection(title: "The lesser evil", body: "Circe advised Odysseus to hug Scylla's cliff and lose six men rather than risk losing everyone to Charybdis. From this strait comes the phrase for being trapped between two dangers."),
            ],
            tags: ["strait", "whirlpool", "odysseus", "dilemma"],
            artwork: ArtworkStyle(symbol: "tornado", tint: .river, seed: 406, imageName: "art_scylla"),
            hook: "Two deaths, one narrow strait"
        ),
        LoreEntry(
            id: "sphinx",
            name: "The Sphinx",
            epithet: "The Riddler of Thebes",
            category: .monster,
            summary: "A winged lion with a woman's face who strangled all who failed her riddle — until Oedipus finally answered it and she cast herself from the rocks.",
            facts: [
                Fact(icon: "questionmark.diamond.fill", label: "Her weapon", value: "A deadly riddle"),
                Fact(icon: "pawprint.fill", label: "Her form", value: "Lion, wings & woman"),
                Fact(icon: "person.fill.checkmark", label: "Answered by", value: "Oedipus"),
            ],
            sections: [
                LoreSection(title: "Answer or die", body: "The Sphinx blocked the road to Thebes, devouring every traveller who could not solve her riddle: 'What walks on four legs at dawn, two at noon, and three at dusk?'"),
                LoreSection(title: "The answer: Man", body: "Oedipus replied: a human — crawling as a baby, walking upright as an adult, leaning on a staff in old age. Defeated at last, the Sphinx threw herself to her death from the cliff."),
            ],
            tags: ["riddle", "thebes", "oedipus", "lion"],
            artwork: ArtworkStyle(symbol: "questionmark.diamond.fill", tint: .gold, seed: 407, imageName: "art_sphinx"),
            hook: "Solve the riddle, or be devoured"
        ),
    ]

    // MARK: - Heroes / Descents

    static let heroes: [LoreEntry] = [
        LoreEntry(
            id: "orpheus",
            name: "Orpheus",
            epithet: "The Musician Who Charmed Death",
            category: .hero,
            summary: "The greatest musician of myth, who descended to reclaim his dead wife Eurydice — and lost her forever with a single backward glance.",
            facts: [
                Fact(icon: "music.mic", label: "His gift", value: "Music that moved stone & god"),
                Fact(icon: "heart.fill", label: "His quest", value: "To reclaim Eurydice"),
                Fact(icon: "eye.fill", label: "His mistake", value: "One backward glance"),
            ],
            sections: [
                LoreSection(title: "The song that stopped the underworld", body: "When Eurydice died of a snakebite, Orpheus went down and played for Hades and Persephone. His grief was so beautiful that the tormented paused, the Furies wept, and the rulers granted his wish."),
                LoreSection(title: "The one condition", body: "Eurydice could follow him back to the light — but he must not look back until both had left the underworld. Steps from the surface, doubt seized him. He turned. She was still in shadow, and vanished with a whisper: 'farewell.'"),
            ],
            tags: ["music", "eurydice", "love", "loss"],
            artwork: ArtworkStyle(symbol: "music.mic", tint: .ember, seed: 501, imageName: "art_orpheus"),
            hook: "He almost brought her back"
        ),
        LoreEntry(
            id: "heracles",
            name: "Heracles",
            epithet: "The Hero Who Chained the Hound",
            category: .hero,
            summary: "For his final labour, the strongest of heroes descended alive into Hades and hauled Cerberus himself into the daylight — the only one to take, and return, the guardian of the gate.",
            facts: [
                Fact(icon: "pawprint.fill", label: "His labour", value: "Capture Cerberus"),
                Fact(icon: "figure.strengthtraining.traditional", label: "His method", value: "Bare-handed strength"),
                Fact(icon: "arrow.up.circle.fill", label: "The outcome", value: "He returned alive"),
            ],
            sections: [
                LoreSection(title: "The twelfth labour", body: "Eurystheus set the impossible last: bring back the three-headed hound of Hades. Heracles was initiated into the sacred Mysteries first, then went down with Hermes and Athena as guides."),
                LoreSection(title: "Permission and force", body: "Hades allowed the capture on one condition — that Heracles overpower Cerberus without weapons. He seized the beast by the throat, wrestled it into submission, and carried it up to the world of the living before returning it."),
            ],
            tags: ["strength", "cerberus", "labour", "return"],
            artwork: ArtworkStyle(symbol: "figure.strengthtraining.traditional", tint: .ember, seed: 502, imageName: "art_heracles"),
            hook: "He dragged the guard-dog into daylight"
        ),
        LoreEntry(
            id: "odysseus",
            name: "Odysseus",
            epithet: "The Wanderer Who Summoned the Dead",
            category: .hero,
            summary: "On his long way home, Odysseus reached the edge of the underworld and called up the spirits of the dead to learn the road ahead.",
            facts: [
                Fact(icon: "location.north.circle.fill", label: "His goal", value: "Guidance home to Ithaca"),
                Fact(icon: "drop.fill", label: "His rite", value: "A trench of blood for the shades"),
                Fact(icon: "eye.fill", label: "He met", value: "The prophet Tiresias"),
            ],
            sections: [
                LoreSection(title: "The rite at the border", body: "Following Circe's instructions, Odysseus sailed to the world's edge, dug a trench, and poured offerings. The spirits of the dead crowded up to drink the blood and speak — but only after the blind prophet Tiresias had his say."),
                LoreSection(title: "Faces from the past", body: "He spoke with his own mother, who had died in his absence; with the fallen heroes of Troy; and with Achilles, who told him he would rather be a poor man's slave among the living than king of all the dead."),
            ],
            tags: ["nekyia", "tiresias", "ithaca", "spirits"],
            artwork: ArtworkStyle(symbol: "location.north.circle.fill", tint: .river, seed: 503, imageName: "art_odysseus"),
            hook: "He called the dead up to speak"
        ),
        LoreEntry(
            id: "theseus",
            name: "Theseus & Pirithous",
            epithet: "The Descent That Went Wrong",
            category: .hero,
            summary: "Two friends descended with a mad plan to carry off Persephone herself — and were trapped in the Chairs of Forgetfulness for their arrogance.",
            facts: [
                Fact(icon: "chair.fill", label: "Their trap", value: "The Chairs of Forgetting"),
                Fact(icon: "crown.fill", label: "Their target", value: "Persephone, Hades' queen"),
                Fact(icon: "figure.strengthtraining.traditional", label: "Freed by", value: "Heracles (only Theseus)"),
            ],
            sections: [
                LoreSection(title: "A reckless oath", body: "Theseus had sworn to help his friend Pirithous win a daughter of Zeus as a bride — and Pirithous chose Persephone. They went down to the underworld to abduct the queen of the dead."),
                LoreSection(title: "Punished for pride", body: "Hades feigned welcome and invited them to sit. The moment they did, they were fused to the Chairs of Forgetfulness. When Heracles later passed through, he tore Theseus free — but the earth shook when he reached for Pirithous, who was left below forever."),
            ],
            tags: ["hubris", "persephone", "trapped", "pirithous"],
            artwork: ArtworkStyle(symbol: "chair.fill", tint: .spirit, seed: 504, imageName: "art_theseus"),
            hook: "They came to steal the queen of the dead"
        ),
        LoreEntry(
            id: "psyche",
            name: "Psyche",
            epithet: "The Soul Who Faced the Dead",
            category: .hero,
            summary: "A mortal woman sent into the underworld itself as the last of her impossible trials to win back the love of Eros.",
            facts: [
                Fact(icon: "sparkle", label: "Her trial", value: "Fetch a box from Persephone"),
                Fact(icon: "centsign.circle.fill", label: "Her tokens", value: "Coins & cakes for the road"),
                Fact(icon: "heart.fill", label: "Her reward", value: "Immortality & Eros"),
            ],
            sections: [
                LoreSection(title: "The final task", body: "Set impossible labours by the jealous Aphrodite, Psyche was ordered to descend and bring back a portion of Persephone's beauty in a box. A tower spoke and taught her the way: coins for Charon, cakes for Cerberus, and to refuse every distraction."),
                LoreSection(title: "The forbidden box", body: "She succeeded — but curiosity undid her at the last. She opened the box, and instead of beauty it held the sleep of death. Eros found her, wiped the sleep away, and Zeus at last made her immortal so the lovers could wed."),
            ],
            tags: ["soul", "eros", "trial", "curiosity"],
            artwork: ArtworkStyle(symbol: "sparkle", tint: .spirit, seed: 505, imageName: "art_psyche"),
            hook: "She walked into death for love"
        ),
        LoreEntry(
            id: "dionysus",
            name: "Dionysus",
            epithet: "The God Who Freed His Mother",
            category: .hero,
            summary: "The god of wine descended into Hades to bring back his mortal mother Semele and raise her to the heavens as a goddess.",
            facts: [
                Fact(icon: "wineglass.fill", label: "His quest", value: "Reclaim his mother Semele"),
                Fact(icon: "arrow.up.circle.fill", label: "The outcome", value: "He succeeded"),
                Fact(icon: "map.fill", label: "His way in", value: "A bottomless lake at Lerna"),
            ],
            sections: [
                LoreSection(title: "A son's promise", body: "Semele died before Dionysus was born, tricked into gazing on Zeus's true form. Grown to godhood, Dionysus refused to leave her among the dead and went down to find her."),
                LoreSection(title: "Raised to the stars", body: "He led Semele up out of Hades and brought her to Olympus, where she was made the goddess Thyone — one of the few mortals ever lifted from the underworld to divinity."),
            ],
            tags: ["wine", "semele", "rescue", "ascension"],
            artwork: ArtworkStyle(symbol: "wineglass.fill", tint: .spirit, seed: 506, imageName: "art_dionysus"),
            hook: "He brought his mother back from death"
        ),
    ]

    // MARK: - Torments

    static let torments: [LoreEntry] = [
        LoreEntry(
            id: "sisyphus",
            name: "Sisyphus",
            epithet: "The Boulder That Always Falls",
            category: .punishment,
            summary: "A cunning king condemned to roll a boulder up a hill for eternity — for near the top it always rolls back down, and he must begin again.",
            facts: [
                Fact(icon: "mountain.2.fill", label: "His task", value: "Roll a boulder uphill, forever"),
                Fact(icon: "link", label: "His crime", value: "Cheating death twice"),
                Fact(icon: "arrow.uturn.down", label: "The cruelty", value: "It always rolls back"),
            ],
            sections: [
                LoreSection(title: "The man who chained Death", body: "Sisyphus twice escaped the underworld — first by trapping Thanatos in chains, then by tricking Persephone into letting him return to 'scold his wife.' The gods do not forgive being outwitted."),
                LoreSection(title: "A punishment of futility", body: "His sentence was chosen with care: endless, pointless labour. The horror is not the weight but the certainty that no effort will ever be finished. It became the ancient world's great image of absurd, unrewarded toil."),
            ],
            tags: ["boulder", "futility", "trickster", "eternal"],
            artwork: ArtworkStyle(symbol: "mountain.2.fill", tint: .blood, seed: 601, imageName: "art_sisyphus"),
            hook: "Forever pushing, forever falling"
        ),
        LoreEntry(
            id: "tantalus",
            name: "Tantalus",
            epithet: "Starving Amid Plenty",
            category: .punishment,
            summary: "Cursed to stand in a pool beneath fruit-laden branches, yet the water recedes when he stoops to drink and the fruit lifts away when he reaches to eat.",
            facts: [
                Fact(icon: "fork.knife", label: "His torment", value: "Eternal hunger & thirst"),
                Fact(icon: "drop.fill", label: "The water", value: "Retreats when he bends"),
                Fact(icon: "leaf.fill", label: "The fruit", value: "Lifts when he reaches"),
            ],
            sections: [
                LoreSection(title: "The unforgivable feast", body: "Tantalus, a favourite of the gods, betrayed them — in the worst version, he killed his own son Pelops and served him to the gods to test their omniscience. They were not fooled, and they were not merciful."),
                LoreSection(title: "Tantalising forever", body: "Placed in a pool up to his chin with fruit dangling overhead, he can never drink nor eat. From his name comes the word 'tantalise' — to be shown a thing you can never have."),
            ],
            tags: ["hunger", "thirst", "hubris", "tantalise"],
            artwork: ArtworkStyle(symbol: "fork.knife", tint: .blood, seed: 602, imageName: "art_tantalus"),
            hook: "Water and fruit forever out of reach"
        ),
        LoreEntry(
            id: "prometheus",
            name: "Prometheus",
            epithet: "The Bringer of Fire, Bound",
            category: .punishment,
            summary: "The Titan who gave fire to humankind, chained to a rock where an eagle devoured his ever-regrowing liver each day — until Heracles set him free.",
            facts: [
                Fact(icon: "flame.fill", label: "His gift", value: "Fire, stolen for mankind"),
                Fact(icon: "bird.fill", label: "His torment", value: "An eagle eats his liver daily"),
                Fact(icon: "figure.strengthtraining.traditional", label: "Freed by", value: "Heracles"),
            ],
            sections: [
                LoreSection(title: "Punished for compassion", body: "Prometheus defied Zeus to give humanity fire — and with it, civilization. For this Zeus chained him to a peak in the Caucasus. Each day an eagle tore out his liver; each night it grew back, so the agony was endless."),
                LoreSection(title: "The rebel set free", body: "Unlike the others, his was a punishment for kindness, not crime — which is why the Greeks half-worshipped him. Heracles at last shot the eagle and broke his chains, and Prometheus was reconciled with the gods."),
            ],
            tags: ["fire", "titan", "eagle", "rebellion"],
            artwork: ArtworkStyle(symbol: "bird.fill", tint: .ember, seed: 603, imageName: "art_prometheus"),
            hook: "Tortured for the gift of fire"
        ),
        LoreEntry(
            id: "ixion",
            name: "Ixion",
            epithet: "Bound to the Burning Wheel",
            category: .punishment,
            summary: "The first mortal to murder kin, then to lust after Hera herself — lashed to a winged wheel of fire that spins through the underworld without rest.",
            facts: [
                Fact(icon: "arrow.triangle.2.circlepath", label: "His torment", value: "A spinning wheel of fire"),
                Fact(icon: "flame.fill", label: "Never", value: "Stops turning"),
                Fact(icon: "crown.fill", label: "His crime", value: "Betraying Zeus's guest-law"),
            ],
            sections: [
                LoreSection(title: "The guest who betrayed", body: "Ixion murdered his father-in-law, and Zeus alone purified him. In return Ixion tried to seduce Hera. Zeus fashioned a cloud in her image to catch him in the act — and the union bred the race of Centaurs."),
                LoreSection(title: "The eternal wheel", body: "For violating sacred hospitality, Zeus bound him to a fiery, ever-spinning wheel, sometimes said to be winged, whirling forever through the air of Tartarus."),
            ],
            tags: ["wheel", "fire", "hospitality", "centaurs"],
            artwork: ArtworkStyle(symbol: "arrow.triangle.2.circlepath", tint: .ember, seed: 604, imageName: "art_ixion"),
            hook: "Chained to a wheel that never stops"
        ),
        LoreEntry(
            id: "danaids",
            name: "The Danaids",
            epithet: "Filling a Vessel That Never Fills",
            category: .punishment,
            summary: "Forty-nine sisters who murdered their husbands on their wedding night, doomed to carry water forever in jars riddled with holes.",
            facts: [
                Fact(icon: "drop.fill", label: "Their task", value: "Fill a leaking vessel"),
                Fact(icon: "person.3.fill", label: "Their number", value: "Forty-nine sisters"),
                Fact(icon: "infinity", label: "The result", value: "Never full, never finished"),
            ],
            sections: [
                LoreSection(title: "The wedding-night murders", body: "Commanded by their father Danaus, the sisters each killed their husband on their wedding night — all but one, Hypermnestra, who spared hers out of love."),
                LoreSection(title: "Water through a sieve", body: "In the underworld they must forever carry water to fill a great basin using jars full of holes. Like Sisyphus, their punishment is perfect futility — labour that can never reach its end."),
            ],
            tags: ["water", "leaking", "futility", "sisters"],
            artwork: ArtworkStyle(symbol: "drop.fill", tint: .river, seed: 605, imageName: "art_danaids"),
            hook: "Carrying water in broken jars, forever"
        ),
        LoreEntry(
            id: "tityos",
            name: "Tityos",
            epithet: "The Giant of the Vultures",
            category: .punishment,
            summary: "A giant so vast his body covered acres, pinned to the ground of Tartarus while two vultures tore endlessly at his liver.",
            facts: [
                Fact(icon: "bird.circle.fill", label: "His torment", value: "Vultures eat his liver"),
                Fact(icon: "ruler.fill", label: "His size", value: "Covered nine acres"),
                Fact(icon: "crown.fill", label: "His crime", value: "Assaulting the goddess Leto"),
            ],
            sections: [
                LoreSection(title: "A crime against a goddess", body: "Tityos assaulted Leto, mother of Apollo and Artemis. Her divine children struck him down with their arrows, and Zeus cast him into the pit."),
                LoreSection(title: "Stretched across the pit", body: "In the underworld his enormous body was staked out across the ground while two vultures perpetually fed on his liver — which, like Prometheus's, regrew as fast as it was devoured."),
            ],
            tags: ["giant", "vultures", "leto", "liver"],
            artwork: ArtworkStyle(symbol: "bird.circle.fill", tint: .blood, seed: 606, imageName: "art_tityos"),
            hook: "A giant staked out for the vultures"
        ),
    ]

    // MARK: - Rulers

    static let rulers: [LoreEntry] = [
        LoreEntry(
            id: "hades",
            name: "Hades",
            epithet: "Lord of the Unseen Realm",
            category: .deity,
            summary: "The elder god who rules the dead — stern and just rather than evil, keeper of the world's buried riches and jealous guardian of his kingdom's borders.",
            facts: [
                Fact(icon: "crown.fill", label: "Domain", value: "The dead & the earth's riches"),
                Fact(icon: "eye.slash.fill", label: "His helm", value: "The Cap of Invisibility"),
                Fact(icon: "dog.fill", label: "His hound", value: "Cerberus"),
            ],
            sections: [
                LoreSection(title: "Not the devil", body: "Hades is often misread as a Greek Satan. He is not — he is a grim but fair administrator of the dead who keeps the cosmic order. The Greeks feared to speak his name and called him Plouton, 'the rich one,' for the wealth beneath the soil."),
                LoreSection(title: "Lord of a fixed realm", body: "When the three brothers divided the cosmos, Zeus took the sky, Poseidon the sea, and Hades the underworld. He rarely left it — and rarely let anything leave it either."),
            ],
            tags: ["hades", "plouton", "ruler", "riches"],
            artwork: ArtworkStyle(symbol: "crown.fill", tint: .spirit, seed: 701, imageName: "art_hades"),
            hook: "Stern, just, and rarely merciful"
        ),
        LoreEntry(
            id: "persephone",
            name: "Persephone",
            epithet: "Queen of the Dead, Bringer of Spring",
            category: .deity,
            summary: "Daughter of the harvest, abducted to be Hades' queen. Her half-year return to the surface is why the earth blooms — and her descent is why it dies each winter.",
            facts: [
                Fact(icon: "leaf.fill", label: "Her double life", value: "Half above, half below"),
                Fact(icon: "circle.grid.cross.fill", label: "The seeds", value: "Six pomegranate seeds"),
                Fact(icon: "snowflake", label: "Her absence", value: "Brings winter to earth"),
            ],
            sections: [
                LoreSection(title: "The abduction", body: "Hades seized Persephone from a flowering meadow and carried her below. Her mother Demeter, goddess of the harvest, searched the world in grief — and while she mourned, nothing grew."),
                LoreSection(title: "The pomegranate bargain", body: "Zeus ordered her return, but because Persephone had eaten pomegranate seeds in the underworld, she was bound to it. The compromise: she spends part of each year below as its queen, part above with her mother. Her descent is autumn and winter; her return is spring."),
            ],
            tags: ["persephone", "demeter", "seasons", "pomegranate"],
            artwork: ArtworkStyle(symbol: "leaf.fill", tint: .spirit, seed: 702, imageName: "art_persephone"),
            hook: "Her descent is why winter comes"
        ),
        LoreEntry(
            id: "nyx",
            name: "Nyx",
            epithet: "Primordial Night",
            category: .deity,
            summary: "One of the first beings to exist, the goddess of Night whose dark home lay at the very edge of the underworld — powerful enough that even Zeus feared to cross her.",
            facts: [
                Fact(icon: "moon.haze.fill", label: "Domain", value: "Night itself"),
                Fact(icon: "sparkles", label: "Age", value: "Born of Chaos"),
                Fact(icon: "person.3.fill", label: "Her children", value: "Death, Sleep, Fate & more"),
            ],
            sections: [
                LoreSection(title: "Older than the gods", body: "Nyx existed before the Olympians, one of the primordial forces. She dwelt in the depths beyond Tartarus, emerging each evening to draw darkness across the sky as her daughter Day withdrew."),
                LoreSection(title: "Feared by Zeus", body: "Homer tells that when Sleep once angered Zeus and fled to Nyx for shelter, even the king of the gods held back his wrath — for he would not do anything to displease swift Night."),
            ],
            tags: ["night", "primordial", "chaos", "darkness"],
            artwork: ArtworkStyle(symbol: "moon.haze.fill", tint: .shadow, seed: 703, imageName: "art_nyx"),
            hook: "Night, whom even Zeus would not anger"
        ),
    ]

    // MARK: - Lookup helpers

    static func entry(id: String) -> LoreEntry? {
        all.first { $0.id == id }
    }

    static func entries(in category: LoreCategory) -> [LoreEntry] {
        all.filter { $0.category == category }
    }
}
