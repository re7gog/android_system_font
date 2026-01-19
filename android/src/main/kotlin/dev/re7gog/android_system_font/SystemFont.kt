package dev.re7gog.android_system_font

import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.fonts.SystemFonts
import android.os.Build
import kotlin.math.abs

class SystemFont {
    fun getFilePath(): String {
        val fallback = "/system/fonts/Roboto-Regular.ttf"
        val blacklist = "/system/fonts/DroidSansMono.ttf"

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return fallback

        val systemMetrics = Paint().apply {
            typeface = Typeface.DEFAULT
            textSize = 100f
        }.fontMetrics

        val availableFonts = SystemFonts.getAvailableFonts()
        availableFonts.forEach {
            val testMetrics = Paint().apply {
                typeface = Typeface.createFromFile(it.file)
                textSize = 100f
            }.fontMetrics

            val fontPath = it.file?.absolutePath ?: fallback
            if (isMetricsMatch(systemMetrics, testMetrics) &&
                fontPath != fallback && fontPath != blacklist)
                return fontPath
        }
        return fallback
    }

    private fun isMetricsMatch(m1: Paint.FontMetrics, m2: Paint.FontMetrics): Boolean {
        val threshold = 0.0001f
        return abs(m1.ascent - m2.ascent) < threshold &&
                abs(m1.descent - m2.descent) < threshold &&
                abs(m1.leading - m2.leading) < threshold &&
                abs(m1.bottom - m2.bottom) < threshold &&
                abs(m1.top - m2.top) < threshold
    }
}