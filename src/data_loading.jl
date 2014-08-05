
function strip_brackets(str)
    isempty(str) ? "" : str[2:end-1]
end

function short_year(year)
    short_year_str = string(year)[end-1:end]
    (short_year_str, int(short_year_str))
end

function load_campaign_finance_data(data_str, year)
    short_year_str, short_year_int = short_year(year)

    data_path = joinpath(_campaign_finance_data_sources[short_year_int], "$(data_str)$(short_year_str).txt")
    readcsv(data_path)
end

function load_pacs_to_candidates(year)
    raw_data = load_campaign_finance_data("pacs", year)
    raw_data[:, 1] = map!(c->int(strip_brackets(c)), raw_data[:, 1])
    raw_data[:, 2] = map!(c->strip_brackets(c), raw_data[:, 2])
    raw_data[:, 3] = map!(c->strip_brackets(c), raw_data[:, 3])
    raw_data[:, 4] = map!(c->strip_brackets(c), raw_data[:, 4])
    raw_data[:, 7] = map!(c->strip_brackets(c), raw_data[:, 7])
    raw_data[:, 8] = map!(c->strip_brackets(c), raw_data[:, 8])
    raw_data[:, 9] = map!(c->strip_brackets(c), raw_data[:, 9])
    raw_data[:, 10] = map!(c->strip_brackets(c), raw_data[:, 10])

    DataFrame(Cycle = raw_data[:, 1], FECRecNo = raw_data[:, 2], PACID = raw_data[:, 3], CID = raw_data[:, 4],
        Amount = raw_data[:, 5], Date = raw_data[:, 6], RealCode = raw_data[:, 7], Type = raw_data[:, 8],
        DI = raw_data[:, 9], FECCandID = raw_data[:, 10])
end

function load_committee_table(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(_campaign_finance_data_sources[short_year_int], "cmtes$(short_year_str).txt")

    data = readtable(data_path; separator = ',', header = false, quotemark = ['|'], truestrings = ["1"], falsestrings = ["0"],
                     names = [:Cycle, :CmteID, :PACShort, :Affiliate, :Ultorg, :RecipID, :RecipCode,
                     :FECCandID, :Party, :PrimCode, :Source, :Sensitive, :Foreign, :Active],
                     eltypes = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
                     UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, Int, Bool])
end