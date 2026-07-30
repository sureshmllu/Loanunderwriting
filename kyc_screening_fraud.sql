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
