using FirebaseAdmin.Auth;
using Microsoft.Extensions.Caching.Memory;

public class FirebaseAuthenticationMiddleware
{
    private readonly RequestDelegate _next;
    private static readonly MemoryCache Cache = new MemoryCache(new MemoryCacheOptions());
    private readonly FirebaseAuth _firebaseAuth;

    public FirebaseAuthenticationMiddleware(RequestDelegate next)
    {
        _next = next;
        _firebaseAuth = FirebaseAuth.DefaultInstance;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var token = context.Request.Headers["Authorization"].FirstOrDefault()?.Split(" ").Last();

        if (string.IsNullOrEmpty(token))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Unauthorized");
            return;
        }

        try
        {
            if (Cache.TryGetValue(token, out FirebaseToken decodedToken))
            {
                // Token is cached, use it
                context.Items["UserId"] = decodedToken.Uid;
            }
            else
            {
                // Verify token with Firebase Admin SDK
                decodedToken = await _firebaseAuth.VerifyIdTokenAsync(token);

                // Cache the token for 10 minutes
                Cache.Set(token, decodedToken, TimeSpan.FromMinutes(10));
                context.Items["UserId"] = decodedToken.Uid;
            }

            await _next(context);
        }
        catch (Exception)
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Unauthorized");
        }
    }
}