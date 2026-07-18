package com.ah.ordinus.domain.decorationShortCode

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface DecorationShortCodeRepository : JpaRepository<DecorationShortCodeEntity, Long> {
    fun existsByShortCode(shortCode: String): Boolean

    @Query(
        """
                SELECT (count(d) > 0)
                FROM DecorationShortCodeEntity d
                WHERE lower(d.shortCode) = lower(:shortCode)
                """,
    )
    fun existsByShortCodeIgnoreCase(
        @Param("shortCode") shortCode: String,
    ): Boolean
}
