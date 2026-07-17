package com.ah.ordinus.domain.decorationShortCode

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.OffsetDateTime

@Entity
@Table(name = "decoration_short_code")
class DecorationShortCodeEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,
    @Column(name = "decoration_id")
    var decorationId: Long,
    @Column(name = "short_code")
    var shortCode: String,
    @Column(name = "display_order")
    var displayOrder: Int? = null,
    @Column(name = "description_sv")
    var descriptionSv: String? = null,
    @Column(name = "description_en")
    var descriptionEn: String? = null,
    @Column(
        name = "created_at",
        nullable = false,
        updatable = false,
        insertable = false,
    )
    var createdAt: OffsetDateTime,
    @Column(
        name = "updated_at",
        nullable = false,
        insertable = false,
    )
    var updatedAt: OffsetDateTime,
)
