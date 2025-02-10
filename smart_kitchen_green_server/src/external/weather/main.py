import openmeteo_requests
import requests_cache
import pandas as pd
from retry_requests import retry

current_date = pd.Timestamp.now()
current_date = current_date.strftime("%Y-%m-%d")
current_date = pd.to_datetime(current_date)
previous_year_date = current_date - pd.DateOffset(years=1)
three_months = previous_year_date + pd.DateOffset(months=3)


def get_historical_data_of_3_months(latitude, longitude):
    cache_session = requests_cache.CachedSession('.cache', expire_after=-1)
    retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
    openmeteo = openmeteo_requests.Client(session=retry_session)
    url = "https://archive-api.open-meteo.com/v1/archive"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "start_date": previous_year_date.date(),
        "end_date": three_months.date(),
        "hourly": ["temperature_2m", "relative_humidity_2m", "precipitation", "soil_temperature_0_to_7cm",
                   "soil_moisture_0_to_7cm"],
        "daily": "daylight_duration"
    }
    responses = openmeteo.weather_api(url, params=params)

    response = responses[0]
    hourly = response.Hourly()
    hourly_temperature_2m = hourly.Variables(0).ValuesAsNumpy()
    hourly_relative_humidity_2m = hourly.Variables(1).ValuesAsNumpy()
    hourly_precipitation = hourly.Variables(2).ValuesAsNumpy()
    hourly_soil_temperature_0_to_7cm = hourly.Variables(3).ValuesAsNumpy()
    hourly_soil_moisture_0_to_7cm = hourly.Variables(4).ValuesAsNumpy()

    hourly_data = {"date": pd.date_range(
        start=pd.to_datetime(hourly.Time(), unit="s"),
        end=pd.to_datetime(hourly.TimeEnd(), unit="s"),
        freq=pd.Timedelta(seconds=hourly.Interval()),
        inclusive="left"
    ), "temperature_2m": hourly_temperature_2m, "relative_humidity_2m": hourly_relative_humidity_2m,
        "precipitation": hourly_precipitation, "soil_temperature_0_to_7cm": hourly_soil_temperature_0_to_7cm,
        "soil_moisture_0_to_7cm": hourly_soil_moisture_0_to_7cm}

    hourly_dataframe = pd.DataFrame(data=hourly_data)

    hourly_mean = hourly_dataframe.describe().loc['mean']
    humidity = hourly_mean['relative_humidity_2m']
    temperature_2m = hourly_mean['temperature_2m']
    precipitation = hourly_mean['precipitation']
    soil_temperature_0_to_7cm = hourly_mean['soil_temperature_0_to_7cm']
    soil_moisture_0_to_7cm = hourly_mean['soil_moisture_0_to_7cm']

    daily = response.Daily()
    daily_daylight_duration = daily.Variables(0).ValuesAsNumpy()

    daily_data = {"date": pd.date_range(
        start=pd.to_datetime(daily.Time(), unit="s"),
        end=pd.to_datetime(daily.TimeEnd(), unit="s"),
        freq=pd.Timedelta(seconds=daily.Interval()),
        inclusive="left"
    ), "daylight_duration": daily_daylight_duration}

    daily_dataframe = pd.DataFrame(data=daily_data)
    daily_mean = daily_dataframe.describe().loc['mean']
    daylight_duration = daily_mean['daylight_duration']

    return (temperature_2m, humidity, soil_temperature_0_to_7cm, soil_moisture_0_to_7cm, precipitation,
            daylight_duration)


