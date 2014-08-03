
function format_pacs_to_candidates_pre2012(raw_data)
    DataFrame(Cycle = raw_data[:, 1], FECRecNo = raw_data[:, 2], PACID = raw_data[:, 3], CID = raw_data[:, 4],
        Amount = raw_data[:, 5], Date = raw_data[:, 6], RealCode = raw_data[:, 7], Type = raw_data[:, 8],
        DI = raw_data[:, 9], FECCandID = raw_data[:, 10])
end

function format_pacs_to_candidates_post2012(raw_data)
    DataFrame(Cycle = raw_data[:, 1], FECRecNo = raw_data[:, 2], PACID = raw_data[:, 3], CID = raw_data[:, 4],
        Amount = raw_data[:, 5], Date = raw_data[:, 6], RealCode = raw_data[:, 7], Type = raw_data[:, 8],
        DI = raw_data[:, 9], FECCandID = raw_data[:, 10])
end


function load_pacs_to_candidates(year)
    short_year_str = string(year)[end-1:end]
    short_year = int(short_year_str)

    data_path = joinpath(_campaign_finance_data_sources[short_year], "pacs$(short_year_str).txt")
    raw_data = readcsv(data_path)

    int(year) >= 2012 ? format_pacs_to_candidates_post2012(raw_data) : format_pacs_to_candidates_pre2012(raw_data)
end