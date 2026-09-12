package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.analytics.AnalyticsService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin/api/analytics")
public class AdminAnalyticsController {

    private final AnalyticsService analyticsService;

    public AdminAnalyticsController(AnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    @GetMapping(value = "/locations", produces = MediaType.APPLICATION_JSON_VALUE)
    public AnalyticsService.Locations locations() {
        return analyticsService.getLocations();
    }

    @GetMapping(value = "/requests", produces = MediaType.APPLICATION_JSON_VALUE)
    public AnalyticsService.RequestAnalytics requests(
            @RequestParam(defaultValue = "township") String view,
            @RequestParam(required = false) String township,
            @RequestParam(required = false) Long hospitalId) {
        return analyticsService.getRequests(view, township, hospitalId);
    }

    @GetMapping(value = "/donations", produces = MediaType.APPLICATION_JSON_VALUE)
    public AnalyticsService.DonationAnalytics donations(
            @RequestParam(defaultValue = "months") String timeframe) {
        return analyticsService.getDonations(timeframe);
    }

    @GetMapping(value = "/donation-totals", produces = MediaType.APPLICATION_JSON_VALUE)
    public AnalyticsService.DonationTotals donationTotals(
            @RequestParam(defaultValue = "days") String mode,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String year,
            @RequestParam(required = false) String week,
            @RequestParam(required = false) String month) {
        return analyticsService.getDonationTotals(mode, date,
                parseIntegerOrNull(year), parseIntegerOrNull(week), parseIntegerOrNull(month));
    }

    @GetMapping(value = "/inventory", produces = MediaType.APPLICATION_JSON_VALUE)
    public AnalyticsService.InventoryAnalytics inventory() {
        return analyticsService.getInventory();
    }

    @GetMapping(value = "/annual-donations", produces = MediaType.APPLICATION_JSON_VALUE)
    public AnalyticsService.AnnualAnalytics annualDonations() {
        return analyticsService.getAnnualDonations();
    }

    private static Integer parseIntegerOrNull(String value) {
        if (value == null || value.isBlank()) return null;
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException ignored) {
            return null;
        }
    }
}
