using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;

[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
[ApiVersion("1")]
public class AuthController : ControllerBase
{
    private readonly NestlyDbContext _dbContext;
    private static readonly MemoryCache UserCache = new MemoryCache(new MemoryCacheOptions());

    public AuthController(NestlyDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    [HttpGet]
    public async Task<IActionResult> Login()
    {
        var firebaseUserId = HttpContext.Items["UserId"]?.ToString();
        if (string.IsNullOrEmpty(firebaseUserId))
            return Unauthorized();

        var user = await _dbContext.Users.FindAsync(firebaseUserId);
        if (user == null)
        {
            user = new User { FirebaseUid = firebaseUserId, CreatedAt = DateTime.UtcNow };
            _dbContext.Users.Add(user);
            await _dbContext.SaveChangesAsync();
        }

        return Ok(new { user.FirebaseUid, user.CreatedAt });
    }

    [HttpGet]
    public async Task<User> GetUser(string firebaseUserId)
    {
        if (UserCache.TryGetValue(firebaseUserId, out User user))
        {
            return user;
        }

        user = await _dbContext.Users.FindAsync(firebaseUserId);

        if (user != null)
        {
            UserCache.Set(firebaseUserId, user, TimeSpan.FromMinutes(10));
        }

        return user;
    }
}