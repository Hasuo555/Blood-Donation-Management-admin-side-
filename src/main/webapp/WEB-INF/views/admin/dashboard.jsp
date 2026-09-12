<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<%@ include file="../layout/header.jsp" %>

<div class="page-header">
    <h1 class="page-title">Dashboard</h1>
    <p class="page-subtitle">System-wide overview</p>
</div>

<div class="metrics-grid">
    <div class="metric-card metric-card--blue">
        <div class="metric-icon">
            <svg viewBox="0 0 24 24"><path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v2h20v-2c0-3.3-6.7-5-10-5z"/></svg>
        </div>
        <div class="metric-body">
            <div class="metric-value">${metrics['totalDonors']}</div>
            <div class="metric-label">Total Donors</div>
        </div>
    </div>

    <div class="metric-card metric-card--green">
        <div class="metric-icon">
            <svg viewBox="0 0 24 24"><path d="M16 11c1.7 0 3-1.3 3-3s-1.3-3-3-3-3 1.3-3 3 1.3 3 3 3zm-8 0c1.7 0 3-1.3 3-3S9.7 5 8 5 5 6.3 5 8s1.3 3 3 3zm0 2c-2.3 0-7 1.2-7 3.5V19h14v-2.5C15 14.2 10.3 13 8 13zm8 0c-.3 0-.6 0-1 .1 1.2.8 2 2 2 3.4V19h6v-2.5c0-2.3-4.7-3.5-7-3.5z"/></svg>
        </div>
        <div class="metric-body">
            <div class="metric-value">${metrics['activeStaff']}</div>
            <div class="metric-label">Active Staff</div>
        </div>
    </div>

    <div class="metric-card metric-card--purple">
        <div class="metric-icon">
            <svg viewBox="0 0 24 24"><path d="M19 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2zm-7 14v-4H8v-2h4V7h2v4h4v2h-4v4h-2z"/></svg>
        </div>
        <div class="metric-body">
            <div class="metric-value">${metrics['totalHospitals']}</div>
            <div class="metric-label">Hospitals</div>
        </div>
    </div>

    <div class="metric-card metric-card--orange">
        <div class="metric-icon">
            <svg viewBox="0 0 24 24"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/></svg>
        </div>
        <div class="metric-body">
            <div class="metric-value">${metrics['totalAppointments']}</div>
            <div class="metric-label">Appointments</div>
        </div>
    </div>

    <div class="metric-card metric-card--teal">
        <div class="metric-icon">
            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/></svg>
        </div>
        <div class="metric-body">
            <div class="metric-value">${metrics['completedDonations']}</div>
            <div class="metric-label">Completed Donations</div>
        </div>
    </div>

    <div class="metric-card metric-card--red">
        <div class="metric-icon">
            <svg viewBox="0 0 24 24"><path d="M12 2C8 2 4 6 4 10c0 5.5 7 12 8 12s8-6.5 8-12c0-4-4-8-8-8z" fill="none" stroke="currentColor" stroke-width="2"/><path d="M12 7v6M9 10h6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
        </div>
        <div class="metric-body">
            <div class="metric-value">${metrics['emergencyRequests']}</div>
            <div class="metric-label">Open Emergency Requests</div>
        </div>
    </div>

    <div class="metric-card metric-card--gray">
        <div class="metric-icon">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zm4 18H6V4h7v5h5v11zm-5-5H8v-2h5v2zm3-4H8V9h8v2z"/></svg>
        </div>
        <div class="metric-body">
            <div class="metric-value">${metrics['totalAuditLogs']}</div>
            <div class="metric-label">System Activity Logs</div>
        </div>
    </div>
</div>

<div class="page-header analytics-heading">
    <div>
        <h2 class="section-title">Yangon Region Analytics</h2>
        <p class="page-subtitle">Live views of active hospital requests, donations, and blood stock.</p>
    </div>
</div>

