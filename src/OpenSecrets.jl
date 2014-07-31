
module OpenSecrets

include("data_detection.jl")

global _data_sources = detect_data_sources()

end