def get_7_days_forecast_data(latitude, longitude):
    cache_session = requests_cache.CachedSession('.cache', expire_after=3600)
    retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
    openmeteo = openmeteo_requests.Client(session=retry_session)
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": 52.52,
        "longitude": 13.41,
        "hourly": ["temperature_2m", "relative_humidity_2m", "precipitation", "soil_temperature_0cm",
                   "soil_temperature_6cm", "soil_moisture_0_to_1cm", "soil_moisture_1_to_3cm"],
        "daily": "daylight_duration"
    }
    responses = openmeteo.weather_api(url, params=params)

    response = responses[0]
    hourly = response.Hourly()
    hourly_temperature_2m = hourly.Variables(0).ValuesAsNumpy()
    hourly_relative_humidity_2m = hourly.Variables(1).ValuesAsNumpy()
    hourly_precipitation = hourly.Variables(2).ValuesAsNumpy()
    hourly_soil_temperature_0cm = hourly.Variables(3).ValuesAsNumpy()
    hourly_soil_temperature_6cm = hourly.Variables(4).ValuesAsNumpy()
    hourly_soil_moisture_0_to_1cm = hourly.Variables(5).ValuesAsNumpy()
    hourly_soil_moisture_1_to_3cm = hourly.Variables(6).ValuesAsNumpy()

    hourly_data = {"date": pd.date_range(
        start=pd.to_datetime(hourly.Time(), unit="s"),
        end=pd.to_datetime(hourly.TimeEnd(), unit="s"),
        freq=pd.Timedelta(seconds=hourly.Interval()),
        inclusive="left"
    ), "temperature_2m": hourly_temperature_2m, "relative_humidity_2m": hourly_relative_humidity_2m,
        "precipitation": hourly_precipitation, "soil_temperature_0cm": hourly_soil_temperature_0cm,
        "soil_temperature_6cm": hourly_soil_temperature_6cm, "soil_moisture_0_to_1cm": hourly_soil_moisture_0_to_1cm,
        "soil_moisture_1_to_3cm": hourly_soil_moisture_1_to_3cm}

    hourly_dataframe = pd.DataFrame(data=hourly_data)
    hourly_mean = hourly_dataframe.describe().loc['mean']
    humidity = hourly_mean['relative_humidity_2m']
    temperature_2m = hourly_mean['temperature_2m']
    precipitation = hourly_mean['precipitation']
    soil_temperature_0cm_to_6cm = (hourly_mean['soil_temperature_0cm'] + hourly_mean['soil_temperature_6cm']) / 2
    soil_moisture_0_to_3cm = (hourly_mean['soil_moisture_0_to_1cm'] + hourly_mean['soil_moisture_1_to_3cm']) / 2

    daily = response.Daily()
    daily_daylight_duration = daily.Variables(0).ValuesAsNumpy()

    daily_data = {"date": pd.date_range(
        start=pd.to_datetime(daily.Time(), unit="s"),
        end=pd.to_datetime(daily.TimeEnd(), unit="s"),
        freq=pd.Timedelta(seconds=daily.Interval()),
        inclusive="left"
    ), "daylight_duration": daily_daylight_duration}

    daily_dataframe = pd.DataFrame(data=daily_data)
    daily_mean = daily_dataframe.describe().loc['mean']
    daily_light_duration_7days = daily_mean['daylight_duration']

    return (temperature_2m, humidity, soil_temperature_0cm_to_6cm, soil_moisture_0_to_3cm, precipitation,
            daily_light_duration_7days)


def get_weather_data(latitude, longitude):
    (temperature_2m_3_months, humidity_3_months, soil_temperature_0_to_7cm_3_months, soil_moisture_0_to_7cm_3_months,
     precipitation_3_months, daylight_duration_3_months) = get_historical_data_of_3_months(latitude, longitude)

    (temperature_2m_7days, humidity_7days, soil_temperature_0cm_to_6cm_7days, soil_moisture_0_to_3cm_7days,
     precipitation_7days, daily_light_duration_7days) = get_7_days_forecast_data(latitude, longitude)

    temperature = (temperature_2m_3_months + temperature_2m_7days) / 2
    humidity = (humidity_3_months + humidity_7days) / 2
    soil_temperature_0_to_7cm = (soil_temperature_0_to_7cm_3_months + soil_temperature_0cm_to_6cm_7days) / 2
    soil_moisture_0_to_7cm = (soil_moisture_0_to_7cm_3_months + soil_moisture_0_to_3cm_7days) / 2
    precipitation = (precipitation_3_months + precipitation_7days) / 2
    daylight_duration = (daylight_duration_3_months + daily_light_duration_7days) / 2

    return temperature, humidity, soil_temperature_0_to_7cm, soil_moisture_0_to_7cm, precipitation, daylight_duration
