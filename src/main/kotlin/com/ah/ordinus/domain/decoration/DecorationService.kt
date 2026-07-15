package com.ah.ordinus.domain.decoration

import com.ah.ordinus.domain.decoration.dto.DecorationResponse
import jakarta.persistence.EntityNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class DecorationService(
    private val decorationRepository: DecorationRepository,
) {
    @Transactional(readOnly = true)
    fun getDecorationById(id: Long): DecorationResponse {
        val decoration =
            decorationRepository
                .findById(id)
                .orElseThrow { EntityNotFoundException("Decoration with id=$id was not found") }

        return DecorationResponse(
            id = decoration.id ?: throw EntityNotFoundException("Decoration id is missing for id=$id"),
            categoryId = decoration.categoryId,
            subcategoryId = decoration.subcategoryId,
            nameSv = decoration.nameSv,
            nameEn = decoration.nameEn,
            initialNumber = decoration.initialNumber,
            yearDisplay = decoration.yearDisplay,
            descriptionSv = decoration.descriptionSv,
            descriptionEn = decoration.descriptionEn,
            displayOrder = decoration.displayOrder,
        )
    }
}
