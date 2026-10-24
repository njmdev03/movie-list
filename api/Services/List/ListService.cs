using Npgsql;

public class ListService(NpgsqlDataSource dataSource)
{
    public async Task<ListCreateResponse> CreateAsync(
        Guid ownerId,
        string name,
        string description,
        CancellationToken cancellationToken
    )
    {
        const string sql = """
            INSERT INTO lists (owner_id, name, description)
            VALUES (@ownerId, @name, @description)
            RETURNING id, name, created_at;
            """;

        await using var connection =
            await dataSource.OpenConnectionAsync(cancellationToken);

        await using var command =
            new NpgsqlCommand(sql, connection);

        command.Parameters.AddWithValue("ownerId", ownerId);
        command.Parameters.AddWithValue("name", name);

        if (description != "")
        {
            command.Parameters.AddWithValue("description", description);
        }

        await using var reader =
            await command.ExecuteReaderAsync(cancellationToken);

        await reader.ReadAsync(cancellationToken);

        return new ListCreateResponse(
            reader.GetGuid(0),
            reader.GetString(1),
            reader.GetDateTime(2));
    }
}