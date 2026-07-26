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
