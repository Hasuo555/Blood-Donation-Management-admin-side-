package com.amyanhlu.admin.analytics;

import com.amyanhlu.admin.entity.Hospital;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

/** Native read-only queries used by the administrator analytics dashboard. */
@Repository
public interface AnalyticsRepository extends JpaRepository<Hospital, Long> {

    @Query(value = """
            SELECT a.township AS township,
                   COUNT(r.id) AS requestCount,
                   COALESCE(SUM(r.units_required), 0) AS unitsRequested
            FROM blood_requests r
            INNER JOIN hospitals h ON h.id = r.hospital_id
            INNER JOIN addresses a ON a.id = h.address_id
            WHERE h.status = 'ACTIVE'
              AND a.division = 'Yangon Region'
              AND (:township IS NULL OR a.township = :township)
            GROUP BY a.township
            ORDER BY a.township
            """, nativeQuery = true)
    List<RequestTownshipRow> findRequestsByTownship(@Param("township") String township);

    @Query(value = """
            SELECT h.id AS hospitalId,
                   h.name AS hospitalName,
                   a.township AS township,
                   COUNT(r.id) AS requestCount,
                   COALESCE(SUM(r.units_required), 0) AS unitsRequested
            FROM blood_requests r
            INNER JOIN hospitals h ON h.id = r.hospital_id
            INNER JOIN addresses a ON a.id = h.address_id
            WHERE h.status = 'ACTIVE'
              AND a.division = 'Yangon Region'
              AND (:township IS NULL OR a.township = :township)
              AND (:hospitalId IS NULL OR h.id = :hospitalId)
            GROUP BY h.id, h.name, a.township
            ORDER BY a.township, h.name
            """, nativeQuery = true)
    List<RequestHospitalRow> findRequestsByHospital(@Param("township") String township,
                                                     @Param("hospitalId") Long hospitalId);

    @Query(value = """
            SELECT DISTINCT a.township AS township
            FROM hospitals h
            INNER JOIN addresses a ON a.id = h.address_id
            WHERE h.status = 'ACTIVE'
              AND a.division = 'Yangon Region'
            ORDER BY a.township
            """, nativeQuery = true)
    List<TownshipRow> findActiveYangonTownships();

    @Query(value = """
            SELECT h.id AS hospitalId, h.name AS hospitalName, a.township AS township
            FROM hospitals h
            INNER JOIN addresses a ON a.id = h.address_id
            WHERE h.status = 'ACTIVE'
              AND a.division = 'Yangon Region'
            ORDER BY a.township, h.name
            """, nativeQuery = true)
    List<HospitalLocationRow> findActiveYangonHospitals();

    @Query(value = """
            SELECT DATE_FORMAT(d.donation_date, :dateFormat) AS periodLabel,
                   MIN(d.donation_date) AS periodStart,
                   h.id AS hospitalId,
                   h.name AS hospitalName,
                   COALESCE(SUM(d.units), 0) AS unitsDonated
            FROM donations d
            INNER JOIN hospitals h ON h.id = d.hospital_id
            INNER JOIN addresses a ON a.id = h.address_id
            WHERE d.status = 'COMPLETED'
              AND d.donation_date >= :fromDate
              AND h.status = 'ACTIVE'
              AND a.division = 'Yangon Region'
            GROUP BY DATE_FORMAT(d.donation_date, :dateFormat), h.id, h.name
            ORDER BY periodStart, h.name
            """, nativeQuery = true)
    List<DonationPeriodRow> findDonationsByPeriod(@Param("fromDate") LocalDate fromDate,
                                                   @Param("dateFormat") String dateFormat);

    @Query(value = """
            SELECT h.id AS hospitalId,
                   h.name AS hospitalName,
                   COALESCE(SUM(d.units), 0) AS unitsDonated
            FROM donations d
            INNER JOIN hospitals h ON h.id = d.hospital_id
            INNER JOIN addresses a ON a.id = h.address_id
            WHERE d.status = 'COMPLETED'
              AND d.donation_date >= :fromDate
              AND d.donation_date < :toDate
              AND h.status = 'ACTIVE'
              AND a.division = 'Yangon Region'
            GROUP BY h.id, h.name
            ORDER BY unitsDonated DESC, h.name
            """, nativeQuery = true)
    List<DonationTotalRow> findDonationTotals(@Param("fromDate") LocalDate fromDate,
                                              @Param("toDate") LocalDate toDate);

    @Query(value = """
            SELECT bt.display_name AS bloodGroup,
                   COALESCE(SUM(stock.units_available), 0) AS unitsAvailable
            FROM blood_types bt
            LEFT JOIN (
                SELECT bi.blood_type_id, SUM(bi.units_available) AS units_available
                FROM blood_inventory bi
                INNER JOIN hospitals h ON h.id = bi.hospital_id
                INNER JOIN addresses a ON a.id = h.address_id
                WHERE h.status = 'ACTIVE'
                  AND a.division = 'Yangon Region'
                GROUP BY bi.blood_type_id
            ) stock ON stock.blood_type_id = bt.id
            GROUP BY bt.id, bt.display_name
            ORDER BY bt.id
            """, nativeQuery = true)
    List<InventoryRow> findInventoryByBloodGroup();

    @Query(value = """
            SELECT YEAR(d.donation_date) AS donationYear,
                   COALESCE(SUM(d.units), 0) AS unitsDonated
            FROM donations d
            INNER JOIN hospitals h ON h.id = d.hospital_id
            INNER JOIN addresses a ON a.id = h.address_id
            WHERE d.status = 'COMPLETED'
              AND d.donation_date >= :fromDate
              AND h.status = 'ACTIVE'
              AND a.division = 'Yangon Region'
            GROUP BY YEAR(d.donation_date)
            ORDER BY donationYear
            """, nativeQuery = true)
    List<AnnualDonationRow> findAnnualDonations(@Param("fromDate") LocalDate fromDate);

    interface RequestTownshipRow {
        String getTownship();
        Long getRequestCount();
        Long getUnitsRequested();
    }

    interface RequestHospitalRow {
        Long getHospitalId();
        String getHospitalName();
        String getTownship();
        Long getRequestCount();
        Long getUnitsRequested();
    }

    interface TownshipRow {
        String getTownship();
    }

    interface HospitalLocationRow {
        Long getHospitalId();
        String getHospitalName();
        String getTownship();
    }

    interface DonationPeriodRow {
        String getPeriodLabel();
        Long getHospitalId();
        String getHospitalName();
        Long getUnitsDonated();
    }

    interface DonationTotalRow {
        Long getHospitalId();
        String getHospitalName();
        Long getUnitsDonated();
    }

    interface InventoryRow {
        String getBloodGroup();
        Long getUnitsAvailable();
    }

    interface AnnualDonationRow {
        Integer getDonationYear();
        Long getUnitsDonated();
    }
}
