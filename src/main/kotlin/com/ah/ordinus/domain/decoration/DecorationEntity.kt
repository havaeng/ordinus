package com.ah.ordinus.domain.decoration

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.PrePersist
import jakarta.persistence.PreUpdate
import jakarta.persistence.Table
import java.time.OffsetDateTime

@Entity
@Table(name = "decoration")
class DecorationEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,
    @Column(name = "category_id")
    var categoryId: Long? = null,
    @Column(name = "subcategory_id")
    var subcategoryId: Long? = null,
    @Column(name = "name_sv", nullable = false)
    var nameSv: String,
    @Column(name = "name_en")
    var nameEn: String? = null,
    @Column(name = "initial_number")
    var initialNumber: Int? = null,
    @Column(name = "year_display")
    var yearDisplay: String? = null,
    @Column(name = "description_sv")
    var descriptionSv: String? = null,
    @Column(name = "description_en")
    var descriptionEn: String? = null,
    @Column(name = "display_order", nullable = false)
    var displayOrder: Int,
    @Column(
        name = "created_at",
        nullable = false,
        updatable = false,
        insertable = false,
    )
    var createdAt: OffsetDateTime? = null,
    @Column(
        name = "updated_at",
        nullable = false,
        insertable = false,
    )
    var updatedAt: OffsetDateTime? = null,
) {
    @PrePersist
    @PreUpdate
    fun validate() {
        validateParentLevel()
        validateYearDisplayPrefix()
    }

    private fun validateParentLevel() {
        val hasCategory = categoryId != null
        val hasSubcategory = subcategoryId != null
        require(hasCategory.xor(hasSubcategory)) {
            "Decoration must have exactly one parent: either categoryId or subcategoryId"
        }
    }

    private fun validateYearDisplayPrefix() {
        if (yearDisplay.isNullOrBlank()) return
        require(yearDisplay!!.length >= 4 && yearDisplay!!.substring(0, 4).all { it.isDigit() }) {
            "yearDisplay must start with 4 digits (e.g. 1909, 2006, 1976/1995)"
        }
    }
}
