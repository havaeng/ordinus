package com.ah.ordinus.domain.decoration

import com.ah.ordinus.domain.decoration.dto.DecorationResponse
import org.springframework.data.domain.Page
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/decorations")
class DecorationController(
    private val decorationService: DecorationService,
) {
    @GetMapping
    fun getAllDecorations(): List<DecorationResponse> = decorationService.getAllDecorations()

    @GetMapping("/paged")
    fun getDecorationsPage(
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int,
        @RequestParam(defaultValue = "id") sortBy: String,
        @RequestParam(defaultValue = "asc") direction: String,
    ): Page<DecorationResponse> =
        decorationService.getDecorationsPage(
            page = page,
            size = size,
            sortBy = sortBy,
            direction = direction,
        )

    @GetMapping("/{id}")
    fun getDecorationById(
        @PathVariable id: Long,
    ): DecorationResponse = decorationService.getDecorationById(id)
}
