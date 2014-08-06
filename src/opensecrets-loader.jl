import Base.read, Base.eof, Base.close
 
type OpenSecretsBuffer <: IO
    io::IO
    peek
    add_backslash

 
    OpenSecretsBuffer(io::IO) = new(io, nothing, false)
end
 
function Base.read(os::OpenSecretsBuffer, ::Type{Uint8})
    if os.add_backslash
        os.add_backslash = false
        return '\\'
    end

    curr = os.peek == nothing ? read(os.io, Uint8) : os.peek
    peek = !eof(os.io) ? read(os.io, Uint8) : nothing

    if curr == '\\' && peek == '|'
        os.add_backslash = true
    end

    curr
end

Base.eof(os::OpenSecretsBuffer) = os.peek == nothing && eof(os.io)

Base.close(os::OpenSecretsBuffer) = close(os.io)