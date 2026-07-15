package com.ah.ordinus.domain.decoration

import com.ah.ordinus.domain.decoration.dto.DecorationResponse
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/decorations")
class DecorationController(
    private val decorationService: DecorationService,
) {
    @GetMapping("/{id}")
    fun getDecorationById(
        @PathVariable id: Long,
    ): DecorationResponse = decorationService.getDecorationById(id)
}
