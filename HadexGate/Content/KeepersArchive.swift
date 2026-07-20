//
//  KeepersArchive.swift
//  HadexGate
//
//  Offline knowledge engine for the Oracle. Matches a seeker's question against
//  curated answers and the app's lore, so the guide always responds — even
//  without Apple Intelligence.
//

import Foundation

enum KeepersArchive {

    /// Hand-written answers for the most common questions, in the Keeper's voice.
    private static let curated: [(keys: [String], answer: String)] = [
        (["tartarus", "look", "abyss", "pit"],
         "Tartarus is a dungeon as far beneath Hades as the sky is above the earth — a place of bronze walls and a triple ring of night. Hesiod says a falling anvil would take nine days to reach it. There the defeated Titans and the great sinners endure torment without end."),
        (["coin", "charon", "obol", "money", "pay", "ferryman"],
         "Yes — the Greeks truly placed a coin, an obol, in or upon the mouth of their dead so the soul could pay Charon the ferryman. Without that fee, and without proper burial, the shade was left on the near shore to wander for a hundred years before it could cross."),
        (["medusa", "gorgon", "perseus", "stone"],
         "Perseus slew Medusa. Knowing her gaze turned the living to stone, he never looked at her directly — he watched her reflection in his polished, mirror-bright shield and struck off her head. From her blood sprang the winged horse Pegasus."),
        (["sisyphus", "boulder", "rock", "stone forever", "push"],
         "Sisyphus was a king who cheated death twice — once by chaining Thanatos himself, once by tricking his way back from the underworld. For outwitting the gods he was condemned to roll a boulder up a hill for eternity; each time it nears the summit it rolls back, and he must begin again. His is the image of endless, futile toil."),
        (["orpheus", "eurydice", "look back", "music"],
         "Orpheus, the greatest of musicians, went down to reclaim his dead wife Eurydice. His grief-song so moved Hades and Persephone that they let her follow him to the light — on one condition: he must not look back until both had left the underworld. Steps from the surface, doubt seized him. He turned too soon, and she slipped back into shadow with a final 'farewell.'"),
        (["winter", "persephone", "seasons", "demeter", "spring"],
         "When Hades carried Persephone below to be his queen, her mother Demeter — goddess of the harvest — mourned so deeply that nothing grew. Because Persephone had eaten pomegranate seeds in the underworld, she was bound to return there for part of each year. Her descent brings autumn and winter; her return brings spring."),
        (["cerberus", "dog", "three head", "hound"],
         "Cerberus is the three-headed hound of Hades, with a serpent for a tail. He welcomes the dead in but savages any who try to leave. Heracles subdued him bare-handed for his final labour; Orpheus lulled him with music; and the Sibyl once drugged him with a honeyed cake."),
        (["hydra", "heads", "grow"],
         "The Lernaean Hydra grew two heads for every one cut away, and one of its heads was immortal. Heracles could only kill it with help: his nephew Iolaus seared each neck-stump with fire before it could regrow, and the immortal head was buried beneath a great rock."),
        (["minotaur", "labyrinth", "maze", "theseus", "thread"],
         "The Minotaur, a man with a bull's head, was penned in the Labyrinth beneath Crete and fed on tribute of youths. Theseus slew it — and escaped the inescapable maze by unwinding a thread given to him by Ariadne, following it back to the light."),
        (["styx", "oath", "swear"],
         "The Styx is the great black river that winds seven times around the underworld. It was so sacred that the gods swore their most binding oaths upon it; any god who broke such an oath was struck senseless for a year and exiled from Olympus for nine more."),
        (["lethe", "forget", "memory"],
         "The Lethe is the river of forgetting. Souls who drank from it lost all memory of their former lives — a necessary erasure before a soul could be reborn into the world above."),
        (["hades", "god", "devil", "lord", "ruler"],
         "Hades is the elder god who rules the dead — but he is not a devil. He is a stern and just keeper of cosmic order, and lord of the riches buried in the earth. The Greeks feared to speak his name, calling him instead Plouton, 'the rich one.'"),
        (["tantalus", "tantalise", "hunger", "thirst"],
         "Tantalus stands forever in a pool beneath fruit-laden boughs, yet the water retreats when he stoops to drink and the fruit lifts away when he reaches to eat. He betrayed the gods' trust in the worst way imaginable, and from his name we get the word 'tantalise.'"),
        (["prometheus", "fire", "eagle", "liver"],
         "Prometheus, the Titan who gave fire to humankind, was chained to a rock where an eagle devoured his liver each day — and each night it grew back. His was a punishment for compassion, not crime, which is why the Greeks half-worshipped him. Heracles finally shot the eagle and freed him."),
        (["judge", "judged", "minos", "rhadamanthus", "aeacus"],
         "Three former kings judge the dead at a meadow where three roads meet: Rhadamanthus judges the souls of the East, Aeacus those of the West, and Minos casts the deciding vote. Each soul is weighed by its deeds alone — sent onward to Elysium, the Asphodel Meadows, or Tartarus."),
        (["elysium", "paradise", "heroes", "heaven"],
         "Elysium is the paradise of the blessed dead — heroes and the truly virtuous — where the sun still shines and souls feast and contest among golden meadows. The very best, reborn worthily three times over, pass at last to the Isles of the Blessed."),
        (["siren", "song", "sailors"],
         "The Sirens lured sailors to their deaths with a song so beautiful that men steered onto the rocks to reach them. Odysseus survived by stopping his crew's ears with wax and having himself lashed to the mast; Orpheus simply out-sang them."),
    ]

    static func answer(for question: String) -> String {
        let q = question.lowercased()

        // 1) Curated answers — best keyword overlap wins.
        var best: (score: Int, answer: String)? = nil
        for item in curated {
            let score = item.keys.reduce(0) { $0 + (q.contains($1) ? 1 : 0) }
            if score > 0, score > (best?.score ?? 0) {
                best = (score, item.answer)
            }
        }
        if let best { return best.answer }

        // 2) Fall back to the lore library by name / tag match.
        if let entry = LoreLibrary.all.first(where: { q.contains($0.name.lowercased()) })
            ?? LoreLibrary.all.first(where: { entry in
                entry.tags.contains { q.contains($0.lowercased()) }
            }) {
            let extra = entry.sections.first.map { " " + $0.body } ?? ""
            return entry.summary + extra
        }

        // 3) A graceful, in-character default.
        return "That knowledge lies deeper in the dark than my archive reaches, seeker. Ask me of the realms of Hades, the rivers of the dead, the monsters of old, the heroes who descended, or the torments of Tartarus — and I will answer plainly."
    }
}
