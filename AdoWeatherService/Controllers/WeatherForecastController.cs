using Microsoft.AspNetCore.Mvc;

namespace AdoWeatherService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetWeatherForecast")]
        public IEnumerable<WeatherForecast> Get()
        {
            var requestTime = DateTime.Now;
            _logger.LogInformation("Weather forecast request started at {RequestTime}", requestTime);

            var forecasts = Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();

            var responseTime = DateTime.Now;
            _logger.LogInformation("Weather forecast request completed at {ResponseTime} with the following data:", responseTime);

            foreach (var forecast in forecasts)
            {
                _logger.LogInformation("Date: {Date}, TempC: {TemperatureC}, Summary: {Summary}", forecast.Date, forecast.TemperatureC, forecast.Summary);
            }

            return forecasts;
        }
    }
}
