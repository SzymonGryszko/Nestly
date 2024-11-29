using Microsoft.EntityFrameworkCore;

public class NestlyDbContext : DbContext
{
    public NestlyDbContext(DbContextOptions<NestlyDbContext> options) : base(options)
    {
    }

    //DbSets for your entities

}