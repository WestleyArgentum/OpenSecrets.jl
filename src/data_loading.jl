
function short_year(year)
    short_year_str = string(year)[end-1:end]
    (short_year_str, int(short_year_str))
end

# -------

function load_pacs_to_candidates(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "pacs$(short_year_str).txt")

    readtable(data_path, separator = ',', header = false, quotemark = ['|'],
              names = [:Cycle, :FECRecNo, :PACID, :CID, :Amount, :Date, :RealCode, :Type, :DI, :FECCandID],
              eltypes = [Int, UTF8String, UTF8String, UTF8String, Float64, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String])
end

# -------

function load_committees(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "cmtes$(short_year_str).txt")

    readtable(data_path; separator = ',', header = false, quotemark = ['|'], truestrings = ["1"], falsestrings = ["0"],
              names = [:Cycle, :CmteID, :PACShort, :Affiliate, :Ultorg, :RecipID, :RecipCode,
              :FECCandID, :Party, :PrimCode, :Source, :Sensitive, :Foreign, :Active],
              eltypes = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, Int, Bool])
end

# -------

function load_candidates(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "cands$(short_year_str).txt")

    readtable(data_path; separator = ',', header = false, quotemark = ['|'],
              names = [:Cycle, :FECCandID, :CID, :FirstLastP, :Party, :DistIDRunFor, :DistIDCurr, :CurrCand,
              :CycleCand, :CRPICO, :RecipCode, :NoPacs],
              eltypes = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String])
end