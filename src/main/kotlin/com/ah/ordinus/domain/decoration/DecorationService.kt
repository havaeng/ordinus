package com.ah.ordinus.domain.decoration

import com.ah.ordinus.domain.decoration.dto.DecorationResponse
import jakarta.persistence.EntityNotFoundException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class DecorationService(
    private val decorationRepository: DecorationRepository,
) {
    @Transactional(readOnly = true)
    fun getAllDecorations(): List<DecorationResponse> =
        decorationRepository
            .findAll()
            .sortedBy { it.id }
            .map { it.toResponse() }

    @Transactional(readOnly = true)
    fun getDecorationsPage(
        page: Int,
        size: Int,
        sortBy: String,
        direction: String,
    ): Page<DecorationResponse> {
        require(page >= 0) { "page must be >= 0" }
        require(size > 0) { "size must be > 0" }

        val sortDirection =
            if (direction.equals("desc", ignoreCase = true)) {
                Sort.Direction.DESC
            } else {
                Sort.Direction.ASC
            }

        val pageable = PageRequest.of(page, size, Sort.by(sortDirection, sortBy))
        return decorationRepository.findAll(pageable).map { it.toResponse() }
    }

    @Transactional(readOnly = true)
    fun getDecorationById(id: Long): DecorationResponse {
        val decoration =
            decorationRepository
                .findById(id)
                .orElseThrow { EntityNotFoundException("Decoration with id=$id was not found") }

        return decoration.toResponse()
    }

    private fun DecorationEntity.toResponse(): DecorationResponse =
        DecorationResponse(
            id = id ?: throw EntityNotFoundException("Decoration id is missing"),
            categoryId = categoryId,
            subcategoryId = subcategoryId,
            nameSv = nameSv,
            nameEn = nameEn,
            initialNumber = initialNumber,
            yearDisplay = yearDisplay,
            descriptionSv = descriptionSv,
            descriptionEn = descriptionEn,
            displayOrder = displayOrder,
        )
}
