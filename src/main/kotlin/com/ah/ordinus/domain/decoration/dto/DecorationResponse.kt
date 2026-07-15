package com.ah.ordinus.domain.decoration.dto

data class DecorationResponse(
    val id: Long,
    val categoryId: Long?,
    val subcategoryId: Long?,
    val nameSv: String,
    val nameEn: String?,
    val initialNumber: Int?,
    val yearDisplay: String?,
    val descriptionSv: String?,
    val descriptionEn: String?,
    val displayOrder: Int,
)