<div class="analytics-grid">
    <section class="card analytics-card analytics-card--wide">
        <div class="card-header analytics-card-header">
            <div>
                <h3>Blood Requests</h3>
                <p>Requests by township or active hospital</p>
            </div>
            <div class="analytics-filters">
                <label class="sr-only" for="requestView">Request view</label>
                <select id="requestView" class="form-control form-control-sm">
                    <option value="township">By township</option>
                    <option value="hospital">By hospital</option>
                </select>
                <label class="sr-only" for="requestTownship">Township</label>
                <select id="requestTownship" class="form-control form-control-sm" hidden>
                    <option value="">All townships</option>
                </select>
                <label class="sr-only" for="requestHospital">Hospital</label>
                <select id="requestHospital" class="form-control form-control-sm" hidden>
                    <option value="">All hospitals</option>
                </select>
            </div>
        </div>
        <div class="analytics-chart-wrap analytics-chart-wrap--requests"><canvas id="requestsChart"></canvas></div>
    </section>

    <section class="card analytics-card analytics-card--wide">
        <div class="card-header analytics-card-header">
            <div>
                <h3>Donated Units per Hospital</h3>
                <p>Completed donations in Yangon Region</p>
            </div>
            <div class="analytics-toggle" role="group" aria-label="Donation timeframe">
                <span id="donationPeriodLabel" class="analytics-period-label">Last 30 days</span>
                <label class="analytics-picker" id="dayPickerWrap" for="datePicker">
                    <span class="sr-only">Donation date</span>
                    <input id="datePicker" type="date" aria-label="Donation date" />
                </label>
                <label class="analytics-picker" id="weekPickerWrap" for="weekPicker" hidden>
                    <span class="sr-only">Donation week</span>
                    <input id="weekPicker" type="week" aria-label="Donation week" />
                </label>
                <label class="analytics-picker" id="monthPickerWrap" for="monthPicker" hidden>
                    <span class="sr-only">Donation month</span>
                    <input id="monthPicker" type="month" aria-label="Donation month" />
                </label>
                <button type="button" class="btn btn-sm active" data-timeframe="days">Days</button>
                <button type="button" class="btn btn-sm" data-timeframe="weeks">Weeks</button>
                <button type="button" class="btn btn-sm" data-timeframe="months">Months</button>
            </div>
        </div>
        <div class="analytics-chart-wrap analytics-chart-wrap--donations"><canvas id="donationsChart"></canvas></div>
    </section>

    <section class="card analytics-card">
        <div class="card-header">
            <h3>Inventory by Blood Type</h3>
            <p>Available units at active Yangon hospitals</p>
        </div>
        <div class="analytics-chart-wrap analytics-chart-wrap--donut"><canvas id="inventoryChart"></canvas></div>
    </section>

    <section class="card analytics-card">
        <div class="card-header">
            <h3>Annual Donation Trends</h3>
            <p>Five-year completed donation comparison</p>
        </div>
        <div class="analytics-chart-wrap"><canvas id="annualChart"></canvas></div>
    </section>
</div>

