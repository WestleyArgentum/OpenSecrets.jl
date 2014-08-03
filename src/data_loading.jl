
function strip_brackets(str)
    str[2:end-1]
end

function format_pacs_to_candidates(raw_data)
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


function load_pacs_to_candidates(year)
    short_year_str = string(year)[end-1:end]
    short_year = int(short_year_str)

    data_path = joinpath(_campaign_finance_data_sources[short_year], "pacs$(short_year_str).txt")
    raw_data = readcsv(data_path)

    format_pacs_to_candidates(raw_data)
end