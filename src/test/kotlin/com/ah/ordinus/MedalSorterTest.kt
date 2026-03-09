package com.ah.ordinus

import com.ah.ordinus.MedalsDTO.BerchScaleValue
import com.ah.ordinus.MedalsDTO.Category
import com.ah.ordinus.MedalsDTO.CoinValue
import com.ah.ordinus.MedalsDTO.MedalEntry
import com.ah.ordinus.MedalsDTO.ToBeWorn
import org.junit.jupiter.api.Assertions.assertSame
import org.junit.jupiter.api.Test
import java.time.Year

class MedalSorterTest {
    private val medalSorter = MedalSorter()

    @Test
    fun `sorter returns correct order by category`() {
        val medals =
            listOf(
                personalMedal(
                    id = 1,
                    category = Category.A,
                    coinValue = CoinValue.GOLD,
                    enactedYear = Year.of(1967),
                    gradeName = "Medal of Honor",
                ),
                personalMedal(
                    id = 2,
                    category = Category.A,
                    coinValue = CoinValue.SILVER,
                    enactedYear = Year.of(1967),
                    gradeName = "A Medal of Honor",
                ),
                personalMedal(
                    id = 3,
                    category = Category.A,
                    coinValue = CoinValue.SILVER,
                    enactedYear = Year.of(1967),
                    gradeName = "Distinguished Service Cross",
                ),
                personalMedal(
                    id = 4,
                    category = Category.A,
                    coinValue = CoinValue.SILVER,
                    enactedYear = Year.of(1967),
                    gradeName = "MMS Medal",
                ),
            )
        val sortedMedals = medalSorter.sortPersonalMedals(medals)

        assert(sortedMedals[0].id == 1L)
        assert(sortedMedals[1].id == 2L)
        assert(sortedMedals[2].id == 3L)
        assert(sortedMedals[3].id == 4L)
    }

    @Test
    fun `sorter returns same list when only one medal`() {
        val medal =
            personalMedal(
                id = 1,
                category = Category.A,
                coinValue = CoinValue.GOLD,
                enactedYear = Year.of(2000),
                gradeName = "Solo",
            )
        val medals = listOf(medal)

        val sortedMedals = medalSorter.sortPersonalMedals(medals)

        assertSame(medals, sortedMedals)
    }

    @Test
    fun `sorter keeps order when already sorted`() {
        val medals =
            listOf(
                personalMedal(
                    id = 1,
                    category = Category.A,
                    coinValue = CoinValue.NONE,
                    enactedYear = Year.of(2020),
                    gradeName = "A",
                ),
                personalMedal(
                    id = 2,
                    category = Category.B,
                    coinValue = CoinValue.BRONZE,
                    enactedYear = Year.of(2015),
                    gradeName = "B",
                ),
                personalMedal(
                    id = 3,
                    category = Category.C,
                    coinValue = CoinValue.SILVER,
                    enactedYear = Year.of(2010),
                    gradeName = "C",
                ),
            )

        val sortedMedals = medalSorter.sortPersonalMedals(medals)

        assert(sortedMedals[0].id == 1L)
        assert(sortedMedals[1].id == 2L)
        assert(sortedMedals[2].id == 3L)
    }

    @Test
    fun `sorter breaks ties by coin value year and grade name`() {
        val medals =
            listOf(
                personalMedal(
                    id = 1,
                    category = Category.B,
                    coinValue = CoinValue.SILVER,
                    enactedYear = Year.of(2000),
                    gradeName = "B",
                ),
                personalMedal(
                    id = 2,
                    category = Category.B,
                    coinValue = CoinValue.SILVER,
                    enactedYear = Year.of(1990),
                    gradeName = "C",
                ),
                personalMedal(
                    id = 3,
                    category = Category.B,
                    coinValue = CoinValue.SILVER,
                    enactedYear = Year.of(1990),
                    gradeName = "A",
                ),
                personalMedal(
                    id = 4,
                    category = Category.A,
                    coinValue = CoinValue.BRONZE,
                    enactedYear = Year.of(2010),
                    gradeName = "Z",
                ),
                personalMedal(
                    id = 5,
                    category = Category.A,
                    coinValue = CoinValue.NONE,
                    enactedYear = Year.of(2010),
                    gradeName = "Y",
                ),
            )

        val sortedMedals = medalSorter.sortPersonalMedals(medals)

        assert(sortedMedals[0].id == 5L)
        assert(sortedMedals[1].id == 4L)
        assert(sortedMedals[2].id == 3L)
        assert(sortedMedals[3].id == 2L)
        assert(sortedMedals[4].id == 1L)
    }

    private fun personalMedal(
        id: Long,
        category: Category,
        coinValue: CoinValue,
        enactedYear: Year,
        gradeName: String,
    ): MedalsDTO.PersonalMedalEntry =
        MedalsDTO.PersonalMedalEntry(
            id = id,
            medalEntry =
                MedalEntry(
                    id = id,
                    gradeName = gradeName,
                    category = category,
                    enactedYear = enactedYear,
                    authorizedForUniform = true,
                    size = BerchScaleValue.EIGHT,
                    toBeWornAs = ToBeWorn.ON_BREAST,
                ),
            coinValue = coinValue,
        )
}
