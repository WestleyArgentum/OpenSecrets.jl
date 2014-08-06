import Base.read, Base.eof, Base.close
 
type OpenSecretsBuffer <: IO
    io::IO
 
    OpenSecretsBuffer(io::IO) = new(io)
end
 
function Base.read(os::OpenSecretsBuffer, ::Type{Uint8})
    c = Base.read(os.io, Uint8)
    c == '\\' ? ' ' : c
end

Base.eof(os::OpenSecretsBuffer) = eof(os.io)

Base.close(os::OpenSecretsBuffer) = close(os.io)