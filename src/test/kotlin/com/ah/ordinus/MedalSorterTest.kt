package com.ah.ordinus

import com.ah.ordinus.MedalsDTO.BerchScaleValue
import com.ah.ordinus.MedalsDTO.Category
import com.ah.ordinus.MedalsDTO.CoinValue
import com.ah.ordinus.MedalsDTO.MedalEntry
import com.ah.ordinus.MedalsDTO.ToBeWorn
import org.junit.jupiter.api.Test
import java.time.Year

class MedalSorterTest {
    private val medalSorter = MedalSorter()

    @Test
    fun `sorter returns correct order by category`() {
        val medals = medalsWithDifferentCategory()
        val sortedMedals = medalSorter.sortPersonalMedals(medals)

        assert(sortedMedals[0].id == 1L)
        assert(sortedMedals[1].id == 2L)
        assert(sortedMedals[2].id == 3L)
        assert(sortedMedals[3].id == 4L)
    }

    fun medalsWithDifferentCategory(): List<MedalsDTO.PersonalMedalEntry> =
        listOf(
            MedalsDTO.PersonalMedalEntry(
                id = 1,
                medalEntry =
                    MedalEntry(
                        id = 1L,
                        gradeName = "Medal of Honor",
                        enactedYear = Year.of(1967),
                        category = Category.A,
                        authorizedForUniform = true,
                        size = BerchScaleValue.EIGHT,
                        discontinuedYear = Year.of(2023),
                        toBeWornAs = ToBeWorn.ON_BREAST,
                    ),
                coinValue = CoinValue.GOLD,
            ),
            MedalsDTO.PersonalMedalEntry(
                id = 2,
                medalEntry =
                    MedalEntry(
                        id = 1L,
                        gradeName = "A Medal of Honor",
                        category = Category.A,
                        enactedYear = Year.of(1967),
                        authorizedForUniform = true,
                        size = BerchScaleValue.EIGHT,
                        discontinuedYear = null,
                        toBeWornAs = ToBeWorn.ON_BREAST,
                    ),
                coinValue = CoinValue.SILVER,
            ),
            MedalsDTO.PersonalMedalEntry(
                id = 3,
                medalEntry =
                    MedalEntry(
                        id = 2L,
                        gradeName = "Distinguished Service Cross",
                        category = Category.A,
                        enactedYear = Year.of(1967),
                        authorizedForUniform = true,
                        size = BerchScaleValue.EIGHT,
                        discontinuedYear = null,
                        toBeWornAs = ToBeWorn.ON_BREAST,
                    ),
                coinValue = CoinValue.SILVER,
            ),
            MedalsDTO.PersonalMedalEntry(
                id = 4,
                medalEntry =
                    MedalEntry(
                        id = 3L,
                        gradeName = "MMS Medal",
                        category = Category.A,
                        enactedYear = Year.of(1967),
                        authorizedForUniform = true,
                        size = BerchScaleValue.EIGHT,
                        toBeWornAs = ToBeWorn.ON_BREAST,
                    ),
                coinValue = CoinValue.SILVER,
            ),
        )
}