<div id="analyticsError" class="alert alert-error analytics-error" hidden>
    Analytics data could not be loaded. Please refresh and try again.
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
<script>
    (() => {
        const colors = ['#dc2626', '#2563eb', '#16a34a', '#f59e0b', '#7c3aed', '#0891b2', '#db2777', '#64748b'];
        const charts = {};
        const state = { locations: { townships: [], hospitals: [] } };
        if (typeof Chart === 'undefined') {
            console.error('Chart.js failed to load.');
            showError();
            return;
        }
        const barValueLabels = {
            id: 'barValueLabels',
            afterDatasetsDraw(chart) {
                if (chart.config.type !== 'bar') return;
                const context = chart.ctx;
                const dataset = chart.getDatasetMeta(0);
                context.save();
                context.font = '600 11px Inter, sans-serif';
                context.textBaseline = 'middle';
                dataset.data.forEach((bar, index) => {
                    const value = Number(chart.data.datasets[0].data[index]);
                    if (!Number.isFinite(value)) return;
                    const suffix = chart.canvas.id === 'requestsChart' ? ' requests' : ' units';
                    const text = value.toLocaleString() + suffix;
                    const inside = bar.width > 70;
                    context.fillStyle = inside ? '#ffffff' : '#334155';
                    context.textAlign = inside ? 'right' : 'left';
                    context.fillText(text, inside ? bar.x - 8 : bar.x + 8, bar.y);
                });
                context.restore();
            }
        };
        Chart.register(barValueLabels);

        const json = (url) => fetch(url, {headers: {'Accept': 'application/json'}})
            .then(response => {
                if (!response.ok) throw new Error('Request failed');
                return response.json();
            });

        const replaceChart = (key, canvasId, config) => {
            if (charts[key]) charts[key].destroy();
            const canvas = document.getElementById(canvasId);
            if (!canvas) return;
            try {
                charts[key] = new Chart(canvas, config);
            } catch (error) {
                console.error('Unable to render ' + key + ' chart', error);
                showError();
            }
        };

        const baseOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { color: '#64748b' } },
                y: { beginAtZero: true, ticks: { precision: 0, color: '#64748b' }, grid: { color: '#e2e8f0' } }
            }
        };

        function showError() {
            document.getElementById('analyticsError').hidden = false;
        }

        function populateLocations() {
            const township = document.getElementById('requestTownship');
            state.locations.townships.forEach(item => township.add(new Option(item.name, item.name)));
            refreshHospitalOptions();
        }

        function refreshHospitalOptions() {
            const hospital = document.getElementById('requestHospital');
            const township = document.getElementById('requestTownship').value;
            hospital.length = 1;
            state.locations.hospitals
                .filter(item => !township || item.township === township)
                .forEach(item => hospital.add(new Option(item.name + ' Â· ' + item.township, item.id)));
        }

        function syncRequestFilters() {
            const hospitalView = document.getElementById('requestView').value === 'hospital';
            document.getElementById('requestTownship').hidden = !hospitalView;
            document.getElementById('requestHospital').hidden = !hospitalView;
        }

        function loadRequests() {
            const view = document.getElementById('requestView').value;
            const params = new URLSearchParams({view});
            const township = document.getElementById('requestTownship').value;
            const hospitalId = document.getElementById('requestHospital').value;
            if (view === 'hospital' && township) params.set('township', township);
            if (view === 'hospital' && hospitalId) params.set('hospitalId', hospitalId);
            return json('<c:url value="/admin/api/analytics/requests" />?' + params)
                .then(data => {
                    const labels = Array.isArray(data.labels) ? data.labels : [];
                    const counts = Array.isArray(data.requestCounts) ? data.requestCounts : [];
                    const units = Array.isArray(data.unitsRequested) ? data.unitsRequested : [];
                    const pairs = labels.map((label, index) => ({
                        label,
                        value: Number(counts[index]) || 0,
                        units: Number(units[index]) || 0
                    })).sort((left, right) => right.value - left.value);
                    replaceChart('requests', 'requestsChart', {
                        type: 'bar',
                        data: {
                            labels: pairs.map(pair => pair.label),
                            datasets: [{
                                label: 'Requests',
                                data: pairs.map(pair => pair.value),
                                backgroundColor: '#ef4444',
                                borderRadius: 5,
                                borderSkipped: false,
                                barPercentage: .72,
                                categoryPercentage: .82
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            indexAxis: 'y',
                            plugins: {
                                legend: {display: false},
                                tooltip: {callbacks: {
                                    label: context => ' ' + context.raw + ' requests',
                                    afterLabel: context => 'Units requested: ' + pairs[context.dataIndex].units
                                }}
                            },
                            scales: {
                                x: {beginAtZero: true, ticks: {precision: 0, color: '#64748b'}, grid: {color: '#e2e8f0'}, title: {display: true, text: 'Requests', color: '#64748b', font: {weight: '600'}}},
                                y: {grid: {display: false}, ticks: {color: '#334155', autoSkip: false}, title: {display: true, text: view === 'hospital' ? 'Hospital' : 'Township', color: '#64748b', font: {weight: '600'}}}
                            },
                            layout: {padding: {right: 42}}
                        }
                    });
                });
        }

        function loadDonations(mode) {
            const params = new URLSearchParams({mode});
            if (mode === 'days') {
                params.set('date', document.getElementById('datePicker').value);
            } else if (mode === 'weeks') {
                const [selectedYear, selectedWeek] = document.getElementById('weekPicker').value.split('-W');
                params.set('year', selectedYear);
                params.set('week', selectedWeek);
            } else {
                const [selectedYear, selectedMonth] = document.getElementById('monthPicker').value.split('-');
                params.set('year', selectedYear);
                params.set('month', selectedMonth);
            }
            return json('<c:url value="/admin/api/analytics/donation-totals" />?' + params)
                .then(data => {
                    document.getElementById('donationPeriodLabel').textContent = data.periodLabel || 'Selected period';
                    const labels = data.labels || [];
                    const values = (data.values || []).map(value => Number(value) || 0);
                    replaceChart('donations', 'donationsChart', {
                        type: 'bar',
                        data: {labels, datasets: [{
                            label: 'Donated units', data: values,
                            backgroundColor: labels.map((_, index) => 'rgba(79, 70, 229, ' + Math.max(.45, 1 - index * .035) + ')'),
                            borderRadius: 5, borderSkipped: false, barPercentage: .72, categoryPercentage: .82
                        }]},
                        options: {
                            responsive: true, maintainAspectRatio: false,
                            indexAxis: 'y',
                            plugins: {
                                legend: {display: false},
                                tooltip: {callbacks: {label: context => ' ' + context.raw + ' units'}}
                            },
                            scales: {
                                x: {beginAtZero: true, ticks: {precision: 0, color: '#64748b'}, grid: {color: '#e2e8f0'}, title: {display: true, text: 'Donated units', color: '#64748b', font: {weight: '600'}}},
                                y: {grid: {display: false}, ticks: {color: '#334155', autoSkip: false}, title: {display: true, text: 'Hospital', color: '#64748b', font: {weight: '600'}}}
                            },
                            layout: {padding: {right: 38}}
                        }
                    });
                });
        }

        function currentIsoWeek(date) {
            const target = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
            const day = target.getUTCDay() || 7;
            target.setUTCDate(target.getUTCDate() + 4 - day);
            const yearStart = new Date(Date.UTC(target.getUTCFullYear(), 0, 1));
            const week = Math.ceil((((target - yearStart) / 86400000) + 1) / 7);
            return target.getUTCFullYear() + '-W' + String(week).padStart(2, '0');
        }

        function initializeDonationPickers() {
            const today = new Date();
            const dateValue = [today.getFullYear(), String(today.getMonth() + 1).padStart(2, '0'), String(today.getDate()).padStart(2, '0')].join('-');
            document.getElementById('datePicker').value = dateValue;
            document.getElementById('weekPicker').value = currentIsoWeek(today);
            document.getElementById('monthPicker').value = dateValue.slice(0, 7);
        }

        function syncDonationPicker(mode) {
            document.getElementById('dayPickerWrap').hidden = mode !== 'days';
            document.getElementById('weekPickerWrap').hidden = mode !== 'weeks';
            document.getElementById('monthPickerWrap').hidden = mode !== 'months';
        }

        function loadInventory() {
            return json('<c:url value="/admin/api/analytics/inventory" />')
                .then(data => replaceChart('inventory', 'inventoryChart', {
                    type: 'doughnut', data: {labels: data.labels, datasets: [{data: data.values, backgroundColor: colors, borderWidth: 2, borderColor: '#fff'}]},
                    options: {responsive: true, maintainAspectRatio: false, cutout: '62%', plugins: {legend: {display: true, position: 'bottom'}}}
                }));
        }

        function loadAnnual() {
            return json('<c:url value="/admin/api/analytics/annual-donations" />')
                .then(data => replaceChart('annual', 'annualChart', {
                    type: 'line', data: {labels: data.labels, datasets: [{label: 'Donated units', data: data.values, borderColor: '#0d9488', backgroundColor: 'rgba(13,148,136,.12)', fill: true, tension: .3}]}, options: baseOptions
                }));
        }

        document.getElementById('requestView').addEventListener('change', () => { syncRequestFilters(); loadRequests().catch(showError); });
        document.getElementById('requestTownship').addEventListener('change', () => { refreshHospitalOptions(); loadRequests().catch(showError); });
        document.getElementById('requestHospital').addEventListener('change', () => loadRequests().catch(showError));
        document.querySelectorAll('[data-timeframe]').forEach(button => button.addEventListener('click', () => {
            document.querySelectorAll('[data-timeframe]').forEach(item => item.classList.remove('active'));
            button.classList.add('active');
            syncDonationPicker(button.dataset.timeframe);
            loadDonations(button.dataset.timeframe).catch(showError);
        }));
        ['datePicker', 'weekPicker', 'monthPicker'].forEach(id => {
            document.getElementById(id).addEventListener('change', () => {
                const mode = document.querySelector('[data-timeframe].active').dataset.timeframe;
                loadDonations(mode).catch(showError);
            });
        });

        initializeDonationPickers();
        syncDonationPicker('days');
        json('<c:url value="/admin/api/analytics/locations" />')
            .then(locations => { state.locations = locations || {townships: [], hospitals: []}; populateLocations(); syncRequestFilters(); return loadRequests(); })
            .catch(showError);
        loadInventory().catch(showError);
        loadAnnual().catch(showError);
        loadDonations('days').catch(showError);
    })();
</script>

<%@ include file="../layout/footer.jsp" %>
