package com.ah.ordinus

import com.ah.ordinus.MedalsDTO.PersonalMedalEntry

class MedalSorter {
    fun sortPersonalMedals(personalMedals: List<PersonalMedalEntry>): List<PersonalMedalEntry> =
        if (personalMedals.size == 1) {
            personalMedals
        } else {
            personalMedals.sortedWith(
                comparator =
                    compareBy(
                        { it.medalEntry.category.priority },
                        { it.coinValue.priority },
                        { it.medalEntry.enactedYear },
                        { it.medalEntry.gradeName },
                    ),
            )
        }
}
