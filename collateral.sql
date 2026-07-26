DROP TABLE IF EXISTS collateral_appraisal;

CREATE TABLE collateral_appraisal (
    app_id                   TEXT PRIMARY KEY,
    applicant_name           TEXT,
    collateral_type          TEXT,     -- Residential Property | Vehicle | Commercial/Equipment | Unsecured
    appraised_value          INTEGER,  -- NULL if unsecured or halted
    appraisal_date           TEXT,     -- ISO date; agent flags appraisals older than 120 days (policy 4.4)
    lien_position            TEXT,     -- 1st Lien | 2nd Lien | N/A
    condition_marketability  TEXT      -- Excellent | Good | Fair | Poor | N/A
);

-- Appraisal feed. ltv_pct and collateral_status are COMPUTED by the agent.
-- requested_amount comes from Agent 1 in context, not this table. No pipeline_state:
-- runtime handles halt. APP-006/007/018/021 are deliberately stale (>120 days).

INSERT INTO collateral_appraisal VALUES
('APP-001', 'James Smith', 'Residential Property', 562500, '2026-05-19', '1st Lien', 'Excellent'),
('APP-002', 'Mary Johnson', 'Vehicle', 38889, '2026-05-23', '1st Lien', 'Excellent'),
('APP-003', 'John Williams', NULL, NULL, NULL, NULL, NULL),
('APP-004', 'Patricia Brown', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-005', 'Robert Jones', 'Residential Property', 631579, '2026-06-04', '1st Lien', 'Good'),
('APP-006', 'Jennifer Garcia', 'Vehicle', 32941, '2025-12-10', '1st Lien', 'Excellent'),
('APP-007', 'Michael Miller', 'Residential Property', 355556, '2026-02-07', '1st Lien', 'Excellent'),
('APP-008', 'Linda Davis', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-009', 'David Rodriguez', 'Commercial/Equipment', 416667, '2026-06-04', '1st Lien', 'Fair'),
('APP-010', 'Elizabeth Martinez', 'Residential Property', 1214286, '2026-06-08', '1st Lien', 'Good'),
('APP-011', 'William Hernandez', 'Vehicle', 38182, '2026-05-27', '1st Lien', 'Fair'),
('APP-012', 'Barbara Lopez', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-013', 'Richard Gonzalez', 'Residential Property', 262500, '2026-06-04', '1st Lien', 'Fair'),
('APP-014', 'Susan Wilson', 'Commercial/Equipment', 50000, '2026-06-08', '1st Lien', 'Excellent'),
('APP-015', 'Joseph Anderson', 'Vehicle', 24000, '2026-06-12', '1st Lien', 'Excellent'),
('APP-016', 'Jessica Thomas', 'Residential Property', 687500, '2026-06-16', '1st Lien', 'Fair'),
('APP-017', 'Thomas Taylor', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-018', 'Sarah Moore', 'Commercial/Equipment', 769231, '2026-01-27', '1st Lien', 'Fair'),
('APP-019', 'Christopher Jackson', 'Vehicle', 68421, '2026-06-12', '1st Lien', 'Excellent'),
('APP-020', 'Karen Martin', 'Residential Property', 447059, '2026-06-16', '1st Lien', 'Good'),
('APP-021', 'Daniel Lee', 'Residential Property', 455556, '2026-03-17', '1st Lien', 'Good'),
('APP-022', 'Nancy Perez', NULL, NULL, NULL, NULL, NULL),
('APP-023', 'Matthew Thompson', 'Vehicle', 27500, '2026-06-12', '1st Lien', 'Fair'),
('APP-024', 'Lisa White', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-025', 'Anthony Harris', 'Residential Property', 1266667, '2026-06-20', '1st Lien', 'Good'),
('APP-026', 'Betty Sanchez', 'Vehicle', 52381, '2026-05-30', '1st Lien', 'Fair'),
('APP-027', 'Mark Clark', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-028', 'Sandra Ramirez', 'Residential Property', 280612, '2026-05-22', '1st Lien', 'Good'),
('APP-029', 'Donald Lewis', 'Commercial/Equipment', 214286, '2026-05-26', '1st Lien', 'Excellent'),
('APP-030', 'Ashley Robinson', 'Vehicle', 36471, '2026-05-30', '1st Lien', 'Fair'),
('APP-031', 'Steven Walker', 'Residential Property', 544444, '2026-06-03', '1st Lien', 'Fair'),
('APP-032', 'Kimberly Young', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-033', 'Andrew Allen', NULL, NULL, NULL, NULL, NULL),
('APP-034', 'Emily King', 'Residential Property', 1200000, '2026-05-30', '1st Lien', 'Fair'),
('APP-035', 'Joshua Wright', 'Commercial/Equipment', 375000, '2026-06-03', '1st Lien', 'Good'),
('APP-036', 'Donna Scott', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-037', 'Kevin Torres', 'Vehicle', 53333, '2026-06-11', '1st Lien', 'Fair'),
('APP-038', 'Michelle Nguyen', 'Residential Property', 411765, '2026-05-30', '1st Lien', 'Good'),
('APP-039', 'Brian Hill', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-040', 'Carol Flores', 'Vehicle', 15789, '2026-06-07', '1st Lien', 'Good'),
('APP-041', 'George Green', 'Residential Property', 637500, '2026-06-11', '1st Lien', 'Excellent'),
('APP-042', 'Amanda Adams', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-043', 'Edward Nelson', 'Vehicle', 38000, '2026-06-03', '1st Lien', 'Good'),
('APP-044', 'Melissa Baker', 'Commercial/Equipment', 266667, '2026-06-07', '1st Lien', 'Fair'),
('APP-045', 'Ronald Hall', 'Residential Property', 977778, '2026-06-11', '1st Lien', 'Good'),
('APP-046', 'Deborah Rivera', 'Unsecured', NULL, NULL, 'N/A', 'N/A'),
('APP-047', 'Timothy Campbell', 'Vehicle', 30588, '2026-06-19', '1st Lien', 'Fair'),
('APP-048', 'Stephanie Mitchell', 'Residential Property', 414286, '2026-06-23', '1st Lien', 'Good'),
('APP-049', 'Jason Carter', 'Commercial/Equipment', 470588, '2026-06-11', '1st Lien', 'Good'),
('APP-050', 'Rebecca Roberts', 'Vehicle', 57778, '2026-06-15', '1st Lien', 'Fair');
