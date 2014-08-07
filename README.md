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

### OpenSecrets.jl

#### Detecting Data Sources
Unfortunately it's not practicle to bundle all the OpenSecrets data along with this package. Instead, OpenSecrets.jl attempts to detect sources of data stored locally in `OpenSecrets.jl/data`. If your data is stored somewhere else, you can tell OpenSecrets.jl about it using `detect_data_sources`.

```julia
detect_data_sources(dir::String)
```
- `dir`: The path to a directory containing unziped versions of the OpenSecrets OpenData.


### Campaign Finance Data

### Common Inputs / Outputs
All of the campaign finance data methods take an integer `year`, and output a DataFrame. Data sets are released every 2 years (according to the election cycle) and data is available starting 1990.

#### Candidates
```julia
OpenSecrets.candidates(year)
```
The candidates table includes lots of interesting information about candidates, including but not limited to: their unique CID, party, and whether they've committed to forgo contributions from PACs.

#### FEC Committees (PACs and Candidate and Party Committees)
```julia
OpenSecretes.committees(year)
```
The committees table contains information about all types of FEC Committees. Interesting fields include "CmteID", which is unique id assigned by the FEC, and "Sensative" which denotes the the committee has business in industries that fall under the jurisdiction of specific congressional committees.


#### PACs to Candidates

#### PACs to PACs

#### Individual Contributions


### Lobbying Data
Not yet implemented! Please contribute!


### 527 Data
Not yet implemented! Please contribute!


### Personal Finance Data
Not yet implemented! Please contribute!
