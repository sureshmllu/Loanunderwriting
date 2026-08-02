-- ============================================================
-- Loan Underwriting - Combined data load
-- Consolidated from 5 source files in the Loanunderwriting repo.
-- Order: KYC/fraud + identity graph -> credit -> income -> collateral -> pricing config.
-- Tables are independent (keyed on app_id, no FKs); order is for readability only.
-- ============================================================


-- ############################################################
-- ## 1. kyc_screening_fraud.sql  (underwriting_kyc_screening, applicant_linkage)
-- ############################################################

-- ============================================================
-- Fraud/KYC gate input tables
-- Executed top to bottom: screening feed, then identity-graph linkage.
-- ============================================================

-- ---- Table 1: underwriting_kyc_screening --------------------
DROP TABLE IF EXISTS underwriting_kyc_screening;

CREATE TABLE underwriting_kyc_screening (
    app_id                    TEXT PRIMARY KEY,
    applicant_name            TEXT,
    id_verification           TEXT,     -- Pass | Fail
    doc_authenticity          TEXT,     -- Genuine | Suspect | Edited
    sanctions_ofac            TEXT,     -- Clear | Hit
    pep_check                 TEXT,     -- Clear | Match
    adverse_media             TEXT,     -- Clear | Flag
    synthetic_fraud_score     INTEGER,  -- 0-100 (>=85 hard stop)
    device_ip_risk            TEXT,     -- Low | Medium | High
    vpn_proxy_tor             INTEGER,  -- 0 | 1
    ip_geo                    TEXT,
    email_age_days            INTEGER,
    existing_customer         TEXT,     -- Yes | No
    internal_fraud_blocklist  TEXT,     -- No | Yes
    aml_risk_rating           TEXT      -- Low | Medium | High
);

-- Screening feed for the Fraud/KYC gate. Raw vendor + device signals only;
-- the gate DERIVES PASS/FLAG/HALT. Hard stops: OFAC Hit, ID Fail, synthetic >= 85.

