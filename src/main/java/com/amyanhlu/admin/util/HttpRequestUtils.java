package com.amyanhlu.admin.util;

import jakarta.servlet.http.HttpServletRequest;

/** Request metadata helpers shared by audit-aware services. */
public final class HttpRequestUtils {

    private HttpRequestUtils() {
    }

    public static String clientIp(HttpServletRequest request) {
        if (request == null) {
            return null;
        }

        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return forwardedFor.split(",", 2)[0].trim();
        }
        return request.getRemoteAddr();
    }
}
