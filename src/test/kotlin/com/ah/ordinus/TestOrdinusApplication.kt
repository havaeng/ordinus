package com.ah.ordinus

import org.springframework.boot.fromApplication
import org.springframework.boot.with

fun main(args: Array<String>) {
    fromApplication<OrdinusApplication>().with(TestcontainersConfiguration::class).run(*args)
}
