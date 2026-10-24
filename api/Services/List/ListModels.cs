public record ListCreateRequest
{
    public required Guid ownerId;
    public required string name;
    public string? description;
}

public record ListCreateResponse
{

}