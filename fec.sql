drop table if exists fec_committees_2024;

create table if not exists fec_committees_2024(
  committee_id text primary key,
  committee_name text,
  committee_type text,
  committee_designation text,
  committee_filing_frequency text,
  candidate_id text,
  treasurer_name text,
  --committee_address_street1 text,
  --committee_address_street2 text,
  committee_address_city text,
  committee_address_state text,
  --committee_address_zipcode text,
  cash_on_hand_beginning_of_period integer,
  cash_on_hand_end_of_period integer,
  coverage_start_date date,
  coverage_end_date date,
  individual_contributions integer,
  party_committee_contributions integer,
  other_committee_contributions integer,
  total_contributions integer,
  transfers_from_other_authorized_committee integer,
  offsets_to_operating_expenditures integer,
  other_receipts integer,
  total_receipts integer,
  transfers_to_other_authorized_committee integer,
  other_loan_repayments integer,
  individual_refunds integer,
  political_party_committee_refunds integer,
  total_contribution_refunds integer,
  other_disbursements integer,
  total_disbursements integer,
  net_contributions integer,
  net_operating_expenditures integer
);

-- "ignore" bc 67 committees have duplicates (ie C00846402), idk why. Seems to be same data in each row, so just ignore it 
insert or ignore into fec_committees_2024
select 
  --Link_Image as link_image,
  CMTE_ID as committee_id,
  CMTE_NM as committee_name,
  --FEC_ELECTION_YR as fec_election_year,
  case
    when CMTE_TP = 'C' then 'Communication cost'
    when CMTE_TP = 'D' then 'Delegate committee'
    when CMTE_TP = 'E' then 'Electioneering communication'
    when CMTE_TP = 'H' then 'House'
    when CMTE_TP = 'I' then 'Independent expenditor'
    when CMTE_TP = 'N' then 'PAC - nonqualified'
    when CMTE_TP = 'O' then 'Super PAC'
    when CMTE_TP = 'P' then 'Presidential'
    when CMTE_TP = 'Q' then 'PAC - qualified'
    when CMTE_TP = 'S' then 'Senate'
    when CMTE_TP = 'U' then 'Single-candidate independent expenditure'
    when CMTE_TP = 'V' then 'Nonqualified Hybrid PAC (with Non-Contribution Account)'
    when CMTE_TP = 'W' then 'QualifiedHybrid PAC (with Non-Contribution Account)'
    when CMTE_TP = 'X' then 'Party - nonqualified'
    when CMTE_TP = 'Y' then 'Party - qualified'
    when CMTE_TP = 'Z' then 'National party nonfederal account'
  end as committee_type,
  case CMTE_DSGN
    when 'A' then 'Candidate Authorized'
    when 'J' then 'Joint Fundraising Committee;'
    when 'P' then 'Principal Campaign Committee'
    when 'U' then 'Unauthorized'
    when 'B' then 'Lobbyist/Registrant PAC'
    when 'D' then 'Leadership PAC'
  end as committee_designation,
  case CMTE_FILING_FREQ
    when 'M' then 'Monthly'
    when 'Q' then 'Quarterly'
    when 'T' then 'Terminated'
    when 'A' then 'Administratively terminated'
    else format('Unknown (%s)', CMTE_FILING_FREQ)
  end as committee_filing_frequency,
  CAND_ID as candidate_id,
  TRES_NM as treasurer_name,
  --CMTE_ST1 as committee_address_street1,
  --CMTE_ST2 as committee_address_street2,
  CMTE_CITY as committee_address_city,
  CMTE_ST as committee_address_state,
  --CMTE_ZIP as committee_address_zipcode,
  COH_BOP as cash_on_hand_beginning_of_period,
  COH_COP as cash_on_hand_end_of_period,
  -- YYYYMMDD to YYYY-MM-DD
  substr(CVG_START_DT, 1, 4) || '-' || substr(CVG_START_DT, 5, 2) || '-' || substr(CVG_START_DT, 7, 2) as coverage_start_date,
  substr(CVG_END_DT, 1, 4) || '-' || substr(CVG_END_DT, 5, 2) || '-' || substr(CVG_END_DT, 7, 2) as coverage_end_date,
  --
  --CVG_START_DT as coverage_start_date,
  --CVG_END_DT as coverage_end_date,
  -- INDV_CONTB, PTY_CMTE_CONTB, OTH_CMTE_CONTB, TTL_CONTB, TRANF_FROM_OTHER_AUTH_CMTE, OFFSETS_TO_OP_EXP, OTHER_RECEIPTS, TTL_RECEIPTS, TRANF_TO_OTHER_AUTH_CMTE, OTH_LOAN_REPYMTS, INDV_REF, POL_PTY_CMTE_REF, TTL_CONTB_REF, OTHER_DISB, TTL_DISB, NET_CONTB, NET_OP_EXP,
  
  -- receipts
  INDV_CONTB as individual_contributions,
  PTY_CMTE_CONTB as party_committee_contributions,
  OTH_CMTE_CONTB as other_committee_contributions,
  TTL_CONTB as total_contributions,
  TRANF_FROM_OTHER_AUTH_CMTE as transfers_from_other_authorized_committee,
  OFFSETS_TO_OP_EXP as offsets_to_operating_expenditures,
  OTHER_RECEIPTS as other_receipts,
  TTL_RECEIPTS as total_receipts,

  -- disbursements
  TRANF_TO_OTHER_AUTH_CMTE as transfers_to_other_authorized_committee,
  OTH_LOAN_REPYMTS as other_loan_repayments,
  INDV_REF as individual_refunds,
  POL_PTY_CMTE_REF as political_party_committee_refunds,
  TTL_CONTB_REF as total_contribution_refunds,
  OTHER_DISB as other_disbursements,
  TTL_DISB as total_disbursements,
  NET_CONTB as net_contributions,
  NET_OP_EXP as net_operating_expenditures
from "committee_summary_2024.csv";

select count(*) from fec_committees_2024;