INSERT INTO underwriting_kyc_screening VALUES
('APP-001', 'James Smith', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 10, 'Medium', 0, 'FL, US', 858, 'Yes', 'No', 'Low'),
('APP-002', 'Mary Johnson', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 3, 'Low', 0, 'MO, US', 147, 'No', 'No', 'Low'),
('APP-003', 'John Williams', 'Fail', 'Suspect', 'Clear', 'Clear', 'Clear', 88, 'Medium', 0, 'GA, US', 45, 'No', 'No', 'High'),
('APP-004', 'Patricia Brown', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 10, 'Medium', 0, 'MA, US', 1022, 'Yes', 'No', 'Low'),
('APP-005', 'Robert Jones', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 19, 'Low', 0, 'IL, US', 457, 'No', 'No', 'Medium'),
('APP-006', 'Jennifer Garcia', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 20, 'Low', 0, 'VA, US', 172, 'No', 'No', 'Low'),
('APP-007', 'Michael Miller', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 17, 'Low', 0, 'NY, US', 1217, 'Yes', 'No', 'Low'),
('APP-008', 'Linda Davis', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 19, 'Low', 0, 'TX, US', 2137, 'Yes', 'No', 'Low'),
('APP-009', 'David Rodriguez', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 22, 'Medium', 0, 'NC, US', 2129, 'Yes', 'No', 'Medium'),
('APP-010', 'Elizabeth Martinez', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 17, 'Medium', 0, 'NC, US', 2356, 'Yes', 'No', 'Low'),
('APP-011', 'William Hernandez', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 18, 'Low', 0, 'PA, US', 2892, 'Yes', 'No', 'Medium'),
('APP-012', 'Barbara Lopez', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 41, 'High', 1, 'TX, US', 2767, 'Yes', 'No', 'Medium'),
('APP-013', 'Richard Gonzalez', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 10, 'Medium', 0, 'OH, US', 1360, 'Yes', 'No', 'Low'),
('APP-014', 'Susan Wilson', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 18, 'Low', 0, 'IL, US', 2759, 'Yes', 'No', 'Low'),
('APP-015', 'Joseph Anderson', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 17, 'Medium', 0, 'AZ, US', 101, 'No', 'No', 'Low'),
('APP-016', 'Jessica Thomas', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 12, 'Low', 0, 'TX, US', 2568, 'Yes', 'No', 'Low'),
('APP-017', 'Thomas Taylor', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 13, 'Medium', 0, 'CO, US', 1842, 'Yes', 'No', 'Low'),
('APP-018', 'Sarah Moore', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 5, 'Low', 0, 'CA, US', 2438, 'Yes', 'No', 'Low'),
('APP-019', 'Christopher Jackson', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 10, 'Medium', 0, 'AZ, US', 622, 'No', 'No', 'Medium'),
('APP-020', 'Karen Martin', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 7, 'Low', 0, 'FL, US', 792, 'No', 'No', 'Low'),
('APP-021', 'Daniel Lee', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 16, 'Low', 0, 'PA, US', 2312, 'Yes', 'No', 'Medium'),
('APP-022', 'Nancy Perez', 'Pass', 'Genuine', 'Hit', 'Clear', 'Flag', 30, 'Low', 0, 'VA, US', 410, 'No', 'No', 'High'),
('APP-023', 'Matthew Thompson', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 20, 'Low', 0, 'TN, US', 386, 'No', 'No', 'Medium'),
('APP-024', 'Lisa White', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 4, 'Low', 0, 'IN, US', 686, 'No', 'No', 'Low'),
('APP-025', 'Anthony Harris', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 15, 'Medium', 0, 'VA, US', 662, 'Yes', 'No', 'Low'),
('APP-026', 'Betty Sanchez', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 15, 'Low', 0, 'NY, US', 297, 'No', 'No', 'Medium'),
('APP-027', 'Mark Clark', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 14, 'Low', 0, 'GA, US', 373, 'No', 'No', 'Low'),
('APP-028', 'Sandra Ramirez', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 16, 'Low', 0, 'TX, US', 1135, 'Yes', 'No', 'Low'),
('APP-029', 'Donald Lewis', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 10, 'Low', 0, 'OH, US', 2016, 'Yes', 'No', 'Low'),
('APP-030', 'Ashley Robinson', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 18, 'Low', 0, 'AZ, US', 1784, 'Yes', 'No', 'Low'),
('APP-031', 'Steven Walker', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 13, 'Medium', 0, 'AZ, US', 1060, 'Yes', 'No', 'Medium'),
('APP-032', 'Kimberly Young', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 8, 'Low', 0, 'NJ, US', 1474, 'Yes', 'No', 'Medium'),
('APP-033', 'Andrew Allen', 'Fail', 'Suspect', 'Clear', 'Clear', 'Clear', 94, 'High', 1, 'AZ, US', 8, 'No', 'Yes', 'High'),
('APP-034', 'Emily King', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 22, 'Low', 0, 'MO, US', 2999, 'Yes', 'No', 'Low'),
('APP-035', 'Joshua Wright', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 21, 'Low', 0, 'GA, US', 1139, 'Yes', 'No', 'Low'),
('APP-036', 'Donna Scott', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 16, 'Low', 0, 'TX, US', 685, 'Yes', 'No', 'Low'),
('APP-037', 'Kevin Torres', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 8, 'Low', 0, 'MI, US', 183, 'No', 'No', 'Low'),
('APP-038', 'Michelle Nguyen', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 15, 'Low', 0, 'TX, US', 529, 'No', 'No', 'Low'),
('APP-039', 'Brian Hill', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 17, 'Low', 0, 'IN, US', 2178, 'Yes', 'No', 'Low'),
('APP-040', 'Carol Flores', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 15, 'Low', 0, 'CO, US', 2746, 'Yes', 'No', 'Low'),
('APP-041', 'George Green', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 11, 'Low', 0, 'CO, US', 1545, 'Yes', 'No', 'Low'),
('APP-042', 'Amanda Adams', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 3, 'Low', 0, 'MD, US', 115, 'No', 'No', 'Low'),
('APP-043', 'Edward Nelson', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 10, 'Medium', 0, 'WA, US', 1189, 'Yes', 'No', 'Low'),
('APP-044', 'Melissa Baker', 'Pass', 'Edited', 'Clear', 'Clear', 'Clear', 47, 'Medium', 0, 'MA, US', 2819, 'Yes', 'No', 'Medium'),
('APP-045', 'Ronald Hall', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 4, 'Low', 0, 'VA, US', 2598, 'Yes', 'No', 'Low'),
('APP-046', 'Deborah Rivera', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 9, 'Medium', 0, 'MO, US', 499, 'No', 'No', 'Low'),
('APP-047', 'Timothy Campbell', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 7, 'Low', 0, 'MI, US', 2362, 'Yes', 'No', 'Low'),
('APP-048', 'Stephanie Mitchell', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 18, 'Medium', 0, 'IL, US', 1140, 'Yes', 'No', 'Low'),
('APP-049', 'Jason Carter', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 9, 'Medium', 0, 'OH, US', 2292, 'Yes', 'No', 'Medium'),
('APP-050', 'Rebecca Roberts', 'Pass', 'Genuine', 'Clear', 'Clear', 'Clear', 11, 'Low', 0, 'AZ, US', 1690, 'Yes', 'No', 'Low');


