package com.ah.ordinus.domain.decoration

import com.ah.ordinus.TestcontainersConfiguration
import jakarta.persistence.EntityNotFoundException
import jakarta.servlet.ServletException
import org.junit.jupiter.api.Assertions.assertInstanceOf
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Import
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import org.springframework.test.web.servlet.setup.MockMvcBuilders
import org.springframework.web.context.WebApplicationContext

@Import(TestcontainersConfiguration::class)
@SpringBootTest(properties = ["app.blob.seed.enabled=false"])
class DecorationControllerSystemTest {
    private lateinit var mockMvc: MockMvc

    @Autowired
    lateinit var webApplicationContext: WebApplicationContext

    @Autowired
    lateinit var jdbcTemplate: JdbcTemplate

    @BeforeEach
    fun setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build()
    }

    @Test
    fun `get decoration by id returns decoration response`() {
        val browseGroupId =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO browse_group (key, title_sv, title_en, display_order)
                VALUES (?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                "test_group_decorations",
                "Testgrupp",
                "Test group",
                9991,
            )!!

        val categoryId =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
                VALUES (?, ?, ?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                browseGroupId,
                "TZ",
                "Testkategori",
                "Test category",
                9991,
                true,
            )!!

        val decorationId =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO decoration (
                    category_id,
                    subcategory_id,
                    name_sv,
                    name_en,
                    initial_number,
                    year_display,
                    description_sv,
                    description_en,
                    display_order
                )
                VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                categoryId,
                "Testdekoration",
                "Test decoration",
                12,
                "2024/2025",
                "Svensk beskrivning",
                "English description",
                1,
            )!!

        try {
            mockMvc
                .perform(get("/api/decorations/{id}", decorationId))
                .andExpect(status().isOk)
                .andExpect(jsonPath("$.id").value(decorationId))
                .andExpect(jsonPath("$.categoryId").value(categoryId))
                .andExpect(jsonPath("$.subcategoryId").isEmpty)
                .andExpect(jsonPath("$.nameSv").value("Testdekoration"))
                .andExpect(jsonPath("$.nameEn").value("Test decoration"))
                .andExpect(jsonPath("$.initialNumber").value(12))
                .andExpect(jsonPath("$.yearDisplay").value("2024/2025"))
                .andExpect(jsonPath("$.descriptionSv").value("Svensk beskrivning"))
                .andExpect(jsonPath("$.descriptionEn").value("English description"))
                .andExpect(jsonPath("$.displayOrder").value(1))
        } finally {
            jdbcTemplate.update("DELETE FROM decoration WHERE id = ?", decorationId)
            jdbcTemplate.update("DELETE FROM category WHERE id = ?", categoryId)
            jdbcTemplate.update("DELETE FROM browse_group WHERE id = ?", browseGroupId)
        }
    }

    @Test
    fun `get decoration by id propagates not found exception when decoration is missing`() {
        val ex =
            assertThrows(ServletException::class.java) {
                mockMvc.perform(get("/api/decorations/{id}", Long.MAX_VALUE)).andReturn()
            }

        assertInstanceOf(EntityNotFoundException::class.java, ex.cause)
    }

    @Test
    fun `get all decorations returns all decorations`() {
        val browseGroupId =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO browse_group (key, title_sv, title_en, display_order)
                VALUES (?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                "test_group_all_decorations",
                "Testgrupp alla",
                "Test group all",
                9992,
            )!!

        val categoryId =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
                VALUES (?, ?, ?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                browseGroupId,
                "TY",
                "Testkategori alla",
                "Test category all",
                9992,
                true,
            )!!

        val decorationId1 =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO decoration (
                    category_id,
                    subcategory_id,
                    name_sv,
                    name_en,
                    initial_number,
                    year_display,
                    description_sv,
                    description_en,
                    display_order
                )
                VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                categoryId,
                "Testdekoration ett",
                "Test decoration one",
                13,
                "2021",
                "Beskrivning ett",
                "Description one",
                1,
            )!!

        val decorationId2 =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO decoration (
                    category_id,
                    subcategory_id,
                    name_sv,
                    name_en,
                    initial_number,
                    year_display,
                    description_sv,
                    description_en,
                    display_order
                )
                VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                categoryId,
                "Testdekoration tva",
                "Test decoration two",
                14,
                "2022",
                "Beskrivning tva",
                "Description two",
                2,
            )!!

        try {
            mockMvc
                .perform(get("/api/decorations"))
                .andExpect(status().isOk)
                .andExpect(jsonPath("$[?(@.id == %s)]".format(decorationId1)).isNotEmpty)
                .andExpect(jsonPath("$[?(@.id == %s)]".format(decorationId2)).isNotEmpty)
        } finally {
            jdbcTemplate.update("DELETE FROM decoration WHERE id IN (?, ?)", decorationId1, decorationId2)
            jdbcTemplate.update("DELETE FROM category WHERE id = ?", categoryId)
            jdbcTemplate.update("DELETE FROM browse_group WHERE id = ?", browseGroupId)
        }
    }

    @Test
    fun `get decorations page returns page metadata and sorted content`() {
        val browseGroupId =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO browse_group (key, title_sv, title_en, display_order)
                VALUES (?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                "test_group_paged_decorations",
                "Testgrupp sida",
                "Test group page",
                9993,
            )!!

        val categoryId =
            jdbcTemplate.queryForObject(
                """
                INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
                VALUES (?, ?, ?, ?, ?, ?)
                RETURNING id
                """.trimIndent(),
                Long::class.java,
                browseGroupId,
                "TX",
                "Testkategori sida",
                "Test category page",
                9993,
                true,
            )!!

        val decorationId1 = insertDecoration(categoryId, "Sida ett", "Page one", 21, 1)
        val decorationId2 = insertDecoration(categoryId, "Sida tva", "Page two", 22, 2)
        val decorationId3 = insertDecoration(categoryId, "Sida tre", "Page three", 23, 3)

        try {
            mockMvc
                .perform(
                    get("/api/decorations/paged")
                        .param("page", "0")
                        .param("size", "2")
                        .param("sortBy", "id")
                        .param("direction", "desc"),
                ).andExpect(status().isOk)
                .andExpect(jsonPath("$.size").value(2))
                .andExpect(jsonPath("$.number").value(0))
                .andExpect(jsonPath("$.content.length()").value(2))
                .andExpect(jsonPath("$.content[0].id").value(decorationId3))
                .andExpect(jsonPath("$.content[1].id").value(decorationId2))
        } finally {
            jdbcTemplate.update(
                "DELETE FROM decoration WHERE id IN (?, ?, ?)",
                decorationId1,
                decorationId2,
                decorationId3,
            )
            jdbcTemplate.update("DELETE FROM category WHERE id = ?", categoryId)
            jdbcTemplate.update("DELETE FROM browse_group WHERE id = ?", browseGroupId)
        }
    }

    private fun insertDecoration(
        categoryId: Long,
        nameSv: String,
        nameEn: String,
        initialNumber: Int,
        displayOrder: Int,
    ): Long =
        jdbcTemplate.queryForObject(
            """
            INSERT INTO decoration (
                category_id,
                subcategory_id,
                name_sv,
                name_en,
                initial_number,
                year_display,
                description_sv,
                description_en,
                display_order
            )
            VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?)
            RETURNING id
            """.trimIndent(),
            Long::class.java,
            categoryId,
            nameSv,
            nameEn,
            initialNumber,
            "2026",
            "Beskrivning",
            "Description",
            displayOrder,
        )!!
}
