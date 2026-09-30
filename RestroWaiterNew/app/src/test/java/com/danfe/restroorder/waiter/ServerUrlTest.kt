package com.danfe.restroorder.waiter

import com.danfe.restroorder.waiter.util.ServerUrl
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Test

/** Unit tests for the URL builder that mirrors helper/Util.java of the old app. */
class ServerUrlTest {

    @Test fun modulesBaseDefaultPrefix() {
        assertEquals(
            "http://192.168.1.5:8007/Modules",
            ServerUrl.modulesBase("http", "192.168.1.5:8007", "/Modules"),
        )
    }

    @Test fun modulesBaseBlankPrefixFallsBackToModules() {
        assertEquals("https://pos.example.com/Modules", ServerUrl.modulesBase("https", "pos.example.com", ""))
    }

    @Test fun modulesBaseNormalizesMissingSlashAndTrailingSlash() {
        assertEquals("http://host/Modules", ServerUrl.modulesBase("http", "host", "Modules"))
        assertEquals("http://host/Modules", ServerUrl.modulesBase("http", "host/", "/Modules/"))
    }

    @Test fun servicesBaseMatchesOldItemShiftQuirk() {
        assertEquals("http://192.168.1.5:8007/Services", ServerUrl.servicesBase("http", "192.168.1.5:8007"))
    }

    @Test fun imageUrlEscapesSpaces() {
        assertEquals(
            "http://h/Modules/ROI_Item/ImageItem/a%20b.png",
            ServerUrl.imageUrl("http://h/Modules", "a b.png"),
        )
    }

    @Test fun validateAcceptsHostAndPort() {
        assertNull(ServerUrl.validateHostPort("192.168.1.5:8007"))
        assertNull(ServerUrl.validateHostPort("pos.example.com"))
        assertNull(ServerUrl.validateHostPort("http://192.168.1.5:8007")) // users paste full URLs too
    }

    @Test fun validateRejectsBadInput() {
        assertNotNull(ServerUrl.validateHostPort(""))
        assertNotNull(ServerUrl.validateHostPort("192.168.1.5:99999"))
        assertNotNull(ServerUrl.validateHostPort("bad host!"))
    }
}