-- ---- Table 2: applicant_linkage -----------------------------
DROP TABLE IF EXISTS applicant_linkage;

CREATE TABLE applicant_linkage (
    app_id                 TEXT PRIMARY KEY,
    applicant_name         TEXT,
    bureau_id              TEXT,     -- bureau's own subject identifier
    shared_address_hash    TEXT,     -- equal hash = same premises
    co_applicant_id        TEXT,     -- linked co-applicant app_id, blank if none
    relationship_declared  TEXT,     -- Spouse | Co-borrower | Guarantor | None
    guarantor_id           TEXT,     -- shared guarantor id, blank if none
    prior_defaults         INTEGER,  -- defaults on record across all bureaus
    active_credit_lines    INTEGER
);
-- Identity-graph feed for the Fraud/KYC gate (policy 2.3). Raw bureau linkage only.
-- No pipeline_state column: this table is READ BY the gate to make its decision, so it
-- cannot carry a pre-computed halt flag (that would be circular). The gate derives a
-- cluster member's halted state at query time by joining to underwriting_kyc_screening.
-- An UNDECLARED shared address is a ring signal; a DECLARED relationship (Spouse /
-- Co-borrower / Guarantor) is normal and must NOT be flagged as fraud.

INSERT INTO applicant_linkage VALUES
('APP-001', 'James Smith', 'BRU-100137', 'ADDR-5C1D40', 'APP-016', 'Spouse', '', 0, 10),
('APP-002', 'Mary Johnson', 'BRU-100274', 'ADDR-99E7D1', '', 'None', '', 2, 3),
('APP-003', 'John Williams', 'BRU-100411', 'ADDR-7F3A9C', 'APP-008', 'None', 'GTR-9902', 2, 3),
('APP-004', 'Patricia Brown', 'BRU-100548', 'ADDR-A86E86', '', 'None', '', 0, 16),
('APP-005', 'Robert Jones', 'BRU-100685', 'ADDR-C4092D', 'APP-014', 'None', '', 1, 9),
('APP-006', 'Jennifer Garcia', 'BRU-100822', 'ADDR-B76777', '', 'None', '', 1, 7),
('APP-007', 'Michael Miller', 'BRU-100959', 'ADDR-AF8558', '', 'None', '', 0, 18),
('APP-008', 'Linda Davis', 'BRU-101096', 'ADDR-7F3A9C', 'APP-011', 'None', 'GTR-9902', 2, 2),
('APP-009', 'David Rodriguez', 'BRU-101233', 'ADDR-A41F07', '', 'Guarantor', 'GTR-1180', 0, 10),
('APP-010', 'Elizabeth Martinez', 'BRU-101370', 'ADDR-202B93', '', 'None', '', 0, 3),
('APP-011', 'William Hernandez', 'BRU-101507', 'ADDR-7F3A9C', 'APP-003', 'None', 'GTR-9902', 3, 3),
('APP-012', 'Barbara Lopez', 'BRU-101644', 'ADDR-40B17D', '', 'None', '', 0, 2),
('APP-013', 'Richard Gonzalez', 'BRU-101781', 'ADDR-2B8E11', 'APP-017', 'None', 'GTR-4471', 0, 7),
('APP-014', 'Susan Wilson', 'BRU-101918', 'ADDR-C4092D', 'APP-005', 'None', '', 0, 4),
('APP-015', 'Joseph Anderson', 'BRU-102055', 'ADDR-D7321C', '', 'None', '', 0, 12),
('APP-016', 'Jessica Thomas', 'BRU-102192', 'ADDR-5C1D40', 'APP-001', 'Spouse', '', 0, 9),
('APP-017', 'Thomas Taylor', 'BRU-102329', 'ADDR-2B8E11', 'APP-020', 'None', 'GTR-4471', 0, 7),
('APP-018', 'Sarah Moore', 'BRU-102466', 'ADDR-D93B26', '', 'Guarantor', 'GTR-1180', 0, 9),
('APP-019', 'Christopher Jackson', 'BRU-102603', 'ADDR-80C6A5', '', 'None', '', 1, 8),
('APP-020', 'Karen Martin', 'BRU-102740', 'ADDR-2B8E11', 'APP-013', 'None', 'GTR-4471', 0, 12),
('APP-021', 'Daniel Lee', 'BRU-102877', 'ADDR-94E551', '', 'None', '', 0, 11),
('APP-022', 'Nancy Perez', 'BRU-103014', 'ADDR-F6D30F', '', 'None', '', 0, 5),
('APP-023', 'Matthew Thompson', 'BRU-103151', 'ADDR-25F54A', '', 'None', '', 1, 17),
('APP-024', 'Lisa White', 'BRU-103288', 'ADDR-E5B209', '', 'Guarantor', 'GTR-1180', 0, 11),
('APP-025', 'Anthony Harris', 'BRU-103425', 'ADDR-7BD6EE', '', 'None', '', 0, 18),
('APP-026', 'Betty Sanchez', 'BRU-103562', 'ADDR-B830E4', 'APP-033', 'None', 'GTR-7715', 2, 1),
('APP-027', 'Mark Clark', 'BRU-103699', 'ADDR-B0AEB4', '', 'None', '', 1, 15),
('APP-028', 'Sandra Ramirez', 'BRU-103836', 'ADDR-6D14BB', 'APP-037', 'None', '', 0, 9),
('APP-029', 'Donald Lewis', 'BRU-103973', 'ADDR-6BE72F', '', 'None', '', 2, 3),
('APP-030', 'Ashley Robinson', 'BRU-104110', 'ADDR-44A3F4', '', 'None', '', 2, 3),
('APP-031', 'Steven Walker', 'BRU-104247', 'ADDR-A6D0CB', '', 'None', '', 0, 7),
('APP-032', 'Kimberly Young', 'BRU-104384', 'ADDR-AEF94B', '', 'None', '', 0, 13),
('APP-033', 'Andrew Allen', 'BRU-104521', 'ADDR-B830E4', 'APP-040', 'None', 'GTR-7715', 1, 3),
('APP-034', 'Emily King', 'BRU-104658', 'ADDR-1A7F55', 'APP-041', 'Spouse', '', 0, 10),
('APP-035', 'Joshua Wright', 'BRU-104795', 'ADDR-72CC81', '', 'Guarantor', 'GTR-1180', 0, 15),
('APP-036', 'Donna Scott', 'BRU-104932', 'ADDR-A0C68E', '', 'None', '', 2, 13),
('APP-037', 'Kevin Torres', 'BRU-105069', 'ADDR-6D14BB', 'APP-028', 'None', '', 0, 6),
('APP-038', 'Michelle Nguyen', 'BRU-105206', 'ADDR-A271A8', '', 'None', '', 0, 12),
('APP-039', 'Brian Hill', 'BRU-105343', 'ADDR-A2AF2F', '', 'None', '', 0, 17),
('APP-040', 'Carol Flores', 'BRU-105480', 'ADDR-B830E4', 'APP-026', 'None', 'GTR-7715', 2, 2),
('APP-041', 'George Green', 'BRU-105617', 'ADDR-1A7F55', 'APP-034', 'Spouse', '', 0, 7),
('APP-042', 'Amanda Adams', 'BRU-105754', 'ADDR-3E62F8', 'APP-045', 'None', 'GTR-6620', 0, 9),
('APP-043', 'Edward Nelson', 'BRU-105891', 'ADDR-3D7946', '', 'None', '', 1, 17),
('APP-044', 'Melissa Baker', 'BRU-106028', 'ADDR-A73232', '', 'None', '', 2, 16),
('APP-045', 'Ronald Hall', 'BRU-106165', 'ADDR-3E62F8', 'APP-049', 'None', 'GTR-6620', 0, 10),
('APP-046', 'Deborah Rivera', 'BRU-106302', 'ADDR-BCFC44', '', 'None', '', 1, 7),
('APP-047', 'Timothy Campbell', 'BRU-106439', 'ADDR-3E9977', '', 'None', '', 2, 7),
('APP-048', 'Stephanie Mitchell', 'BRU-106576', 'ADDR-989923', '', 'None', '', 0, 18),
('APP-049', 'Jason Carter', 'BRU-106713', 'ADDR-3E62F8', 'APP-042', 'None', 'GTR-6620', 0, 8),
('APP-050', 'Rebecca Roberts', 'BRU-106850', 'ADDR-42135B', '', 'None', '', 1, 5);


