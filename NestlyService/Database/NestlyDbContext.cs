using Microsoft.EntityFrameworkCore;

public class NestlyDbContext : DbContext
{
    public NestlyDbContext(DbContextOptions<NestlyDbContext> options) : base(options)
    {
    }

    public DbSet<User> Users { get; set; }

}