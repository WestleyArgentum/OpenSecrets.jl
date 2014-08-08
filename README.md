# OpenSecrets.jl

A Julia package for working with [OpenSecrets data](http://www.opensecrets.org/resources/create/). Please note their [terms of service](http://www.opensecrets.org/myos/terms_of_use.php).


## Quickstart

```julia
julia> Pkg.clone("https://github.com/WestleyArgentum/OpenSecrets.jl.git")

julia> using DataFrames

julia> using OpenSecrets

julia> candidates = OpenSecrets.candidates(2012)
5952x12 DataFrame
|-------|-------|-------------|-------------|----------------------------|-------|--------------|------------|----------|-----------|--------|-----------|--------|
| Row # | Cycle | FECCandID   | CID         | FirstLastP                 | Party | DistIDRunFor | DistIDCurr | CurrCand | CycleCand | CRPICO | RecipCode | NoPacs |
| 1     | 2012  | "H2NC08219" | "N00034999" | "Antonio Blue (D)"         | "D"   | "NC08"       | "    "     | " "      | "Y"       | "C"    | "DC"      | " "    |
| 2     | 2012  | "H2VI00082" | "N00035000" | "Stacey Plaskett (D)"      | "D"   | "VI00"       | "    "     | " "      | "Y"       | "C"    | "DN"      | " "    |
| 3     | 2012  | "S2NY00317" | "N00035001" | "Tim Sweet (I)"            | "I"   | "NYS1"       | "    "     | "Y"      | "Y"       | "C"    | "3L"      | " "    |
⋮
| 5950  | 2012  | "S4TX00417" | "N00035206" | "Joshua Loveless (I)"      | "I"   | "TX03"       | "    "     | " "      | " "       | " "    | "3N"      | " "    |
| 5951  | 2012  | "S4GA11202" | "N00028137" | "John F. Coyne III (D)"    | "D"   | "GAS1"       | "    "     | " "      | " "       | "C"    | "DN"      | " "    |
| 5952  | 2012  | "S4WV00159" | "N00009771" | "Shelley Moore Capito (R)" | "R"   | "WV02"       | "    "     | " "      | " "       | "I"    | "RW"      | " "    |

julia> pac_contribs = OpenSecrets.pacs_to_candidates(12)
394542x10 DataFrame
|--------|-------|-----------------------|-------------|-------------|--------|--------------|----------|-------|-----|-------------|
| Row #  | Cycle | FECRecNo              | PACID       | CID         | Amount | Date         | RealCode | Type  | DI  | FECCandID   |
| 1      | 2012  | "4110820121170387477" | "C00248195" | "N00030744" | 500.0  | "09/13/2012" | "K2000"  | "24K" | "D" | "H0KS04051" |
| 2      | 2012  | "4020720131181040202" | "C00002089" | "N00034562" | 2500.0 | "08/17/2012" | "LC100"  | "24K" | "D" | "H2TX02094" |
| 3      | 2012  | "4092720121165116372" | "C00106146" | "N00027060" | 1000.0 | "08/17/2012" | "H2100"  | "24K" | "D" | "H4NY27076" |
⋮
| 394540 | 2012  | "4101320121167221143" | "C00354753" | "N00033728" | 5000.0 | "09/13/2012" | "E1150"  | "24K" | "D" | "S2WI00235" |
| 394541 | 2012  | "4042020111138209938" | "C00002972" | "N00002782" | 1000.0 | "03/31/2011" | "E1610"  | "24K" | "D" | "H8FL06056" |
| 394542 | 2012  | "4022320121152244010" | "C00284885" | "N00002685" | 5000.0 | "12/13/2011" | "G4500"  | "24K" | "D" | "S2GA00118" |

julia> candidates[ Bool[ ismatch(r"Obama", c) for c in candidates[:FirstLastP] ], : ]
1x12 DataFrame
|-------|-------|-------------|-------------|--------------------|-------|--------------|------------|----------|-----------|--------|-----------|--------|
| Row # | Cycle | FECCandID   | CID         | FirstLastP         | Party | DistIDRunFor | DistIDCurr | CurrCand | CycleCand | CRPICO | RecipCode | NoPacs |
| 1     | 2012  | "P80003338" | "N00009638" | "Barack Obama (D)" | "D"   | "PRES"       | "PRES"     | "Y"      | "Y"       | "I"    | "DW"      | " "    |

julia> pac_contribs[ Bool[ !isna(c) && ismatch(r"N00009638", c) for c in pac_contribs[:CID]], :]
30631x10 DataFrame
|-------|-------|-----------------------|-------------|-------------|--------|--------------|----------|-------|-----|-------------|
| Row # | Cycle | FECRecNo              | PACID       | CID         | Amount | Date         | RealCode | Type  | DI  | FECCandID   |
| 1     | 2012  | "2012220131179043711" | "C00485052" | "N00009638" | 6.0    | "11/03/2012" | "J9000"  | "24Z" | "D" | "P80003338" |
| 2     | 2012  | "4082620121161594936" | "C00010603" | "N00009638" | 700.0  | "06/14/2012" | "Z5200"  | "24Z" | "D" | "P80003338" |
| 3     | 2012  | "4092120121164811124" | "C00191247" | "N00009638" | 3000.0 | "08/01/2012" | "Z5200"  | "24K" | "D" | "P80003338" |
⋮
| 30629 | 2012  | "4020120131180469705" | "C90011156" | "N00009638" | 26.0   | "10/01/2012" | "L0000"  | "24E" | "I" | "P80003338" |
| 30630 | 2012  | "4020120131180474397" | "C90011156" | "N00009638" | 3.0    | "10/04/2012" | "L0000"  | "24E" | "I" | "P80003338" |
| 30631 | 2012  | "4020120131180497016" | "C90011156" | "N00009638" | 26.0   | "10/25/2012" | "L0000"  | "24E" | "I" | "P80003338" |
```

## API

### Detecting Data Sources
Unfortunately it's not practicle to bundle all the OpenSecrets data along with this package. Instead, OpenSecrets.jl attempts to detect sources of data stored locally in `OpenSecrets.jl/data`. If your data is stored somewhere else, you can tell OpenSecrets.jl about it by calling `detect_data_sources` with the path to the directory containing the unzipped files.

```julia
OpenSecrets.detect_data_sources(dir::String)
```


### Campaign Finance Data
All of the campaign finance data methods take an integer `year`, and output a DataFrame. Data sets are released every 2 years (according to the election cycle) and data is available starting 1990.

#### Candidates
```julia
OpenSecrets.candidates(year)
```
- `Cycle`: Last year (even year) of the federal two year election cycle.
- `FECCandID`: Assigned by FEC and selected by CRP as the active, should multiples exist.
- `CID`: Unique identifier for each candidate. Every candidate should have one and only one CID throughout all cycles. Recipid for candidates is based on CID.
- `FirstLastP`: Candidate name in format of firstname lastname and party in parens, like "Steve Kagen (D)".
- `Party`: The party of the candidate. "D" for Democratic, "R" for Republican", "I" for Independent, "L" for Libertarian", "3" for other third party and "U" for Unknown.
- `DistIDRunFor`: Four character identifier of the office sought by the candidate. For congressional races, the first two characters are the state and the next two are the district for House candidates and "S1" or "S2" for Senate candidates. "PRES" indicates a presidential candidate.
- `DistIDCurr`: Four character identifier of the office currently held (if any) by the candidate. For House members, the first two characters are the state and the next two are the district. For Senators the first two characters are the state and the last two characters are "S1" or "S2". "PRES" indicates a presidential candidate. For non-incumbents, this field is blank. If a member of Congress dies or leaves office, this field should become blank. This field is frozen on election day. For cycles prior to the current cycle, DistidCurr reflects office held on Election Day of the Cycle.
- `CurrCand`: This field indicates whether the candidate is currently running for federal office - "Y" means yes, otherwise this field is blank. If a candidate loses a primary or drops out of the race, this field becomes blank. This field is frozen on Election Day, and thus for previous cycles can be used to show the candidate who ran in the general election.
- `CycleCand`: This field indicates whether the candidate ever ran for federal office during the cycle in question. Like CurrCand, "Y" means yes and blank means no. This field should be "Y" for any candidate who filed to run for office or otherwise formally declared intention to run. This does NOT change if the candidate drops out or loses a primary. Be aware that we've tightened the definition in recent cycles - for older data, CycleCand is likely to cast a broader net. Also note that incumbents are usually assumed to be running for re-election and get a "Y" in CycleCand unless there is evidence to the contrary.
- `CRPICO`: Identifies type of candidate - "I" is incumbent, "C" is challenger, "O" is open seat. This may be blank if the candidate is neither a member of Congress nor running this cycle. Note this is based on the office sought. A House incumbent running for the Senate would have a CRPICO of "C" or "O", not "I."
- `RecipCode`: A two-character code defining the type of candidate. The first character is party ("D" for Democratic, "R" for Republican, "3" for Independent or third party, "U" for Unknown.) The second character is "W" for Winner, "L" for Loser, "I" for incumbent, "C" for Challenger, "O" for "Open Seat", and "N" for Non-incumbent. Incumbent, Challenger and Open Seat are based on CRPICO. "N" is reserved for candidates that are neither in office nor running during the cycle in question. This lives in dbo_CandsCRP.
- `NoPacs`: Indicates whether candidate has publicly committed to forego contributions from PACs.


#### FEC Committees (PACs and Candidate and Party Committees)
```julia
OpenSecretes.committees(year)
```
- `Cycle`: Last year (even year) of the federal 2-year election cycle
- `CmteID`: Unique ID given by FEC to each committee.
- `PACShort`: Standardized committee name based on PAC's sponsor.
- `Affiliate`: Usually blank. For leadpacs, shows the sponsoring member.
- `Ultorg`: The standardized parent organization for the organization listed in the PACShort field. If there is no parent identified, this field will be equal to PACShort.
- `RecipID`: For candidate committees this will be the candidate's CID. Otherwise, it will be the same as CmteID.
- `RecipCode`: A two-character code defining the type of recipient. For candidates, the first character is party ("D" for Democratic, "R" for Republican, "3" for Independent, Libertarian or third party, "U" for Unknown.) The second character is "W" for Winner, "L" for Loser, "I" for incumbent, "C" for Challenger, "O" for "Open Seat", and "N" for Non-incumbent. "N" is reserved for candidates that are neither in office nor running during the cycle in question. For party committees, the first character is party and the second character is "P." For PACs, the first character is "P" and for outside spending groups, "O". For both, the second character is "B" for Business, "L" for Labor", "I" for Ideological, "O" for "Other" and "U" for unknown.
- `FECCandID`: Unique ID given to candidates by FEC.
- `Party`: (D,R,3,I,L) Will be null or empty if committee is not a party, joint fundraising, leadership or candidate committee.
- `PrimCode`: The standard five character code identifying the committee's industry or ideology.
- `Source`: Indicates how the PrimCode was determined.
- `Sensitive`: If "Y", the committee has significant business in multiple industries, some of which fall under the jurisdiction of specific congressional committees.
- `Foreign`: This is a bit field. Off/False indicate that the company is not owned by a foreign entity. Those that are owned by a foreign entity are on/True, sometimes "-1".
- `Active`: Determines if cmte is active in the cycle - false is no and true is yes


#### PACs to Candidates
```julia
OpenSecrets.pacs_to_candidates(year)
```
- `Cycle`: Last year (even year) of the federal 2-year election cycle
- `FECRecNo`: A unique record identifier within a given cycle.
- `PACID`: The committee id number for the PAC making the contribution.
- `CID`: A unique identifier for candidates that is constant throughout cycles.
- `Amount`: The amount contributed. This will be negative for refunds.
- `Date`: The reported date of the contribution.
- `RealCode`: The standard five character code identifying the donor's industry or ideology. Usually based on Primcode. Sometimes a PAC sponsor will have secondary interests which may replace the main realcode depending on recipient. For example, Boeing is primarily Air Transport but has Air Defense interests. Thus Boeing contributions to members of the Armed Services committee would have a realcode of Air Defense.
- `Type`: The transaction type code for the contribution. 24A is an Independent Expenditure against the candidate, 24C is a coordinated expenditure, 24E is an independent expenditure for the candidate, 24F is a communication cost for the candidate, 24K is a direct contribution, 24N is a communication cost against the candidate and 24Z is an in kind contribution
- `DI`: Whether the contribution is direct ("D") or indirect ("I."). Indirect contributions include independent expenditures and communications costs, are not subject to contribution limits and must be made completely independently of the candidate. Indirect contributions can also be against the candidate.
- `FECCandID`: FECCandID of recipient candidate


#### PACs to PACs
```julia
OpenSecrets.pacs_to_other(year)
```
- `Cycle`: Last year (even year) of the federal 2-year election cycle
- `FECRecNo`: A unique record identifier within a given cycle.
- `Filerid`: The committee id number for the PAC making the filing. Refers to donor if Type 2* or recipient if Type=1*.
- `DonorCmte`: The standardized name for the donor based on the name of the PAC's sponsor.
- `ContribLendTrans`: Reported name of the donor if Type=1* or the recipient if Type=2*.
- `City`: The donor's city. This could be based on a home address or an employer's address.
- `State`: The donor's state. This could be based on a home address or an employer's address.
- `Zip`: The donor's zip code. This could be based on a home address or an employer's address.
- `FECOccEmp`: The donor's disclosed employer and/or occupation.
- `Primcode`: The primary industry/ideological code for the donor PAC's sponsor.
- `Date`: The reported date of the contribution.
- `Amount`: The amount contributed. This will be negative for refunds.
- `RecipID`: The recipient's id number. If the contribution is to a candidate this will be the candidate's unique candidate id number. Otherwise, it will be the FEC committee id number.
- `Party`: The party (if any) of the recipient. "D" for Democratic, "R" for Republican", "I" for Independent, "L" for Libertarian", "3" for other third party and "U" for Unknown. This field will be blank or null for PACs other than leadership PACs.
- `Otherid`: Committee id for donor if Type=1* or recipient if Type=2*.
- `RecipCode`: A two character code defining the type of recipient. For candidates, the first character is party ("D" for Democratic, "R" for Republican, "3" for Independent, Libertarian or third party, "U" for Unknown.) The second character is "W" for Winner, "L" for Loser, "I" for incumbent, "C" for Challenger, "O" for "Open Seat", and "N" for Non-incumbent. "N" is reserved for candidates that are neither in office nor running during the cycle in question. For party committees, the first character is party and the second character is "P." For PACs, the first character is "P" and for outside spending groups, the first character is "O". For both, the second character is "B" for Business, "L" for Labor", "I" for Ideological, "O" for "Other" and "U" for unknown.
- `RecipPrimcode`: The industry/ideological code for the recipient - codes beginning with Z1 are candidate committees, codes beginning with Z5 are party committees and codes beginning with J2 are leadership PACs.
- `Amend`: Whether the record comes from an amended report
- `Report`: The type of report - 1st quarter, year end, etc.
- `PG`: Whether the contribution is for a Primary ("P") or General ("G") election.
- `Microfilm`: The FEC microfilm record for the contribution
- `Type`: The transaction type code for the contribution. 11 is a tribal contribution, 22Z is a contribution refund to a candidate or committee, 24G is a Transfer to an affiliated committee, 24K is a direct contribution, 24R is a election recount disbursement and 24Z is an in kind contribution
- `RealCode`: The standard five character code identifying the donor's industry or ideology.Usually based on Primcode. Sometimes a PAC sponsor will have secondary interests which may replace the main realcode depending on recipient. For example, Boeing is primarily Air Transport but has Air Defense interests. Thus Boeing contributions to members of the Armed Services committee would have a realcode of Air Defense.
- `Source`: Indicates how the Realcode was determined.


#### Individual Contributions
```julia
OpenSecretes.individual_contributions(year)
```
- `Cycle`: Last year (even year) of the federal 2-year election cycle
- `FECTransID`: A unique record identifier within a given cycle.
- `ContribID`: A unique identifier for individual donors.  Family groups match on first 11 chars
- `Contrib`: The name of the contributor, usually in the format Last name, First Name.
- `RecipID`: The recipient's id number. If the contribution is to a candidate this will be the candidate's unique candidate id number. Otherwise, it will be the FEC committee id number.
- `Orgname`: The standardized organization name for the contributor. This is usually based on the donor's employer. The donor may not have an income producing occupation (e.g. homemaker)
- `UltOrg`: The standardized parent organization for the organization listed in the Orgname field. If there is no parent identified, this field will be blank or null.
- `RealCode`: The standard five character code identifying the donor's industry or ideology. Usually based on Orgname (e.g., the orgname "Microsoft Corp" would normally get realcode C5120 for computer software.)
- `Date`: The reported date of the contribution.
- `Amount`: The amount contributed. This will be negative for refunds.
- `Street`: 2000+ cycle only, and only for committees that file electronically
- `City`: The donor's city. This could be based on a home address or an employer's address. 
- `State`: The donor's state. This could be based on a home address or an employer's address.
- `Zip`: The donor's zip code. This could be based on a home address or an employer's address.
- `RecipCode`: A two-character code defining the type of recipient. For candidates, the first character is party ("D" for Democratic, "R" for Republican, "3" for Independent, Libertarian or third party, "U" for Unknown.) The second character is "W" for Winner, "L" for Loser, "I" for incumbent, "C" for Challenger, "O" for "Open Seat", and "N" for Non-incumbent. "N" is reserved for candidates that are neither in office nor running during the cycle in question. For party committees, the first character is party and the second character is "P." For PACs, the first character is "P" and the second character is "B" for Business, "L" for Labor", "I" for Ideological, "O" for "Other" and "U" for unknown.
- `Type`: The transaction type code for the contribution. 15 is a contribution, 15e is an earmarked contribution (made through a group such as Club for Growth or Emily's List), 15j is a contribution through a joint fund raising committee and 22y is a refund. "10" indicates "soft" or nonfederal money for the 2002 cycle and earlier. For the 2004 cycle and later type "10" indicates Levin funds.or outside spending.
- `CmteID`: The committee id number for the recipient. Note that a candidate can have more than one committee — this field indicates the exact committee receiving the contribution.
- `OtherID`: The committee id number for the intermediary party to earmarked contributions.
- `Gender`: The donor's gender. Can also be "U" if unknown or "N" if the name is ambiguous.
- `Microfilm`: Refers to specific page of FEC report images on which this transaction appears.
- `Occupation`: The donor's disclosed occupation.
- `Employer`: The donor's s disclosed employer
- `Source`: Indicates how the RealCode was determined — see the How to Use Source in the OpenSecrets OpenData Guide

Note that older versions of the individual contributions table (pre 2012) will not contain `Occupation` or `Employer`, but will include:
- `Occ_EF`: The donor's disclosed occupation from electronic filing.
- `Emp_EF`: The donor's disclosed employer from electronic filing.
- `FecOccEmp`: The donor's disclosed employer and/or occupation.


### Lobbying Data
Not yet implemented! Please contribute!


### 527 Data
Not yet implemented! Please contribute!


### Personal Finance Data
Not yet implemented! Please contribute!
