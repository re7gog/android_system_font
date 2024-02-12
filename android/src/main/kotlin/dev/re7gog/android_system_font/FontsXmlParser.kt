package dev.re7gog.android_system_font

import android.graphics.Typeface
import android.os.Build
import android.util.Xml
import org.xmlpull.v1.XmlPullParser
import java.io.File
import java.io.FileInputStream


class SystemFont {
    // Black magic
    private enum class SearchMode { PRODUCT, SYSTEM, LEGACY }
    private data class RecurFontSearchRes(val font: String?, val needResearch: Boolean = true)

    fun getFilePath(): String {
        // SystemFonts.getAvailableFonts() is useless here because
        // it only allows you to get a list of paths that don't even need to be searched
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                val fontName = Typeface.DEFAULT.systemFontFamilyName.toString()
                val res = recursiveFontSearch(SearchMode.PRODUCT, fontName)
                if (res != null) return "/product/fonts/$res"
                return "/system/fonts/${recursiveFontSearch(SearchMode.SYSTEM, fontName)!!}"
            } else return "/system/fonts/${recursiveFontSearch(SearchMode.LEGACY)!!}"
        } catch (_: Exception) {
            return "/system/fonts/Roboto-Regular.ttf"
        }
    }

    private fun recursiveFontSearch(searchMode: SearchMode, fontName: String? = null): String? {
        var res = RecurFontSearchRes(fontName)
        while (res.needResearch)  // Process aliases
            res = fontSearch(searchMode, res.font)
        return res.font
    }

    private fun fontSearch(searchMode: SearchMode, fontName: String?): RecurFontSearchRes {
        var fileName = "/system/etc/fonts.xml"
        var file = File(fileName)
        if (searchMode == SearchMode.PRODUCT) {
            fileName = "/product/etc/fonts_customization.xml"
            file = File(fileName)
            if (!file.exists()) return RecurFontSearchRes(null, false)
        }
        FileInputStream(file).use { stream ->
            val parser = Xml.newPullParser()
            parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false)
            parser.setInput(stream, null)
            parser.nextTag()
            return if (searchMode == SearchMode.PRODUCT) {
                fontsParser(parser, "fonts-modification", fontName)
            } else fontsParser(parser, "familyset", fontName)
        }
    }

    private fun fontsParser(
        parser: XmlPullParser, endTag: String, fontName: String?
    ): RecurFontSearchRes {
        var rightFamily = false
        while (true) {
            parser.next()
            val name = parser.name
            val eventType = parser.eventType
            if (fontName != null && name == "alias" &&
                parser.getAttributeValue(null, "name") == fontName)
            {
                val actualFont = parser.getAttributeValue(null, "to")
                return RecurFontSearchRes(actualFont, true)
            }
            else if (fontName != null && name == "family" && eventType == XmlPullParser.START_TAG &&
                parser.getAttributeValue(null, "name") == fontName)
            {
                rightFamily = true
            }
            else if (rightFamily && name == "family" && eventType == XmlPullParser.END_TAG)
            {
                rightFamily = false
            }
            else if (
                (fontName != null && rightFamily || fontName == null) &&
                name == "font" &&
                eventType == XmlPullParser.START_TAG &&
                parser.getAttributeValue(null, "style") == "normal" &&
                (fontName != null || fontName == null &&
                        parser.getAttributeValue(null, "weight") == "400")
                )
            {
                parser.next()
                return RecurFontSearchRes(parser.text.trim(), false)
            }
            else if (name == endTag && eventType == XmlPullParser.END_TAG)
            {
                return RecurFontSearchRes(null, false)
            }
        }
    }
}