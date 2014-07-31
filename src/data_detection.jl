
function detect_data_sources(dir::String = joinpath(Pkg.dir(), "OpenSecrets/data/"))
    data_sources = Dict()

    for thing in readdir(dir)
        thing_path = abspath(joinpath(dir, thing))

        !(isdir(thing_path) && ismatch(r"^CampaignFin[0-9]{2}$", thing)) && continue

        year = int(match(r"[0-9]{2}$", thing).match)
        data_sources[year] = abspath(joinpath(dir, thing))
    end

    isdefined(:_data_sources) && merge!(_data_sources, data_sources)
    data_sources
end