-- ############################################################
-- ## 2. credit_bureau.sql  (credit_bureau)
-- ############################################################

DROP TABLE IF EXISTS credit_bureau;

CREATE TABLE credit_bureau (
    app_id              TEXT PRIMARY KEY,
    applicant_name      TEXT,
    fico_score          INTEGER,   -- NULL for a halted application (no bureau pull)
    bureau              TEXT,
    history_years       INTEGER,
    open_trade_lines    INTEGER,
    delinquencies_24mo  INTEGER,
    utilization_pct     INTEGER,
    public_records      TEXT       -- None | 1 Collection | Prior BK
);

-- Bureau feed. credit_status is derived by the Credit agent, not stored.
-- No pipeline_state: halt is held in runtime state and short-circuits this agent
-- before the query runs. Halted applications appear as all-NULL rows (no pull).

INSERT INTO credit_bureau VALUES
('APP-001', 'James Smith', 760, 'Experian', 12, 7, 0, 16, 'None'),
('APP-002', 'Mary Johnson', 680, 'Equifax', 7, 7, 2, 25, 'None'),
('APP-003', 'John Williams', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('APP-004', 'Patricia Brown', 710, 'Experian', 10, 16, 1, 16, 'None'),
('APP-005', 'Robert Jones', 620, 'TransUnion', 6, 5, 1, 62, '1 Collection'),
('APP-006', 'Jennifer Garcia', 740, 'TransUnion', 11, 7, 0, 21, 'None'),
('APP-007', 'Michael Miller', 690, 'TransUnion', 8, 15, 0, 41, 'None'),
('APP-008', 'Linda Davis', 580, 'Experian', 3, 2, 5, 81, 'Prior BK'),
('APP-009', 'David Rodriguez', 780, 'Equifax', 12, 15, 0, 14, 'None'),
('APP-010', 'Elizabeth Martinez', 790, 'Experian', 14, 8, 0, 10, 'None'),
('APP-011', 'William Hernandez', 650, 'Equifax', 9, 10, 3, 48, '1 Collection'),
('APP-012', 'Barbara Lopez', 700, 'Experian', 9, 22, 1, 20, 'None'),
('APP-013', 'Richard Gonzalez', 715, 'Equifax', 6, 12, 1, 17, 'None'),
('APP-014', 'Susan Wilson', 640, 'Equifax', 7, 8, 2, 40, '1 Collection'),
('APP-015', 'Joseph Anderson', 750, 'Equifax', 9, 19, 0, 21, 'None'),
('APP-016', 'Jessica Thomas', 810, 'TransUnion', 12, 12, 0, 18, 'None'),
('APP-017', 'Thomas Taylor', 670, 'TransUnion', 9, 12, 2, 25, 'None'),
('APP-018', 'Sarah Moore', 730, 'Equifax', 8, 6, 0, 23, 'None'),
('APP-019', 'Christopher Jackson', 610, 'Equifax', 6, 5, 5, 75, 'Prior BK'),
('APP-020', 'Karen Martin', 745, 'Equifax', 7, 6, 1, 17, 'None'),
('APP-021', 'Daniel Lee', 705, 'Equifax', 11, 11, 1, 28, 'None'),
('APP-022', 'Nancy Perez', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('APP-023', 'Matthew Thompson', 660, 'Equifax', 7, 21, 2, 36, 'None'),
('APP-024', 'Lisa White', 690, 'TransUnion', 10, 21, 1, 36, 'None'),
('APP-025', 'Anthony Harris', 775, 'Equifax', 12, 12, 0, 8, 'None'),
('APP-026', 'Betty Sanchez', 590, 'TransUnion', 2, 3, 3, 65, '1 Collection'),
('APP-027', 'Mark Clark', 730, 'TransUnion', 11, 9, 0, 16, 'None'),
('APP-028', 'Sandra Ramirez', 680, 'TransUnion', 8, 12, 2, 43, 'None'),
('APP-029', 'Donald Lewis', 760, 'Experian', 12, 13, 0, 5, 'None'),
('APP-030', 'Ashley Robinson', 710, 'Equifax', 8, 11, 1, 15, 'None'),
('APP-031', 'Steven Walker', 640, 'Experian', 3, 10, 1, 48, 'None'),
('APP-032', 'Kimberly Young', 790, 'Experian', 13, 13, 0, 15, 'None'),
('APP-033', 'Andrew Allen', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('APP-034', 'Emily King', 805, 'Experian', 15, 19, 0, 5, 'None'),
('APP-035', 'Joshua Wright', 675, 'Equifax', 9, 13, 1, 40, 'None'),
('APP-036', 'Donna Scott', 550, 'Experian', 2, 4, 2, 63, 'Prior BK'),
('APP-037', 'Kevin Torres', 725, 'TransUnion', 7, 16, 1, 12, 'None'),
('APP-038', 'Michelle Nguyen', 695, 'TransUnion', 10, 5, 0, 29, 'None'),
('APP-039', 'Brian Hill', 740, 'TransUnion', 9, 6, 0, 13, 'None'),
('APP-040', 'Carol Flores', 630, 'Equifax', 6, 5, 3, 52, '1 Collection'),
('APP-041', 'George Green', 765, 'Equifax', 10, 22, 0, 10, 'None'),
('APP-042', 'Amanda Adams', 715, 'TransUnion', 10, 5, 0, 16, 'None'),
('APP-043', 'Edward Nelson', 685, 'Experian', 6, 12, 2, 27, 'None'),
('APP-044', 'Melissa Baker', 750, 'Experian', 9, 9, 0, 15, 'None'),
('APP-045', 'Ronald Hall', 650, 'Equifax', 7, 9, 3, 59, '1 Collection'),
('APP-046', 'Deborah Rivera', 780, 'TransUnion', 9, 11, 0, 8, 'None'),
('APP-047', 'Timothy Campbell', 700, 'Equifax', 8, 18, 0, 17, 'None'),
('APP-048', 'Stephanie Mitchell', 815, 'Experian', 15, 22, 0, 14, 'None'),
('APP-049', 'Jason Carter', 660, 'TransUnion', 7, 7, 2, 32, 'None'),
('APP-050', 'Rebecca Roberts', 735, 'Experian', 8, 12, 0, 12, 'None');


-- ############################################################
-- ## 3. income_verification.sql  (income_verification)
-- ############################################################

DROP TABLE IF EXISTS income_verification;

CREATE TABLE income_verification (
    app_id                  TEXT PRIMARY KEY,
    applicant_name          TEXT,
    verified_annual_income  INTEGER,   -- NULL for a halted application
    monthly_gross_income    INTEGER,
    other_monthly_debt      INTEGER,   -- existing obligations, excl. the proposed loan
    employment_verified     TEXT       -- Yes | No | Pending
);

-- Payroll / bank-statement feed. Proposed payment, DTI, coverage and status are
-- COMPUTED by the Capacity agent, not stored. No pipeline_state: runtime handles halt.

INSERT INTO income_verification VALUES
('APP-001', 'James Smith', 96000, 8000, 0, 'Yes'),
('APP-002', 'Mary Johnson', 68000, 5667, 1718, 'Yes'),
('APP-003', 'John Williams', NULL, NULL, NULL, NULL),
('APP-004', 'Patricia Brown', 90000, 7500, 1855, 'Pending'),
('APP-005', 'Robert Jones', 155000, 12917, 2452, 'Pending'),
('APP-006', 'Jennifer Garcia', 45000, 3750, 587, 'Pending'),
('APP-007', 'Michael Miller', 92000, 7667, 784, 'Yes'),
('APP-008', 'Linda Davis', 32000, 2667, 1126, 'Yes'),
('APP-009', 'David Rodriguez', 195000, 16250, 1146, 'Yes'),
('APP-010', 'Elizabeth Martinez', 196000, 16333, 0, 'Yes'),
('APP-011', 'William Hernandez', 89000, 7417, 2431, 'Yes'),
('APP-012', 'Barbara Lopez', 54000, 4500, 1179, 'Yes'),
('APP-013', 'Richard Gonzalez', 60000, 5000, 384, 'Pending'),
('APP-014', 'Susan Wilson', 41000, 3417, 1162, 'Yes'),
('APP-015', 'Joseph Anderson', 38000, 3167, 374, 'Pending'),
('APP-016', 'Jessica Thomas', 124000, 10333, 0, 'Pending'),
('APP-017', 'Thomas Taylor', 33000, 2750, 935, 'Pending'),
('APP-018', 'Sarah Moore', 369000, 30750, 1169, 'Yes'),
('APP-019', 'Christopher Jackson', 108000, 9000, 3123, 'Yes'),
('APP-020', 'Karen Martin', 91000, 7583, 275, 'Yes'),
('APP-021', 'Daniel Lee', 108000, 9000, 927, 'Pending'),
('APP-022', 'Nancy Perez', NULL, NULL, NULL, NULL),
('APP-023', 'Matthew Thompson', 34000, 2833, 600, 'Pending'),
('APP-024', 'Lisa White', 60000, 5000, 1288, 'Yes'),
('APP-025', 'Anthony Harris', 253000, 21083, 1022, 'Yes'),
('APP-026', 'Betty Sanchez', 99000, 8250, 3201, 'Yes'),
('APP-027', 'Mark Clark', 80000, 6667, 846, 'Pending'),
('APP-028', 'Sandra Ramirez', 60000, 5000, 18, 'Yes'),
('APP-029', 'Donald Lewis', 137000, 11417, 1010, 'Pending'),
('APP-030', 'Ashley Robinson', 59000, 4917, 888, 'Yes'),
('APP-031', 'Steven Walker', 120000, 10000, 1540, 'Pending'),
('APP-032', 'Kimberly Young', 36000, 3000, 3, 'Yes'),
('APP-033', 'Andrew Allen', NULL, NULL, NULL, NULL),
('APP-034', 'Emily King', 183000, 15250, 0, 'Yes'),
('APP-035', 'Joshua Wright', 299000, 24917, 6167, 'Pending'),
('APP-036', 'Donna Scott', 32000, 2667, 1541, 'Pending'),
('APP-037', 'Kevin Torres', 89000, 7417, 1167, 'Yes'),
('APP-038', 'Michelle Nguyen', 91000, 7583, 0, 'Yes'),
('APP-039', 'Brian Hill', 90000, 7500, 1200, 'Pending'),
('APP-040', 'Carol Flores', 30000, 2500, 878, 'Yes'),
('APP-041', 'George Green', 124000, 10333, 0, 'Yes'),
('APP-042', 'Amanda Adams', 57000, 4750, 1443, 'Yes'),
('APP-043', 'Edward Nelson', 58000, 4833, 1221, 'Yes'),
('APP-044', 'Melissa Baker', 187000, 15583, 2665, 'Yes'),
('APP-045', 'Ronald Hall', 240000, 20000, 3145, 'Pending'),
('APP-046', 'Deborah Rivera', 33000, 2750, 197, 'Yes'),
('APP-047', 'Timothy Campbell', 39000, 3250, 669, 'Yes'),
('APP-048', 'Stephanie Mitchell', 74000, 6167, 0, 'Yes'),
('APP-049', 'Jason Carter', 360000, 30000, 7080, 'Yes'),
('APP-050', 'Rebecca Roberts', 102000, 8500, 1550, 'Pending');


-- ############################################################
-- ## 4. collateral.sql  (collateral_appraisal)
-- ############################################################

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


-- ############################################################
-- ## 5. terms_config.sql  (terms_config)
-- ############################################################

DROP TABLE IF EXISTS terms_config;

CREATE TABLE terms_config (
    config_type  TEXT,     -- base_rate | credit_spread | ltv_adj | security_adj
                           -- | covenant | condition | ecoa_reason
    config_key   TEXT,
    num_value    REAL,
    text_value   TEXT
);
-- Pricing and term-sheet reference data for the Decision agent.
--
-- Pricing formula:
--     interest_rate_pct = base_rate(loan_type)
--                       + credit_spread(credit_status)
--                       + ltv_adj(ltv band)
--                       + security_adj(Secured | Unsecured)
--     rounded to 2 decimals.
--
-- credit_spread is keyed on the credit band produced by the Credit agent
-- (Excellent | Good | Fair | Subprime | Poor). A NULL num_value means the band is
-- not priceable and the application must be declined rather than priced.
--
-- Lending policy 6.3 requires identical pricing for identical inputs, so every
-- component must come from this table. Agents may not improvise a spread.

INSERT INTO terms_config VALUES
-- base rate by product (text_value carries the maximum term in months)
('base_rate',    'Mortgage',                5.30, '360'),
('base_rate',    'Auto',                    5.20, '84'),
('base_rate',    'SME',                     6.80, '120'),
('base_rate',    'Personal',                6.50, '60'),

-- spread by credit band (policy 3.3)
('credit_spread', 'Excellent',              0.10, NULL),
('credit_spread', 'Good',                   0.55, NULL),
('credit_spread', 'Fair',                   1.40, NULL),
('credit_spread', 'Subprime',               2.60, NULL),
('credit_spread', 'Poor',                   NULL, 'Not priceable - decline under policy 3.2'),

-- loan-to-value adjustment
('ltv_adj',      '0-60',                    0.00, NULL),
('ltv_adj',      '61-70',                   0.10, NULL),
('ltv_adj',      '71-80',                   0.25, NULL),
('ltv_adj',      '81-90',                   0.35, NULL),
('ltv_adj',      '91-100',                  0.60, NULL),

-- security adjustment
('security_adj', 'Secured',                 0.00, NULL),
('security_adj', 'Unsecured',               2.50, NULL),

-- covenants by product
('covenant',     'Mortgage',                NULL, 'Escrow taxes and insurance; owner-occupancy certification'),
('covenant',     'Auto',                    NULL, 'Comprehensive and collision insurance'),
('covenant',     'SME',                     NULL, 'Minimum DSCR 1.25x; quarterly financial statements'),
('covenant',     'Personal',                NULL, 'None'),

-- closing conditions by product
('condition',    'Mortgage',                NULL, 'Clear title and lien perfection; hazard insurance binder'),
('condition',    'Auto',                    NULL, 'Lien recorded on vehicle title'),
('condition',    'SME',                     NULL, 'Personal guarantee from principals'),
('condition',    'Personal',                NULL, 'Standard closing conditions'),

-- ECOA / Reg B adverse-action wording, keyed to upstream agent flags (policy 6.4)
('ecoa_reason',  'insufficient_credit',      NULL, 'Credit score below minimum requirement'),
('ecoa_reason',  'serious_delinquency',      NULL, 'Delinquent past or present credit obligations'),
('ecoa_reason',  'high_utilization',         NULL, 'Excessive obligations in relation to credit limits'),
('ecoa_reason',  'insufficient_history',     NULL, 'Length of credit history is insufficient'),
('ecoa_reason',  'prior_bankruptcy',         NULL, 'Bankruptcy or public record on file'),
('ecoa_reason',  'dti_exceeds_limit',        NULL, 'Excessive obligations in relation to income'),
('ecoa_reason',  'income_unverified',        NULL, 'Unable to verify income'),
('ecoa_reason',  'insufficient_collateral',  NULL, 'Value or type of collateral not sufficient'),
('ecoa_reason',  'exceeds_policy_limits',    NULL, 'Application does not meet credit policy standards'),
-- fraud-related declines share one generic reason (policy 2.4)
('ecoa_reason',  'sanctions_hit',            NULL, 'Unable to verify identity or account information'),
('ecoa_reason',  'id_mismatch',              NULL, 'Unable to verify identity or account information'),
('ecoa_reason',  'synthetic_identity',       NULL, 'Unable to verify identity or account information'),
('ecoa_reason',  'document_forgery',         NULL, 'Unable to verify identity or account information');
