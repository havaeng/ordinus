package com.ah.ordinus.domain.other

import java.time.Year

class MedalsDTO {
    data class MedalOverview(
        val id: Long,
        val name: String,
        val description: String? = null,
        val coinValueOccurrences: Set<CoinValue>? = null,
        val grades: List<MedalEntry>? = null,
        val sizes: Set<BerchScaleValue>? = null,
    )

    data class MedalEntry(
        val id: Long,
        val gradeName: String,
        val abbreviation: String? = null,
        val category: Category,
        val size: BerchScaleValue? = null,
        val enactedYear: Year,
        val discontinuedYear: Year? = null,
        val authorizedForUniform: Boolean? = null,
        val toBeWornAs: ToBeWorn,
    )

    enum class Category(
        val priority: Int,
    ) {
        A(1),
        B(2),
        C(3),
        D(4),
        E(5),
        F(6),
        G(7),
        H(8),
        I(9),
        J(10),
        K(11),
        L(12),
        L2(13),
        Foreign(14),
    }

    enum class BerchScaleValue(
        val value: Number,
    ) {
        FIVE(5),
        SIX(6),
        SEVEN(7),
        SEVEN_AND_A_HALF(7.5),
        EIGHT(8),
        TWELVE(12),
        FIFTEEN(15),
        EIGHTEEN(18),
    }

    enum class CoinValue(
        val priority: Int,
    ) {
        GOLD(1),
        SILVER(2),
        BRONZE(3),
        IRON(4),
        OTHER(5),
        NONE(0),
    }

    enum class CoinValueSuffix(
        val priority: Int,
    ) {
        ENAMEL(0),
        WITH_WREATH(1),
        WITH_STAR(2),
        TWO_STARS(3),
    }

    enum class ToBeWorn {
        AROUND_NECK,
        ON_BREAST,
        GRAND_CROSS,
        STAR,
    }

    enum class ExtraDetails {
        WITH_CHAIN,
        WITH_BLUE_RIBBON,
        WITH_BLUE_RIBBON_AND_YELLOW_SIDE_STRIPES,
    }

    data class PersonalMedalEntry(
        val id: Long,
        val medalEntry: MedalEntry,
        val coinValue: CoinValue,
    )
}
