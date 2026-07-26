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
