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
