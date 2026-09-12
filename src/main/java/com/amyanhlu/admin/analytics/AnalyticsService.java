package com.amyanhlu.admin.analytics;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.Year;
import java.time.DayOfWeek;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class AnalyticsService {

    private final AnalyticsRepository analyticsRepository;

    public AnalyticsService(AnalyticsRepository analyticsRepository) {
        this.analyticsRepository = analyticsRepository;
    }

    public RequestAnalytics getRequests(String view, String township, Long hospitalId) {
        boolean hospitalView = "hospital".equalsIgnoreCase(view);
        if (!hospitalView) {
            List<AnalyticsRepository.RequestTownshipRow> rows =
                    analyticsRepository.findRequestsByTownship(blankToNull(township));
            return new RequestAnalytics(
                    "township",
                    rows.stream().map(AnalyticsRepository.RequestTownshipRow::getTownship).toList(),
                    rows.stream().map(row -> value(row.getRequestCount())).toList(),
                    rows.stream().map(row -> value(row.getUnitsRequested())).toList());
        }

        List<AnalyticsRepository.RequestHospitalRow> rows = analyticsRepository.findRequestsByHospital(
                blankToNull(township), hospitalId);
        return new RequestAnalytics(
                "hospital",
                rows.stream().map(AnalyticsRepository.RequestHospitalRow::getHospitalName).toList(),
                rows.stream().map(row -> value(row.getRequestCount())).toList(),
                rows.stream().map(row -> value(row.getUnitsRequested())).toList());
    }

    public Locations getLocations() {
        List<LocationTownship> townships = analyticsRepository.findActiveYangonTownships().stream()
                .map(row -> new LocationTownship(row.getTownship()))
                .toList();
        List<LocationHospital> hospitals = analyticsRepository.findActiveYangonHospitals().stream()
                .map(row -> new LocationHospital(row.getHospitalId(), row.getHospitalName(), row.getTownship()))
                .toList();
        return new Locations(townships, hospitals);
    }

    public DonationAnalytics getDonations(String timeframe) {
        String normalized = normalizeTimeframe(timeframe);
        LocalDate fromDate = switch (normalized) {
            case "days" -> LocalDate.now().minusDays(29);
            case "weeks" -> LocalDate.now().minusWeeks(11);
            default -> LocalDate.now().minusMonths(11).withDayOfMonth(1);
        };
        String dateFormat = switch (normalized) {
            case "days" -> "%Y-%m-%d";
            case "weeks" -> "%x-W%v";
            default -> "%Y-%m";
        };

        List<AnalyticsRepository.DonationPeriodRow> rows =
                analyticsRepository.findDonationsByPeriod(fromDate, dateFormat);
        LinkedHashSet<String> labels = new LinkedHashSet<>();
        LinkedHashMap<Long, DatasetBuilder> datasets = new LinkedHashMap<>();
        for (AnalyticsRepository.DonationPeriodRow row : rows) {
            labels.add(row.getPeriodLabel());
            DatasetBuilder dataset = datasets.computeIfAbsent(row.getHospitalId(),
                    id -> new DatasetBuilder(row.getHospitalName()));
            dataset.values.put(row.getPeriodLabel(), value(row.getUnitsDonated()));
        }

        List<String> labelList = new ArrayList<>(labels);
        List<DonationDataset> datasetList = datasets.values().stream()
                .map(dataset -> new DonationDataset(dataset.label,
                        labelList.stream().map(label -> dataset.values.getOrDefault(label, 0L)).toList()))
                .toList();
        return new DonationAnalytics(normalized, labelList, datasetList);
    }

    public DonationTotals getDonationTotals(String mode, String date, Integer year,
                                             Integer week, Integer month) {
        String normalized = normalizeMode(mode);
        PeriodSelection period = resolvePeriod(normalized, date, year, week, month);
        List<AnalyticsRepository.DonationTotalRow> rows =
                analyticsRepository.findDonationTotals(period.fromDate(), period.toDate());
        return new DonationTotals(
                normalized,
                period.label(),
                rows.stream().map(AnalyticsRepository.DonationTotalRow::getHospitalName).toList(),
                rows.stream().map(row -> value(row.getUnitsDonated())).toList());
    }

    public InventoryAnalytics getInventory() {
        List<AnalyticsRepository.InventoryRow> rows = analyticsRepository.findInventoryByBloodGroup();
        return new InventoryAnalytics(
                rows.stream().map(AnalyticsRepository.InventoryRow::getBloodGroup).toList(),
                rows.stream().map(row -> value(row.getUnitsAvailable())).toList());
    }

    public AnnualAnalytics getAnnualDonations() {
        int currentYear = Year.now().getValue();
        int firstYear = currentYear - 4;
        Map<Integer, Long> values = new LinkedHashMap<>();
        for (int year = firstYear; year <= currentYear; year++) {
            values.put(year, 0L);
        }
        for (AnalyticsRepository.AnnualDonationRow row :
                analyticsRepository.findAnnualDonations(LocalDate.of(firstYear, 1, 1))) {
            values.put(row.getDonationYear(), value(row.getUnitsDonated()));
        }
        return new AnnualAnalytics(
                values.keySet().stream().map(String::valueOf).toList(),
                values.values().stream().toList());
    }

    private static String normalizeTimeframe(String timeframe) {
        return switch (timeframe == null ? "" : timeframe.toLowerCase()) {
            case "days", "weeks", "months" -> timeframe.toLowerCase();
            default -> "months";
        };
    }

    private static String normalizeMode(String mode) {
        return switch (mode == null ? "" : mode.toLowerCase()) {
            case "days", "weeks", "months" -> mode.toLowerCase();
            default -> "days";
        };
    }

    private static PeriodSelection resolvePeriod(String mode, String date, Integer year,
                                                 Integer week, Integer month) {
        LocalDate today = LocalDate.now();
        if ("days".equals(mode)) {
            LocalDate selected = parseDateOrToday(date, today);
            return new PeriodSelection(selected, selected.plusDays(1),
                    selected.format(DateTimeFormatter.ofPattern("MMM d, uuuu")));
        }

        if ("weeks".equals(mode)) {
            WeekFields iso = WeekFields.ISO;
            int selectedYear = year == null ? today.get(iso.weekBasedYear()) : year;
            int selectedWeek = week == null ? today.get(iso.weekOfWeekBasedYear()) : week;
            if (selectedYear < 1 || selectedWeek < 1 || selectedWeek > 53) {
                selectedYear = today.get(iso.weekBasedYear());
                selectedWeek = today.get(iso.weekOfWeekBasedYear());
            }
            LocalDate weekStart = LocalDate.of(selectedYear, 1, 4)
                    .with(iso.weekBasedYear(), selectedYear)
                    .with(iso.weekOfWeekBasedYear(), selectedWeek)
                    .with(DayOfWeek.MONDAY);
            return new PeriodSelection(weekStart, weekStart.plusDays(7),
                    "Week " + String.format("%02d", selectedWeek) + " (" + weekStart + " - "
                            + weekStart.plusDays(6) + ")");
        }

        int selectedYear = year == null ? today.getYear() : year;
        int selectedMonth = month == null ? today.getMonthValue() : month;
        if (selectedYear < 1 || selectedMonth < 1 || selectedMonth > 12) {
            selectedYear = today.getYear();
            selectedMonth = today.getMonthValue();
        }
        YearMonth selected = YearMonth.of(selectedYear, selectedMonth);
        return new PeriodSelection(selected.atDay(1), selected.plusMonths(1).atDay(1),
                selected.format(DateTimeFormatter.ofPattern("MMMM uuuu")));
    }

    private static LocalDate parseDateOrToday(String date, LocalDate fallback) {
        try {
            return date == null || date.isBlank() ? fallback : LocalDate.parse(date);
        } catch (RuntimeException ignored) {
            return fallback;
        }
    }

    private static String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private static long value(Long value) {
        return value == null ? 0L : value;
    }

    private record PeriodSelection(LocalDate fromDate, LocalDate toDate, String label) { }

    private static final class DatasetBuilder {
        private final String label;
        private final Map<String, Long> values = new LinkedHashMap<>();

        private DatasetBuilder(String label) {
            this.label = label;
        }
    }

    public record RequestAnalytics(String view, List<String> labels, List<Long> requestCounts,
                                   List<Long> unitsRequested) { }

    public record Locations(List<LocationTownship> townships, List<LocationHospital> hospitals) { }

    public record LocationTownship(String name) { }

    public record LocationHospital(Long id, String name, String township) { }

    public record DonationAnalytics(String timeframe, List<String> labels,
                                    List<DonationDataset> datasets) { }

    public record DonationTotals(String mode, String periodLabel, List<String> labels,
                                 List<Long> values) { }

    public record DonationDataset(String label, List<Long> data) { }

    public record InventoryAnalytics(List<String> labels, List<Long> values) { }

    public record AnnualAnalytics(List<String> labels, List<Long> values) { }
}
