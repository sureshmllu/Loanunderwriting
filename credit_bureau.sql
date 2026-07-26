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
