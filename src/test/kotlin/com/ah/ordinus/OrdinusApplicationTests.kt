package com.ah.ordinus

import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Import

@Import(TestcontainersConfiguration::class)
@SpringBootTest(properties = ["app.blob.seed.enabled=false"])
class OrdinusApplicationTests {
    @Test
    fun contextLoads() {
    }
}
