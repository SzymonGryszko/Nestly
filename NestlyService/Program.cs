using AspNetCoreRateLimit;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//Firebase
FirebaseApp.Create(new AppOptions()
{
    Credential = GoogleCredential.FromFile("firebase-admin-key.json")
});

//Versioning
builder.Services.AddApiVersioning(options =>
{
    options.AssumeDefaultVersionWhenUnspecified = true;
    options.DefaultApiVersion = new ApiVersion(1, 0);
    options.ReportApiVersions = true;
});

//Serilog
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .WriteTo.File(builder.Configuration["Logging:Path"], rollingInterval: RollingInterval.Day)
    .CreateLogger();

//HealthCheck
builder.Services.AddHealthChecks();

//CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin().DisallowCredentials()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

//Database
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
var databaseProvider = builder.Configuration["DatabaseProvider"];

if (databaseProvider == "SQLite")
{
    builder.Services.AddDbContext<NestlyDbContext>(options => options.UseSqlite(connectionString));
}
else if (databaseProvider == "SqlServer")
{
    builder.Services.AddDbContext<NestlyDbContext>(options => options.UseSqlServer(connectionString));
}
else
{
    throw new InvalidOperationException("Unsupported database provider specified in configuration.");
}

//Rate Limiting
builder.Services.AddMemoryCache();
builder.Services.Configure<IpRateLimitOptions>(builder.Configuration.GetSection("IpRateLimiting"));
builder.Services.AddInMemoryRateLimiting();
builder.Services.AddSingleton<IRateLimitConfiguration, RateLimitConfiguration>();



var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Nestly API v1");
});


app.Use(async (context, next) =>
{
    Log.Information("Request: {Method} {Path}", context.Request.Method, context.Request.Path);
    await next.Invoke();
});

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.MapHealthChecks("/health");

app.UseMiddleware<ExceptionMiddleware>();

app.UseMiddleware<FirebaseAuthenticationMiddleware>();

app.UseCors("AllowAll");

app.UseIpRateLimiting();

app.Run();
