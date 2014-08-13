
function short_year(year)
    short_year_str = string(year)[end-1:end]
    (short_year_str, int(short_year_str))
end

# -------

function pacs_to_candidates(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "pacs$(short_year_str).txt")
    data_stream = OpenSecretsBuffer(Latin1Buffer(open(data_path, "r")))

    readtable(data_stream, separator = ',', header = false, quotemark = ['|'],
              names = [:Cycle, :FECRecNo, :PACID, :CID, :Amount, :Date, :RealCode, :Type, :DI, :FECCandID],
              eltypes = [Int, UTF8String, UTF8String, UTF8String, Float64, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String])
end

# -------

function committees(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "cmtes$(short_year_str).txt")
    data_stream = OpenSecretsBuffer(Latin1Buffer(open(data_path, "r")))

    readtable(data_stream; separator = ',', header = false, quotemark = ['|'], truestrings = ["1"], falsestrings = ["0"],
              names = [:Cycle, :CmteID, :PACShort, :Affiliate, :Ultorg, :RecipID, :RecipCode,
              :FECCandID, :Party, :PrimCode, :Source, :Sensitive, :Foreign, :Active],
              eltypes = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, Int, Bool])
end

# -------

function candidates(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "cands$(short_year_str).txt")
    data_stream = OpenSecretsBuffer(Latin1Buffer(open(data_path, "r")))

    readtable(data_stream; separator = ',', header = false, quotemark = ['|'],
              names = [:Cycle, :FECCandID, :CID, :FirstLastP, :Party, :DistIDRunFor, :DistIDCurr, :CurrCand,
              :CycleCand, :CRPICO, :RecipCode, :NoPacs],
              eltypes = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String])
end

# -------

function pacs_to_other(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "pac_other$(short_year_str).txt")
    data_stream = OpenSecretsBuffer(Latin1Buffer(open(data_path, "r")))

    readtable(data_stream; separator = ',', header = false, quotemark = ['|'],
              names = [:Cycle, :FECRecNo, :Filerid, :DonorCmte, :ContribLendTrans, :City, :State, :Zip, :FECOccEmp,
              :Primcode, :Date, :Amount, :RecipID, :Party, :Otherid, :RecipCode, :RecipPrimcode, :Amend, :Report,
              :PG, :Microfilm, :Type, :RealCode, :Source],
              eltypes = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String, UTF8String, Float64, UTF8String, UTF8String, UTF8String, UTF8String,
              UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String])
end

# -------

function individual_contributions(year)
    short_year_str, short_year_int = short_year(year)
    data_path = joinpath(get(_campaign_finance_data_sources, short_year_int, ""), "indivs$(short_year_str).txt")
    data_stream = OpenSecretsBuffer(Latin1Buffer(open(data_path, "r")))

    # the OpenData naming scheme isn't really scalable, but for now, 90 and above for 1990 - 1999
    # and 00+ for 2000 and on.
    if 90 <= short_year_int || short_year_int <= 10
        field_names = [:Cycle, :FECTransID, :ContribID, :Contrib, :RecipID, :Orgname, :UltOrg, :RealCode, :Date,
                      :Amount, :Street, :City, :State, :Zip, :RecipCode, :Type, :CmteID, :OtherID, :Gender,
                      :FecOccEmp, :Microfilm, :Occ_EF, :Emp_EF, :Source]
        field_vals = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
                     UTF8String, Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
                     UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String]
    else
        field_names = [:Cycle, :FECTransID, :ContribID, :Contrib, :RecipID, :Orgname, :UltOrg, :RealCode, :Date,
                      :Amount, :Street, :City, :State, :Zip, :RecipCode, :Type, :CmteID, :OtherID, :Gender,
                      :Microfilm, :Occupation, :Employer, :Source]
        field_vals = [Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
                     UTF8String, Int, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String,
                     UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String, UTF8String]
    end

    readtable(data_stream; separator = ',', header = false, quotemark = ['|'],
              names = field_names, eltypes = field_vals)
end
